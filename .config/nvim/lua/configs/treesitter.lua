pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

return {
  ensure_installed = {
    "vim",
    "lua",
    "luadoc",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "vue",
    "c",
    "markdown",
    "markdown_inline",
    "prisma",
    "rust",
    "go",
    "zig",
    "bash",
  },
}
