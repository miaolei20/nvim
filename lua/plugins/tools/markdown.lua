return{
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
        latex = { 
          enabled = false, -- 彻底禁用 LaTeX
          fallback_to_text = false 
        }
      },
}