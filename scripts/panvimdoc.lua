-- This is a vimdoc custom writer for pandoc.
-- It produces output that can be used as vimdoc documentation
--
-- Invoke with: pandoc -t panvimdoc.lua README.md
local pipe = pandoc.pipe
local stringify = (require("pandoc.utils")).stringify
-- local inspect = require 'inspect'

function dump(s)
  print(require("scripts.inspect").inspect(s))
end

-- The global variable PANDOC_DOCUMENT contains the full AST of
-- the document which is going to be written. It can be used to
-- configure the writer.
local meta = PANDOC_DOCUMENT.meta

-- Choose the image format based on the value of the
-- `image_format` meta value.
local image_format = meta.image_format and stringify(meta.image_format) or "png"
local image_mime_type = ({
  jpeg = "image/jpeg",
  jpg = "image/jpeg",
  gif = "image/gif",
  png = "image/png",
  svg = "image/svg+xml",
})[image_format] or error("unsupported image format `" .. image_format .. "`")

-- Character escaping
local function escape(s, in_attribute)
  return s
end

-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
local function attributes(attr)
  local attr_table = {}
  for x, y in pairs(attr) do
    if y and y ~= "" then
      table.insert(attr_table, " " .. x .. '="' .. escape(y, true) .. '"')
    end
  end
  return table.concat(attr_table)
end

-- Table to store footnotes, so they can be included at the end.
local notes = {}
local toc = {}
local links = {}
local header_count = 1

-- Blocksep is used to separate block elements.
function Blocksep()
  return "\n\n"
end

local function osExecute(cmd)
  local fileHandle = assert(io.popen(cmd, "r"))
  local commandOutput = assert(fileHandle:read("*a"))
  local returnTable = { fileHandle:close() }
  return commandOutput, returnTable[3] -- rc[3] contains returnCode
end

local function mod(a, b)
  a = a - 1
  b = b
  return (a - (math.floor(a / b) * b)) + 1
end

