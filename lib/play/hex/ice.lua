local class = require 'lib.common.class'
local Hex = require 'lib.play.hex.base'
local HexType = require 'lib.play.hex.type'

local Ice = class(Hex, function (self)
	Hex.init(self)
end)

function Ice:copy()
	return self
end

function Ice:get_type()
	return HexType.Ice
end

function Ice:can_lineup()
	return false
end

function Ice:on_event(type, x, y, board, result, params)
	if type == 'lineup_nearby' or type == 'bomb_nearby' then
		result:get_curr_step():del_hex(self, x, y)
	end
end

function Ice:tostring()
	return 'I'
end

function Ice:gen_snapshot()
	return ''
end

function Ice:apply_snapshot(s)

end

function Ice:get_properties()
	return {}
end

function Ice:is_equal(other)
	return other:get_type() == HexType.Ice
end

return Ice