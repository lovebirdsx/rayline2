local class = require 'lib.common.class'
local Hex = require 'lib.play.hex.base'
local HexType = require 'lib.play.hex.type'

local Icing = class(Hex, function (self)
	Hex.init(self)
end)

function Icing:copy()
	return self
end

function Icing:get_type()
	return HexType.Icing
end

function Icing:can_lineup()
	return false
end

function Icing:on_event(type, x, y, board, result, params)
	if type == 'bomb_nearby' then
		result:get_curr_step():del_hex(self, x, y)
	end
end

function Icing:tostring()
	return 'C'
end

function Icing:gen_snapshot()
	return ''
end

function Icing:apply_snapshot(s)

end

function Icing:is_equal(other)
	return other:get_type() == HexType.Icing
end

function Icing:get_properties()
	return {}
end

return Icing
