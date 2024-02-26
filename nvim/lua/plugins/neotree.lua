return {
  "nvim-neo-tree/neo-tree.nvim",
  requires = {
    "3rd/image.nvim",
  },
  opts = function()
    return {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
        },
      },
    }
  end,
}
