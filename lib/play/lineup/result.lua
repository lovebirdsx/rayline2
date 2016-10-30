local class = require 'lib.common.class'
local Step = require 'lib.play.lineup.step'

local Result = class(function (self, board)
	self.board = board
	self._steps = {}
	self._curr_step_id = 0
end)

function Result:reset()
	self._curr_step_id = 0
end

function Result:expand_step()
	local step = Step(self.board, self)
	table.insert(self._steps, step)
	return step
end

function Result:increase_step()
	self._curr_step_id = self._curr_step_id + 1
	return self._steps[self._curr_step_id]
end

function Result:get_curr_step()
	return self._steps[self._curr_step_id]
end

function Result:get_next_step()
	if not self:has_next_step() then
		self:expand_step()
	end

	return self._steps[self._curr_step_id + 1]
end

function Result:has_next_step()
	return self._curr_step_id < #self._steps
end

function Result:get_step(id)
	return self._steps[id]
end

function Result:get_size()
	return #self._steps
end

function Result:tostring()
	local strs = {}
	for i, step in ipairs(self._steps) do
		table.insert(strs, string.format('step %d: \n%s', i, step:tostring('\t')))
	end
	return table.concat(strs, '\n')
end

return Result
