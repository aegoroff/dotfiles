-- Shims for plugins that still use APIs deprecated in Neovim 0.12+.
-- Remove this file once upstream plugins ship fixes.

local validate = vim.validate

---@diagnostic disable-next-line: duplicate-set-field
function vim.validate(arg1, ...)
  if type(arg1) == "table" then
    for name, spec in pairs(arg1) do
      validate(name, spec[1], spec[2], spec[3])
    end
    return true
  end
  return validate(arg1, ...)
end

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

local str_utfindex = vim.str_utfindex

---@diagnostic disable-next-line: duplicate-set-field
function vim.str_utfindex(s, encoding, index, strict_indexing)
  if encoding == nil then
    return str_utfindex(s, "utf-8")
  end
  if type(encoding) == "number" then
    return str_utfindex(s, "utf-8", encoding, index)
  end
  return str_utfindex(s, encoding, index, strict_indexing)
end
