return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    close_if_last_window = false,
    config = function()
        vim.keymap.set("n", "<leader>tb", "<cmd>Neotree show focus buffers right<cr>",
            { desc = "Neotree show buffers right" })
        vim.keymap.set("n", "<leader>tt", "<cmd>Neotree show focus filesystem left<cr>",
            { desc = "Neotree show filesystem" })
        vim.keymap.set("n", "<leader>tg", "<cmd>Neotree float git_status<cr>", { desc = "Neotree git status" })

        vim.keymap.set("n", "<leader>tc", function()
            vim.cmd("Neotree close buffers")
            vim.cmd("Neotree close filesystem")
        end, { desc = "Nootree: close all" })

        vim.keymap.set("n", "<leader>te", function()
            vim.cmd("Neotree show buffers right")
            vim.cmd("Neotree show filesystem left")
        end, { desc = "Nootree: close all" })
    end
}
