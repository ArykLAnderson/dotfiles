return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend("keep", {
      Color = "██", -- Use block instead of icon for color items to make swatches more usable
    }, LazyVim.config.icons.kinds)
    opts.sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    }
    opts.keymap = {
      ["<C-y>"] = { "select_and_accept" },
      ["<C-h>"] = { "hide" },
      ["<C-e>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        LazyVim.cmp.map({ "snippet_forward" }),
        "fallback",
      },
    }
  end,
}
