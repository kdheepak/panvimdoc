--[[
	Demojify.lua
	A function to strip emoji-like codepoints from strings.

	This module is licensed under MIT, review the LICENSE file or:
	https://github.com/buildthomas/Demojify/blob/master/LICENSE
--]]

local function lookupify(t)
  local r = {}
  for _, v in pairs(t) do
    r[v] = true
  end
  return r
end

-- All emoji-like codepoint ranges in UTF8
local blockedRanges = {
  { 0x0001F601, 0x0001F64F },
  { 0x00002702, 0x000027B0 },
  { 0x0001F680, 0x0001F6C0 },
  { 0x000024C2, 0x0001F251 },
  { 0x0001F300, 0x0001F5FF },
  { 0x00002194, 0x00002199 },
  { 0x000023E9, 0x000023F3 },
  { 0x000025FB, 0x000026FD },
  { 0x0001F300, 0x0001F5FF },
  { 0x0001F600, 0x0001F636 },
  { 0x0001F681, 0x0001F6C5 },
  { 0x0001F30D, 0x0001F567 },
  -- unicode 8
  { 0x0001F980, 0x0001F984 },
  { 0x0001F910, 0x0001F918 },
  { 0x0001F6E0, 0x0001F6E5 },
  -- unicode 9
  { 0x0001F920, 0x0001F927 },
  { 0x0001F919, 0x0001F91E },
  { 0x0001F933, 0x0001F93A },
  { 0x0001F93C, 0x0001F93E },
  { 0x0001F985, 0x0001F98F },
  { 0x0001F940, 0x0001F94F },
  { 0x0001F950, 0x0001F95F },
  -- unicode 10
  { 0x0001F928, 0x0001F92F },
  { 0x0001F9D0, 0x0001F9DF },
  { 0x0001F9E0, 0x0001F9E6 },
  { 0x0001F992, 0x0001F997 },
  { 0x0001F960, 0x0001F96B },
  -- unicode 11
  { 0x0001F9B0, 0x0001F9B9 },
  { 0x0001F97C, 0x0001F97F },
  { 0x0001F9F0, 0x0001F9FF },
  { 0x0001F9E7, 0x0001F9EF },
  -- unicode 12
  { 0x0001F7E0, 0x0001F7EB },
  { 0x0001FA90, 0x0001FA95 },
  { 0x0001F9A5, 0x0001F9AA },
  { 0x0001F9BA, 0x0001F9BF },
  { 0x0001F9C3, 0x0001F9CA },
  { 0x0001FA70, 0x0001FA73 },
}

-- Miscellaneous UTF8 codepoints that should be blocked
local blockedSingles = lookupify({
  0x000000A9,
  0x000000AE,
  0x0000203C,
  0x00002049,
  0x000020E3,
  0x00002122,
  0x00002139,
  0x000021A9,
  0x000021AA,
  0x0000231A,
  0x0000231B,
  0x000025AA,
  0x000025AB,
  0x000025B6,
  0x000025C0,
  0x00002934,
  0x00002935,
  0x00002B05,
  0x00002B06,
  0x00002B07,
  0x00002B1B,
  0x00002B1C,
  0x00002B50,
  0x00002B55,
  0x00003030,
  0x0000303D,
  0x00003297,
  0x00003299,
  0x0001F004,
  0x0001F0CF,
  -- unicode 7
  0x0001F6F3,
  0x0001F6F4,
  0x0001F6E9,
  0x0001F6F0,
  0x0001F6CE,
  0x0001F6CD,
  0x0001F6CF,
  0x0001F6CB,
  0x00023F8,
  0x00023F9,
  0x00023FA,
  0x0000023,
  0x0001F51F,
  -- unicode 8
  0x0001F6CC,
  0x0001F9C0,
  0x0001F6EB,
  0x0001F6EC,
  0x0001F6D0,
  0x00023CF,
  0x000002A,
  0x0002328,
  -- unicode 9
  0x0001F5A4,
  0x0001F471,
  0x0001F64D,
  0x0001F64E,
  0x0001F645,
  0x0001F646,
  0x0001F681,
  0x0001F64B,
  0x0001F647,
  0x0001F46E,
  0x0001F575,
  0x0001F582,
  0x0001F477,
  0x0001F473,
  0x0001F930,
  0x0001F486,
  0x0001F487,
  0x0001F6B6,
  0x0001F3C3,
  0x0001F57A,
  0x0001F46F,
  0x0001F3CC,
  0x0001F3C4,
  0x0001F6A3,
  0x0001F3CA,
  0x00026F9,
  0x0001F3CB,
  0x0001F6B5,
  0x0001F6B5,
  0x0001F468,
  0x0001F469,
  0x0001F990,
  0x0001F991,
  0x0001F6F5,
  0x0001F6F4,
  0x0001F6D1,
  0x0001F6F6,
  0x0001F6D2,
  0x0002640,
  0x0002642,
  0x0002695,
  0x0001F3F3,
  0x0001F1FA,
  -- unicode 10
  0x0001F91F,
  0x0001F932,
  0x0001F931,
  0x0001F9F8,
  0x0001F9F7,
  0x0001F3F4,
  -- unicode 11
  0x0001F970,
  0x0001F973,
  0x0001F974,
  0x0001F97A,
  0x0001F975,
  0x0001F976,
  0x0001F9B5,
  0x0001F9B6,
  0x0001F468,
  0x0001F469,
  0x0001F99D,
  0x0001F999,
  0x0001F99B,
  0x0001F998,
  0x0001F9A1,
  0x0001F99A,
  0x0001F99C,
  0x0001F9A2,
  0x0001F9A0,
  0x0001F99F,
  0x0001F96D,
  0x0001F96C,
  0x0001F96F,
  0x0001F9C2,
  0x0001F96E,
  0x0001F99E,
  0x0001F9C1,
  0x0001F6F9,
  0x0001F94E,
  0x0001F94F,
  0x0001F94D,
  0x0000265F,
  0x0000267E,
  0x0001F3F4,
  -- unicode 12
  0x0001F971,
  0x0001F90E,
  0x0001F90D,
  0x0001F90F,
  0x0001F9CF,
  0x0001F9CD,
  0x0001F9CE,
  0x0001F468,
  0x0001F469,
  0x0001F9D1,
  0x0001F91D,
  0x0001F46D,
  0x0001F46B,
  0x0001F46C,
  0x0001F9AE,
  0x0001F415,
  0x0001F6D5,
  0x0001F6FA,
  0x0001FA82,
  0x0001F93F,
  0x0001FA80,
  0x0001FA81,
  0x0001F97B,
  0x0001F9AF,
  0x0001FA78,
  0x0001FA79,
  0x0001FA7A,
})

-- Demojify function
return function(str)
  -- Array that will contain non-emoji codepoints in string
  local codepoints = {}

  -- Loop over codepoints in input
  for _, codepoint in utf8.codes(str) do
    -- Assume innocent until proven guilty
    local insert = true

    -- Check if singular blocked
    if blockedSingles[codepoint] then
      insert = false
    else
      -- Check all ranges
      for _, range in ipairs(blockedRanges) do
        if range[1] <= codepoint and codepoint <= range[2] then
          -- Codepoint is in an emoji range
          insert = false
          break
        end
      end
    end

    -- Only insert into table if proven non-emoji
    if insert then
      table.insert(codepoints, codepoint)
    end
  end

  -- Return string without emoji codepoints
  return utf8.char(table.unpack(codepoints))
end
