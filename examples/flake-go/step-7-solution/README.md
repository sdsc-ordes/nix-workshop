# Step 7 - Package the Go Executable

## Exercises

1. Nothing.

2. See [`flake.nix`](./flake.nix). The derivation does not build with
   `nix build -L "./#default"` because the `vendorHash` does not match. If you
   adjust for that, the derivation builds.

   > [!TIP]
   >
   > The derivation from `pkgs.buildGoModule` has a special attribute
   > `goModules` which is the fixed-output derivation (FOD) containing all Go
   > dependencies. Building it with `nix repl .` to the get the store path:
   >
   > ```bash
   > nix repl .
   > nix-repl> :b packages.${builtins.currentSystem}.default.goModules
   >
   > This derivation produced the following outputs:
   >   out -> /nix/store/xij5xpd9li73kyll8sxd85zgyy3hm1xv-go-demo-go-modules
   > ```
   >
   > Inspecting `/nix/store/xij5xpd9...-go-demo-go-modules` gives
   >
   > ```bash
   > tree -L 3 /nix/store/xij5xpd9li73kyll8sxd85zgyy3hm1xv-go-demo-go-modules
   >
   > /nix/store/xij5xpd9li73kyll8sxd85zgyy3hm1xv-go-demo-go-modules
   > ├── github.com
   > │   ├── aymanbagabas
   > │   │   └── go-osc52
   > │   ├── charmbracelet
   > │   │   ├── bubbletea
   > │   │   ├── colorprofile
   > │   │   ├── lipgloss
   > │   │   └── x
   > │   ├── erikgeiser
   > │   │   └── coninput
   > │   ├── lucasb-eyer
   > │   │   └── go-colorful
   > │   ├── mattn
   > │   │   ├── go-isatty
   > │   │   ├── go-localereader
   > │   │   └── go-runewidth
   > │   ├── muesli
   > │   │   ├── ansi
   > │   │   ├── cancelreader
   > │   │   └── termenv
   > │   ├── rivo
   > │   │   └── uniseg
   > │   └── xo
   > │       └── terminfo
   > ├── golang.org
   > │   └── x
   > │       ├── sync
   > │       ├── sys
   > │       └── text
   > └── modules.txt
   > 30 directories, 1 file
   > ```

   Running the `./result/bin/demo` should work.

   ```bash
   ls -ald ./result
   > /nix/store/c8yfq7kwrwa2bflbn15fgafb95sv1wfl-go-demo
   ```

   > [!NOTE]
   >
   > The Nix derivation is called `go-demo` but the executable inside is named
   > `bin/demo` due to how Go builds executables and how `pkgs.buildGoModule`
   > behaves.

3. See [`package.nix`](./nix/package.nix).

   > [!NOTE]
   >
   > The `src` variable of type `path` in `pkgs.buildGoModule` will be put into
   > the Nix store and the builder (`bash`) used in `pkgs.buildGoModule` will
   > only see that path. Nix builds are sandboxed and do not use your local
   > directory. You can inspect the `src` variable with `nix repl .`:
   >
   > ```bash
   > nix repl .
   > nix-repl> packages.x86_64-linux.default.src
   > /nix/store/dp8lm266pxy9y8h54c460qv2vi0pdrlm-source/examples/flake-go/step-7-solution/src
   > ```
   >
   > which is the store path to the source.
