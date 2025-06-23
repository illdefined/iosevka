{
  description = "Custom variation of the Iosevka typeface family";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.kyouma.net" ];
    extra-trusted-public-keys = [ "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg=" ];
  };

  outputs = { nixpkgs, ... }:
  let
    inherit (nixpkgs) lib;
    eachSystem = fn: lib.genAttrs lib.systems.flakeExposed (system: fn system nixpkgs.legacyPackages.${system});
  in {
    packages = eachSystem (system: pkgs:
    let
      iosevka = pkgs.iosevka.overrideAttrs (prevAttrs: {
        requiredSystemFeatures = prevAttrs.requiredSystemFeatures or [ ] ++ [ "big-parallel" ];
      });
    in {
      iosevka-idiosyn-sans = iosevka.override {
        set = "-idiosyn-sans";
        privateBuildPlan = import ./iosevka.nix // {
          family = "idiosyn sans";
          spacing = "normal";
        };
      };

      iosevka-idiosyn-sans-quasi = iosevka.override {
        set = "-idiosyn-sans-quasi";
        privateBuildPlan = import ./iosevka.nix // {
          family = "idiosyn sans quasi";
          spacing = "quasi-proportional";
        };
      };

      iosevka-idiosyn-sans-term = iosevka.override {
        set = "-idiosyn-sans-term";
        privateBuildPlan = import ./iosevka.nix // {
          family = "idiosyn sans term";
          spacing = "term";
        };
      };
    });
  };
}
