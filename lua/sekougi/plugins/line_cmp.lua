return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
    },
    config = function()
        local cmp = require("cmp")

        -- Основная настройка (для обычного редактирования)
        cmp.setup(
            {
                -- Installed sources:
                sources = {
                    { name = "path" }, -- file paths
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
                        { name = "cmdline" }
                    }
                )
            }
        )

        -- Дополнение при поиске (/ и ?)
        cmp.setup.cmdline(
            { "/", "?" },
            {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            }
        )
    end
}
