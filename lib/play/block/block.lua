require 'lib.common.table'

local class = require 'lib.common.class'
local NormalHex = require 'lib.play.hex.normal'

local CFG = {
	{id=1, 	type='normal', shape = '0', params = {color_id=3, pos_list={{0, 0},}}},
	{id=2, 	type='normal', shape = '1', params = {color_id=3, pos_list={{-2, 0},{0, 0},{2, 0},{4, 0},}}},
	{id=3, 	type='normal', shape = '1', params = {color_id=3, pos_list={{2, -4},{1, -2},{0, 0},{-1, 2},}}},
	{id=4, 	type='normal', shape = '1', params = {color_id=3, pos_list={{-2, -4},{-1, -2},{0, 0},{1, 2},}}},
	{id=5, 	type='normal', shape = '7', params = {color_id=7, pos_list={{1, -2},{-2, 0},{0, 0},{2, 0},}}},
	{id=6, 	type='normal', shape = '7', params = {color_id=7, pos_list={{-1, -2},{-2, 0},{0, 0},{2, 0},}}},
	{id=7, 	type='normal', shape = '7', params = {color_id=7, pos_list={{-2, 0},{0, 0},{2, 0},{-1, 2},}}},
	{id=8, 	type='normal', shape = '7', params = {color_id=7, pos_list={{-2, 0},{0, 0},{2, 0},{1, 2},}}},
	{id=9, 	type='normal', shape = '2', params = {color_id=2, pos_list={{-1, -2},{1, -2},{-2, 0},{0, 0},}}},
	{id=10, type='normal', shape = '2', params = {color_id=2, pos_list={{-1, -2},{1, -2},{0, 0},{2, 0},}}},
	{id=11, type='normal', shape = '2', params = {color_id=2, pos_list={{-1, -2},{-2, 0},{0, 0},{-1, 2},}}},
	{id=12, type='normal', shape = '7', params = {color_id=6, pos_list={{1, -2},{-2, 0},{0, 0},{-1, 2},}}},
	{id=13, type='normal', shape = '7', params = {color_id=6, pos_list={{1, -2},{0, 0},{-1, 2},{1, 2},}}},
	{id=14, type='normal', shape = '7', params = {color_id=6, pos_list={{1, -2},{0, 0},{2, 0},{-1, 2},}}},
	{id=15, type='normal', shape = '7', params = {color_id=6, pos_list={{-1, -2},{1, -2},{0, 0},{-1, 2},}}},
	{id=16, type='normal', shape = '7', params = {color_id=5, pos_list={{-1, -2},{0, 0},{-1, 2},{1, 2},}}},
	{id=17, type='normal', shape = '7', params = {color_id=5, pos_list={{-1, -2},{0, 0},{2, 0},{1, 2},}}},
	{id=18, type='normal', shape = '7', params = {color_id=5, pos_list={{-1, -2},{-2, 0},{0, 0},{1, 2},}}},
	{id=19, type='normal', shape = '7', params = {color_id=5, pos_list={{-1, -2},{1, -2},{0, 0},{1, 2},}}},
	{id=20, type='normal', shape = 'U', params = {color_id=1, pos_list={{-1, -2},{-2, 0},{-1, 2},{1, 2},}}},
	{id=21, type='normal', shape = 'U', params = {color_id=1, pos_list={{1, -2},{2, 0},{-1, 2},{1, 2},}}},
	{id=22, type='normal', shape = 'U', params = {color_id=1, pos_list={{-1, -2},{1, -2},{-2, 0},{-1, 2},}}},
	{id=23, type='normal', shape = 'U', params = {color_id=4, pos_list={{-1, -2},{1, -2},{2, 0},{1, 2},}}},
	{id=24, type='normal', shape = 'U', params = {color_id=4, pos_list={{-2, 0},{2, 0},{-1, 2},{1, 2},}}},
	{id=25, type='normal', shape = 'U', params = {color_id=4, pos_list={{-1, -2},{1, -2},{-2, 0},{2, 0},}}},

	{id=26, type='normal', shape = 'X', params = {color_id=2, pos_list={{-1, -2},{1, -2},{0, 0},{-1, 2},{1, 2},}}},
	{id=27, type='normal', shape = 'X', params = {color_id=1, pos_list={{1, -2},{-2, 0},{0, 0},{2, 0},{1, 2},}}},
	{id=28, type='normal', shape = 'X', params = {color_id=1, pos_list={{-1, -2},{-2, 0},{0, 0},{2, 0},{-1, 2},}}},
	{id=29, type='normal', shape = 'X', params = {color_id=6, pos_list={{-1, -2},{-2, 0},{0, 0},{2, 0},{1, 2},}}},
	{id=30, type='normal', shape = 'X', params = {color_id=6, pos_list={{1, -2},{-2, 0},{0, 0},{2, 0},{-1, 2},}}},
	{id=31, type='normal', shape = 'X', params = {color_id=5, pos_list={{1, -2},{0, 0},{2, 0},{-1, 2},{1, 2},}}},
	{id=32, type='normal', shape = 'X', params = {color_id=5, pos_list={{-2, 0},{0, 0},{2, 0},{-1, 2},{1, 2},}}},
	{id=33, type='normal', shape = 'X', params = {color_id=3, pos_list={{-1, -2},{-2, 0},{0, 0},{-1, 2},{1, 2},}}},
	{id=34, type='normal', shape = 'X', params = {color_id=3, pos_list={{-1, -2},{1, -2},{-2, 0},{0, 0},{-1, 2},}}},
	{id=35, type='normal', shape = 'X', params = {color_id=4, pos_list={{-1, -2},{1, -2},{-2, 0},{0, 0},{2, 0},}}},
	{id=36, type='normal', shape = 'X', params = {color_id=4, pos_list={{-1, -2},{1, -2},{0, 0},{2, 0},{1, 2},}}},

	{id=37, type='normal', shape = 'X', params = {color_id=7, pos_list={{0, 0},{2, 0},}}},
	{id=38, type='normal', shape = 'X', params = {color_id=3, pos_list={{1, -2},{0, 0},}}},
	{id=39, type='normal', shape = 'X', params = {color_id=3, pos_list={{-1, -2},{0, 0},}}},
	{id=40, type='normal', shape = 'X', params = {color_id=1, pos_list={{-2, 0},{0, 0},{2, 0},}}},
	{id=41, type='normal', shape = 'X', params = {color_id=2, pos_list={{1, -2},{0, 0},{-1, 2},}}},
	{id=42, type='normal', shape = 'X', params = {color_id=2, pos_list={{-1, -2},{0, 0},{1, 2},}}},
	{id=43, type='normal', shape = 'X', params = {color_id=1, pos_list={{-1, -2},{-2, 0},{0, 0},}}},
	{id=44, type='normal', shape = 'X', params = {color_id=6, pos_list={{-1, -2},{1, -2},{-2, 0},}}},
	{id=45, type='normal', shape = 'X', params = {color_id=6, pos_list={{-1, -2},{1, -2},{2, 0},}}},
	{id=46, type='normal', shape = 'X', params = {color_id=5, pos_list={{1, -2},{2, 0},{1, 2},}}},
	{id=47, type='normal', shape = 'X', params = {color_id=5, pos_list={{2, 0},{-1, 2},{1, 2},}}},
	{id=48, type='normal', shape = 'X', params = {color_id=4, pos_list={{-2, 0},{-1, 2},{1, 2},}}},
	{id=49, type='normal', shape = 'X', params = {color_id=4, pos_list={{-1, -2},{-2, 0},{-1, 2},}}},
}

