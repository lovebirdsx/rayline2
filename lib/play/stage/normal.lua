local class = require 'lib.common.class'
local Type = require 'lib.play.stage.type'
local Base = require 'lib.play.stage.base'
local Board = require 'lib.play.board'
local Inserter = require 'lib.play.inserter.inserter'
local ConditionManager = require 'lib.play.condition.manager'

local Normal = class(Base, function (self, params)
	params = params or {}
	Base.init(self, params)

	self.board = Board()
	self.inserter = Inserter()

	self.score = 0
	self.high_score = 0
end)

function Normal:add_score(score)
	self.score = self.score + score
	if self.score > self.high_score then
		self.high_score = self.score
	end
	return self.score
end

function Normal:is_high_score()
	return self.high_score == self.score
end

function Normal:get_score()
	return self.score
end

function Normal:get_high_score()
	return self.high_score
end

function Normal:restart()
	self.board:clear()
	self.inserter = Inserter()
	self.score = 0
end

function Normal:get_type()
	return Type.Normal
end

function Normal:get_board()
	return self.board
end

function Normal:get_inserter()
	return self.inserter
end

function Normal:is_gameover()
	local board = self.board
	local inserter = self.inserter

    for i = 1, inserter:get_block_count() do
        local block = inserter:get_block(i)
        if board:can_locate_any(block) then
            return false
        end
    end

    return true
end

function Normal:apply_snapshot(s)
	self.score = s.score
	self.high_score = s.high_score
	self.board:apply_snapshot(s.board)
	self.inserter:apply_snapshot(s.inserter)
end

function Normal:gen_snapshot()
	return {
		score = self.score,
		high_score = self.high_score,
		board = self.board:gen_snapshot(),
		inserter = self.inserter:gen_snapshot(),
	}
end

function Normal:is_equal(other)
	if self.score ~= other.score then return false end
	if self.high_score ~= other.high_score then return false end
	if self:get_type() ~= other:get_type() then return false end
	if not self.board:is_equal(other.board) then return false end
	if not self.inserter:is_equal(other.inserter) then return false end

	return true
end

return Normal