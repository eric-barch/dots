{ inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.username = "ericbarch";
  home.homeDirectory = "/Users/ericbarch";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.zen-browser = {
    enable = true;
    darwinDefaultsId = "app.zen-browser.zen";

    profiles.default = {
      id = 0;
      path = "default";
      isDefault = true;

      containersForce = true;
      containers = {
        blog = { id = 1; color = "orange"; icon = "circle"; };
        professional = { id = 2; color = "green"; icon = "circle"; };
        current = { id = 3; color = "blue"; icon = "circle"; };
      };
    };
  };

  # Zen can't save its per-install profile choice because home-manager
  # owns profiles.ini. This makes it use the Default=1 profile instead.
  launchd.agents.moz-legacy-profiles = {
    enable = true;
    config = {
      ProgramArguments = [ "/bin/launchctl" "setenv" "MOZ_LEGACY_PROFILES" "1" ];
      RunAtLoad = true;
    };
  };
}
