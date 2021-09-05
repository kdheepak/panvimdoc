function dump(s)
  io.stderr:write(require("scripts.inspect").inspect(s) .. "\n")
  -- io.stderr:write(pandoc.utils.stringify(s) .. "\n")
end

local pandoc = _G.pandoc

local COMMENT = false

local List = require("pandoc.List")

function Blocks(blocks)
  for i = #blocks - 1, 1, -1 do
    if blocks[i].t == "Null" then
      blocks:remove(i)
    end
  end
  return blocks
end

function RawBlock(el)
  local str = el.c[2]
  if str == "<!-- panvimdoc-ignore-start -->" then
    COMMENT = true
  elseif str == "<!-- panvimdoc-ignore-end -->" then
    COMMENT = false
  end
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Header(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Para(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function BlockQuote(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Table(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Plain(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function OrderedList(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function BulletList(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function LineBlock(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function HorizontalRule(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Div(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function DefinitionList(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function CodeBlock(el)
  if COMMENT == true then
    return pandoc.Null()
  end
  return el
end

function Str(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Cite(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Code(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Emph(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Image(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function LineBreak(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Link(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Math(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Note(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Quoted(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function RawInline(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function SmallCaps(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function SoftBreak(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Space(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Span(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Text(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Strikeout(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Strong(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Subscript(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Superscript(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end

function Underline(el)
  if COMMENT == true then
    return pandoc.Str("")
  end
  return el
end
