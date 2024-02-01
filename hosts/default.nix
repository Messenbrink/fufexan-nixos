hj6svcfm969h0fmf5hfmgr8sa9vmh789dsl0nzdfqpc1mqy7h2";
{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    howdy = inputs.nixpkgs-howdy;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    io = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/programs/steam.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kmonad"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.mihai.imports = homeImports."mihai@io";
              extraSpecialArgs = specialArgs;
            };
          }

          # enable unmerged Howdy
          {disabledModules = ["security/pam.nix"];}
          "${howdy}/nixos/modules/security/pam.nix"
          "${howdy}/nixos/modules/services/security/howdy"
          "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

          inputs.agenix.nixosModules.default
        ];
    };

    # rog = nixosSystem {
    #   inherit specialArgs;
    #   modules =
    #     laptop
    #     ++ [
    #       ./rog
    #       "${mod}/core/lanzaboote.nix"

    #       "${mod}/programs/gamemode.nix"
    #       "${mod}/programs/hyprland.nix"
    #       "${mod}/programs/steam.nix"

    #       "${mod}/services/kmonad"
    #       {home-manager.users.mihai.imports = homeImports."mihai@rog";}
    #     ];
    # };

    kiiro = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ];
    };

    vm = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./vm
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/hyprland.nix"

          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.mihai.imports = homeImports."mihai@io";
              extraSpecialArgs = specialArgs;
            };
          }
        ];
    };
  };
}
