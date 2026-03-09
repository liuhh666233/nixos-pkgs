{ inputs, ... }:

let self = inputs.self;

in {
  # Define custom overlays for development packages
  flake.overlays = {
    dev = inputs.nixpkgs.lib.composeManyExtensions [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            akracer = python-final.callPackage ./pkgs/python/akracer { };
            akshare = python-final.callPackage ./pkgs/python/akshare { };
          })
        ];
      })

    ];
  };

  # Configure per-system settings
  perSystem = { system, config, pkgs-dev, ... }: {
    # Define `pkgs-dev` to be a nixpkgs instance with the custom overlays
    # applied. This ensures all `perSystem` across all parts files can
    # consistently access `pkgs-dev`.
    _module.args.pkgs-dev = import inputs.nixpkgs {
      inherit system;
      overlays = [ self.overlays.dev ];
      config.allowUnfree = true;
    };

    devShells.default = let
      name = "nixos-pkgs";

      pythonForRepo = (pkgs-dev.python3.withPackages (p:
        with p; [
          pandas
          numpy
          polars
          matplotlib
          pydantic
          loguru
          pyarrow
          duckdb
          click
          pyyaml
          pendulum
          pudb
          rich
          akshare
        ]));

    in pkgs-dev.mkShell.override {
      stdenv = pkgs-dev.llvmPackages_18.stdenv;
    } rec {
      inherit name;

      # List additional development tools not included in `inputsFrom`.
      packages = with pkgs-dev; [
        pre-commit
        pythonForRepo
        yarn
        nodejs
        yt-dlp-light
      ];

      shellHook = let icon = "f1c0";
      in ''
        export PS1="$(echo -e '\u${icon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
        export LD_LIBRARY_PATH=${pkgs-dev.llvmPackages_18.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
        export PYTHONPATH="$(pwd):${pythonForRepo.sitePackages}:$PYTHONPATH"
      '';
    };
  };
}
