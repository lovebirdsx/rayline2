local class = require 'lib.common.class'
local Factory = require 'lib.play.condition.factory'

local Manager = class(function (self, stage)
	self.c_map = {}
	self.c_array = {}
	self.stage = stage
end)

function Manager:add_condition(c)
	assert(not self.c_map[c:get_type()])
	self.c_map[c:get_type()] = c
	table.insert(self.c_array, c)

	c:bind(self.stage)
end

function Manager:set_condition(id, c)
	assert(id <= self:get_condition_count())
	local old_c = self.c_array[id]
	self.c_map[old_c:get_type()] = nil
	assert(not self.c_map[c:get_type()])

	self.c_map[c:get_type()] = c
	self.c_array[id] = c
	c:bind(self.stage)
end

function Manager:rem_condition(id)
	assert(id <= self:get_condition_count())
	local c = self.c_array[id]
	self.c_map[c:get_type()] = nil
	return table.remove(self.c_array, id)
end

function Manager:_clear()
	self.c_map = {}
	self.c_array = {}
end

function Manager:get_conditions()
	return table.copy(self.c_array)
end

function Manager:get_condition_count()
	return #self.c_array
end

function Manager:get_condition(id)
	return self.c_array[id]
end

function Manager:is_ok()
	for _, c in ipairs(self.c_array) do
		if not c:is_ok() then return false end
	end
	return true
end

function Manager:is_failed()
	for _, c in ipairs(self.c_array) do
		if c:is_failed() then return true end
	end
	return false
end

function Manager:get_status_string()
	local r = {}
	for _, c in ipairs(self.c_array) do
		table.insert(r, c:get_status_string())
	end
	return table.concat(r, '\n')
end

function Manager:tostring()
	local r = {}
	for _, c in ipairs(self.c_array) do
		table.insert(r, c:tostring())
	end
	return table.concat(r, '\n')
end

function Manager:gen_snapshot()
	local snapshot = {}
	for _, c in ipairs(self.c_array) do
		table.insert(snapshot, {type = c:get_type(), snapshot = c:gen_snapshot()})
	end
	return snapshot
end

function Manager:apply_snapshot(s)
	self:_clear()

	local c_map = {}
	for _, cs in pairs(s) do
		local c_type, c_snapshot = cs.type, cs.snapshot
		local c = Factory.create(c_type)
		c:apply_snapshot(c_snapshot)
		self:add_condition(c)
	end
end

function Manager:is_equal(other)
	if self:get_condition_count() ~= other:get_condition_count() then
		return false
	end

	for c_type, c in pairs(self.c_map) do
		local c1 = other.c_map[c_type]
		if not c1 or not c:is_equal(c1) then
			return false
		end
	end

	return true
end

return Manager
