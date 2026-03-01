return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require('nvim-treesitter').install({ 'lua', 'vim', 'rust', 'c', 'toml', 'vimdoc', 'c_sharp' }):wait(300000)
    end,
}
