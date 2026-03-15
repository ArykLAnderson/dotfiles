return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      -- Disable golangci-lint for Go files
      go = {},
      -- Disable markdown linting
      markdown = {},
    },
  },
}
