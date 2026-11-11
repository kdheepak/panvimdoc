local demojify = require("lib.Demojify")

function P(s)
  require("scripts.logging").temp(s)
end

function string.starts_with(str, starts)
  return str:sub(1, #starts) == starts
end

function string.ends_with(str, ends)
  return ends == "" or str:sub(-#ends) == ends
end

local function isShortcode(text)
  return #text > 2 and text:starts_with(":") and text:ends_with(":")
end

-- Each run of inlines is cleaned on its own, so removing an emoji can only
-- take a space from its own run. Tracking "an emoji was just removed" across
-- the whole document let it eat the first space of a later paragraph when
-- the emoji ended a line.
local function removeEmojis(inlines)
  local out = pandoc.Inlines({})
  local i = 1
  while i <= #inlines do
    local el = inlines[i]
    if el.t == "Str" then
      local text = demojify(el.text)
      if text == "" or isShortcode(text) then
        -- Drop one space with the emoji so its words don't end up two spaces
        -- apart: the one after it, or the one before it at the end of a line.
        local nxt = inlines[i + 1]
        if nxt and nxt.t == "Space" then
          i = i + 1
        elseif #out > 0 and out[#out].t == "Space" then
          out:remove(#out)
        end
      else
        el.text = text
        out:insert(el)
      end
    else
      -- Inline code keeps its emojis, so only raw and math text is cleaned.
      if el.t == "RawInline" or el.t == "Math" then
        el.text = demojify(el.text)
      end
      out:insert(el)
    end
    i = i + 1
  end
  return out
end

local function removeRawBlockEmojis(el)
  el.text = demojify(el.text)
  if #el.text == 0 then
    return {}
  end
  return el
end

return { { Inlines = removeEmojis, RawBlock = removeRawBlockEmojis } }
