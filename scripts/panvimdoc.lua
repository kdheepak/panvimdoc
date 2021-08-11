-- This is a vimdoc custom writer for pandoc.
-- It produces output that can be used as vimdoc documentation
--
-- Invoke with: pandoc -t vimdoc.lua README.md
local pipe = pandoc.pipe
local stringify = (require 'pandoc.utils').stringify
-- local inspect = require 'inspect'

-- The global variable PANDOC_DOCUMENT contains the full AST of
-- the document which is going to be written. It can be used to
-- configure the writer.
local meta = PANDOC_DOCUMENT.meta

-- Choose the image format based on the value of the
-- `image_format` meta value.
local image_format = meta.image_format and stringify(meta.image_format) or 'png'
local image_mime_type = ({
  jpeg = 'image/jpeg',
  jpg = 'image/jpeg',
  gif = 'image/gif',
  png = 'image/png',
  svg = 'image/svg+xml',
})[image_format] or error('unsupported image format `' .. image_format .. '`')

-- Character escaping
local function escape(s, in_attribute)
  return s
end

-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
local function attributes(attr)
  local attr_table = {}
  for x, y in pairs(attr) do
    if y and y ~= '' then
      table.insert(attr_table, ' ' .. x .. '="' .. escape(y, true) .. '"')
    end
  end
  return table.concat(attr_table)
end

-- Table to store footnotes, so they can be included at the end.
local notes = {}

-- Blocksep is used to separate block elements.
function Blocksep()
  return '\n\n'
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will do the template processing as usual.
function Doc(body, metadata, variables)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  local neovim_version = metadata.neovimversion
  if neovim_version == nil then
    neovim_version = 'v0.5.0' -- TODO get version from external process
  end
  local vimdoctitle = metadata.vimdoctitle
  if vimdoctitle == nil then
    error('vimdoctitle metadata not found')
  end
  local date = metadata.date
  if date == nil then
    date = os.date('%Y %B %d')
  end
  add(vimdoctitle .. '    For Neovim ' .. neovim_version .. '    ' .. 'Last change: ' .. date)
  add('')
  add(body)
  add('vim:tw=78:ts=8:noet:ft=help:norl:')
  return table.concat(buffer, '\n') .. '\n'
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return escape(s)
end

function Space()
  return ' '
end

function SoftBreak()
  return '\n'
end

function LineBreak()
  return '<br/>'
end

function Emph(s)
  return '_' .. s .. '_'
end

function Strong(s)
  return '**' .. s .. '**'
end

function Subscript(s)
  return '_' .. s
end

function Superscript(s)
  return '^' .. s
end

function SmallCaps(s)
  return s
end

function Strikeout(s)
  return '~' .. s .. '~'
end

function Link(s, tgt, tit, attr)
  return '|' .. s .. '| ' .. '<' .. escape(tgt, true) .. '>'
end

function Image(s, src, tit, attr)
  return '<img src=\'' .. escape(src, true) .. '\' title=\'' .. escape(tit, true) .. '\'/>'
end

function Code(s, attr)
  return '>\n' .. escape(s) .. '\n<'
end

function InlineMath(s)
  return '`' .. escape(s) .. '`'
end

function DisplayMath(s)
  return '`' .. escape(s) .. '`'
end

function SingleQuoted(s)
  return '\'' .. s .. '\''
end

function DoubleQuoted(s)
  return '"' .. s .. '"'
end

function Note(s)
  return s
end

function Span(s, attr)
  return s
end

function RawInline(format, str)
  if format == 'html' then
    return str
  else
    return ''
  end
end

function Cite(s, cs)
  return s
end

function Plain(s)
  return s
end

local current_element = nil

