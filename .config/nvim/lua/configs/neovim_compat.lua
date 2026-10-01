-- Shims for plugins that still use APIs deprecated in Neovim 0.12+.
-- Remove this file once upstream plugins ship fixes.

if vim.lsp.get_buffers_by_client_id then
  local get_buffers_by_client_id = vim.lsp.get_buffers_by_client_id

  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.get_buffers_by_client_id(client_id)
    local client = vim.lsp.get_client_by_id(client_id)
    if client and client.attached_buffers then
      return vim.tbl_keys(client.attached_buffers)
    end
    return get_buffers_by_client_id(client_id)
  end
end
