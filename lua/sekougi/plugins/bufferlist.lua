return {
    "kilavila/nvim-bufferlist",
    config = function()
    
      --set keymaps
      local keymap = vim.keymap

      keymap.set("n", "<leader>bl", "<cmd>BufferListOpen<cr>", { desc = "Open buffer list" })
      keymap.set("n", "<leader>bq", "<cmd>QuickNavOpen<cr>", { desc = "Open pinned buffer list" })
      keymap.set("n", "<leader>ba", "<cmd>QuickNavAdd<cr>", { desc = "Pin buffer" })
      keymap.set("n", "<leader>bb", "<cmd>QuickNavNext<cr>", { desc = "Next pinned buffer" })
      keymap.set("n", "<leader>bv", "<cmd>QuickNavPrev<cr>", { desc = "Prev pinned buffer" })

      end,
}
