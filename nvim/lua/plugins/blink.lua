return {
  "saghen/blink.cmp",
  dependencies = {
    "Kaiser-Yang/blink-cmp-avante",
  },
  opts = function(_, opts)
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend("keep", {
      Color = "██", -- Use block instead of icon for color items to make swatches more usable
    }, LazyVim.config.icons.kinds)
    opts.sources = {
      -- Add 'avante' to the list
      default = { "avante", "copilot", "lsp", "path", "buffer" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          kind = "Copilot",
          score_offset = 100,
          async = true,
        },
      },
    }
    opts.keymap = {
      ["<C-y>"] = { "select_and_accept" },
      ["<C-h>"] = { "hide" },
      ["<C-e>"] = {
        require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      },
    }
  end,
}
