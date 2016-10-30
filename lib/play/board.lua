local class = require 'lib.common.class'
local File = require 'lib.common.file'
local Serializer = require 'lib.common.serializer'
local HexType = require 'lib.play.hex.type'
local LineupResult = require 'lib.play.lineup.result'
local HexFactory = require 'lib.play.hex.factory'

local Board = class(function (self, size)
	self.size = size or 5
	self.locate_count = 0

	self:_init_slots()
	self:_init_kb_slots()
end)

function Board:_init_slots()
	local slots = {}
	local max_row_count = self.size * 2 - 1
	for r = self.size - 1, -(self.size - 1), -1 do
		local y = r * 2
		local col_count = max_row_count - math.abs(r) - 1

		local row = {}
		for x = -col_count, col_count, 2 do
			row[x] = {hex = HexFactory.create(HexType.Empty), x = x, y = y}
		end
		slots[y] = row
	end
	self.slots = slots
end

function Board:_get_slots_by_kb(k, b)
	local slots = {}
	self:foreach_hex_slot(function (s)
		if s.y == s.x * k + b then
			table.insert(slots, s)
		end
	end)
	return slots
end

function Board:get_locate_count()
	return self.locate_count
end

function Board:get_slot(x, y)
	return self.slots[y][x]
end

function Board:get_kb_slots(k, b)
	if self.kb_slots[k] then
		return assert(self.kb_slots[k][b], ('no kb slots [k = %g b = %g]'):format(k, b))
	else
		assert(false, ('no k slots [k = %g]'):format(k))
	end
end

local _NEARBY_DXYS = {{-1,2},{1,2},{-2,0},{2,0},{-1,-2},{1,-2}}
function Board:get_nearby_slots(x, y)
	local slots = {}

	for _, dxy in ipairs(_NEARBY_DXYS) do
		local dx, dy = dxy[1], dxy[2]
		local sx, sy = x + dx, y + dy
		if self.slots[sy] and self.slots[sy][sx] then
			table.insert(slots, self.slots[sy][sx])
		end
	end

	return slots
end

function Board:_init_kb_slots()
	local kb_slots = {}
	for _, kdb in ipairs({{0,2}, {2,4}, {-2,4}}) do
		local k, db = kdb[1], kdb[2]
		kb_slots[k] = {}
		for b = -(self.size-1)*db, (self.size-1)*db, db do
			kb_slots[k][b] = self:_get_slots_by_kb(k, b)
		end
	end
	self.kb_slots = kb_slots
end

function Board:gen_snapshot()
	local s = {}

	s.size = self.size
	s.locate_count = self.locate_count

	local slots = {}
	self:foreach_hex_slot(function (slot)
		local x, y, hex = slot.x, slot.y, slot.hex
		table.insert(slots, {x, y, hex:get_type(), hex:gen_snapshot()})
	end)

	s.slots = slots

	return s
end

function Board:apply_snapshot(s)
	if (s.size ~= self.size) then
		self:init(s.size)
	end

	self.locate_count = s.locate_count or 0

	local i = 1
	for _, slot in ipairs(s.slots) do
		local x, y, hex_type, hex_snapshot = slot[1], slot[2], slot[3], slot[4]
		local hex0 = self.slots[y][x].hex
		local hex = HexFactory.create(hex_type)
		hex:apply_snapshot(hex_snapshot)
		self.slots[y][x].hex = hex
	end
end

function Board:save(path)
	local s = self:gen_snapshot()
	File.write(path, Serializer.format(s))
end

function Board:load(path)
	local str = File.read(path)
	if str then
		local snapshot = Serializer.parse(str)
		self:apply_snapshot(snapshot)
		return true
	end

	return false
end

