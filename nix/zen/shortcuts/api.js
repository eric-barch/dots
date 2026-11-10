"use strict";

/* global ExtensionAPI, Services */

// Zen hides the sidebar and toolbar with compact mode, and two settings pick
// which of them compact mode hides. A part is hidden when compact mode is on
// and set to hide it; with neither hidden, compact mode is off.
this.zenLayout = class extends ExtensionAPI {
  getAPI() {
    return {
      zenLayout: {
        async toggle(part) {
          const win = Services.wm.getMostRecentWindow("navigator:browser");
          const compactMode = win?.gZenCompactModeManager;
          if (!compactMode) {
            return;
          }

          const isCompact = compactMode.preference;
          let sidebarHidden =
            isCompact &&
            Services.prefs.getBoolPref("zen.view.compact.hide-tabbar");
          let toolbarHidden =
            isCompact &&
            Services.prefs.getBoolPref("zen.view.compact.hide-toolbar");

          if (part === "sidebar") {
            sidebarHidden = !sidebarHidden;
          } else if (part === "toolbar") {
            toolbarHidden = !toolbarHidden;
          } else {
            // Hides both unless both are already hidden.
            const hide = !(sidebarHidden && toolbarHidden);
            sidebarHidden = hide;
            toolbarHidden = hide;
          }

          if (!sidebarHidden && !toolbarHidden) {
            compactMode.preference = false;
            return;
          }
          if (sidebarHidden && toolbarHidden) {
            compactMode.hideBoth();
          } else if (sidebarHidden) {
            compactMode.hideSidebar();
          } else {
            compactMode.hideToolbar();
          }
          compactMode.preference = true;
        },
      },
    };
  }
};