local function renderToc(project)
  local t = {}
  local function add(s)
    table.insert(t, s)
  end
  add(string.rep("=", 78))
  local l = "Table of Contents"
  local tag = "*" .. stringify(meta.project) .. "-" .. string.gsub(string.lower(l), "%s", "-") .. "*"
  add(l .. string.rep(" ", 78 - #l - #tag) .. tag)
  add("")
  for i, elem in pairs(toc) do
    local level, item, link = elem[1], elem[2], elem[3]
    if level == 1 then
      local padding = string.rep(" ", 78 - #item - #link)
      add(item .. padding .. link)
    elseif level == 2 then
      local padding = string.rep(" ", 74 - #item - #link)
      add("  - " .. item .. padding .. link)
    end
  end
  add("")
  return table.concat(t, "\n")
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
  local vim_version = metadata.vimversion
  if vim_version == nil then
    vim_version = osExecute("nvim --version"):gmatch("([^\n]*)\n?")()
    if string.find(vim_version, "-dev") then
      vim_version = string.gsub(vim_version, "(.*)-dev.*", "%1")
    end
    if vim_version == "" then
      vim_version = osExecute("vim --version"):gmatch("([^\n]*)\n?")()
      vim_version = string.gsub(vim_version, "(.*) %(.*%)", "%1")
    end
    if vim_version == "" then
      vim_version = "vim"
    end
  elseif vim_version == "vim" then
    vim_version = osExecute("vim --version"):gmatch("([^\n]*)\n?")()
  end

  local vim_doc_title = metadata.vimdoctitle
  if vim_doc_title == nil then
    vim_doc_title = metadata.project .. ".txt"
  end
  local date = metadata.date
  if date == nil then
    date = os.date("%Y %B %d")
  end
  local l = vim_doc_title
  local m = "For " .. vim_version
  local r = "Last change: " .. date
  local n = math.max(0, 78 - #l - #m - #r)
  local s = string.rep(" ", math.floor(n / 2))
  if mod(n, 2) == 1 then
    add(l .. s .. m .. s .. " " .. r)
  else
    add(l .. s .. m .. s .. r)
  end
  add("")
  if metadata.toc == nil or metadata.toc then
    add(renderToc(vim_doc_title))
  end
  add(body)
  local left = header_count .. ". Links"
  local right = "links"
  local right_link = string.format("|%s-%s|", stringify(meta.project), right)
  right = string.format("*%s-%s*", stringify(meta.project), right)
  local padding = string.rep(" ", 78 - #left - #right)
  table.insert(toc, { 1, left, right_link })
  add(string.rep("=", 78) .. "\n" .. string.format("%s%s%s", left, padding, right))
  add("")
  for i, v in ipairs(links) do
    add(i .. ". *" .. v[1] .. "*" .. ": " .. v[2])
  end
  add("")
  add("vim:tw=78:ts=8:noet:ft=help:norl:")
  return table.concat(buffer, "\n") .. "\n"
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return escape(s)
end

function Space()
  return " "
end

function SoftBreak()
  return "\n"
end

function LineBreak()
  return "<br/>"
end

function Emph(s)
  return "_" .. s .. "_"
end

function Strong(s)
  return "**" .. s .. "**"
end

function Subscript(s)
  return "_" .. s
end

function Superscript(s)
  return "^" .. s
end

function SmallCaps(s)
  return s
end

function Strikeout(s)
  return "~" .. s .. "~"
end

function Link(s, tgt, tit, attr)
  if not string.starts(tgt, "#") and not string.starts(s, "http") then
    links[#links + 1] = { stringify(meta.project) .. "-" .. s:gsub("%s", "-"), tgt }
  end
  return "|" .. stringify(meta.project) .. "-" .. s:gsub("%s", "-") .. "|"
end

function Image(s, src, tit, attr)
  return "<img src='" .. escape(src, true) .. "' title='" .. escape(tit, true) .. "'/>"
end

function Code(s, attr)
  return ">" .. escape(s) .. "<"
end

function InlineMath(s)
  return "`" .. escape(s) .. "`"
end

function DisplayMath(s)
  return "`" .. escape(s) .. "`"
end

function SingleQuoted(s)
  return "'" .. s .. "'"
end

function DoubleQuoted(s)
  return '"' .. s .. '"'
end

function Note(s)
  return s
end

function Null(s)
  return ""
end

function Span(s, attr)
  return s
end

function RawInline(format, str)
  if format == "html" then
    return str
  else
    return ""
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
    local current_line = current_element .. string.rep(" ", 78 - 40 - #current_element)
    for word in string.gmatch(s, "([^%s]+)") do
      if string.match(word, "[.]") and #word == 1 then
        current_line = current_line .. word
      elseif (#current_line + #word) > 78 then
        table.insert(t, current_line)
        current_line = string.rep(" ", 40 - 1) .. word
      elseif #current_line == 0 then
        current_line = string.rep(" ", 40 - 1) .. word
      else
        current_line = current_line .. " " .. word
      end
    end
    table.insert(t, current_line)
    current_element = nil
    return table.concat(t, "\n") .. "\n"
  else
    local t = {}
    local current_line = ""
    for word in string.gmatch(s, "([^%s]+)") do
      if string.match(word, "[.]") and #word == 1 then
        current_line = current_line .. word
      elseif (#current_line + #word) > 78 then
        table.insert(t, current_line)
        current_line = word
      elseif #current_line == 0 then
        current_line = word
      else
        current_line = current_line .. " " .. word
      end
    end
    table.insert(t, current_line)
    return table.concat(t, "\n")
  end
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  local left, right, right_link, padding
  if lev == 1 then
    left = string.format("%d. %s", header_count, s)
    right = string.lower(string.gsub(s, "%s", "-"))
    right_link = string.format("|%s-%s|", stringify(meta.project), right)
    right = string.format("*%s-%s*", stringify(meta.project), right)
    padding = string.rep(" ", 78 - #left - #right)
    table.insert(toc, { 1, left, right_link })
    s = string.format("%s%s%s", left, padding, right)
    header_count = header_count + 1
    current_element = nil
    s = string.rep("=", 78) .. "\n" .. s
    return s
  end
  if lev == 2 then
    left = string.upper(s)
    right = string.lower(string.gsub(s, "%s", "-"))
    right_link = string.format("|%s-%s|", stringify(meta.project), right)
    right = string.format("*%s-%s*", stringify(meta.project), right)
    padding = string.rep(" ", 74 - #left - #right)
    table.insert(toc, { 2, s, right_link })
    s = string.format("%s%s%s", left, padding, right)
    current_element = nil
    return s
  end
  if lev == 3 then
    left = ""
    current_element = s
    right = string.gsub(s, "{.+}", "")
    right = string.gsub(right, "%[.+%]", "")
    right = string.gsub(right, "^%s*(.-)%s*$", "%1")
    right = string.format("*%s-%s*", stringify(meta.project), right)
    if attr.doc then
      right = right .. " *" .. attr.doc .. "*"
    end
    padding = string.rep(" ", 78 - #left - #right)
    local r = string.format("%s%s%s", left, padding, right)
    return r
  end
end

function BlockQuote(s)
  return ">\n" .. s .. "\n<\n"
end

function HorizontalRule()
  return string.rep("-", 78)
end

function LineBlock(ls)
  return table.concat(ls, "\n")
end

local List = require("pandoc.List")

function CodeBlock(s, attr)
  if attr.class == "vimdoc" then
    return s
  else
    local t = {}
    for line in s:gmatch("([^\n]*)\n?") do
      table.insert(t, "    " .. escape(line))
    end
    return ">\n" .. table.concat(t, "\n") .. "\n<\n"
  end
end

function indent(s, fl, ol)
  local ret = {}
  local i = 1

  for l in s:gmatch("[^\r\n]+") do
    if i == 1 then
      ret[i] = fl .. l
    else
      ret[i] = ol .. l
    end
    i = i + 1
  end
  return table.concat(ret, "\n")
end

function BulletList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, indent(item, "- ", "    "))
  end
  return "\n" .. table.concat(buffer, "\n") .. "\n"
end

function OrderedList(items)
  local buffer = {}
  for i, item in pairs(items) do
    table.insert(buffer, "1. " .. item)
  end
  return "\n" .. table.concat(buffer, "\n") .. "\n"
end

function DefinitionList(items)
  local buffer = {}
  for _, item in pairs(items) do
    local k, v = next(item)
    table.insert(buffer, k .. string.rep(" ", 78 - 40 + 1 - #k) .. table.concat(v, "\n"))
  end
  return "\n" .. table.concat(buffer, "\n") .. "\n"
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
local function html_align(align)
  if align == "AlignLeft" then
    return "left"
  elseif align == "AlignRight" then
    return "right"
  elseif align == "AlignCenter" then
    return "center"
  else
    return "left"
  end
end

function CaptionedImage(src, tit, caption, attr)
  return '<div class="figure">\n<img src="'
    .. escape(src, true)
    .. '" title="'
    .. escape(tit, true)
    .. '"/>\n'
    .. '<p class="caption">'
    .. escape(caption)
    .. "</p>\n</div>"
end

-- Position some text within a wider string (stuffed with blanks)
-- 'way' is '0' to left justify, '1' for right and '2' for center
function _position(txt, width, way)
  if way < 0 or way > 2 then
    return txt
  end
  local l = #txt
  if width > l then
    local b = (way == 0 and 0) or math.floor((width - l) / way)
    local a = width - l - b
    return string.rep(" ", b) .. txt .. string.rep(" ", a)
  else
    return txt
  end
end

function _getNthRowLine(txt, nth, height, width)
  local s = ""
  if nth == height then
    s = subString(txt, (nth - 1) * width, width + 1) -- Avoid cutting last UTF8 sequence
  else
    s = subString(txt, (nth - 1) * width, width)
  end
  return s
end

function get_1st_letter(s)
  local function get_1st_letter_rec(s, acc)
    if #s == 0 then
      return "", ""
    elseif #s == 1 then
      return s, ""
    else
      local m = s:match("^\27%[[0-9;]+m")

      if m == nil then
        local m = s:match("^[^\27]\27%[[0-9;]+m")
        if m == nil then
          return acc .. s:sub(1, 1), s:sub(2)
        else
          return acc .. m, s:sub(#m + 1)
        end
      else
        return get_1st_letter_rec(s:sub(#m + 1), acc .. m)
      end
    end
  end
  return get_1st_letter_rec(s, "")
end
--
-- Returns a substring of 's', starting after 'orig' and of length 'nb'
-- Escape sequences are NOT counted as characters and thus are not cut.
function subString(s, orig, nb)
  local col = 0
  local buf = ""
  local h

  while #s > 0 and col < orig do
    h, s = get_1st_letter(s)
    col = col + 1
  end

  col = 0
  while #s > 0 and col < nb do
    h, s = get_1st_letter(s)
    buf = buf .. h
    col = col + 1
  end
  return buf
end

MAX_COL_WIDTH = 42
MIN_COL_WIDTH = 5

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  local buffer = {}
  local table_width_for_adjust = 0
  local max_table_width_for_adjust = 78
  local align = { ["AlignDefault"] = 0, ["AlignLeft"] = 0, ["AlignRight"] = 1, ["AlignCenter"] = 2 }
  local function add_row(s)
    table.insert(buffer, s)
  end
  -- Find maximum width for each column:
  local col_width = {}
  local row_height = {}
  for j, row in pairs(rows) do
    row_height[j] = 1
  end
  local header_height = 1
  local cell_width = 0
  local cell_height = 0
  table_width_for_adjust = #headers + 3 -- # of columns + 2 for borders + 1 for margin
  for i, header in pairs(headers) do
    table.insert(col_width, i, #header)
    for j, row in pairs(rows) do
      cell_width = #row[i]
      if cell_width > col_width[i] then
        col_width[i] = cell_width
      end
    end
    if col_width[i] > MIN_COL_WIDTH then
      -- Sum of all widths for columns that could be reduced
      table_width_for_adjust = table_width_for_adjust + col_width[i]
    else
      max_table_width_for_adjust = max_table_width_for_adjust - col_width[i]
    end
  end
  -- Reduce large cells if needed:
  local xs = table_width_for_adjust - max_table_width_for_adjust
  if xs > 0 then
    for i, w in pairs(col_width) do
      if w > MIN_COL_WIDTH then
        col_width[i] = w - math.floor(w * xs / table_width_for_adjust + 1)
      end
      cell_height = math.floor(#headers[i] / col_width[i]) + 1
      if cell_height > header_height then
        header_height = cell_height
      end
      for j, row in pairs(rows) do
        text_width = #row[i]
        cell_height = math.floor(text_width / col_width[i]) + 1
        if cell_height > row_height[j] then
          row_height[j] = cell_height
        end
      end
    end
  end

  local last = #col_width
  local tmpl = ""
  for i, w in pairs(col_width) do
    -- Here, 'c' stands for "crossing char" and will be replaced
    tmpl = tmpl .. string.rep("─", w) .. (i < last and "c" or "")
  end
  local CELL_SEP = "│"

  if caption ~= "" then
    add_row(Strong(caption))
    add_row("")
  end
  local header_row = {}
  local empty_header = true
  for i, h in pairs(headers) do
    -- Table headers have same color as document headers
    empty_header = empty_header and h == ""
  end
  local content = ""
  local s = ""
  if not empty_header then
    for k = 1, header_height do -- Break long lines
      content = ""
      s = ""
      for i, h in pairs(headers) do
        s = _getNthRowLine(h, k, header_height, col_width[i])
        s = _position(s, col_width[i], 2)
        content = content .. CELL_SEP .. s
      end
      add_row(content .. CELL_SEP)
    end
  end
  for i, row in pairs(rows) do
    content = ""
    for k = 1, row_height[i] do -- Break long lines
      content = ""
      s = ""
      for j, c in pairs(row) do
        if col_width[j] then
          s = _getNthRowLine(c, k, row_height[i], col_width[j])
          content = content .. CELL_SEP .. _position(s, col_width[j], align[aligns[j]])
        end
      end
      add_row(content .. CELL_SEP)
    end
    if i < #rows then
    end
  end
  add_row("")
  return table.concat(buffer, "\n")
end

function string.starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

function RawBlock(format, str)
  if format == "html" then
    if string.starts(str, "<!--") then
      return ""
    else
      return str
    end
  else
    return ""
  end
end

function Div(s, attr)
  return "<div" .. attributes(attr) .. ">\n" .. s .. "</div>"
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index = function(_, key)
  io.stderr:write(string.format("WARNING: Undefined function '%s'\n", key))
  return function()
    return ""
  end
end
setmetatable(_G, meta)
