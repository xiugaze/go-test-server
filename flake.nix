{
  description = "Go web server test flake";
  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, gomod2nix, utils}: 
  utils.lib.eachSystem [
    "x86_64-linux"
  ] (system: 
    let 
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ gomod2nix.overlays.default ];
      };
    in {
      packages = {
        default = pkgs.buildGoApplication {
          pname = "go-test-server";
          version = "1.0.1";
          src = ./.;
          modules = ./gomod2nix.toml;
          buildinputs = with pkgs; [ ];

          postInstall = ''
              mkdir -p $out/share/go-test-server
              cp -r ./static $out/share/go-test-server/
          '';
        };
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          gopls
          gotools
          go-tools
          gomod2nix.packages.${system}.default
        ];
      };
  });
}

