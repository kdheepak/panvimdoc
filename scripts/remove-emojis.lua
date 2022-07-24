local demojify = require("Demojify")

local function cleanup(elem)
	if elem.text ~= nil then
		elem.text = demojify(elem.text)
		if string.len(elem.text) ~= 0 then
			return elem
		else
			return {}
		end
	end
end

return { { Inline = cleanup, Block = cleanup} }
