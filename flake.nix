{
  description = "My first flake";

  inputs = {
    nixpkg.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-ld.url = "github:Mic92/nix-ld";
    # hyprland.url = "github:spikespaz/hyprland-nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-ld, self, nixpkgs, home-manager, ... } @ inputs:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
        ];
      };
    };
    homeConfigurations = {
      ralen = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
        ./home.nix
        ];
      };
    };
    devShells.${system}.default = (import ./shell.nix { inherit pkgs; });
  };
} 
