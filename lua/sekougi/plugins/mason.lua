return {
    "mason-org/mason.nvim",
    dependencies = {
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "lua-language-server",
                    "rust-analyzer",
                    "codelldb",
                    "roslyn",
                    "omnisharp",
                    "netcoredbg",
                    "gopls",
                    "delve",
                },
            },
        },
    },
    config = function()
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        })
    end,
}
