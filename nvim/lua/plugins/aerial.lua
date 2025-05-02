return {
  "stevearc/aerial.nvim",
  opts = function(_, opts)
    opts.layout.min_width = 30
    opts.layout.resize_to_content = true
    -- opts.layout.win_opts.relative_number = true
    return opts
  end,
}
