{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.virtualisation.podman;
in {
  options.${namespace}.virtualisation.podman = {
    enable = mkBoolOpt false "Whether or not to enable Podman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    wktlnix = {
      user = {
        extraGroups = [
          "docker"
          "podman"
        ];
      };

      home.extraOptions = {
        home.shellAliases = {
          "docker-compose" = "podman-compose";
        };
      };
    };

    virtualisation = {
      podman = {
        inherit (cfg) enable;

        # prune images and containers periodically
        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };

        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };

    oci-containers = {
      backend = "podman";
    };
  };
}
