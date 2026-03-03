local function find_code_files()
    require("telescope.builtin").find_files({
        find_command = {
            "fd",
            "--type", "f",
            "--extension", "cs",
            "--extension", "shader",
            "--extension", "asmdef",
            "--extension", "html",
            "--extension", "rs",
            "--extension", "lua",
            "--extension", "c",
            "--extension", "js",
        },
    })
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        telescope.load_extension("fzf")

        local keymap = vim.keymap
        keymap.set("n", "<leader>ff", find_code_files, { desc = "Fuzzy find code file name" })
        keymap.set("n", "<leader>fa", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find file name" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
    end,
}
