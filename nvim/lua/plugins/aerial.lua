return {
  "stevearc/aerial.nvim",
  opts = function(_, opts)
    return {
      layout = {
        min_width = 30,
        resize_to_content = true,
      },
    }
    -- opts.layout.win_opts.relative_number = true
  end,
}
