<h1 align="center">
    <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/4c449b822779d9f3fca2e0eed36c95b07d623fd9/ng/out/nix.svg" style="margin-left: 20pt; width: 150px" align="center"/>
    <br>
    <br>
    <br>Nix & NixOS Workshop
    <br>
</h1>

> [!CAUTION]
>
> This workshop is currently under development and is not yet complete.

This workshop is structured in 2 parts

- Part 1: Learn what a Nix DevShell is and how to extend it. It is designed to
  provide a **minimal, hands-on** introduction to how Nix works. While
  explanations are concise, they aim to be precise enough to help you grasp the
  objectives of this part.

  - Gain a basic understanding of the Nix language.
  - Learn what a `flake.nix` file is.
  - Understand what a Nix derivation is and how it materializes.

- Part 2: Building and running a basic NixOS system.
  - Requires Part 1.
  - Configure and build a NixOS system.
  - Deploy it to a cloud VM.

<!-- prettier-ignore-start -->


<!--toc:start-->
- [Requirements](#requirements)
- [Part 1 - Nix & Nix DevShell](#part-1-nix-nix-devshell)
- [Part 2 - NixOS](#part-2-nixos)
    - [What is NixOS?](#what-is-nixos)
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
> - [Nix Packages Search](https://search.nixos.org/packages?)
> - [Nix Packages Search for Version Pinning](https://nixhub.io)
> - [NixOS Manual](https://nixos.org/manual/nixos/stable)
> - [NixOS Options Search](https://search.nixos.org/options?)
> - [NixOS With Flakes](https://nixos-and-flakes.thiscute.world)
> - [NixOS Status](https://status.nixos.org)
> - [Nixpkgs Pull Request Tracker](https://nixpk.gs/pr-tracker.html)
> - [Nixpkgs-Lib Function Search](https://noogle.dev)

## Requirements

The basic requirements for working with this repository by using one of the
following approaches:

- **Use your machine** [recommended]

  Ensure that you have installed
  [`Nix`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-nix)
  and optionally
  [`direnv`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-direnv).

- **Use the container**

  You can run most of the workshop inside the provided container by running in
  the root of this repository

  ```bash
  git clean -df

  podman run -it \
    --userns=keep-id \
    -v "$(pwd):/workspace" \
    -w /workspace \
    ghcr.io/sdsc-ordes/nix-workshop:latest
  ```

  or

  ```bash
  git clean -df

  docker run -it  \
    --user root \
    -v "$(pwd):/workspace" \
    -w /workspace \
    ghcr.io/sdsc-ordes/nix-workshop:latest
  ```

- **Use the `devcontainer`** [

  A `devcontainer` setup is given in [`.devcontainer`](./.devcontainer). You can
  start this with `code`. **Adjust the
  [`devontainer.json`](./.devcontainer/devcontainer.json) if you are using
  `docker` instead of `podman`**.

## Part 1 - Nix, Flakes & Nix DevShell

[Check the slides here.](https://sdsc-ordes.github.io/technical-presentation/gh-pages/nix-workshop/part-1)

## Part 2 - NixOS

#### What is NixOS?

A NixOS derivation is created by a function `inputs.nixpkgs.lib.nixosSystem`
which comes from the [Nixpkgs Flake](https://github.com/NixOS/nixpkgs). The
`nixpkgs` repository is the mono-repository which maintains more than 130'000
software packages. These packages are defined - by nothing more than (you
guessed it) - Nix functions which return derivations.

##### The `nixosSystem` Function

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

### Build/Run & Understand a Simple VM

First familiar yourself with the commands on the [`justfile`](./justfile) with
by running `just`. The `build` and `repl` commands, we have covered in the
introduction.

In this example we are going to build a simple VM with just a user `nixos` and
without a graphical desktop environment.

```bash
cp ./.env.tmpl .env
## Modify the .env file to have `NIXOS_HOST=vm-simple`
```

#### Understand the Configuration

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
