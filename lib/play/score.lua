local class = require 'lib.common.class'

local Score = {}

function Score.get_locate_score(block)
	return 10
end

local SCORE_CFG = {
	[1] = 40,
	[2] = 80,
	[3] = 160,
	[4] = 320,
	[5] = 640,
	[6] = 1280,
	[7] = 2560,
	[8] = 5120,
	[9] = 10240,
	[10] = 20480,
}

local DIAMOND_SCORE = 100

function Score.access_result(result)
	local lineup_slot_count = 0
	local lineup_count = 0

	for i = 1, result:get_size() do
		local step = result:get_step(i)
		local events = step:get_events()
		for _, ev in ipairs(events) do
			local type, slots = ev.type, ev.slots
			if type == 'lineup' then
				lineup_count = lineup_count + 1
				local score = SCORE_CFG[lineup_count]
				ev.score = score
			elseif type == 'del_diamond' then
				ev.score = DIAMOND_SCORE
			end
		end
	end
end

return Score
