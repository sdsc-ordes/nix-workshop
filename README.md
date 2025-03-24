<h1 align="center">
    <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/4c449b822779d9f3fca2e0eed36c95b07d623fd9/ng/out/nix.svg" style="margin-left: 20pt; width: 150px" align="center"/>
    <br>
    <br>
    <br>NixOS Workshop
    <br>
</h1>

> [!CAUTION]
>
> This workshop is currently under development and is not yet complete. Please
> refrain from reading it!

This workshop focuses on building and running a basic NixOS system. It is
designed to provide a **minimal, hands-on** introduction to how Nix/NixOS works.
While explanations are concise, they aim to be precise enough to help you grasp
the objectives of this workshop:

- Gain a basic understanding of the Nix language.
- Learn what a `flake.nix` file is.
- Understand what a Nix derivation is and how it materializes.
- Configure and build a NixOS system.
- Deploy it to a cloud VM.

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
> Due to the lack of well-structured and centralized official documentation on
> Nix topics, many external links to additional reading materials and videos are
> provided. Learning Nix can be challenging, but we prioritize linking to
> official documentation whenever relevant. Some useful resources include:
>
> - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
> - [NixOS Options Search](https://search.nixos.org/options?)
> - [Nix Packages Search](https://search.nixos.org/packages?)
> - [Nixpkgs-Lib Function Search](https://noogle.dev/)
> - [NixOS With Flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes)
> - [NixOS Status](https://status.nixos.org/)
> - [Nixpkgs Pull Request Tracker](https://nixpk.gs/pr-tracker.html)

## Requirements

Ensure that you have installed
[`Nix`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-nix)
and
[`direnv`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-direnv).

The basic requirements for working with this repository are:

- `just`
- `nix`

## Introduction

Nix is a simple functional language, structurally similar to JSON but with
functions. It supports fundamental data types such as `string`s, `integers`,
`paths`, `lists`, and `attribute sets`. For a more detailed explanation, see
[Nix Language Basics](https://nixos.org/guides/nix-pills/04-basics-of-language.html#basics-of-language).

> [!CAUTION]
>
> The Nix language is specifically designed for deterministic software building
> and distribution. Due to its narrow scope, it lacks certain features, such as
> floating-point types, which are unnecessary in this context.

Most `*.nix` files in this and other repositories define functions. You can
learn more about functions in Nix from
[this guide](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

For example, the function `args: /* implementation */` in `myfunction.nix` takes
one argument `args` and returns an attribute set `{ val1 = ... }`:

```nix
# File: `myfunction.nix`:
args:
let
  aNumber = 1;  # A number.
  aList = [ 1 2 3 "help"];  # A list with 4 elements.
  anAttrSet = { a = 1; b.c.d = [1]; };  # A nested attribute set.
  result = args.myFunc { val1 = aNumber; };  # Calls another function `args.myFunc`.
in
{ val1 = aNumber; val2 = anAttrSet.b.c.d; val3 = result; }
```

Watch this [short introduction](https://www.youtube.com/watch?v=HiTgbsFlPzs) to
get a better understanding on this basic building block.

> [!TIP]
>
> In Nix world everything is a function. And to to procedural-like statements
> you use `let ... in` blocks as shown above to better structure what return
> value you construct, instead of writing large one-liners.

All `*.nix` files you explore in this repository are exactly similar but the
attribute set they return will be specific to what the
[NixOS module system](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
expects. More to that later.

---

### What is a Flake? (`flake.nix`)

A [`flake.nix`](./flake.nix) provides a **deterministic** way to manage
dependencies and configurations in Nix. It references external Nix
functions—called
[**inputs**](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#_1-flake-inputs)—which
are fetched from other repositories, local files, or URLs. It also defines
structured
[**outputs**](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#_2-flake-outputs),
specifying what the flake provides.

Each `flake.nix` file consists of a **single attribute set**, containing:

- **Inputs**: Defined in the `inputs` attribute, listing dependencies the flake
  relies on.
- **Outputs**: A function that takes `inputs` and returns an
  [attribute set](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/outputs),
  specifying what the flake provides (e.g., packages, modules, or NixOS
  configurations).

For example, outputs such as `outputs.x86_64-linux.packages = ...` typically
define Nix **derivations**, which are the core building blocks of Nix packages.

---

### What is a Nix Derivation?

A [derivation](https://nix.dev/manual/nix/2.24/glossary#gloss-derivation) is a
**specialized attribute set** that describes how to build a Nix package. In raw
form, it looks like `{ type = "derivation"; ... }` and carries a well-defined
structure with built-in meaning.

> A derivation is an instruction that Nix uses to realize a package. Created
> using a special `derivation` function in the Nix language, it can depend on
> multiple other derivations and produce one or more outputs. The complete set
> of dependencies required to build a derivation—including its transitive
> dependencies—is called a **closure**.
> [\[Ref\]](https://zero-to-nix.com/concepts/derivations)

When Nix evaluates a derivation, it stores the result in the Nix store
(`/nix/store`) as a **store derivation**
([more details](https://nix.dev/manual/nix/2.24/glossary#gloss-store-derivation)).

To inspect the `formatter.x86_64-linux` output from this repository’s
[`flake.nix`](./flake.nix), run the following command:

```bash
nix eval .#formatter.x86_64-linux

> «derivation /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv»
```

```bash
cat /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv

> Derive([("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt","","")],[("/nix/store/1fmb3b4cmr1bl1v6vgr8plw15rqw5jhf-treefmt.toml.drv",["out"]),("/nix/store/3avbfsh9rjq8psqbbplv2da6dr679cib-treefmt-2.1.0.drv",["out"]),("/nix/store/61fjldjpjn6n8b037xkvvrgjv4q8myhl-bash-5.2p37.drv",["out"]),("/nix/store/gp6gh2jn0x7y7shdvvwxlza4r5bmh211-stdenv-linux.drv",["out"])],["/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"],"x86_64-linux","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash",["-e","/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"],[("__structuredAttrs",""),("allowSubstitutes",""),("buildCommand","target=$out/bin/treefmt\nmkdir -p \"$(dirname \"$target\")\"\n\nif [ -e \"$textPath\" ]; then\n  mv \"$textPath\" \"$target\"\nelse\n  echo -n \"$text\" > \"$target\"\nfi\n\nif [ -n \"$executable\" ]; then\n  chmod +x \"$target\"\nfi\n\neval \"$checkPhase\"\n"),("buildInputs",""),("builder","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash"),("checkPhase","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash -n -O extglob \"$target\"\n"),("cmakeFlags",""),("configureFlags",""),("depsBuildBuild",""),("depsBuildBuildPropagated",""),("depsBuildTarget",""),("depsBuildTargetPropagated",""),("depsHostHost",""),("depsHostHostPropagated",""),("depsTargetTarget",""),("depsTargetTargetPropagated",""),("doCheck",""),("doInstallCheck",""),("enableParallelBuilding","1"),("enableParallelChecking","1"),("enableParallelInstalling","1"),("executable","1"),("mesonFlags",""),("name","treefmt"),("nativeBuildInputs",""),("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt"),("outputs","out"),("passAsFile","buildCommand text"),("patches",""),("preferLocalBuild","1"),("propagatedBuildInputs",""),("propagatedNativeBuildInputs",""),("stdenv","/nix/store/hsxp8g7zdr6wxk1mp812g8nbzvajzn4w-stdenv-linux"),("strictDeps",""),("system","x86_64-linux"),("text","#!/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash\nset -euo pipefail\nunset PRJ_ROOT\nexec /nix/store/0jcp33pgf85arjv3nbghws34mrmy7qq5-treefmt-2.1.0/bin/treefmt \\\n  --config-file=/nix/store/qk8rqccch6slk037dhnprryqwi8mv0xs-treefmt.toml \\\n  --tree-root-file=.git/config \\\n  \"$@\"\n\n")])
```

The output of `/nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv` above is
the internal serialization of the formatter's derivation which **when built**
can be used to format all files in this repository.

> [!NOTE]
>
> A derivation contains only build instructions for Nix to realize/build it.
> This can be literally anything, e.g. a software package, a wrapper shell
> script or only source files.

We can build the above derivation - or in other terms **realize it in the Nix
store** - by doing:

```bash
nix build /nix/store/72zknv2ssr8pkvf5jrc0g5w64bqjvyq1-treefmt.drv
```

or

```bash
nix build ".#formatter.x86_64-linux"
# Use quoted strings here (`zsh` interprets # differently!"
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

You can run it by doing

```bash
nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt/bin/treefmt -h
```

---

### What is an Installable?

The path `.#formatter.x86_64-linux.treefmt` mentioned in the previous section is
commonly referred to as a
[Flake output attribute installable](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#flake-output-attribute),
or simply an
[_installable_](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#installables).

An **installable** is any Flake output that can be realized in the Nix store.

Breaking down `.#formatter.x86_64-linux.treefmt`:

- `.` refers to this repository’s [`flake.nix`](./flake.nix).
- `formatter.x86_64-linux.treefmt` following `#` is an output attribute defined
  within the flake.

Most
[modern Nix commands](https://nix.dev/manual/nix/2.24/command-ref/experimental-commands)
accept installables as input, making them a fundamental concept in working with
Flakes.

> [!TIP]
>
> Although Nix Flakes are still considered experimental,
> [there's no harm in using them](https://jade.fyi/blog/flakes-arent-real).
> Despite ongoing discussions within the Nix community, Flakes are expected to
> be stabilized in the future.

---

### What is NixOS?

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
