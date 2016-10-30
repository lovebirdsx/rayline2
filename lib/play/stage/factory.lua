local Type = require 'lib.play.stage.type'
local Normal = require 'lib.play.stage.normal'
local Puzzle = require 'lib.play.stage.puzzle'

local _classes = {
	[Type.Normal] = Normal,
	[Type.Puzzle] = Puzzle,
}

local Factory = {}
function Factory.create(type, params)
	local creater = assert(_classes[type], 'invalid hex type ' .. type)
	return creater(params)
end

return Factory
