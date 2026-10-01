local dap = require("dap")

local function zig_program()
  local root = vim.fn.getcwd()
  local default = root .. "/zig-out/bin/" .. vim.fs.basename(root)
  if vim.fn.filereadable(default) == 1 then
    return default
  end
  return vim.fn.input("Path to executable: ", default, "file")
end

local function native_program()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local attach_codelldb = {
  name = "Attach to process",
  type = "codelldb",
  request = "attach",
  processId = require("dap.utils").pick_process,
  cwd = "${workspaceFolder}",
}

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.exepath("codelldb"),
    args = { "--port", "${port}" },
  },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = {
    command = "js-debug-adapter",
  },
}

dap.configurations.zig = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Launch (pick binary)",
    type = "codelldb",
    request = "launch",
    program = zig_program,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Launch (args)",
    type = "codelldb",
    request = "launch",
    program = zig_program,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      return vim.split(vim.fn.input("Args: "), "%s+", { trimempty = true })
    end,
  },
  attach_codelldb,
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = native_program,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Launch (args)",
    type = "codelldb",
    request = "launch",
    program = native_program,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      return vim.split(vim.fn.input("Args: "), "%s+", { trimempty = true })
    end,
  },
  attach_codelldb,
}
dap.configurations.cpp = dap.configurations.c

for _, language in ipairs { "typescript", "javascript" } do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
    },
  }
end
