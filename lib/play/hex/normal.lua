local class = require 'lib.common.class'
local Base = require 'lib.play.hex.base'
local Type = require 'lib.play.hex.type'

local Normal = class(Base, function (self, params)
	Base.init(self)
	params = params or {}
	self.color_id = params.color_id or 1
	self.tied_up = params.tied_up or false
end)

function Normal:copy()
	local h = Normal()
	h.tied_up = self.tied_up
	h.color_id = self.color_id
	return h
end

function Normal:get_type()
	return Type.Normal
end

function Normal:get_color_id()
	return self.color_id
end

function Normal:set_color_id(color_id)
	self.color_id = color_id
end

function Normal:set_tied_up(bool)
	self.tied_up = bool
end

function Normal:get_tied_up()
	return self.tied_up
end

function Normal:can_lineup()
	return true
end

function Normal:on_event(type, x, y, board, result, params)
	if type == 'lineup' or type == 'arrowup' then
		if self.tied_up then
			self.tied_up = false
		else
			local curr_step = result:get_curr_step()
			curr_step:del_hex(self, x, y)

			if type == 'lineup' then
				local next_step = result:get_next_step()
				next_step:add_event('lineup_nearby', board:get_nearby_slots(x, y))
			end
		end
	elseif type == 'bomb_nearby' then
		result:get_curr_step():del_hex(self, x, y)
	end
end

function Normal:tostring()
	return self.tied_up and 'N1' or 'N0'
end

function Normal:gen_snapshot()
	return {self.color_id, self.tied_up}
end

function Normal:apply_snapshot(s)
	self.color_id = s[1]
	self.tied_up = s[2]
end

function Normal:get_properties()
	return {color_id = self.color_id, tied_up = self.tied_up}
end

function Normal:is_equal(hex)
	return hex:get_type() == Type.Normal and hex.color_id == self.color_id and hex.tied_up == self.tied_up
end

return Normal
