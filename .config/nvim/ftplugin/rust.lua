vim.keymap.set("n", "<leader>a", function()
  vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
end, { buffer = true, desc = "Rust LSP code action" })
