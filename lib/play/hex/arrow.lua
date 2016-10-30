local class = require 'lib.common.class'
local Base = require 'lib.play.hex.base'
local Type = require 'lib.play.hex.type'

local ArrowHex = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)
	self.k = params.k or 0
end)

function ArrowHex:copy()
	return self
end

function ArrowHex:get_k()
	return self.k
end

function ArrowHex:set_k(k)
	self.k = k
end

function ArrowHex:get_type()
	return Type.Arrow
end

function ArrowHex:can_lineup()
	return true
end

function ArrowHex:on_event(type, x, y, board, result, params)
	if type == 'lineup' or type == 'bomb_nearby' or type == 'arrowup' then
		if not self.is_arrow_prepare then
			local next_step = result:get_next_step()
			next_step:add_event('arrow_prepare', {board:get_slot(x, y)})
			self.is_arrow_prepare = true
		end
	elseif type == 'arrow_prepare' then
		local next_step = result:get_next_step()
		local b = y - self.k * x
		local slots = board:get_kb_slots(self.k, b)
		local ok_slots = {}
		for _, s in ipairs(slots) do
			if s.x ~= x or s.y ~= y then
				table.insert(ok_slots, s)
			end
		end

		next_step:add_event('arrowup', ok_slots)
		next_step:add_event('arrow_bomb', {board:get_slot(x, y)}, {x = x, y = y, k = self.k, b = b})
	elseif type == 'arrow_bomb' then
		local curr_step = result:get_curr_step()
		curr_step:del_hex(self, x, y)
	end
end

function ArrowHex:tostring()
	return 'A'
end

function ArrowHex:gen_snapshot()
	return self.k
end

function ArrowHex:apply_snapshot(s)
	self.k = s
end

function ArrowHex:is_equal(other)
	return other:get_type() == Type.Arrow and other.k == self.k
end

function ArrowHex:get_properties()
	return {k = self.k}
end

return ArrowHex