function Board:print_kb_string()
	for k, slots_row in pairs(self.kb_slots) do
		for b, slots in pairs(slots_row) do
			local str = {}
			for i, s in ipairs(slots) do
				str[#str + 1] = string.format('(%2d,%2d)', s.x, s.y)
			end
			print(string.format('k=%g b=%g pos = %s', k, b, table.concat(str, ', ')))
		end
	end
end

function Board:can_locate(block, x, y)
	local slots = block:get_slots()
	for _, s in ipairs(slots) do
		local nx, ny = s.x + x, s.y + y
		if not self:can_locate_hex(nx, ny) then
			return false
		end
	end
	return true
end

function Board:can_locate_any(b)
	local result = false
	self:foreach_hex_slot(function (s)
		if self:can_locate(b, s.x, s.y) then
			result = true
			return true
		end
	end)

	return result
end

function Board:locate(block, x, y)
	local slots = block:get_slots()
	for _, s in ipairs(slots) do
		self:set_hex(s.hex, s.x + x, s.y + y)
	end

	self.locate_count = self.locate_count + 1
end

function Board:undo_locate(block, x, y)
	local slots = block:get_slots()
	for _, s in ipairs(slots) do
		self:del_hex(s.x + x, s.y + y)
	end

	self.locate_count = self.locate_count - 1
end

function Board:resize(new_size)
	if self.size == new_size then return end

	local old_slots = self.slots
	self:init(new_size)
	self:foreach_hex_slot(function (s)
		local x, y = s.x, s.y
		if old_slots[y] and old_slots[y][x] then
			self.slots[y][x].hex = old_slots[y][x].hex
		end
	end)
end

function Board:get_size()
	return self.size
end

function Board:get_hex(x, y)
	return self.slots[y][x].hex
end

function Board:has_hex(x, y)
	return self.slots[y] and self.slots[y][x]
end

function Board:set_hex(h, x, y)
	assert(h)
	self.slots[y][x].hex = h:copy()
end

function Board:set_kb_hex(h, k, b)
	assert(h)
	local slots = self:get_kb_slots(k, b)
	assert(slots)
	for _, s in ipairs(slots) do
		self:set_hex(h, s.x, s.y)
	end
end

function Board:del_hex(x, y)
	self.slots[y][x].hex = HexFactory.create(HexType.Empty)
end

function Board:can_locate_hex(x, y)
	local row = self.slots[y]
	if not row then return false end
	local slot = row[x]
	return slot and slot.hex:get_type() == HexType.Empty
end

function Board:foreach_hex_slot(f, ...)
	for _, r in pairs(self.slots) do
		for _, slot in pairs(r) do
			if f(slot, ...) then break end
		end
	end
end

function Board:foreach_kb_slots(f, ...)
	for _, kdb in ipairs({{0,2}, {2,4}, {-2,4}}) do
		local k, db = kdb[1], kdb[2]
		for b = -(self.size-1)*db, (self.size-1)*db, db do
			local slots = self.kb_slots[k][b]
			f(k, b, slots, ...)
		end
	end
end

-- return {slots1, slots2, ...}
function Board:get_lineup_slots()
	local lineup_slots = {}
	self:foreach_kb_slots(function (k, b, slots)
		local count = 0
		for _, s in ipairs(slots) do
			if s.hex:can_lineup() then
				count = count + 1
			end
		end
		if count == #slots then
			table.insert(lineup_slots, slots)
		end
	end)

	return lineup_slots
end

local function get_kb(s1, s2)
	local dx, dy = s1.x - s2.x, s1.y - s2.y
	local k = dx == 0 and 0 or dy / dx
	local b = s2.y - k * s2.x
	return k, b
end

local function get_near_db(k)
	return k == 0 and 2 or 4
end

function Board:lineup()
	local lineup_slots = self:get_lineup_slots()
	if #lineup_slots <= 0 then
		return false
	end

	local result = LineupResult(self)

	for _, slots in ipairs(lineup_slots) do
		local step = result:expand_step()
		local k, b  = get_kb(slots[1], slots[2])
		step:add_event('lineup', slots, {k = k, b = b})

		-- local near_db = get_near_db(k)
		-- for _, db in ipairs({near_db, -near_db}) do
		-- 	local nk, nb = k, b + db
		-- 	local slots = self:get_kb_slots(nk, nb)
		-- 	if slots then
		-- 		step:add_event('lineup_nearby', slots)
		-- 	end
		-- end
	end

	repeat
		local step = result:increase_step()
		step:commit()
	until not result:has_next_step()

	result:reset()

	return true, result
end

function Board:undo_lineup(result)
	local step_count = result:get_size()
	for id = step_count, 1, -1 do
		local step = result:get_step(id)
		step:revert()
	end
end

function Board:random_slot()
	local slots = {}
	self:foreach_hex_slot(function (s)
		table.insert(slots, s)
	end)
	local s = slots[math.random(1, #slots)]
	return s
end

function Board:copy()
	local b = Board(self.size)
	self:foreach_hex_slot(function (s)
		b:set_hex(s.hex, s.x, s.y)
	end)
	b.locate_count = self.locate_count
	return b
end

function Board:is_equal(b)
	if self.size ~= b.size then return false end
	if self.locate_count ~= b.locate_count then return false end
	local result = true
	self:foreach_hex_slot(function (s)
		local s2 = b.slots[s.y][s.x]
		if not s2.hex:is_equal(s.hex) then
			result = false
			return true
		end
	end)

	return result
end

function Board:get_no_empty_hex_count()
	local count = 0
	self:foreach_hex_slot(function (s)
		if s.hex:get_type() ~= HexType.Empty then
			count = count + 1
		end
	end)
	return count
end

function Board:get_hex_count_by_type(hex_type)
	local count = 0
	self:foreach_hex_slot(function (s)
		if s.hex:get_type() == hex_type then
			count = count + 1
		end
	end)
	return count
end

function Board:clear()
	local empty_hex = HexFactory.create(HexType.Empty)
	self:foreach_hex_slot(function (s)
		self:set_hex(empty_hex, s.x, s.y)
	end)
end

function Board:is_empty()
	return self:get_no_empty_hex_count() == 0
end

function Board:tostring()
	local s = {'locate_count = ' .. self.locate_count}
	local max_row_count = self.size * 2 - 1
	for r = self.size - 1, -(self.size - 1), -1 do
		local ss = {}
		local y = r * 2
		local col_count = max_row_count - math.abs(r) - 1
		for x = -col_count, col_count, 2 do
			local slot = self.slots[y][x]
			assert(slot.hex, string.format('(x, y) = (%2d, %2d)', x, y))
			ss[#ss + 1] = (slot.hex:get_type() ~= HexType.Empty) and slot.hex:tostring() or '__'
		end

		s[#s + 1] = string.rep(' ', math.abs(r)) .. table.concat(ss)
	end
	return table.concat(s, '\n')
end

return Board
