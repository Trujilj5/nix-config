{ pkgs, ... }:

{
  stylix.targets.neovim.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", -- latest stable release
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      local opts = {}

      require("vim-options")
      require("lazy").setup("plugins")
    '';

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
}