-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- line numbers are off by default
opt.number = false
opt.relativenumber = false
-- window title for each split
opt.winbar = "%=%m %f"

function StripTrailingWhitespace()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufcontent = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local newbufcontent = bufcontent
  local changed = 0
  for row, line in pairs(bufcontent)
  do
    local newline = string.gsub(line, ' +$', '')
    if newline ~= line
    then
      newbufcontent[row] = newline
      changed = changed + 1
    end
  end
  if changed > 0
  then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, newbufcontent)
    print("Removed trailing spaces for ",changed," lines")
  end
end
