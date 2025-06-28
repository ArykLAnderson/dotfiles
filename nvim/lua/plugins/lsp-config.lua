return {
  "neovim/nvim-lspconfig",
  opts = function()
    return {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- Enable lsp cursor word highlighting
      document_highlight = {
        enabled = true,
      },
      -- add any global capabilities here
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        protols = {},
        jdtls = {},
        ts_ls = {
          enabled = true,
        },
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          -- ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = false,
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
        yamlls = {
          settings = {
            schemas = {
              gitlab = "/*ci.yml",
              kubernetes = "/*.yaml",
              -- Add the schema for gitlab piplines
              -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.yml",
            },
          },
        },
        zls = {
          cmd = { vim.fn.expand("$HOME/workspace/zig/zls/zig-out/bin/zls") },
          settings = {
            enable_build_on_save = true,
            build_on_save_args = { "install", "-Dtarget=wasm32-wasi", "-fwasmtime" },
          },
        },
        -- groovyls = {
        --     filetypes = { "groovy" },
        --     settings = {
        --       groovy = {
        --         classpath = {
        --           groovyPackagePath .. "/build/libs/groovy-language-server-all.jar",
        --         },
        --       },
        --     },
        -- }
      },
      setup = {
        -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
        jdtls = function(_, opts)
          return true
        end,
      },
    }
  end,
}
