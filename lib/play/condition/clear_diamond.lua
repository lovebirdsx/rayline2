local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'
local HexType = require 'lib.play.hex.type'

local ClearDiamond = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)
end)

function ClearDiamond:bind(stage)
	self.stage = stage
	self.max_count = stage:get_board():get_hex_count_by_type(HexType.Diamond)
end

function ClearDiamond:is_bind()
	return self.stage ~= nil
end

function ClearDiamond:get_type()
	return Type.ClearDiamond
end

function ClearDiamond:get_type_string()
	return Type.tostring(self:get_type())
end

function ClearDiamond:get_filed_names()
	return {}
end

function ClearDiamond:gen_snapshot()
	return nil
end

function ClearDiamond:apply_snapshot(s)

end

function ClearDiamond:is_equal(other)
	return self:get_type() == other:get_type()
end

function ClearDiamond:tostring()
	return 'Clear Diamond'
end

function ClearDiamond:get_status_string()
	assert(self:is_bind())
	local board = self.stage:get_board()
	return ('Clear Diamond (%d / %d)'):format(self.max_count - board:get_hex_count_by_type(HexType.Diamond), self.max_count)
end

function ClearDiamond:is_ok()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() >= 0 and board:get_hex_count_by_type(HexType.Diamond) == 0
end

function ClearDiamond:is_failed()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() == 0 and board:get_hex_count_by_type(HexType.Diamond) > 0
end

return ClearDiamond
