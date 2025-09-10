{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        # Show hidden files by default (useful for .git directories, config files, etc.)
        show_hidden = true;
        # Sort directories first
        sort_dir_first = true;
        # Show size in human readable format
        linemode = "size";
        # Show full paths in the status bar
        show_task = true;
      };

      preview = {
        # Enable image preview if terminal supports it
        image_filter = "triangle";
        image_quality = 75;
        # Preview text files
        max_width = 600;
        max_height = 900;
      };

      opener = {
        # Open directories with Zed when Enter is pressed
        folder = [
          { run = "zed-fhs \"$1\""; desc = "Open with Zed"; for = "unix"; }
        ];
        text = [
          { run = "zed-fhs \"$1\""; desc = "Open with Zed"; for = "unix"; }
        ];
      };

      open = {
        # Rules for opening different file types
        rules = [
          { name = "*/"; use = "folder"; }
          { mime = "text/*"; use = "text"; }
          { mime = "image/*"; use = "image"; }
          { mime = "video/*"; use = "video"; }
          { mime = "audio/*"; use = "audio"; }
          { mime = "inode/x-empty"; use = "text"; }
          { mime = "application/json"; use = "text"; }
          { mime = "*/xml"; use = "text"; }
          { mime = "*/javascript"; use = "text"; }
          { mime = "*/x-wine-extension-ini"; use = "text"; }
        ];
      };

      tasks = {
        # Suppress task errors in selection mode
        suppress_preload = false;
        bizarre_retry = 5;
        image_alloc = 536870912; # 512MB
        image_bound = [0 0];
      };

      plugin = {
        # Enable useful plugins for development
        preloaders = [
          { name = "*"; cond = "!mime"; run = "mime"; multi = true; prio = "high"; }
        ];
      };

      input = {
        # Cursor settings
        cursor_blink = true;
      };

      log = {
        # Disable verbose logging for cleaner experience
        enabled = false;
      };
    };

    # Custom keymaps optimized for project selection
    keymap = {
      manager.prepend_keymap = [
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go home"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to config"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to downloads"; }
        { on = [ "g" "D" ]; run = "cd ~/Documents"; desc = "Go to documents"; }
        { on = [ "g" "p" ]; run = "cd ~/projects"; desc = "Go to projects"; }
        { on = [ "g" "n" ]; run = "cd ~/nixos"; desc = "Go to NixOS config"; }
        { on = [ "o" ]; run = "open"; desc = "Open selected"; }
        { on = [ "<Enter>" ]; run = "open"; desc = "Open selected"; }
        { on = [ "." ]; run = "hidden toggle"; desc = "Toggle hidden files"; }
        { on = [ "f" ]; run = "filter"; desc = "Filter files"; }
        { on = [ "/" ]; run = "find"; desc = "Find files"; }
        { on = [ "s" ]; run = "search fd"; desc = "Search with fd"; }
        { on = [ "S" ]; run = "search rg"; desc = "Search with ripgrep"; }
      ];
    };

    # Shell wrapper function for changing directory on exit
    initLua = ''
      -- Custom Yazi configuration for project selection
      function Linemode:custom()
        local time = math.floor(self._file.cha.modified or 0)
        if time == 0 then
          time = ""
        else
          time = os.date("%m/%d %H:%M", time)
        end

        local size = self._file:size()
        return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
      end
    '';
  };

  # Shell integration for changing directory when exiting Yazi
  programs.zsh.initContent = lib.mkAfter ''
    function yy() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
}
