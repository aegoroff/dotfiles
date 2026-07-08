-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "vue_ls", "angularls", "zls", "bashls", "ts_ls", "vtsls", "clangd" }

local function vue_language_server_path()
  return vim.fs.joinpath(
    vim.fn.stdpath "data",
    "mason",
    "packages",
    "vue-language-server",
    "node_modules",
    "@vue",
    "language-server"
  )
end

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path(),
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("clangd", {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
  end,
  init_options = {
    clangdFileStatus = true,
  },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=1",
  },
})

vim.lsp.config("bashls", {
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
      return on_dir(vim.uv.cwd())
    end
    on_dir(vim.fs.root(path, { ".git" }) or vim.fs.dirname(path))
  end,
})

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end
