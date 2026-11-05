{ inputs, config, ... }:
let
  # Zen needs a fixed UUID for each space and pin. This derives one from a
  # name, so it's stable across builds. Changing the name gives it a new ID,
  # which Zen treats as a new item.
  uuid =
    seed:
    let
      h = builtins.hashString "sha256" seed;
      s = builtins.substring;
    in
    "${s 0 8 h}-${s 8 4 h}-4${s 13 3 h}-8${s 17 3 h}-${s 20 12 h}";

  # Opens Google sign-in with the account pre-filled, then continues to the
  # app. Once signed in, it skips straight to the app.
  googleUrl =
    email: target: "https://accounts.google.com/AccountChooser?Email=${email}&continue=${target}";

  containers = config.programs.zen-browser.profiles.default.containers;

  # One space: its container, plus Gmail and Google Calendar Essentials
  # signed into that space's Google account.
  mkSpace =
    { name, position, icon, email }:
    {
      id = uuid "zen-space-${name}";
      inherit position icon;
      container = containers.${name}.id;
      pins = {
        gmail = {
          id = uuid "zen-pin-${name}-gmail";
          url = googleUrl email "https://mail.google.com/mail/";
          position = 1;
          isEssential = true;
          container = containers.${name}.id;
        };
        googleCalendar = {
          id = uuid "zen-pin-${name}-calendar";
          url = googleUrl email "https://calendar.google.com/calendar/";
          position = 2;
          isEssential = true;
          container = containers.${name}.id;
        };
      };
    };
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
        "zen.workspaces.container-specific-essentials-enabled" = true;
      };

      containersForce = true;
      containers = {
        blog = { id = 1; color = "orange"; icon = "circle"; };
        professional = { id = 2; color = "green"; icon = "circle"; };
        current = { id = 3; color = "blue"; icon = "circle"; };
      };

      spacesForce = true;
      spaces = {
        blog = mkSpace {
          name = "blog";
          position = 1;
          icon = "🪵";
          email = "eric@barch.blog";
        };
        professional = mkSpace {
          name = "professional";
          position = 2;
          icon = "👔";
          email = "eric.michael.barch@gmail.com";
        };
        current = mkSpace {
          name = "current";
          position = 3;
          icon = "🚰";
          email = "eric@currentsoftware.app";
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
