return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-cmdline"
    },
    config = function()
        local cmp = require("cmp")

        -- Основная настройка (для обычного редактирования)
        cmp.setup(
            {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Add tab support
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm(
                        {
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true
                        }
                    )
                },
                -- Installed sources:
                sources = {
                    {name = "path"}, -- file paths
                    {name = "nvim_lsp", keyword_length = 3}, -- from language server
                    {name = "nvim_lsp_signature_help"}, -- display function signatures with current parameter emphasized
                    {name = "nvim_lua", keyword_length = 2}, -- complete neovim's Lua runtime API such vim.lsp.*
                    {name = "buffer", keyword_length = 2}, -- source current buffer
                    {name = "vsnip", keyword_length = 2}, -- nvim-cmp source for vim-vsnip
                    {name = "calc"} -- source for math calculation
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                }
            }
        )

        -- Дополнение в командной строке
        cmp.setup.cmdline(
            ":",
            {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    {
                        {name = "cmdline"}
                    }
                )
            }
        )

        -- Дополнение при поиске (/ и ?)
        cmp.setup.cmdline(
            {"/", "?"},
            {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    {name = "buffer"}
                }
            }
        )
    end
}

