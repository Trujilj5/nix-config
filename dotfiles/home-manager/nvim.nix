{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      nil
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      python3Packages.python-lsp-server
      rust-analyzer
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      black
      rustfmt
      ripgrep
      fd
      git
      lazygit
      tree-sitter
    ];
  };

  home.file = {
    ".config/nvim/lua".source = ../config/nvim/lua;
    ".config/nvim/lazy-lock.json".source = ../config/nvim/lazy-lock.json;
    ".config/nvim/.luarc.json".source = ../config/nvim/.luarc.json;
  };

  xdg.configFile."nvim/init-custom.lua".source = ../config/nvim/init.lua;
}
