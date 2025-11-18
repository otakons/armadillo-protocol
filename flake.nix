{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.stdenv.mkDerivation {
            pname = "armadillo-protocol";
            version = "0.1.0";
            src = ./game;
            buildInputs = with pkgs.godotPackages; [ godot export-template ];

            buildPhase = ''
              export HOME=$TMPDIR

              mkdir -p work/build
              cp -r $src/* work/
              mkdir -p $HOME/.local/share/godot

              ln -s ${pkgs.godotPackages.export-template}/share/godot/export_templates $HOME/.local/share/godot/
              ls $HOME/.local/share/godot/export_templates

              godot --headless --export-release "Linux" --path work

              mkdir -p $out
              cp -r work/build/* $out/
            '';

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            godot_4_3
            steam-run-free
          ];
        };
      };
    };
}
