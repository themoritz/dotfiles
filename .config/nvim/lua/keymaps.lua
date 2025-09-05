vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>v', ':e $MYVIMRC<CR>', { desc = 'Open [V]im config' })
vim.keymap.set('n', '<leader>w', ':%s/\\s\\+$//e<CR>', { noremap = true, silent = true, desc = 'Trim [W]hitespace' })
