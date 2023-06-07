-- LSP Zero plugin config

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'pyright',
    'rust_analyzer'
})

-- On attach to lsp-enabled buffer
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr }
    local bind = vim.keymap.set

    bind('n', '<leader>ws', function() vim.lsp.buf.workspace_symbol() end, opts)
    bind('n', '<leader>ve', function() vim.diagnostic.open_float() end, opts)
    bind('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
    bind('n', '<leader>re', function() vim.lsp.buf.references() end, opts)
    bind('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)

    -- Auto format on save based on current lang server (must be one)
    lsp.buffer_autoformat()
end)

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.setup()

local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }
})
