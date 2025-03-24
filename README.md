<h1 align="center">
    <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/4c449b822779d9f3fca2e0eed36c95b07d623fd9/ng/out/nix.svg" style="margin-left: 20pt; width: 150px" align="center"/>
    <br>
    <br>
    <br>NixOS Workshop
    <br>
</h1>

> [!CAUTION]
>
> This workshop is not finished, and under current development. Don't read it!

This workshop targets the building and running of a simple NixOS. It its meant
to give you a **minimal, brute-force** introduction to how Nix/NixOS works. A
lot of explanations are short but hopefully precise enough to make you
understand the goal of this workshop:

- Basic understanding of the Nix language.
- Understanding of what a `flake.nix` is.
- Understanding what a Nix derivation is and what its realization looks like.
- Configure and build a NixOS system.
- Deploy it to a Cloud VM.

<!-- prettier-ignore-start -->
<!--toc:start-->

- [Requirements](#requirements)
- [Introduction](#introduction)
  - [Whats a Flake `flake.nix`](#whats-a-flake-flakenix)
  - [Whats a Nix Derivation?](#whats-a-nix-derivation)
  - [Whats an Installable?](#whats-an-installable)
  - [NixOS](#nixos)
    - [The `nixosSystem` Function](#the-nixossystem-function)
- [Build/Run & Understand a Simple VM](#buildrun-understand-a-simple-vm)
  - [Understand the Configuration](#understand-the-configuration)

<!--toc:end-->
<!-- prettier-ignore-end -->

> [!TIP]
>
> Most links with further reads and videos are due to the lack of good &
> centralized official documentation on Nix topics. This makes also starting to
> learn Nix pretty uneasy. However, we try to link always to official
> documentation if it makes sense. Some links we use in the following are:
>
> - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
> - [NixOS Options Search](https://search.nixos.org/options?)
> - [Nix Packages Search](https://search.nixos.org/packages?)
> - [Nixpks-Lib Function Search](https://noogle.dev/)
> - [NixOS With Flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes)
> - [NixOS Status](https://status.nixos.org/)
> - [Nixpkgs Pullrequest Tracker](https://nixpk.gs/pr-tracker.html)

## Requirements

Make sure you installed
[`Nix`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-nix)
and
[`direnv`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-direnv).

The basic requirements for working in this repository are:

- `just`
- `nix`

## Introduction

Nix is a simple functional language which is almost similar to JSON with
functions. It has basic types like `string`s, `integers`, `paths`, `list`s and
`attribute set`s, (further
[read](https://nixos.org/guides/nix-pills/04-basics-of-language.html#basics-of-language)).

> [!CAUTION]
>
> The Nix language has its purpose and target towards deterministically building
> & distributing software and therefore is a very narrowly scoped language. That
> means you also don't find floating-point types etc. because it has little
> benefit in this context.

When you look at most Nix files `*.nix` in this and other repositories, they
will most always contain a function (further
[read](https://nixos.org/guides/nix-pills/05-functions-and-imports.html)).

For example, the function `args: /* implementation */` in `myfunction.nix` takes
one argument `args` and returns an attribute set `{ val1 = ... }`:

```nix
# File: `myfunction.nix`:
args:
let
  # A number.
  aNumber = 1;

  # A list with 4 elements.
  aList = [ 1 2 3 "help"];

  # A attribute set (key, value map) with two elements,
  # a number and a list.
  anAttrSet = { a = 1; b.c.d = [1]; };

  # Calling another function `args.myFunc` (it needs to be defined in `args`)
  # with an attribute set as input.
  result = args.myFunc { val1 = aNumber;};
in
{ val1 = aNumber; val2 = anAttrSet.b.c.d; val3 = result;}
```

Watch this [short introduction](https://www.youtube.com/watch?v=HiTgbsFlPzs) to
get a better understanding on this basic building block.

All `*.nix` files you explore in this repository are exactly similar but the
attribute set they return will be specific to what the
[NixOS module system](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
expects.

### Whats a Flake `flake.nix`

A [`flake.nix`](./flake.nix) is a deterministic way
([`flake.lock`](./flake.lock)) to load other Nix functions - called
[**inputs**](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#_1-flake-inputs) -
from other repositories/files or URLs and define
[ **outputs** ](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#_2-flake-outputs).
A [`flake.nix`](./flake.nix) is a Nix file which contains one attribute set. .

Each `flake.nix` can define a set of inputs in an `inputs` attribute and also
define a bunch of outputs in the `outputs` attribute. The `outputs` attribute is
a function which takes all `inputs` and must return an
[attribute set of the following shape](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/outputs).
What you return in `outputs` (e.g. `outputs.x86_64-linux.packages = ...`) are
mostly Nix **derivations**.

### Whats a Nix Derivation?

A [derivation](https://nix.dev/manual/nix/2.24/glossary#gloss-derivation) is in
its raw-form an **attribute set** (e.g. `{ type = "derivation"; ... }`) with
special shape and builtin meaning (further
[watch](https://www.youtube.com/watch?v=WT75jfETWRg)).

> A derivation is an instruction that Nix uses to realise a Nix package. They’re
> created using a special derivation function in the Nix language. They can
> depend on any number of other derivations and produce one or more final
> outputs. A derivation and all of the dependencies required to build it —
> direct dependencies, and all dependencies of those dependencies, etc — is
> called a closure. [\[Ref\]](https://zero-to-nix.com/concepts/derivations)

When the Nix interpreter evaluates a derivation, it always stores it in the Nix
store (`/nix/store`) as a side-effect - producing a
[_store derivation_](https://nix.dev/manual/nix/2.24/glossary#gloss-store-derivation).

The following will evaluate the path `formatter.x86_64-linux` in `outputs` of
this repository's [`flake.nix`](./flake.nix) and then print its content:

```bash
nix eval ".#formatter.x86_64-linux"

> «derivation /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv»

cat /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv

> Derive([("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt","","")],[("/nix/store/1fmb3b4cmr1bl1v6vgr8plw15rqw5jhf-treefmt.toml.drv",["out"]),("/nix/store/3avbfsh9rjq8psqbbplv2da6dr679cib-treefmt-2.1.0.drv",["out"]),("/nix/store/61fjldjpjn6n8b037xkvvrgjv4q8myhl-bash-5.2p37.drv",["out"]),("/nix/store/gp6gh2jn0x7y7shdvvwxlza4r5bmh211-stdenv-linux.drv",["out"])],["/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"],"x86_64-linux","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash",["-e","/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"],[("__structuredAttrs",""),("allowSubstitutes",""),("buildCommand","target=$out/bin/treefmt\nmkdir -p \"$(dirname \"$target\")\"\n\nif [ -e \"$textPath\" ]; then\n  mv \"$textPath\" \"$target\"\nelse\n  echo -n \"$text\" > \"$target\"\nfi\n\nif [ -n \"$executable\" ]; then\n  chmod +x \"$target\"\nfi\n\neval \"$checkPhase\"\n"),("buildInputs",""),("builder","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash"),("checkPhase","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash -n -O extglob \"$target\"\n"),("cmakeFlags",""),("configureFlags",""),("depsBuildBuild",""),("depsBuildBuildPropagated",""),("depsBuildTarget",""),("depsBuildTargetPropagated",""),("depsHostHost",""),("depsHostHostPropagated",""),("depsTargetTarget",""),("depsTargetTargetPropagated",""),("doCheck",""),("doInstallCheck",""),("enableParallelBuilding","1"),("enableParallelChecking","1"),("enableParallelInstalling","1"),("executable","1"),("mesonFlags",""),("name","treefmt"),("nativeBuildInputs",""),("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt"),("outputs","out"),("passAsFile","buildCommand text"),("patches",""),("preferLocalBuild","1"),("propagatedBuildInputs",""),("propagatedNativeBuildInputs",""),("stdenv","/nix/store/hsxp8g7zdr6wxk1mp812g8nbzvajzn4w-stdenv-linux"),("strictDeps",""),("system","x86_64-linux"),("text","#!/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash\nset -euo pipefail\nunset PRJ_ROOT\nexec /nix/store/0jcp33pgf85arjv3nbghws34mrmy7qq5-treefmt-2.1.0/bin/treefmt \\\n  --config-file=/nix/store/qk8rqccch6slk037dhnprryqwi8mv0xs-treefmt.toml \\\n  --tree-root-file=.git/config \\\n  \"$@\"\n\n")])
```

The `cat` output above is the internal serialization of the derivation of the
formatter which **when built** can be used to format all files in this
repository.

**Note:** A derivation contains only build instruction to fully describe what it
will build. This can be literally anything, e.g. a software package, a wrapper
shell script or only only source files.

We can build the above derivation - or in other terms realize it in the Nix
store - by doing:

```bash
nix build /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv
```

or

```bash
nix build ".#formatter.x86_64-linux" # Use quoted strings here (`zsh` interprets # differently!"
```

This will by default produce a symlink `./result` pointing to the Nix store
where this executable is available. Lets inspect it with:

```bash
ls -ald ./result

> Permissions Size User  Date Modified Name
> lrwxrwxrwx     - nixos 23 Mar 18:18   ./result -> /nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt

tree /nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt

> /nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt
> └── bin
>     └── treefmt
```

You can of course run it by doing
`/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt/bin/treefmt -h`.

### Whats an Installable?

The path `.#formatter.x86_64-linux.treefmt` in the previous section is commonly
referred to as a
[Flake output attribute installable](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#flake-output-attribute)
under the general term
[_installable_](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#installables).
An _installable_ is something you can realize in the Nix store.

The path `.#formatter.x86_64-linux.treefmt` refers to this repository's
[./flake.nix](./flake.nix) by the part `.` and its output attribute
`formatter.x86_64-linux`.

Most
[modern Nix commands](https://nix.dev/manual/nix/2.24/command-ref/experimental-commands)
take installables as input.

> [!TIP]
>
> Even tough Nix Flakes are still experimental, there is
> [no harm in using them](https://jade.fyi/blog/flakes-arent-real) as they will
> get eventually stabilized although their controversial discussion in the Nix
> community.

### NixOS

A NixOS derivation is created by a function `inputs.nixpkgs.lib.nixosSystem`
which comes from the [Nixpkgs Flake](https://github.com/NixOS/nixpkgs). The
`nixpkgs` repository is the mono-repository which maintains more than 130'000
software packages. These packages are defined - by nothing more than (you
guessed it) - Nix functions which return derivations.

#### The `nixosSystem` Function

The `inputs.nixpkgs.lib.nixosSystem` function will produce a derivation which
you can evaluate. For example - in this repository's
[`flake.nix`](./flake.nix) - the attribute
`nixosConfigurations.x86_64-linux.vm-simple` is such a function invocation and
to evaluate it you can run:

```bash
nix eval ".#nixosConfigurations.vm-simple.config.system.build.toplevel"
```

or you **better build** it with

```bash
nix build ".#nixosConfigurations.vm-simple.config.system.build.toplevel"
```

which will take some time and the resulting Nix store path linked by `./result`
then contains the built OS:

```bash
tree -L 2 ./result

> ./result
> ├── activate
> ├── append-initrd-secrets -> /nix/store/ccyny0nr3a4dn5f864caj1nmvhkyz938-append-initrd-secrets/bin/append-initrd-secrets
> ├── bin
> │   └── switch-to-configuration
> ├── boot.json
> ├── configuration-name
> ├── dry-activate
> ├── etc -> /nix/store/34f7cw087r9js5c1f3snwra466p03rjv-etc/etc
> ├── extra-dependencies
> ├── firmware -> /nix/store/28a2j3qirvnzjrzwahgqpl6d83p4dibb-firmware/lib/firmware
> ├── init
> ├── init-interface-version
> ├── initrd -> /nix/store/rhk5xymxhaap08abmvy8fspcfm3ghyf1-initrd-linux-6.6.82/initrd
> ├── kernel -> /nix/store/7c8qjbmxyyyscapv46cprwg3h1i0ry8b-linux-6.6.82/bzImage
> ├── kernel-modules -> /nix/store/5r9yn7mgianbqlqdn649k647v7zn6k9w-linux-6.6.82-modules
> ├── kernel-params
> ├── nixos-version
> ├── specialisation
> ├── sw -> /nix/store/v71rhhllsl7av7nrkzb58snsb2c7fal1-system-path
> ├── system
> └── systemd -> /nix/store/w9qcpyhjrxsqrps91wkz8r4mqvg9zrxc-systemd-256.10
```

The above (to my best knowledge) in simple terms contains everything needed to
boot into this NixOS system. An
[activation script `activate`](https://nixos.org/manual/nixos/stable/#sec-activation-script)
prepares symlinks into the immutable `/nix/store` on folders like

- `/boot` (kernel and bootloader),
- `/etc` (system configuration files), -`/var` (variable data) ,
- `/run` (ephemeral runtime data),
- `/home` (home directories)
- etc.

[`switch-to-configuration`](https://nixos.org/manual/nixos/stable/#sec-switching-systems)
script also takes care to switch to the new system on a running system and
restart the appropriate `systemd` services.

The next section explains how to build/run & understand a simple NixOS VM setup.

## Build/Run & Understand a Simple VM

In this example we are going to build a simple VM with just a user `nixos` and
without a graphical desktop environment.

```bash
cp ./.env.tmpl .env
# Modify the .env file to have `NIXOS_HOST=vm-simple`
```

### Understand the Configuration

The [`./nixos/hosts/vm-simple/default.nix`](./nixos/hosts/vm-simple/default.nix)
contains one function which returns the NixOS system:

```nix
{ inputs, outputs, ... }:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/vm/configuration.nix
  ];
  specialArgs = {
    inherit inputs outputs;
  };
}
```

The function call `inputs.nixpkgs.lib.nixosSystem {...}` is a function defined
in [`nixpgs`](https://github.com/NixOS/nixpkgs) which will generate a Nix
derivation.

When we instruct Nix to build this derivation, the derivation gets realized in
the Nix store (e.g. in `/nix/store`).
