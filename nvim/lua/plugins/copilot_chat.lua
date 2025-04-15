return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    prompts = {
      WriteUnitTest = {
        prompt = "Write a unit test for the following code: {code}",
        system_prompt = "Prefer to write unit tests with an anonymous struct defining the test scenario that uses setup and assert functions",
        mapping = "<leader>ccmc",
        description = "My custom prompt description",
      },
    },
  },
}
