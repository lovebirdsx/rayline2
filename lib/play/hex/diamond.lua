local class = require 'lib.common.class'
local Base = require 'lib.play.hex.base'
local Type = require 'lib.play.hex.type'

local Diamond = class(Base, function (self, params)
	Base.init(self)
	params = params or {}
	self.lock_count = params.lock_count or 0
end)

function Diamond:copy()
	return Diamond({lock_count = self.lock_count})
end

function Diamond:get_type()
	return Type.Diamond
end

function Diamond:set_lock_count(count)
	self.lock_count = count
end

function Diamond:get_lock_count()
	return self.lock_count
end

function Diamond:can_lineup()
	return true
end

function Diamond:on_event(type, x, y, board, result, params)
	if type == 'lineup' or type == 'arrowup' then
		if self.lock_count > 0 then
			self.lock_count = self.lock_count - 1
		else
			local curr_step = result:get_curr_step()
			curr_step:del_hex(self, x, y)

			local next_step = result:get_next_step()
			next_step:add_event('del_diamond', {board:get_slot(x, y)})

			if type == 'lineup' then
				next_step:add_event('lineup_nearby', board:get_nearby_slots(x, y))
			end
		end
	elseif type == 'bomb_nearby' then
		result:get_curr_step():del_hex(self, x, y)
	end
end

function Diamond:tostring()
	return 'D' .. self.lock_count
end

function Diamond:gen_snapshot()
	return {self.lock_count}
end

function Diamond:apply_snapshot(s)
	self.lock_count = s[1]
end

function Diamond:get_properties()
	return {lock_count = self.lock_count}
end

function Diamond:is_equal(hex)
	return hex:get_type() == Type.Diamond and hex.lock_count == self.lock_count
end

return Diamond
