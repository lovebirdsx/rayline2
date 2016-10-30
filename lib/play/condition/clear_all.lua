local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'

local ClearAll = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)
end)

function ClearAll:bind(stage)
	self.stage = stage
end

function ClearAll:is_bind()
	return self.stage ~= nil
end

function ClearAll:get_type()
	return Type.ClearAll
end

function ClearAll:get_type_string()
	return Type.tostring(self:get_type())
end

function ClearAll:get_filed_names()
	return {}
end

function ClearAll:gen_snapshot()
	return nil
end

function ClearAll:apply_snapshot(s)

end

function ClearAll:is_equal(other)
	return self:get_type() == other:get_type()
end

function ClearAll:tostring()
	return 'Clear All'
end

function ClearAll:get_status_string()
	assert(self:is_bind())
	return 'Clear All'
end

function ClearAll:is_ok()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() >= 0 and board:is_empty()
end

function ClearAll:is_failed()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() == 0 and not board:is_empty()
end

return ClearAll
