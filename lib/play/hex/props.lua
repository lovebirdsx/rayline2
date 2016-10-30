require 'lib.common.table'

local class = require 'lib.common.class'

local Props = class(function (self)
	self.data = {}
end)

function Props:test(name)
	return self.data[name] ~= nil
end

function Props:set(name, value)
	self.data[name] = value
end

function Props:get(name)
	return self.data[name]
end

function Props:get_count()
	return table.size(self.data)
end

function Props:get_all()
	return table.copy(self.data)
end

function Props:gen_snapshot()
	return self.data
end

function Props:apply_snapshot(s)
	self.data = s
end

function Props:is_equal(other)
	if self:get_count() ~= other:get_count() then
		return false
	end

	for k, v in pairs(self.data) do
		local v2 = other.data[k]
		if v2 ~= v then
			return false
		end
	end

	return true
end

function Props:tostring()
	local r = {}
	for k, v in pairs(self.data) do
		table.insert(r, ('%s = %s'):format(k, tostring(v)))
	end

	return table.concat(r, ' ')
end

return Props