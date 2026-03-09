{ inputs, ... }:

let self = inputs.self;

in {
  flake.overlays.default = self.overlays.dev;

  perSystem = { system, config, pkgs, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [ self.overlays.default ];
    };
  };
}
