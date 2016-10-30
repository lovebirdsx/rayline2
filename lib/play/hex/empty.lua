local class = require 'lib.common.class'
local Base = require 'lib.play.hex.base'
local Type = require 'lib.play.hex.type'

local EmptyHex = class(Base, function (self)
	Base.init(self)
end)

function EmptyHex:copy()
	return self
end

function EmptyHex:get_type()
	return Type.Empty
end

function EmptyHex:can_lineup()
	return false
end

function EmptyHex:on_event(type, x, y, board, result, params)

end

function EmptyHex:tostring()
	return 'E'
end

function EmptyHex:gen_snapshot()
	return ''
end

function EmptyHex:apply_snapshot(s)

end

function EmptyHex:is_equal(other)
	return other:get_type() == Type.Empty
end

function EmptyHex:get_properties()
	return {}
end

return EmptyHex
