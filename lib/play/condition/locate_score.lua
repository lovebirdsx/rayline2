local class = require 'lib.common.class'
local Base = require 'lib.play.condition.base'
local Type = require 'lib.play.condition.type'

local LocateScore = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)

	self.locate_count = params.locate_count or 10
	self.score = params.score or 1000
end)

function LocateScore:bind(stage)
	self.stage = stage
end

function LocateScore:is_bind()
	return self.stage ~= nil
end

function LocateScore:get_type()
	return Type.LocateScore
end

function LocateScore:get_type_string()
	return Type.tostring(self:get_type())
end

function LocateScore:get_locate_count(count)
	return self.locate_count
end

function LocateScore:get_score(score)
	return self.score
end

function LocateScore:set_locate_count(count)
	self.locate_count = tonumber(count)
end

function LocateScore:set_score(score)
	self.score = tonumber(score)
end

function LocateScore:get_filed_names()
	return {'locate_count', 'score'}
end

function LocateScore:gen_snapshot()
	return {
		locate_count = self.locate_count,
		score = self.score
	}
end

function LocateScore:apply_snapshot(s)
	self.locate_count = s.locate_count
	self.score = s.score
end

function LocateScore:is_equal(other)
	return self.locate_count == other.locate_count and self.score == other.score
end

function LocateScore:tostring()
	return ('score:%g locate count:%g'):format(self.score, self.locate_count)
end

function LocateScore:get_status_string()
	assert(self:is_bind())
	local locate_count = self.stage:get_board():get_locate_count()
	return ('Get score %g in %g(%g) locates'):format(self.score, self.locate_count, locate_count)
end

function LocateScore:is_ok()
	assert(self:is_bind())
	local score = self.stage:get_score()
	local locate_count = self.stage:get_board():get_locate_count()
	return score >= self.score and locate_count <= self.locate_count
end

function LocateScore:is_failed()
	assert(self:is_bind())
	local score = self.stage:get_score()
	local locate_count = self.stage:get_board():get_locate_count()
	return score < self.score and locate_count >= self.locate_count
end

return LocateScore
