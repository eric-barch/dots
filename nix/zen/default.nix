{ inputs, config, lib, pkgs, ... }:
let
  # Stable UUID for a space or pin, derived from a name. Renaming one makes
  # Zen treat it as a new item.
  uuid =
    seed:
    let
      h = builtins.hashString "sha256" seed;
      s = builtins.substring;
    in
    "${s 0 8 h}-${s 8 4 h}-4${s 13 3 h}-8${s 17 3 h}-${s 20 12 h}";

  # Google sign-in with the account pre-filled, continuing to the app.
  googleUrl =
    email: target: "https://accounts.google.com/AccountChooser?Email=${email}&continue=${target}";

  # Extension from addons.mozilla.org, kept updated. It can be disabled in
  # Zen but only removed here.
  amo = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "normal_installed";
    # Icon in the extensions menu, not the toolbar.
    default_area = "menupanel";
  };

  # Our unsigned add-on for the ⌃⇧H/K/O shortcuts; see shortcuts/. Zen only
  # replaces it when its version changes, so each build stamps one from the
  # build time. Zip can't store the store's 1970 timestamps, so they're
  # bumped to 1980.
  zenShortcuts = pkgs.runCommand "zen-shortcuts.xpi" { nativeBuildInputs = [ pkgs.zip ]; } ''
    cp -r ${./shortcuts} src
    chmod -R u+w src
    t=$(date +%s)
    sed -i "s/\"version\": \"1.0\"/\"version\": \"1.$((t / 100000)).$((t % 100000))\"/" src/manifest.json
    find src -exec touch -d @315532800 {} +
    cd src
    zip -q -r -X $out .
  '';

  # One entry per space. Each gets a container of the same name, plus Gmail
  # and Calendar Essentials signed into its Google account. Keep a
  # containerId once set; Zen ties the container's tabs to it.
  spaces = {
    blog = {
      position = 1;
      containerId = 1;
      color = "orange";
      icon = "🪵";
      email = "eric@barch.blog";
    };
    professional = {
      position = 2;
      containerId = 2;
      color = "green";
      icon = "👔";
      email = "eric.michael.barch@gmail.com";
    };
    current = {
      position = 3;
      containerId = 3;
      color = "blue";
      icon = "🚰";
      email = "eric@currentsoftware.app";
    };
  };

  mkContainer = _: space: {
    id = space.containerId;
    inherit (space) color;
    icon = "circle";
  };

  mkSpace = name: space: {
    id = uuid "zen-space-${name}";
    inherit (space) position icon;
    container = space.containerId;
    pins = {
      gmail = {
        id = uuid "zen-pin-${name}-gmail";
        url = googleUrl space.email "https://mail.google.com/mail/";
        position = 1;
        isEssential = true;
        container = space.containerId;
      };
      googleCalendar = {
        id = uuid "zen-pin-${name}-calendar";
        url = googleUrl space.email "https://calendar.google.com/calendar/";
        position = 2;
        isEssential = true;
        container = space.containerId;
      };
    };
  };

  # Toolbar areas changed from Zen's defaults. Edits made in Customize
  # Toolbar reset on restart.
  toolbarLayout = {
    placements = {
      # No compact mode toggle.
      zen-sidebar-top-buttons = [ ];
      # No flexible spaces around the address bar. Back and forward can't
      # leave this toolbar; userChrome draws the nav buttons over the
      # sidebar.
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

  # HACK: the flake skips writing spaces and pins when Zen's session file
  # doesn't exist yet (a new profile), so seed an empty one.
  # TODO: remove once upstream fixes it:
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
        # Reinstalled from the local file on every start, so rebuilds apply.
        "zen-shortcuts@dots" = {
          install_url = "file://${zenShortcuts}";
          installation_mode = "force_installed";
        };
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
        # Address bar in its own toolbar above the page, not in the sidebar.
        "zen.view.use-single-toolbar" = false;
        # Compact mode starts out hiding both; the shortcuts change this.
        "zen.view.compact.hide-toolbar" = true;
        "browser.uiCustomization.state" = builtins.toJSON toolbarLayout;
        # Zen adds a compact mode toggle on first run regardless of the
        # layout; marking that done keeps it out.
        "zen.ui.migration.compact-mode-button-added" = true;
        "zen.welcome-screen.seen" = true;
        # Zen opens its privacy policy as a second first-run tab.
        "startup.homepage_welcome_url.additional" = "";
        # 1Password handles addresses and cards.
        "extensions.formautofill.addresses.capture.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        # Let the shortcuts add-on install unsigned and run its privileged
        # part.
        "xpinstall.signatures.required" = false;
        "extensions.experiments.enabled" = true;
      };

      userChrome = builtins.readFile ./userChrome.css;

      search = {
        force = true;
        default = "ddg";
      };

      containersForce = true;
      containers = lib.mapAttrs mkContainer spaces;

      spacesForce = true;
      spaces = lib.mapAttrs mkSpace spaces;
    };
  };

  # home-manager owns profiles.ini, so Zen can't save its profile choice;
  # this makes it use the Default=1 profile.
  launchd.agents.moz-legacy-profiles = {
    enable = true;
    config = {
      ProgramArguments = [ "/bin/launchctl" "setenv" "MOZ_LEGACY_PROFILES" "1" ];
      RunAtLoad = true;
    };
  };
}
