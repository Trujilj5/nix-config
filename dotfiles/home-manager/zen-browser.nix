{ pkgs, lib, inputs, ... }:

{
  # Install zen-browser from flake input
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  # Zen Browser configuration files
  home.file = {
    # Main user preferences extracted from current prefs.js
    ".zen/profiles/v9uffy91.Default Profile/user.js" = {
      text = ''
        // Current user preferences from existing configuration
        user_pref("browser.toolbars.bookmarks.visibility", "always");
        user_pref("browser.contentblocking.category", "standard");
        user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
        user_pref("sidebar.visibility", "hide-sidebar");
        user_pref("layout.css.prefers-color-scheme.content-override", 0);
        user_pref("browser.download.useDownloadDir", true);
        user_pref("browser.download.alwaysOpenPanel", false);
        user_pref("devtools.theme", "dark");
        user_pref("devtools.toolbox.host", "right");
        user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
        user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
        user_pref("font.name.monospace.x-western", "sans-serif");
        user_pref("font.name.sans-serif.x-western", "sans-serif");
        user_pref("font.name.serif.x-western", "sans-serif");
        user_pref("privacy.globalprivacycontrol.was_ever_enabled", true);
        user_pref("privacy.clearOnShutdown_v2.formdata", true);
        user_pref("privacy.history.custom", true);
        user_pref("doh-rollout.mode", 0);
        user_pref("doh-rollout.uri", "https://mozilla.cloudflare-dns.com/dns-query");
      '';
    };

    # Keyboard shortcuts - current configuration
    ".zen/profiles/v9uffy91.Default Profile/zen-keyboard-shortcuts.json" = {
      text = ''
        {
          "shortcuts": [
            {
              "id": "zen-workspace-forward",
              "key": "k",
              "keycode": "",
              "group": "zen-workspace",
              "modifiers": {"control": false, "alt": false, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenWorkspaceForward",
              "disabled": false
            },
            {
              "id": "zen-workspace-backward",
              "key": "j",
              "keycode": "",
              "group": "zen-workspace",
              "modifiers": {"control": false, "alt": false, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenWorkspaceBackward",
              "disabled": false
            },
            {
              "id": "zen-split-view-grid",
              "key": "g",
              "keycode": "",
              "group": "zen-split-view",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenSplitViewGrid",
              "disabled": false
            },
            {
              "id": "zen-split-view-vertical",
              "key": "v",
              "keycode": "",
              "group": "zen-split-view",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenSplitViewVertical",
              "disabled": false
            },
            {
              "id": "zen-split-view-horizontal",
              "key": "h",
              "keycode": "",
              "group": "zen-split-view",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenSplitViewHorizontal",
              "disabled": false
            },
            {
              "id": "zen-split-view-unsplit",
              "key": "u",
              "keycode": "",
              "group": "zen-split-view",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenSplitViewUnsplit",
              "disabled": false
            },
            {
              "id": "zen-toggle-sidebar",
              "key": "b",
              "keycode": "",
              "group": "zen-other",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": false},
              "action": "cmd_zenToggleSidebar",
              "disabled": false
            },
            {
              "id": "zen-compact-mode-toggle",
              "key": "e",
              "keycode": "",
              "group": "zen-compact-mode",
              "modifiers": {"control": false, "alt": false, "shift": true, "meta": false, "accel": false},
              "action": "cmd_zenCompactModeToggle",
              "disabled": false
            },
            {
              "id": "zen-compact-mode-show-toolbar",
              "key": "t",
              "keycode": "",
              "group": "zen-compact-mode",
              "modifiers": {"control": false, "alt": true, "shift": false, "meta": false, "accel": true},
              "action": "cmd_zenCompactModeShowToolbar",
              "disabled": false
            },
            {
              "id": "zen-copy-url",
              "key": "c",
              "keycode": "",
              "group": "zen-other",
              "modifiers": {"control": false, "alt": false, "shift": true, "meta": false, "accel": true},
              "action": "cmd_zenCopyCurrentURL",
              "disabled": false
            },
            {
              "id": "zen-copy-url-markdown",
              "key": "c",
              "keycode": "",
              "group": "zen-other",
              "modifiers": {"control": false, "alt": true, "shift": true, "meta": false, "accel": true},
              "action": "cmd_zenCopyCurrentURLMarkdown",
              "disabled": false
            }
          ]
        }
      '';
    };

    # UI customization state
    ".zen/profiles/v9uffy91.Default Profile/xulstore.json" = {
      text = ''
        {
          "chrome://browser/content/browser.xhtml": {
            "sidebar-box": {
              "sidebarcommand": "",
              "style": "",
              "hidden": "true"
            }
          }
        }
      '';
    };

    # Profiles configuration
    ".zen/profiles.ini" = {
      text = ''
        [Profile0]
        Name=Default Profile
        IsRelative=1
        Path=v9uffy91.Default Profile
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';
    };

    # Empty zen themes configuration (as currently set)
    ".zen/profiles/v9uffy91.Default Profile/zen-themes.json" = {
      text = "{}";
    };
  };

  # Desktop entry for zen-browser
  xdg.desktopEntries.zen-browser = {
    name = "Zen Browser";
    genericName = "Web Browser";
    comment = "Browse the World Wide Web";
    exec = "zen";
    icon = "zen-browser";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "application/xhtml+xml"
    ];
    settings = {
      StartupNotify = "true";
    };
  };

  # Session variables for Wayland support
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}