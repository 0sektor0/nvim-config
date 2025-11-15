function config_rust()
    vim.lsp.config(
        "rust_analyzer",
        {
            settings = {
                ["rust_analyzer"] = {
                    diagnostics = {
                        enable = true,
                    }
                }
            }
        }
    )

    vim.lsp.enable("rust_analyzer")
end

function config_lua()
    vim.lsp.config(
        "lua_ls",
        {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath("config") and
                        (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                    then
                        return
                    end
                end

                client.config.settings.Lua =
                    vim.tbl_deep_extend(
                        "force",
                        client.config.settings.Lua,
                        {
                            runtime = {
                                version = "LuaJIT",
                                path = {
                                    "lua/?.lua",
                                    "lua/?/init.lua"
                                }
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME
                                }
                            }
                        }
                    )
            end,
            settings = {
                Lua = {}
            }
        }
    )

    vim.lsp.enable("lua_ls")
end

function config_keymap()
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })

    vim.keymap.set("n", "<leader>lb", function()
        vim.lsp.buf.format({ async = true })
    end, { desc = "Lint format buffer" })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } }
            }
        }
    },
    config = function()
        config_lua()
        config_rust()
        config_keymap()
    end
}
