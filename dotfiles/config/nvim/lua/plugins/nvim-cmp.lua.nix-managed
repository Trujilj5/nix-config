return {
  {
    "hrsh7th/cmp-nvim-lsp",  -- LSP completion source
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",      -- LuaSnip integration with cmp
      "rafamadriz/friendly-snippets",  -- Predefined snippets
    },
  },
  {
    "hrsh7th/cmp-buffer",  -- Buffer completions
  },
  {
    "hrsh7th/cmp-path",    -- File path completions (useful for Bun scripts)
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      vim.opt.completeopt = "menu,menuone,noselect"
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()  -- Load VSCode-style snippets

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Optional: Jump through snippet placeholders
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- LSP completions (Lua, TS, YAML)
          { name = "luasnip" },   -- Snippets (all languages)
          { name = "path" },      -- File paths (useful for Bun)
        }, {
          { name = "buffer" },    -- Buffer words (all languages)
        }),
      })
    end,
  },
}
