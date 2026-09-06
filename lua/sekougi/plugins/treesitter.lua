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
    end
}
