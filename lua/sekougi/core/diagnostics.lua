-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = true,  -- Show inline virtual text
  signs = true,         -- Show signs in the gutter
  update_in_insert = false,
  underline = true,     -- Underline the problematic code
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

