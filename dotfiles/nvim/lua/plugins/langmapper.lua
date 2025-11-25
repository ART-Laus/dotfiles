return {
  {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1,
    config = function()
      require('langmapper').setup()
    end,
  }
}
