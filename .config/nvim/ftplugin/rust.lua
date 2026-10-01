local function map(lhs, cmd, desc)
  vim.keymap.set("n", lhs, function()
    vim.cmd.RustLsp(cmd)
  end, { buffer = true, desc = desc })
end

map("<leader>a", "codeAction", "Rust LSP code action") -- supports rust-analyzer's grouping
map("<leader>re", "expandMacro", "Rust expand macro")
map("<leader>rE", { "explainError", "current" }, "Rust explain error")
map("<leader>rd", { "renderDiagnostic", "current" }, "Rust render diagnostic")
map("<leader>rr", "runnables", "Rust runnables")
map("<leader>rD", "debuggables", "Rust debuggables")
map("<leader>ro", "openCargo", "Rust open Cargo.toml")
map("<leader>rp", "parentModule", "Rust parent module")
