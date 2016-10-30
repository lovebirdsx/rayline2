local class = require 'lib.common.class'
local Base = require 'lib.play.hex.base'
local Type = require 'lib.play.hex.type'

local BombHex = class(Base, function (self)
	Base.init(self)
end)

function BombHex:copy()
	return self
end

function BombHex:get_type()
	return Type.Bomb
end

function BombHex:can_lineup()
	return true
end

function BombHex:on_event(type, x, y, board, result, params)
	if type == 'lineup' or type == 'bomb_nearby' or type == 'arrowup' then
		if not self.is_bomb_prepare then
			local step = result:get_next_step()
			step:add_event('bomb_prepare', {board:get_slot(x, y)})
			self.is_bomb_prepare = true
		end
	elseif type == 'bomb_prepare' then
		local next_step = result:get_next_step()
		next_step:add_event('bomb_nearby', board:get_nearby_slots(x, y))
		next_step:add_event('bomb', {board:get_slot(x, y)})
	elseif type == 'bomb' then
		local curr_step = result:get_curr_step()
		curr_step:del_hex(self, x, y)
	end
end

function BombHex:tostring()
	return 'B'
end

function BombHex:gen_snapshot()
	return ''
end

function BombHex:apply_snapshot(s)

end

function BombHex:is_equal(other)
	return other:get_type() == Type.Bomb
end

function BombHex:get_properties()
	return {}
end

return BombHex
