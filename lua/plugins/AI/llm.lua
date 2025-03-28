return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      local tools = require("llm.tools") -- 更新为新的模块路径
      require("llm").setup({
        url = "https://api.deepseek.com/chat/completions",
        model = "deepseek-chat",
        api_type = "openai",
        max_tokens = 4096,
        temperature = 0.3,
        top_p = 0.7,

        -- 更新后的提示，使用完整 Markdown 格式
        prompt = [[
          1. 使用中文回复
          2. 确保代码直接可用
          3. 对所有文本使用完整的 Markdown 格式，包括标题、列表和代码块
          4. 优先使用最新的 API
        ]],

        prefix = {
          user = { text = " ", hl = "Title" }, -- 用户图标
          assistant = { text = " ", hl = "Added" }, -- 助手图标
        },

        save_session = true,
        max_history = 15,

        keys = {
          ["Input:Submit"] = { mode = { "n", "i" }, key = "<cr>", remap = true },
          ["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>", remap = true },
          ["Input:HistoryNext"] = { mode = { "n", "i" }, key = "<C-j>", remap = true },
          ["Input:HistoryPrev"] = { mode = { "n", "i" }, key = "<C-k>", remap = true },
        },

        -- 添加所有 AI 工具
        app_handler = {
          -- 翻译单词到中文
          WordTranslate = {
            handler = tools.flexi_handler,
            prompt = "将以下文本翻译成中文，仅返回翻译结果",
            opts = {
              exit_on_move = true,
              enter_flexible_window = false,
            },
          },

          -- 优化代码
          OptimizeCode = {
            handler = tools.side_by_side_handler,
            prompt = "优化以下代码，提供优化后的代码和简要说明",
          },

          -- 测试代码
          TestCode = {
            handler = tools.side_by_side_handler,
            prompt = "为以下代码编写测试用例，仅返回测试代码",
          },

          -- 文档生成
          DocGen = {
            handler = tools.side_by_side_handler,
            prompt = "为以下代码生成详细的文档注释",
          },

          -- 代码审查
          CodeReview = {
            handler = tools.side_by_side_handler,
            prompt = "审查以下代码，指出潜在问题并提供改进建议",
          },

          -- 代码解释
          ExplainCode = {
            handler = tools.flexi_handler,
            prompt = "解释以下代码的工作原理，使用清晰的中文描述",
          },

          -- 重构代码
          RefactorCode = {
            handler = tools.side_by_side_handler,
            prompt = "重构以下代码以提高可读性和效率，提供重构后的代码",
          },
        },
      })

      -- 设置文件类型为 Markdown 的自动命令
      vim.api.nvim_create_autocmd("FileType", { -- 注意这里改为 "FileType"（大写 T）
        pattern = "llm",
        callback = function()
          vim.bo.filetype = "markdown"
        end,
      })
    end,

    -- 保留现有的按键配置并添加新工具的快捷键
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "切换 AI 会话" },
      { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler  please explain the following code:<cr>", desc = "解释代码" },
      { "<leader>at", mode = "v", "<cmd>LLMSelectedTextHandler  optimize the following code:<cr>", desc = "优化代码" },
      { "<leader>ar", mode = "v", "<cmd>LLMSelectedTextHandler  refactor the following code:<cr>", desc = "重构代码" },
      { "<leader>ad", mode = "v", "<cmd>LLMSelectedTextHandler  add documentation to the following code:<cr>", desc = "添加文档" },
      { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler  translate the following text to Chinese:<cr>", desc = "翻译成中文" },
      { "<leader>te", mode = "x", "<cmd>LLMSelectedTextHandler  translate the following text to English:<cr>", desc = "翻译成英文" },
      -- 添加 AI 工具的快捷键
      { "<leader>aw", mode = "v", "<cmd>LLMAppHandler WordTranslate<cr>", desc = "翻译单词到中文" },
      { "<leader>ao", mode = "v", "<cmd>LLMAppHandler OptimizeCode<cr>", desc = "优化代码" },
      { "<leader>atc", mode = "v", "<cmd>LLMAppHandler TestCode<cr>", desc = "生成测试代码" },
      { "<leader>ag", mode = "v", "<cmd>LLMAppHandler DocGen<cr>", desc = "生成文档" },
      { "<leader>acr", mode = "v", "<cmd>LLMAppHandler CodeReview<cr>", desc = "代码审查" },
      { "<leader>aec", mode = "v", "<cmd>LLMAppHandler ExplainCode<cr>", desc = "解释代码" },
      { "<leader>arc", mode = "v", "<cmd>LLMAppHandler RefactorCode<cr>", desc = "重构代码" },
    },
  },
}