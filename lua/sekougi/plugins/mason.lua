return {
    "mason-org/mason.nvim",
    opts = {},
    ensure_installed = {
        "lua-language-server",
        "rust-anayzer",
        "codelldb",
    },
    config = function()
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        })
    end
}
