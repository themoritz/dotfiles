return {
  'Exafunction/windsurf.vim',
  event = 'BufEnter',
  config = function()
    vim.g.codeium_disable_bindings = 1

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'beancount' },
      command = 'CodeiumDisable',
    })

    vim.keymap.set('i', '<C-.>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })

    vim.keymap.set('i', '<C-/>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true, silent = true })

    vim.keymap.set('i', '<M-w>', function()
      return vim.fn['codeium#AcceptNextWord']()
    end, { expr = true, silent = true })

    vim.keymap.set('i', '<M-l>', function()
      return vim.fn['codeium#AcceptNextLine']()
    end, { expr = true, silent = true })

    vim.keymap.set('i', '<M-]>', function()
      return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true, silent = true })

    vim.keymap.set('i', '<M-[>', function()
      return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true, silent = true })
  end,
}
