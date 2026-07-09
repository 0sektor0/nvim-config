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
            -- Список языков, которые будут автоматически установлены
            ensure_installed = {
                "lua",
                "vim",
                "rust",
                "c",
                "toml",
                "vimdoc",
                "c_sharp"
            },
            -- Автоматическая установка парсера при открытии файла, если он не установлен
            auto_install = true,
            -- Подсветка синтаксиса
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })

        require("nvim-ts-autotag").setup()
    end,
}
