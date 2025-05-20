return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = {
    disable_hint = true,
  },
  config = function()
    vim.keymap.set('n', '<leader>g', '<cmd>Neogit<cr>', { desc = 'Neo[g]it' })
  end,
}
