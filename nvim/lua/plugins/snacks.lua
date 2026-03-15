return {
  "folke/snacks.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>*", LazyVim.pick("grep_word"), desc = "Grep word under cursor" },
    
    -- Remap autocmds to <leader>sA
    { "<leader>sA", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    
    -- Search AI documents in ./ai/ directory (including gitignored files)
    { "<leader>sa", function()
      local ai_dir = vim.fn.getcwd() .. "/ai"
      if vim.fn.isdirectory(ai_dir) == 0 then
        vim.notify("No ./ai directory found in current project", vim.log.levels.WARN)
        return
      end
      Snacks.picker.files({
        cwd = ai_dir, -- Set working directory to ./ai
        prompt_title = "Search AI Documents",
        args = { "--no-ignore-vcs" }, -- Search gitignored files
      })
    end, desc = "Search AI docs" },
  },
}