local CFG_BY_ID = table.array_to_kv(CFG, 'id')

local function create_slots(id)
	local cfg = assert(CFG_BY_ID[id], 'no block id ' .. id)
	local type, params = cfg.type, cfg.params
	if type == 'normal' then
		local color_id = params.color_id
		local slots = {}
		for _, p in ipairs(params.pos_list) do
			local x, y = p[1], p[2]
			local hex = NormalHex({color_id = color_id})
			table.insert(slots, {hex = hex, x = x, y = y})
		end

		return slots
	else
		error('unkown block type ' .. type)
	end
end

local Block = class(function (self, params)
	params = params or {}
	local id = params.id
	if id then
		self:_init(id)
	end
end)

function Block:_init(id)
	self.id = id
	self.slots = create_slots(id)
end

function Block:get_id()
	return self.id
end

function Block:gen_snapshot()
	return self.id
end

function Block:apply_snapshot(s)
	local id = s
	if id then
		self:_init(id)
	end
end

function Block:is_equal(other)
	return self.id == other.id
end

function Block:get_slots()
	return self.slots and table.copy(self.slots) or {}
end

function Block:get_hex_count()
	return self.slots and #self.slots or 0
end

function Block:tostring()
	if self.slots then
		local t = {}

		for i, slot in ipairs(self.slots) do
			t[i] = '[' .. slot.hex:tostring() .. ']'
		end

		return table.concat(t, ', ')
	else
		return '[]'
	end
end

return Block
