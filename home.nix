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

  # Our own unsigned add-on with shortcuts to hide the sidebar and toolbar.
  # See zen-shortcuts/api.js. Zen keeps its installed copy while the
  # version stays the same, so each build stamps a newer version from the
  # build time. Zip stores timestamps from 1980 on, so the store's 1970
  # ones are moved up first.
  zenShortcuts = pkgs.runCommand "zen-shortcuts.xpi" { nativeBuildInputs = [ pkgs.zip ]; } ''
    cp -r ${./zen-shortcuts} src
    chmod -R u+w src
    t=$(date +%s)
    sed -i "s/\"version\": \"1.0\"/\"version\": \"1.$((t / 100000)).$((t % 100000))\"/" src/manifest.json
    find src -exec touch -d @315532800 {} +
    cd src
    zip -q -r -X $out .
  '';

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
      # Firefox won't let back and forward leave this toolbar, so
      # userChrome draws the nav buttons over the top of the sidebar.
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
        # Enable the Browser Toolbox (Tools > Browser Tools), devtools for
        # Zen's own interface. Used to inspect it when writing userChrome.
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;
        "zen.workspaces.container-specific-essentials-enabled" = true;
        "zen.view.show-newtab-button-top" = false;
        # Address bar and nav buttons in a toolbar above the page, instead of
        # at the top of the sidebar.
        "zen.view.use-single-toolbar" = false;
        # Compact mode hides the toolbar as well as the sidebar.
        "zen.view.compact.hide-toolbar" = true;
        "browser.uiCustomization.state" = builtins.toJSON toolbarLayout;
        # On first run, Zen adds the compact mode toggle to the toolbar
        # regardless of the layout above, then sets this flag so it only
        # happens once. Marking it done keeps the toggle out.
        "zen.ui.migration.compact-mode-button-added" = true;
        "zen.welcome-screen.seen" = true;
        # Zen opens its privacy policy as a second first-run tab.
        "startup.homepage_welcome_url.additional" = "";
        # 1Password handles addresses and cards.
        "extensions.formautofill.addresses.capture.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        # Let the zen-shortcuts add-on install without Mozilla's signature,
        # and run the privileged part that changes Zen's compact mode.
        "xpinstall.signatures.required" = false;
        "extensions.experiments.enabled" = true;
      };

      # The page fills the window's edges, with no gap or rounding there.
      # Where it meets the sidebar and toolbar, it keeps Zen's normal gap
      # and rounded corner. In compact mode, the sidebar and toolbar are
      # hidden, so the left and top are window edges too. Targets Zen's
      # internal element names, so a Zen update could stop it working; Zen
      # would then just look like its default again.
      userChrome = ''
        :root:not([inDOMFullscreen="true"]) #zen-tabbox-wrapper {
          margin-right: 0 !important;
          margin-bottom: 0 !important;
        }
        :root:not([inDOMFullscreen="true"]) .browserSidebarContainer {
          border-top-right-radius: 0 !important;
          border-bottom-right-radius: 0 !important;
          border-bottom-left-radius: 0 !important;
        }
        :root[zen-compact-mode="true"]:not([inDOMFullscreen="true"]) #zen-tabbox-wrapper {
          margin-left: 0 !important;
          margin-top: 0 !important;
        }
        :root[zen-compact-mode="true"]:not([inDOMFullscreen="true"]) .browserSidebarContainer {
          border-top-left-radius: 0 !important;
        }
        /* While hidden in compact mode, the toolbar's container still
           reserves a strip at the top of the window. Only applies when
           compact mode is set to hide the toolbar. */
        @media -moz-pref("zen.view.compact.hide-toolbar") {
          :root[zen-compact-mode="true"] #zen-appcontent-navbar-wrapper:not(:is([zen-has-hover], [has-popup-menu], [zen-compact-mode-active])) {
            height: 0 !important;
            min-height: 0 !important;
          }
        }
        /* In compact mode, Zen moves the window buttons, and the now-empty
           top row of the sidebar, into the toolbar. The window buttons are
           taken out of the layout, staying where they are, and the empty
           row is sized to keep the nav buttons and address bar where they
           are when the sidebar is shown. 226px was measured from a screen
           recording against the sidebar's 231px width. Zen keeps that width
           on the sidebar itself, out of the toolbar's reach, so it is
           repeated here and goes stale if the sidebar is resized. The
           window buttons aren't sized directly because Zen draws their dots
           as a pattern that repeats across their full width. */
        :root[zen-compact-mode="true"] #nav-bar > .titlebar-buttonbox-container {
          position: absolute !important;
        }
        :root[zen-compact-mode="true"] #nav-bar > #zen-sidebar-top-buttons {
          box-sizing: border-box !important;
          width: 226px !important;
          min-width: 226px !important;
          padding: 0 !important;
          margin: 0 !important;
          flex-shrink: 0 !important;
          overflow: hidden !important;
        }
        /* While the sidebar slides, Zen drops some of its compact mode
           spacing, which pulls the window buttons 6px left and the nav
           buttons and address bar 12px left for the length of the slide.
           These undo that; both offsets were measured from a screen
           recording. */
        :root[zen-compact-mode="true"][zen-compact-animating] #nav-bar > .titlebar-buttonbox-container {
          translate: 6px 0 !important;
        }
        :root[zen-compact-mode="true"][zen-compact-animating] #nav-bar > #zen-sidebar-top-buttons {
          width: 231px !important;
          min-width: 231px !important;
        }
        /* Zen slides the sidebar in and out of compact mode by animating
           its margin, which drags the page and toolbar along with it. While
           it animates, it's taken out of the layout and slides over the
           page, below the toolbar, so nothing else moves. */
        :root[zen-compact-mode="true"] #navigator-toolbox[animate="true"] {
          position: fixed !important;
          z-index: 10 !important;
          top: var(--zen-toolbar-height-with-bookmarks) !important;
          bottom: 0 !important;
          left: 0 !important;
        }
        /* The page alone then slides alongside the sidebar, by the
           sidebar's 231px width, over the same 0.1s Zen gives the sidebar.
           Zen marks only the slide in, by clipping #browser, which is how
           the two directions are told apart. */
        @keyframes zen-page-slide-out {
          from { translate: 231px 0; }
          to { translate: 0 0; }
        }
        @keyframes zen-page-slide-in {
          from { translate: 0 0; }
          to { translate: 231px 0; }
        }
        :root[zen-compact-mode="true"][zen-compact-animating] #browser:not([style*="clip"]) #zen-tabbox-wrapper {
          animation: zen-page-slide-out 0.1s ease-out forwards;
        }
        :root[zen-compact-mode="true"][zen-compact-animating] #browser[style*="clip"] #zen-tabbox-wrapper {
          animation: zen-page-slide-in 0.1s ease-out forwards;
        }
        /* Back, forward and reload stay in the toolbar but are drawn at the
           end of the sidebar's top row, so the address bar starts where the
           sidebar ends. Each is fixed at 32px, and the first is pulled left
           by all three (96px). */
        #nav-bar :is(#back-button, #forward-button, #stop-reload-button) {
          width: 32px !important;
          min-width: 32px !important;
          max-width: 32px !important;
          margin-inline: 0 !important;
          padding-inline: 0 !important;
          justify-content: center !important;
        }
        #nav-bar #stop-reload-button > toolbarbutton {
          margin-inline: 0 !important;
          padding-inline: 0 !important;
        }
        #nav-bar #back-button {
          margin-inline-start: -96px !important;
        }
      '';

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
