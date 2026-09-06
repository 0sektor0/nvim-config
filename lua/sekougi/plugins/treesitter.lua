return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local parsers = {
            'go',
            'rust',
            'c',
            'c_sharp',
            'lua',
            'vim',
            'vimdoc',
            'toml',
            'markdown',
            'markdown_inline',
            'query'
        }
        require('nvim-treesitter').install(parsers):wait(300000)

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end
}
