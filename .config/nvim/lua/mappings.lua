require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- blank border in the float's own bg = 1-cell padding around hover text
local pad = { " ", "NormalFloat" }
local padded_border = { pad, pad, pad, pad, pad, pad, pad, pad }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    map("n", "K", function()
      vim.lsp.buf.hover { border = padded_border }
    end, { buffer = args.buf, desc = "LSP hover" })
  end,
})

vim.lsp.inlay_hint.enable(true)
map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Run or continue the debugger" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Condition: ")
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "Step over" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step into" })
map("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "Step out" })
map("n", "<leader>dC", function()
  require("dap").run_to_cursor()
end, { desc = "Run to cursor" })
map("n", "<leader>dq", function()
  require("dap").terminate()
end, { desc = "Terminate debug session" })
map("n", "<leader>dt", function()
  require("dapui").toggle()
end, { desc = "Toggle debug UI" })
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug continue" })
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug step over" })
map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug step into" })
map("n", "<F12>", function()
  require("dap").step_out()
end, { desc = "Debug step out" })
map("n", "<leader>dus", function ()
    local widgets = require('dap.ui.widgets');
    local sidebar = widgets.sidebar(widgets.scopes);
    sidebar.open();
end, { desc = "Open debugging sidebar" })
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>tt", function()
    require("neotest").run.run()
end, { desc = "Run nearest test" })

map("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file test" })

map("n", "<leader>ta", function()
    require("neotest").run.run(vim.uv.cwd())
end, { desc = "Run All Test Files" })

map("n", "<leader>td", function()
    require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

map("n", "<leader>to", ":Neotest output<CR>", { desc = "Test output" })
map("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Test summary" })

map("n", "<leader>rcu", function()
    require('crates').upgrade_all_crates()
end, { desc = "Upgrade crates" })

map("n", "<leader>nu", function()
    require("package-info").update()
end, { desc = "Update dependency" })

map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>lt", function ()
  require("gitui").open()
end, { desc = "Gitui" })
