require "nvchad.mappings"

-- add yours here

local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Run or continue the debugger" })
map("n", "<leader>dus", function ()
    local widgets = require('dap.ui.widgets');
    local sidebar = widgets.sidebar(widgets.scopes);
    sidebar.open();
end, { desc = "Open debugging sidebar" })
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~2<CR>", { desc = "Git Last Commit" })
map("n", "<leader>tt", function()
    require("neotest").run.run()
end, { desc = "Run nearest test" })

map("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file test" })

map("n", "<leader>ta", function()
    require("neotest").run.run(vim.loop.cwd())
end, { desc = "Run All Test Files" })

map("n", "<leader>to", ":Neotest output<CR>", { desc = "Test output" })
map("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Test summary" })

map("n", "<leader>rcu", function()
    require('crates').upgrade_all_crates()
end, { desc = "Upgrage crates" })

map("n", "<leader>nu", function()
    require("package-info").update()
end, { desc = "Update dependency" })

map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })