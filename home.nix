{ inputs, config, ... }:
let
  # Zen needs a fixed UUID per space. This derives one from the space's
  # name, so it's stable across builds. Renaming a space gives it a new
  # ID, which Zen treats as a new space (its open tabs won't carry over).
  spaceId =
    name:
    let
      h = builtins.hashString "sha256" "zen-space-${name}";
      s = builtins.substring;
    in
    "${s 0 8 h}-${s 8 4 h}-4${s 13 3 h}-8${s 17 3 h}-${s 20 12 h}";
in
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

      settings = {
        "browser.warnOnQuitShortcut" = false;
      };

      containersForce = true;
      containers = {
        blog = { id = 1; color = "orange"; icon = "circle"; };
        professional = { id = 2; color = "green"; icon = "circle"; };
        current = { id = 3; color = "blue"; icon = "circle"; };
      };

      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles.default.containers;
        in
        {
          blog = {
            id = spaceId "blog";
            position = 1;
            icon = "🪵";
            container = containers.blog.id;
          };
          professional = {
            id = spaceId "professional";
            position = 2;
            icon = "👔";
            container = containers.professional.id;
          };
          current = {
            id = spaceId "current";
            position = 3;
            icon = "🚰";
            container = containers.current.id;
          };
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
