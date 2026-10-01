-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "vue_ls", "angularls", "zls", "bashls", "vtsls", "clangd" }

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

local ts_inlay_hints = {
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

vim.lsp.config("vtsls", {
  settings = {
    typescript = { inlayHints = ts_inlay_hints },
    javascript = { inlayHints = ts_inlay_hints },
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

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config("zls", {
  settings = {
    zls = {
      enable_build_on_save = true,
    },
  },
})

vim.lsp.config("clangd", {
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

---@param client vim.lsp.Client
---@param bufnr integer
local function vtsls_source_definition(client, bufnr)
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  client:exec_cmd({
    title = "Go to source definition",
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  }, { bufnr = bufnr }, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("vtsls: no source definition found", vim.log.levels.WARN)
      return
    end
    vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
  end)
end

-- client-side no-op in VS Code; vtsls sends it after "Organize Imports"
vim.lsp.commands["_typescript.didOrganizeImports"] = function() end

---@param kind string
local function apply_source_action(kind)
  vim.lsp.buf.code_action { context = { only = { kind }, diagnostics = {} }, apply = true }
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
    end

    if client.name == "clangd" then
      map("<leader>cs", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch source/header")
    elseif client.name == "vtsls" then
      map("<leader>co", function()
        apply_source_action "source.organizeImports"
      end, "Organize imports")
      map("<leader>cu", function()
        apply_source_action "source.removeUnusedImports"
      end, "Remove unused imports")
      map("gS", function()
        vtsls_source_definition(client, args.buf)
      end, "Go to source definition")
    end
  end,
})
