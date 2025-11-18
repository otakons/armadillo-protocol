{
  description = "Super epic armadillo game";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          godotVersion = pkgs.godotPackages;
        in
        {
          packages.linux = pkgs.stdenv.mkDerivation {
            pname = "armadillo-protocol";
            version = "0.1.0";
            src = ./game;

            buildInputs = with godotVersion; [ godot export-template ];

            buildPhase = ''
              export HOME=$TMPDIR

              mkdir -p work/build
              cp -r $src/* work/
              mkdir -p $HOME/.local/share/godot

              ln -s ${godotVersion.export-template}/share/godot/export_templates \
                $HOME/.local/share/godot/

              godot --headless --export-release "Linux" --path work

              mkdir -p $out/bin
              install -m 755 work/build/armadillo-protocol.x86_64 $out/bin/armadillo-protocol
              install -m 644 work/build/armadillo-protocol.pck $out/bin/armadillo-protocol.pck
            '';
          };

          devShells.default = pkgs.mkShell {
            packages = with godotVersion; [
              godot
              export-template
            ] ++ [
              pkgs.steam-run-free
            ];
          };
        };
    };
}
