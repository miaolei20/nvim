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

        -- 增强提示词工程：明确要求使用 Markdown 代码块格式
        prompt = [[
          你是一个专业的编程助手，遵循以下规则：
          1. 用中文回答
          2. 代码需要可直接应用
          3. 使用 Markdown 代码块格式
          4. 优先使用最新 API
        ]],

        -- 优化界面显示
        prefix = {
          user = { text = "  ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },

        -- 历史记录配置
        save_session = true,
        max_history = 15,

        -- 增强键位映射（双模式支持）
        keys = {
          ["Input:Submit"]      = { mode = {"n", "i"}, key = "<cr>", remap = true },
          ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>", remap = true },
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>", remap = true },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>", remap = true },
        },
      })

      -- 通过自动命令将 LLM 窗口的 filetype 设置为 markdown，从而保证内容渲染正确
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "llm",  -- 此处假设 LLM 窗口的 filetype 为 "llm"
        callback = function()
          vim.bo.filetype = "markdown"
        end,
      })
    end,

    -- 快捷键配置
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "Toggle AI Session" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", desc = "Explain Code" },
      { "<leader>at", mode = "v", "<cmd>LLMSelectedTextHandler 优化这段代码<cr>", desc = "Optimize Code" },
      { "<leader>ar", mode = "v", "<cmd>LLMSelectedTextHandler 重构这段代码<cr>", desc = "Refactor Code" },
      { "<leader>ad", mode = "v", "<cmd>LLMSelectedTextHandler 为这段代码添加文档注释<cr>", desc = "Add Docs" },
      { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 将以下内容翻译成中文:<cr>", desc = "Translate to ZH" },
      { "<leader>te", mode = "x", "<cmd>LLMSelectedTextHandler Translate to English:<cr>", desc = "Translate to EN" },
    },
  },
}
