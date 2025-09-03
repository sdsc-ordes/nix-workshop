# Step 9 - Create a Pure-Distroless Docker Container

Solutions are in [`full-solution`](../full-solution).

## Exercises

1. In step 7 we packaged the Go executable in [`./src/`](./src) with Nix.

   Available with `nix run ".#default"`.

   We want to build a Docker container, but not with `docker build` but with
   `nix` and
   [`pkgs.dockerTools`](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools).

   > [!TIP]
   >
   > Nix is the better OCI image builder when it comes to security and software
   > dependencies:

   > You could reach a similar state with `docker build` by properly:
   >
   > - version pin package manager updates and system packages (its not easy).
   > - using separate `docker build` stages like "build" and then copying
   >   everything into a `scratch`/distorless base image.
   >
   > However, Nix is purer, more reproducible and strips the built image to the
   > core having only the `/nix/store` paths which are actually needed.

   The command we are gonna use is `pkgs.dockerTools.buildLayer`:

   ```nix
   pkgs.dockerTools.buildLayeredImage {
    name = "myimage";
    tag = "latest";

    contents = [ pkgs.cowsay ];

    config = {
       # This config section is serialized to the image and can contain
       # all
       Cmd = [ "/bin/cowsay" ];
    };
   }
   ```

   This builds a Nix derivation with the following properties:

   - Contains the `.*.tar.gz` compressed Docker image and has name
     `myimage:latest` which you then can load into Docker/Podman.

   - Has the content of the derivation `pkgs.cowsay`
     (`/nix/store/.../bin/cowsay`) copied to `/bin`.

   - Sets the image entry command to `/bin/cowsay` (same as
     `CMD ["/bin/cowsay"]` in a `Dockerfile`).

     > [!NOTE]
     >
     > The `config =` section can the same attribute names as Dockers
     > serialization format. You can inspect these on any image with
     > `podman inspect --format={{ .Config | json }} <image>`, i.e.
     >
     > ```shell
     > podman pull docker.io/nixos/nix
     > podman inspect --format="{{ .Config | json }}" docker.io/nixos/nix | jq
     > ```
     >
     > ```json
     > {
     >   "User": "0:0",
     >   "Env": [
     >     "USER=root",
     >     "PATH=/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin",
     >     "MANPATH=/root/.nix-profile/share/man:/nix/var/nix/profiles/default/share/man",
     >     "SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt",
     >     "GIT_SSL_CAINFO=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt",
     >     "NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt",
     >     "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels:/root/.nix-defexpr/channels"
     >   ],
     >   "Cmd": [
     >     "/nix/store/smkzrg2vvp3lng3hq7v9svfni5mnqjh2-bash-interactive-5.2p37/bin/bash"
     >   ],
     >   "Labels": {
     >     "org.opencontainers.image.description": "Nix container image",
     >     "org.opencontainers.image.source": "https://github.com/NixOS/nix",
     >     "org.opencontainers.image.title": "Nix",
     >     "org.opencontainers.image.vendor": "Nix project",
     >     "org.opencontainers.image.version": "2.31.1"
     >   }
     > }
     > ```

     Use `pkgs.dockerTools.buildLayeredImage` in
     [`./nix/package.nix`](nix/package.nix) to create a new Nix flake output
     `packages.${system}.image` derivation. The image should launch the `demo`
     executable from the `default` package.

2. Build the `image` derivation and load the container and run it.

   Hint: `podman load < ./result` and `podman run -it demo:latest`.
