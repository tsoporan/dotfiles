-- LSP Zero plugin config

local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

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


lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
