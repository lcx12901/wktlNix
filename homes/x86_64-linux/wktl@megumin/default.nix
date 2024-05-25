{config, lib, namespace, ...}: let
  inherit (lib.${namespace}) enabled;
in {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      terminal = {
        shell = {
          startship = enabled;
          zsh = enabled;
        };
        tools = {
          fzf = enabled;
        };
      };
    };
  };

  home.stateVersion = "23.11";
}