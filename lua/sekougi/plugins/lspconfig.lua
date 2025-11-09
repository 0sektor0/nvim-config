-- nvim/lua/sekougi/plugins/lspconfig.lua

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Базовые настройки LSP которые применяются ко всем серверам
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    -- Общая функция on_attach для всех LSP серверов
    local on_attach = function(client, bufnr)
      -- Включить completion
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      
      -- Настройка ключевых mappings для LSP
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Навигация по коду
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      
      -- Работа с кодом
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
      
      -- Диагностика
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
      
      -- Подсветка символов под курсором
      if client.server_capabilities.documentHighlightProvider then
        vim.cmd([[
          augroup LspDocumentHighlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]])
      end
    end

    -- Глобальные настройки диагностики
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Значки для диагностики на полях
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
