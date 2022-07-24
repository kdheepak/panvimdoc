local demojify = require("Demojify")

-- keep track if a emoji was removed previously
local prevEmoji = false

local function cleanup(elem)
	-- get rid of the space after the emoji, reset
	if elem.t == "Space" and prevEmoji then
		prevEmoji = false
		return {}
	end
	-- only handle things with text contents
	if elem.text ~= nil then
		elem.text = demojify(elem.text)
		if #elem.text ~= 0 then
			return elem
		else
			prevEmoji = true
			return {}
		end
	end
end

return { { Inline = cleanup, Block = cleanup} }
