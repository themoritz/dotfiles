-- Instally Lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require 'settings'
require 'keymaps'

-- Configure plugins
local plugins = 'plugins'
require('lazy').setup(plugins, {
  change_detection = { notify = false },
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.bean', '*.beancount' },
  callback = function()
    vim.bo.filetype = 'beancount'
  end,
  group = vim.api.nvim_create_augroup('beancount', { clear = true }),
})
