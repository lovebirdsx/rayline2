local class = require 'lib.common.class'
local Type = require 'lib.play.stage.type'
local Base = require 'lib.play.stage.base'
local Board = require 'lib.play.board'
local Inserter = require 'lib.play.inserter.inserter'
local ConditionManager = require 'lib.play.condition.manager'

local Puzzle = class(Base, function (self, params)
	Base.init(self, params)

	self.board = Board(5)
	self.inserter = Inserter()
	self.condition_manager = ConditionManager(self)

	self.score = 0
	self.time = 0
end)

function Puzzle:get_type()
	return Type.Puzzle
end

function Puzzle:get_score()
	return self.score
end

function Puzzle:get_time()
	return self.time
end

function Puzzle:get_board()
	return self.board
end

function Puzzle:get_inserter()
	return self.inserter
end

function Puzzle:get_condition_manager()
	return self.condition_manager
end

function Puzzle:is_gameover()
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

function Puzzle:is_failed()
	return self.condition_manager:is_failed() or self:is_gameover()
end

function Puzzle:is_ok()
	return self.condition_manager:is_ok()
end

function Puzzle:is_end()
	return self:is_ok() or self:is_failed()
end

function Puzzle:update(dt)
	self.time = self.time + dt
end

function Puzzle:add_score(score)
	self.score = self.score + score
	return self.score
end

function Puzzle:apply_snapshot(s)
	self.score = s.score
	self.time = s.time
	self.board:apply_snapshot(s.board)
	self.inserter:apply_snapshot(s.inserter)
	self.condition_manager:apply_snapshot(s.condition_manager)
end

function Puzzle:gen_snapshot()
	return {
		score = self.score,
		time = self.time,
		board = self.board:gen_snapshot(),
		inserter = self.inserter:gen_snapshot(),
		condition_manager = self.condition_manager:gen_snapshot()
	}
end

function Puzzle:is_equal(other)
	if self.score ~= other.score then return false end
	if self.time ~= other.time then return false end
	if not self.board:is_equal(other.board) then return false end
	if not self.inserter:is_equal(other.inserter) then return false end
	if not self.condition_manager:is_equal(other.condition_manager) then return false end

	return true
end

return Puzzle
