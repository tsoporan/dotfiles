-- JABS plugin config

require('jabs').setup({
    position = { 'right', 'bottom' },
    sort_mru = true
})

vim.api.nvim_set_keymap(
    "n",
    "<leader>b",
    ":JABSOpen<CR>",
    { noremap = true }
)
