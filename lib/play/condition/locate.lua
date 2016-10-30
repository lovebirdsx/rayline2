local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'

local Locate = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)

	self.locate_count = params.locate_count or 10
end)

function Locate:bind(stage)
	self.stage = stage
end

function Locate:is_bind()
	return self.stage ~= nil
end

function Locate:get_type()
	return Type.Locate
end

function Locate:get_type_string()
	return Type.tostring(self:get_type())
end

function Locate:get_locate_count(count)
	return self.locate_count
end

function Locate:set_locate_count(count)
	self.locate_count = tonumber(count)
end

function Locate:get_filed_names()
	return {'locate_count'}
end

function Locate:gen_snapshot()
	return {
		locate_count = self.locate_count,
	}
end

function Locate:apply_snapshot(s)
	self.locate_count = s.locate_count
end

function Locate:is_equal(other)
	return self.locate_count == other.locate_count
end

function Locate:tostring()
	return ('locate count:%g'):format(self.locate_count)
end

function Locate:get_status_string()
	assert(self:is_bind())
	local locate_count = self.stage:get_board():get_locate_count()
	return ('%g(%g) locates'):format(self.locate_count, locate_count)
end

function Locate:is_ok()
	assert(self:is_bind())
	local locate_count = self.stage:get_board():get_locate_count()
	return locate_count <= self.locate_count
end

function Locate:is_failed()
	assert(self:is_bind())
	local locate_count = self.stage:get_board():get_locate_count()
	return locate_count > self.locate_count
end

return Locate
