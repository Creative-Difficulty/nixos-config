-- render-markdown shows wrapped table rows raw under the cursor because the cursor can't sit on
-- their virtual lines; keep them rendered and mark the row with CursorLine instead of the cursor
local updater = require('render-markdown.core.ui').updater
local replacements = require('render-markdown.lib.replacements')

local guicursor = vim.o.guicursor
local cursor_row = nil
local wrapped_row = nil
local wrapped_win = nil

-- Neovim places the cursor on the line above the hidden rows, so hide it and keep its scrolloff
-- from pulling the view there; scroll_to applies scrolloff to the highlighted row instead
local function set_wrapped_win(win)
  -- Neovim drops a blend-only highlight, so the cursor would stay visible without nocombine
  vim.api.nvim_set_hl(0, 'MarkdownHiddenCursor', { blend = 100, nocombine = true })
  local value = win and guicursor .. ',n:MarkdownHiddenCursor' or guicursor
  if vim.o.guicursor ~= value then
    vim.o.guicursor = value
  end
  if wrapped_win and wrapped_win ~= win and vim.api.nvim_win_is_valid(wrapped_win) then
    vim.wo[wrapped_win].scrolloff = -1
  end
  if win then
    vim.wo[win].scrolloff = 0
  end
  wrapped_win = win
end

local function scroll_to(win, row)
  local function height(from, to)
    if to < from then
      return 0
    end
    return vim.api.nvim_win_text_height(win, { start_row = from, end_row = to }).all
  end
  local function screen_row(top)
    return height(top, row.anchor - 1) + row.offset
  end
  local cursor = vim.api.nvim_win_get_cursor(win)[1] - 1
  local win_height = vim.api.nvim_win_get_height(win)
  local scrolloff = math.max(math.min(vim.go.scrolloff, math.floor((win_height - row.height) / 2)), 0)
  local topline = vim.fn.line('w0', win) - 1
  local top = topline
  while top < cursor and screen_row(top) + row.height + scrolloff > win_height do
    top = top + 1
  end
  while top > 0 and screen_row(top) < scrolloff do
    top = top - 1
  end
  if top ~= topline then
    vim.fn.winrestview { topline = top + 1 }
  end
end

local updater_hide = updater.hide
function updater:hide(extmark, range)
  local mark = extmark:get()
  local replace = mark.replace
  mark.replace = nil
  local hidden = updater_hide(self, extmark, range)
  mark.replace = replace
  return hidden
end

local updater_display = updater.display
function updater:display()
  if self.win ~= vim.api.nvim_get_current_win() then
    return updater_display(self)
  end
  cursor_row = vim.api.nvim_win_get_cursor(self.win)[1] - 1
  wrapped_row = nil
  updater_display(self)
  cursor_row = nil
  set_wrapped_win(wrapped_row and self.win)
  if wrapped_row then
    scroll_to(self.win, wrapped_row)
  end
end

local updater_clear = updater.clear
function updater:clear()
  updater_clear(self)
  if self.win == vim.api.nvim_get_current_win() then
    set_wrapped_win(nil)
  end
end

local resolve = replacements.resolve
function replacements.resolve(visible, line_count)
  local highlighted = nil
  visible = vim.tbl_map(function(mark)
    if not mark.replace or mark.start_row ~= cursor_row then
      return mark
    end
    highlighted = vim.tbl_map(function(line)
      return vim.tbl_map(function(chunk)
        local groups = type(chunk[2]) == 'table' and vim.list_slice(chunk[2]) or { chunk[2] }
        groups[#groups + 1] = 'CursorLine'
        return { chunk[1], groups }
      end, line)
    end, mark.replace)
    return vim.tbl_extend('force', mark, { replace = highlighted })
  end, visible)
  local generated = resolve(visible, line_count)
  for _, group in ipairs(highlighted and generated or {}) do
    for i, line in ipairs(group.opts.virt_lines) do
      if line == highlighted[1] then
        wrapped_row = { anchor = group.start_row, offset = i - 1, height = #highlighted }
      end
    end
  end
  return generated
end

vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
  callback = function()
    set_wrapped_win(nil)
  end,
})
