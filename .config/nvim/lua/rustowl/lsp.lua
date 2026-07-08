-- Override rustowl's LSP helper to use client:notify on Neovim 0.12+.
-- Upstream checks debug.getinfo().nparams and falls back to deprecated client.notify.

local M = {}

---@param filter? vim.lsp.get_clients.Filter
---@return vim.lsp.Client[]
M.get_rustowl_clients = function(filter)
  filter = vim.tbl_deep_extend("force", filter or {}, {
    name = "rustowl",
  })
  ---@diagnostic disable-next-line: deprecated
  return type(vim.lsp.get_clients) == "function" and vim.lsp.get_clients(filter) or vim.lsp.get_active_clients(filter)
end

---@param client vim.lsp.Client
---@param root_dir string
---@return boolean
local function is_in_workspace(client, root_dir)
  if not client.workspace_folders then
    return false
  end
  for _, dir in ipairs(client.workspace_folders) do
    if (root_dir .. "/"):sub(1, #dir.name + 1) == dir.name .. "/" then
      return true
    end
  end
  return false
end

---@param client vim.lsp.Client
---@param method string
---@param params table?
---@return boolean
local function client_notify(client, method, params)
  return client:notify(method, params)
end

---@param client vim.lsp.Client
---@param root_dir string
local function notify_workspace_folder(client, root_dir)
  if is_in_workspace(client, root_dir) then
    return
  end
  local workspace_folder = { uri = vim.uri_from_fname(root_dir), name = root_dir }
  local params = {
    event = {
      added = { workspace_folder },
      removed = {},
    },
  }
  client_notify(client, "workspace/didChangeWorkspaceFolders", params)
  if not client.workspace_folders then
    client.workspace_folders = {}
  end
  table.insert(client.workspace_folders, workspace_folder)
end

---@return integer|nil
M.start = function()
  local config = require("rustowl.config")
  local root_dir = config.client.root_dir()
  if not root_dir then
    vim.schedule(function()
      vim.notify("rustowl: Failed to detect root_dir.", vim.log.levels.ERROR)
    end)
    return
  end

  for _, client in ipairs(M.get_rustowl_clients()) do
    if not is_in_workspace(client, root_dir) then
      notify_workspace_folder(client, root_dir)
      vim.lsp.buf_attach_client(0, client.id)
      return
    end
  end

  local notify_workspace_folder_hook = function(client)
    notify_workspace_folder(client, root_dir)
  end
  local on_init = type(config.client.on_init) == "function"
      and function(...)
        notify_workspace_folder_hook(...)
        config.client.on_init(...)
      end
    or notify_workspace_folder_hook
  local client_config = vim.tbl_deep_extend("force", config.client, { root_dir = root_dir, on_init = on_init })
  return vim.lsp.start(client_config)
end

---@param client vim.lsp.Client
---@return boolean
local function client_is_stopped(client)
  return client:is_stopped()
end

M.stop = function()
  local clients = M.get_rustowl_clients()
  vim.lsp.stop_client(clients)
  local t, err, _ = vim.uv.new_timer()
  local timer = assert(t, err)
  local max_attempts = 50
  local attempts_to_live = max_attempts
  local stopped_client_count = 0
  timer:start(200, 100, function()
    for _, client in ipairs(clients) do
      if client_is_stopped(client) then
        stopped_client_count = stopped_client_count + 1
      end
    end
    if stopped_client_count >= #clients then
      timer:stop()
      attempts_to_live = 0
    elseif attempts_to_live <= 0 then
      vim.schedule(function()
        vim.notify(
          ("rustowl: Could not stop all LSP clients after %d attempts."):format(max_attempts),
          vim.log.levels.ERROR
        )
      end)
      timer:stop()
      attempts_to_live = 0
    end
    attempts_to_live = attempts_to_live - 1
  end)
end

M.restart = function()
  M.stop()
  M.start()
end

return M
