local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'

local TimeScore = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)

	self.time = params.time or 30
	self.score = params.score or 1000
end)

function TimeScore:bind(stage)
	self.stage = stage
end

function TimeScore:is_bind()
	return self.stage ~= nil
end

function TimeScore:get_type()
	return Type.TimeScore
end

function TimeScore:get_type_string()
	return Type.tostring(self:get_type())
end

function TimeScore:get_time(time)
	return self.time
end

function TimeScore:get_score(score)
	return self.score
end

function TimeScore:set_time(time)
	self.time = tonumber(time)
end

function TimeScore:set_score(score)
	self.score = tonumber(score)
end

function TimeScore:get_filed_names()
	return {'time', 'score'}
end

function TimeScore:gen_snapshot()
	return {
		time = self.time,
		score = self.score
	}
end

function TimeScore:apply_snapshot(s)
	self.time = s.time
	self.score = s.score
end

function TimeScore:is_equal(other)
	return self.time == other.time and self.score == other.score
end

function TimeScore:tostring()
	return ('score:%g time:%g'):format(self.score, self.time)
end

function TimeScore:get_status_string()
	assert(self:is_bind())
	local time = self.stage:get_time()
	return ('Get score %g in %g(%g) seconds'):format(self.score, self.time, math.floor(time))
end

function TimeScore:is_ok()
	assert(self:is_bind())
	local score = self.stage:get_score()
	local time = self.stage:get_time()
	return score >= self.score and time <= self.time
end

function TimeScore:is_failed()
	assert(self:is_bind())
	local score = self.stage:get_score()
	local time = self.stage:get_time()
	return score < self.score and time >= self.time
end

return TimeScore
