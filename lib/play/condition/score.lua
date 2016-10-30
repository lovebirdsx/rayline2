local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'

local Score = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)

	self.score = params.score or 0
end)

function Score:bind(stage)
	self.stage = stage
end

function Score:is_bind()
	return self.stage ~= nil
end

function Score:get_type()
	return Type.Score
end

function Score:get_type_string()
	return Type.tostring(self:get_type())
end

function Score:get_score(score)
	return self.score
end

function Score:set_score(score)
	self.score = tonumber(score)
end

function Score:get_filed_names()
	return {'score'}
end

function Score:gen_snapshot()
	return self.score
end

function Score:apply_snapshot(s)
	local score = s
	self.score = score
end

function Score:is_equal(other)
	return self.score == other.score
end

function Score:tostring()
	return 'Score: ' .. self.score
end

function Score:get_status_string()
	assert(self:is_bind())
	return ('Reach Score %g'):format(self.score)
end

function Score:is_ok()
	assert(self:is_bind())
	return self.stage:get_score() >= self.score
end

function Score:is_failed()
	assert(self:is_bind())
	return false
end

return Score
