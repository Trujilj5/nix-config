# dotfiles/home-manager/nvim.nix - Neovim configuration
{ pkgs, ... }:

{
  # Enable Neovim with configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Additional packages that might be needed by plugins
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil # Nix language server
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      python3Packages.python-lsp-server
      rust-analyzer

      # Formatters
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      black
      rustfmt

      # Other tools
      ripgrep
      fd
      git
      lazygit
      tree-sitter
    ];
  };

  # Manage Neovim configuration files
  home.file = {
    # Main init file
    ".config/nvim/init.lua".source = ../config/nvim/init.lua;

    # Lua configuration directory
    ".config/nvim/lua".source = ../config/nvim/lua;

    # Lazy plugin lockfile
    ".config/nvim/lazy-lock.json".source = ../config/nvim/lazy-lock.json;

    # LSP configuration
    ".config/nvim/.luarc.json".source = ../config/nvim/.luarc.json;
  };
}
