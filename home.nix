{ inputs, config, lib, pkgs, ... }:
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

  # Installs an extension from addons.mozilla.org by its URL slug and keeps
  # it updated.
  amo = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    # Allow extension to be disabled in the browser, but not removed. Remove
    # it by deleting its line in this config.
    installation_mode = "normal_installed";
    # Put icon in the extensions menu instead of pinning it to the toolbar.
    default_area = "menupanel";
  };

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

  # Toolbar layout. Only the areas changed from Zen's defaults are listed;
  # the rest keep their defaults. Changes made in the browser's Customize
  # Toolbar are reset on restart.
  toolbarLayout = {
    placements = {
      # Removed the compact mode toggle.
      zen-sidebar-top-buttons = [ ];
      # Removed the flexible spaces on either side of the address bar.
      nav-bar = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "vertical-spacer"
        "urlbar-container"
        "unified-extensions-button"
      ];
    };
    # Format version of this layout, so Firefox doesn't try to migrate it.
    currentVersion = 28;
  };

  # HACK: on a brand-new profile, Zen's session file doesn't exist yet,
  # and the flake skips writing spaces and pins into a missing file. This
  # seeds an empty one so the first build applies everything.
  # TODO: remove if upstream fixes it:
  # https://github.com/0xc000022070/zen-browser-flake/pull/401
  zenProfilePath =
    "${config.programs.zen-browser.profilesPath}/${config.programs.zen-browser.profiles.default.path}";
  emptySession = pkgs.writeText "zen-empty-session.json" (
    builtins.toJSON {
      lastCollected = 0;
      spaces = [ ];
      tabs = [ ];
      folders = [ ];
      groups = [ ];
      splitViewData = [ ];
    }
  );
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

    policies = {
      # Skip Zen's first-run and post-update tabs.
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      # No Mozilla account sign-in or sync.
      DisableFirefoxAccounts = true;

      ExtensionSettings = {
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = amo "1password-x-password-manager";
        "addon@darkreader.org" = amo "darkreader";
        "uBlock0@raymondhill.net" = amo "ublock-origin";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = amo "vimium-ff";
      };
    };

    # See HACK note above.
    activationFragments.default = [
      {
        priority = 0;
        requiresLock = true;
        skipSubject = "initial session";
        text = ''
          if [[ ! -e ${lib.escapeShellArg "${zenProfilePath}/zen-sessions.jsonlz4"} ]]; then
            run mkdir -p ${lib.escapeShellArg zenProfilePath}
            run ${lib.getExe pkgs.mozlz4a} ${emptySession} \
              ${lib.escapeShellArg "${zenProfilePath}/zen-sessions.jsonlz4"}
          fi
        '';
      }
    ];

    profiles.default = {
      id = 0;
      path = "default";
      isDefault = true;

      settings = {
        "browser.warnOnQuitShortcut" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
        "zen.workspaces.container-specific-essentials-enabled" = true;
        "zen.view.show-newtab-button-top" = false;
        # Address bar and nav buttons in a toolbar above the page, instead of
        # at the top of the sidebar.
        "zen.view.use-single-toolbar" = false;
        "browser.uiCustomization.state" = builtins.toJSON toolbarLayout;
        # On first run, Zen adds the compact mode toggle to the toolbar
        # regardless of the layout above, then sets this flag so it only
        # happens once. Marking it done keeps the toggle out.
        "zen.ui.migration.compact-mode-button-added" = true;
        # Gap, in pixels, between the web page and the browser's edges. 0
        # makes the page fill the window, with no border around it.
        "zen.theme.content-element-separation" = 0;
        "zen.welcome-screen.seen" = true;
        # Zen opens its privacy policy as a second first-run tab.
        "startup.homepage_welcome_url.additional" = "";
        # 1Password handles addresses and cards.
        "extensions.formautofill.addresses.capture.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
      };

      search = {
        force = true;
        default = "ddg";
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
