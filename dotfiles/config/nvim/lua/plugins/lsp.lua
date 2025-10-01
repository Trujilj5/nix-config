-- LSP configuration for Nix support
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Nix LSP
        nil_ls = {
          mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            ['nil'] = {
              testSetting = 42,
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        -- Alternative Nix LSP
        nixd = {
          mason = false,
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixpkgs-fmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/path/to/flake").nixosConfigurations.CONFIGNAME.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/path/to/flake").homeConfigurations.CONFIGNAME.options',
                },
              },
            },
          },
        },
        -- Lua LSP
        lua_ls = {
          mason = false,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        -- Bash LSP
        bashls = {
          mason = false,
        },
        -- Python LSP
        pyright = {
          mason = false,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        -- Rust LSP
        rust_analyzer = {
          mason = false,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      },
    },
  },
}