return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
  init = function()
    local harpoon = require("harpoon")
    require("which-key").add({
      { "<leader>h", group = "Harpoon", icon = "󰛢" },
      { "<leader>ha", function() harpoon:list():add() end, desc = "Add File", icon = "󰐕" },
      { "<leader>h1", function() harpoon:list():select(1) end, desc = "Go to File 1", icon = "󰎤" },
      { "<leader>h2", function() harpoon:list():select(2) end, desc = "Go to File 2", icon = "󰎧" },
      { "<leader>h3", function() harpoon:list():select(3) end, desc = "Go to File 3", icon = "󰎪" },
      { "<leader>h4", function() harpoon:list():select(4) end, desc = "Go to File 4", icon = "󰎭" },
      { "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Toggle Menu", icon = "󰍜" },
    })
  end,
}
