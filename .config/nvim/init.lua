vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

require "configs.neovim_compat"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- recompile base46 cache when chadrc.lua changed (e.g. after git pull)
local chadrc = vim.fn.stdpath "config" .. "/lua/chadrc.lua"
local stamp = vim.g.base46_cache .. "chadrc.sha256"
local hash = vim.fn.sha256(table.concat(vim.fn.readfile(chadrc), "\n"))
if vim.fn.filereadable(stamp) == 0 or vim.fn.readfile(stamp)[1] ~= hash then
  require("base46").load_all_highlights()
  vim.fn.writefile({ hash }, stamp)
end

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
