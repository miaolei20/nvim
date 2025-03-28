return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      require("llm").setup({
        url = "https://api.deepseek.com/chat/completions",
        model = "deepseek-chat",
        api_type = "openai",
        max_tokens = 4096,
        temperature = 0.3,
        top_p = 0.7,

        -- Updated prompt with full Markdown formatting
        prompt = [[
          1. Use Chinese for responses
          2. Ensure code is directly applicable
          3. Use full Markdown formatting for all text, including headers, lists, and code blocks
          4. Prioritize the latest API
        ]],

        prefix = {
          user = { text = " ", hl = "Title" }, -- Updated user icon
          assistant = { text = " ", hl = "Added" }, -- Updated assistant icon
        },

        save_session = true,
        max_history = 15,

        keys = {
          ["Input:Submit"] = { mode = {"n", "i"}, key = "<cr>", remap = true },
          ["Input:Cancel"] = { mode = {"n", "i"}, key = "<C-c>", remap = true },
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>", remap = true },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>", remap = true },
        },
      })

      -- Autocmd to set filetype to markdown
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "llm",
        callback = function()
          vim.bo.filetype = "markdown"
        end,
      })
    end,

    -- Keeping present key configurations
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "Toggle AI Session" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler  please explain the following code:<cr>", desc = "Explain Code" },
      { "<leader>at", mode = "v", "<cmd>LLMSelectedTextHandler  optimize the following code:<cr>", desc = "Optimize Code" },
      { "<leader>ar", mode = "v", "<cmd>LLMSelectedTextHandler  refactor the following code:<cr>", desc = "Refactor Code" },
      { "<leader>ad", mode = "v", "<cmd>LLMSelectedTextHandler  add documentation to the following code:<cr>", desc = "Add Docs" },
      { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler  translate the following text to Chinese:<cr>", desc = "Translate to ZH" },
      { "<leader>te", mode = "x", "<cmd>LLMSelectedTextHandler  translate the following text to English:<cr>", desc = "Translate to EN" },
    },
  },
}