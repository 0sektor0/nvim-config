return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            -- Languages that will be installed automatically
            ensure_installed = {
                "lua",
                "vim",
                "rust",
                "c",
                "toml",
                "vimdoc",
                "c_sharp"
            },
            -- Automatically install a parser when opening a file if it is missing
            auto_install = true,
            -- Syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })

        require("nvim-ts-autotag").setup()
    end,
}
