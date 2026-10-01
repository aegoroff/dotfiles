local prettier = { "prettier" }
local shfmt = { "shfmt" }
local clang_format = { "clang-format" }

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofumpt" },
    rust = { "rustfmt" },
    zig = { "zigfmt" },
    sh = shfmt,
    bash = shfmt,
    c = clang_format,
    cpp = clang_format,
    cuda = clang_format,
    proto = clang_format,
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    vue = prettier,
    css = prettier,
    scss = prettier,
    less = prettier,
    html = prettier,
    json = prettier,
    jsonc = prettier,
    yaml = prettier,
    markdown = prettier,
    graphql = prettier,
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

return options
