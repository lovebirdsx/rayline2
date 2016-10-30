local class = require 'lib.common.class'
local Type = require 'lib.play.gen.type'
local Block = require 'lib.play.block.block'

local CFG = {}

CFG[Type.Simple] = {
	{range = {1, 1}, rate = 1},
	{range = {37, 49}, rate = 49 - 37 + 1},
}

CFG[Type.Normal] = {
	{range = {1, 1}, rate = 10},
	{range = {2, 19}, rate = 90},
}

CFG[Type.Normal2] = {
	{range = {1, 1}, rate = 10},
	{range = {2, 25}, rate = 90},
}

CFG[Type.Hard] = {
	{range = {1,  1}, rate = 10},
	{range = {26, 36}, rate = 90},
}

CFG[Type.SimpleHard] = {
	{range = {1, 1}, rate = 1},
	{range = {37, 49}, rate = 13},
	{range = {26, 36}, rate = 11},
}

CFG[Type.NormalHard] = {
	{range = {1, 1}, rate = 10},
	{range = {2, 25}, rate = 45},
	{range = {26, 36}, rate = 45},
}

CFG[Type.SimpleNormal] = {
	{range = {1, 1}, rate = 1},
	{range = {2, 25}, rate = 24},
	{range = {37, 49}, rate = 13},
}

local Policy = class(function (self, type)
	local cfg = assert(CFG[type], 'no policy type ' .. type)
	local gen_cfg = {}
	local total_rate = 0
	for i, r in ipairs(cfg) do
		total_rate = total_rate + r.rate
	end
	self.total_rate = total_rate
	self.cfg = cfg
	self.type = type
end)

function Policy:gen_id()
	local rate = math.random(1, self.total_rate)
	for i, r in ipairs(self.cfg) do
		if rate <= r.rate then
			local from, to = r.range[1], r.range[2]
			return math.random(from, to)
		else
			rate = rate - r.rate
		end
	end

	assert(false)
end

function Policy:set_type(type)
	self:init(type)
end

function Policy:get_type()
	return self.type
end

function Policy:get_all_ids()
	local ids = {}

	for _, r in ipairs(self.cfg) do
		for id = r.range[1], r.range[2] do
			table.insert(ids, id)
		end
	end

	return ids
end

function Policy:get_all_blocks()
	local ids = self:get_all_ids()
	local blocks = {}

	for i, id in ipairs(ids) do
		table.insert(blocks, Block({id = id}))
	end
	return blocks
end

function Policy:gen_snapshot()
	return self.type
end

function Policy:apply_snapshot(s)
	self:set_type(s)
end

function Policy:is_equal(other)
	return self.type == other.type
end

function Policy:tostring()
	return Type.tostring(self.type)
end

return Policy