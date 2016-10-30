local class = require 'lib.common.class'

local Base = class(function (self)

end)

function Base:copy()
	error('copy not implement ')
end

function Base:can_lineup()
	error('can_lineup not implement ')
end

function Base:tostring()
	error('tostring not implement ')
end

function Base:on_event(type, x, y, board, result, params)
	error('on_event not implement ')
end

function Base:get_type()
	error('get_type not implement')
end

function Base:gen_snapshot()
	error('gen_snapshot not implement')
end

function Base:apply_snapshot(s)
	error('apply_snapshot not implement')
end

function Base:get_properties()
	error('get_properties not implement')
end

function Base:is_equal(hex)
	error('is_equal not implement')
end

return Base
