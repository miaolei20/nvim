return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = function()
      return {
        -- 启用 treesitter 检查，提升配对准确性
        check_ts = true,
        -- 禁用特定文件类型，避免干扰
        disable_filetype = { "TelescopePrompt", "vim" },
        -- 优化性能：禁用未使用的功能
        disable_in_macro = true,  -- 在宏录制时禁用
        disable_in_visualblock = true,  -- 在可视块模式下禁用
        -- VSCode-like 行为：快速配对和跳过
        fast_wrap = {
          map = "<M-e>",  -- Alt+e 快速包裹（模仿 VSCode 可选快捷键）
          chars = { "{", "[", "(", "\"", "'" },  -- 支持的包裹字符
          pattern = [=[[%'%"%>%]%)%}%,%;%s]]=],  -- 结束触发模式
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",  -- 快捷键顺序
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
        -- 映射 VSCode 风格的闭合括号跳过
        map_bs = true,  -- 启用 Backspace 删除配对
        map_c_h = false,  -- 禁用 Ctrl+h（减少冲突）
        map_c_w = false,  -- 禁用 Ctrl+w（减少冲突）
      }
    end,
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      -- CMP 集成优化：延迟加载并绑定确认事件
      local cmp_status, cmp = pcall(require, "cmp")
      if cmp_status then
        cmp.event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
      end

      -- 添加自定义规则：模仿 VSCode 的智能闭合跳过
      local Rule = require("nvim-autopairs.rule")
      autopairs.add_rules({
        -- 当输入闭合括号时，如果已配对则跳过
        Rule("(", ")"):end_wise(function()
          return vim.fn.col(".") - 1 == vim.fn.col("$") - 1
        end),
        Rule("{", "}"):end_wise(function()
          return vim.fn.col(".") - 1 == vim.fn.col("$") - 1
        end),
        Rule("[", "]"):end_wise(function()
          return vim.fn.col(".") - 1 == vim.fn.col("$") - 1
        end),
      })
    end,
  },
}