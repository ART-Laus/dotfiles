return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'lua','vim','query',
          'bash','json','yaml','toml','markdown','regex',
          'c','cpp','python',
          'javascript','typescript','html','css',
          'rust',
        },
        highlight = { enable = true },
      }
    end,
  }
}
