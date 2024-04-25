{
  # The structure was adopted from `github:ryantm/agenix`.
  description = "Package a redlib module and ship the upstream redlib package.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }: 
    let eachSystem = nixpkgs.lib.genAttrs (import systems); in
    {
      nixosModules.redlib = import ./modules/redlib.nix;
      nixosModules.default = self.nixosModules.redlib;

      packages = eachSystem (system: 
        let pkgs = nixpkgs.legacyPackages.${system}; in 
        {
          redlib = pkgs.redlib;
          default = self.packages.${system}.redlib;
        });
    };
}
