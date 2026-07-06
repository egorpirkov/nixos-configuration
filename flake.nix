{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pano-scrobbler-flake.url = "github:kawaiiDango/pano-scrobbler-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    helium.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, helium, pano-scrobbler-flake, home-manager, spicetify-nix, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; 
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

	  home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pirkov = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
        ];
      };
    };
  };
}
