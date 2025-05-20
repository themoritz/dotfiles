return {
  'ggandor/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, '<CR>', '<Plug>(leap)')
    vim.keymap.set('n', '<leader><CR>', '<Plug>(leap-from-window)')
  end,
}
