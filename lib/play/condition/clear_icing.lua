local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'
local HexType = require 'lib.play.hex.type'

local ClearIcing = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)
end)

function ClearIcing:bind(stage)
	self.stage = stage
	self.max_count = stage:get_board():get_hex_count_by_type(HexType.Icing)
end

function ClearIcing:is_bind()
	return self.stage ~= nil
end

function ClearIcing:get_type()
	return Type.ClearIcing
end

function ClearIcing:get_type_string()
	return Type.tostring(self:get_type())
end

function ClearIcing:get_filed_names()
	return {}
end

function ClearIcing:gen_snapshot()
	return nil
end

function ClearIcing:apply_snapshot(s)

end

function ClearIcing:is_equal(other)
	return self:get_type() == other:get_type()
end

function ClearIcing:tostring()
	return 'Clear Icing'
end

function ClearIcing:get_status_string()
	assert(self:is_bind())
	local board = self.stage:get_board()
	return ('Clear Icing (%d / %d)'):format(self.max_count - board:get_hex_count_by_type(HexType.Icing), self.max_count)
end

function ClearIcing:is_ok()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() >= 0 and board:get_hex_count_by_type(HexType.Icing) == 0
end

function ClearIcing:is_failed()
	assert(self:is_bind())
	local inserter, board = self.stage:get_inserter(), self.stage:get_board()
	return inserter:get_block_count() == 0 and board:get_hex_count_by_type(HexType.Icing) > 0
end

return ClearIcing