function Para(s)
  if current_element then
    local t = {}
    local current_line = current_element .. string.rep(' ', 78 - 40 - #current_element)
    for word in string.gmatch(s, '([^%s]+)') do
      if string.match(word, '[.]') and #word == 1 then
        current_line = current_line .. word
      elseif (#current_line + #word) > 78 then
        table.insert(t, current_line)
        current_line = string.rep(' ', 40 - 1) .. word
      elseif #current_line == 0 then
        current_line = string.rep(' ', 40 - 1) .. word
      else
        current_line = current_line .. ' ' .. word
      end
    end
    table.insert(t, current_line)
    current_element = nil
    return table.concat(t, '\n') .. '\n'
  else
    local t = {}
    local current_line = ''
    for word in string.gmatch(s, '([^%s]+)') do
      if string.match(word, '[.]') and #word == 1 then
        current_line = current_line .. word
      elseif (#current_line + #word) > 78 then
        table.insert(t, current_line)
        current_line = word
      elseif #current_line == 0 then
        current_line = word
      else
        current_line = current_line .. ' ' .. word
      end
    end
    table.insert(t, current_line)
    return table.concat(t, '\n')
  end
end

local header_count = 1

-- lev is an integer, the header level.
function Header(lev, s, attr)
  local left, right, padding
  if lev == 1 then
    left = string.format('%d. %s', header_count, s)
    right = string.lower(string.gsub(s, '%s', '-'))
    right = string.format('*%s-%s*', meta.project[1].c, right)
    padding = string.rep(' ', 78 - #left - #right)
    s = string.format('%s%s%s', left, padding, right)
    header_count = header_count + 1
    current_element = nil
    s = string.rep('=', 78) .. '\n' .. s
    return s
  end
  if lev == 2 then
    left = string.upper(s)
    right = string.lower(string.gsub(s, '%s', '-'))
    right = string.format('*%s-%s*', meta.project[1].c, right)
    padding = string.rep(' ', 78 - #left - #right)
    s = string.format('%s%s%s', left, padding, right)
    current_element = nil
    return s
  end
  if lev == 3 then
    left = ''
    current_element = s
    right = string.gsub(s, '{.+}', '')
    right = string.gsub(right, '%[.+%]', '')
    right = string.gsub(right, '^%s*(.-)%s*$', '%1')
    right = string.format('*%s-%s*', meta.project[1].c, right)
    if attr.doc then
      right = right .. ' *' .. attr.doc .. '*'
    end
    padding = string.rep(' ', 78 - #left - #right)
    local r = string.format('%s%s%s', left, padding, right)
    return r
  end
end

function BlockQuote(s)
  return '>\n' .. s .. '\n<\n'
end

function HorizontalRule()
  return string.rep('-', 78)
end

function LineBlock(ls)
  return table.concat(ls, '\n')
end

function CodeBlock(s, attr)
  local t = {}
  for line in s:gmatch('([^\n]*)\n?') do
    table.insert(t, '    ' .. escape(line))

  end
  return '>\n' .. table.concat(t, '\n') .. '\n<\n'
end

function BulletList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, '-' .. item)
  end
  return '\n' .. table.concat(buffer, '\n') .. '\n'
end

function OrderedList(items)
  local buffer = {}
  for i, item in pairs(items) do
    table.insert(buffer, '1. ' .. item)
  end
  return '\n' .. table.concat(buffer, '\n') .. '\n'
end

function DefinitionList(items)
  local buffer = {}
  for _, item in pairs(items) do
    local k, v = next(item)
    table.insert(buffer, k .. string.rep(' ', 78 - 40 + 1 - #k) .. table.concat(v, '\n'))
  end
  return '\n' .. table.concat(buffer, '\n') .. '\n'
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
local function html_align(align)
  if align == 'AlignLeft' then
    return 'left'
  elseif align == 'AlignRight' then
    return 'right'
  elseif align == 'AlignCenter' then
    return 'center'
  else
    return 'left'
  end
end

function CaptionedImage(src, tit, caption, attr)
  return '<div class="figure">\n<img src="' .. escape(src, true) .. '" title="' .. escape(tit, true) .. '"/>\n'
             .. '<p class="caption">' .. escape(caption) .. '</p>\n</div>'
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  if caption ~= '' then
    add('Caption: ' .. caption)
  end
  local header_row = {}
  local head
  local empty_header = true
  for i, h in pairs(headers) do
    table.insert(header_row, h)
    empty_header = empty_header and h == ''
  end
  if empty_header then
    head = ''
  else
    local header_line = ''
    for _, h in pairs(header_row) do
      header_line = header_line .. h .. ' '
    end
    add(header_line)
  end
  for _, row in pairs(rows) do
    local row_line = ''
    for i, c in pairs(row) do
      row_line = row_line .. c .. ' '
    end
    add(row_line)
  end
  return table.concat(buffer, '\n')
end

function RawBlock(format, str)
  if format == 'html' then
    return str
  else
    return ''
  end
end

function Div(s, attr)
  return '<div' .. attributes(attr) .. '>\n' .. s .. '</div>'
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index = function(_, key)
  io.stderr:write(string.format('WARNING: Undefined function \'%s\'\n', key))
  return function()
    return ''
  end
end
setmetatable(_G, meta)
