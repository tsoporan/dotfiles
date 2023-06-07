-- Telescope plugin config


local builtin = require('telescope.builtin')

require('telescope').setup({
    defaults = {
        layout_config = {
            horizontal = {
                prompt_position = "bottom",
                preview_width = 0.55,
                results_width = 0.8
            }
        },
    },
})

require('telescope').load_extension "file_browser"

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fs', builtin.git_files, {})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

vim.api.nvim_set_keymap("n", "<leader><leader>", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
    { noremap = true, silent = true })


vim.api.nvim_set_keymap(
    "n",
    "<leader>x",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)
