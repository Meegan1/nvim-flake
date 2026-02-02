nvim-flake (nixCats Neovim)
===========================

A flake that builds a configurable Neovim distribution using the nixCats helper library. It exports:
- package overlays and built Neovim packages (per-system)
- devShells
- Home Manager modules (`homeModules.default`)
- NixOS modules (`nixosModules.default`)
- `overlays`, `packages`, `devShells`, `utils` and `templates` helpers

This flake expects `nixpkgs` (unstable recommended) and the `nixCats` utils available in `inputs`. It also includes an overlay that automatically exposes flake inputs named `plugins-<name>` as `pkgs.neovimPlugins.<name>` so you can add extra plugin flakes as inputs.

Quick examples
--------------

1) Add the flake as an input in your system flake

````nix {flake.nix}
# add to your top-level `inputs = { ... }`
nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

# this repository as an input
nvim-flake.url = "github:meegan1/nvim-flake"; # or your fork / path

# Optional: follow nixpkgs where needed
nvim-flake.inputs.nixpkgs.follows = "nixpkgs";
````

2) After adding the flake as an input, choose one of the following (these are alternatives, not sequential):

Option A — Import the Home Manager module
````nix {flake.nix}
# In your system/home-manager module imports:
home-manager = {
  users.meegan1 = {
    imports = [
      inputs.nvim-flake.homeModules.default
      # other modules...
    ];

    # enable the nvim module if you want the module to manage Neovim state
    nvim.enable = true;
  };
};
````

Option B — Use the flake's overlays / packages
- The flake exposes `overlays` and `packages` outputs per system. You can add its overlays to your `nixpkgs` or refer to built packages:

````nix {flake.nix}
# Example: add overlay to your pkgs (in flake outputs)
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  nvim-flake.url = "github:meegan1/nvim-flake";
};

outputs = { self, nixpkgs, nvim-flake, ... }:
{
  # add the overlay to your system pkgs via an overlay composition:
  nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
    system = "aarch64-darwin"; # or x86_64-linux, etc.
    modules = [
      # add the overlay (example)
      (import ./configuration.nix {
        overlays = [ nvim-flake.overlays.${system} ];
      })
    ];
  };
}
````

Option C — Import locally (if using this repo in the filesystem)
- If you prefer to import the helper directly from the repo `default.nix`:

````nix {default.nix}
# from a flake or local file:
myNixCats = import ./default.nix { inherit inputs; };

# then use myNixCats.homeModules.default or myNixCats.overlays, etc.
````

Supported systems
-----------------
The flake is configured to build for the common platforms:
- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

Custom plugins and extra inputs
-------------------------------
The flake contains an overlay that will auto-detect plugin flakes provided as inputs whose name matches plugins-<name>. Example in this repo's `flake.nix`:

````nix {flake.nix}
inputs.plugins-mcphub-nvim = {
  url = "github:ravitemer/mcphub.nvim";
  flake = false; # if the plugin repo is not a flake
};
````

Those plugin inputs become available under `pkgs.neovimPlugins` via the overlay, and the default package definition already toggles many optional plugin categories. To enable them, either:
- add and expose the overlay and include the plugin in your configuration, or
- import `inputs.nvim-flake.homeModules.default` into Home Manager and enable options there.

Primary outputs
---------------
You can expect these outputs from the flake:
- overlays — an overlay that exposes built neovim packages and plugins
- homeModules.default — Home Manager module for managing Neovim configuration
- nixosModules.default — NixOS module variant
- packages — per-system Neovim packages (package set)
- devShells.default — a development shell with the Neovim package
- utils / templates — helper utilities provided by nixCats

Notes & recommendations
-----------------------
- The flake is intended to be used with a `nixpkgs` unstable input (some plugin wrappers rely on it).
- If adding plugin flakes, follow the naming convention `plugins-<name>` to have them picked up automatically by the overlay.
- The default package name is `nvim` (see `default.nix`) and the flake builds per-system outputs.

