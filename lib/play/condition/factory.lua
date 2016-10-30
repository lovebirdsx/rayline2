local Type = require 'lib.play.condition.type'
local Score = require 'lib.play.condition.score'
local ClearAll = require 'lib.play.condition.clear_all'
local ClearIcing = require 'lib.play.condition.clear_icing'
local ClearIce = require 'lib.play.condition.clear_ice'
local ClearDiamond = require 'lib.play.condition.clear_diamond'
local LocateScore = require 'lib.play.condition.locate_score'
local Locate = require 'lib.play.condition.locate'
local TimeScore = require 'lib.play.condition.time_score'

local _classes = {
	[Type.Score] = Score,
	[Type.ClearAll] = ClearAll,
	[Type.ClearIcing] = ClearIcing,
	[Type.ClearIce] = ClearIce,
	[Type.ClearDiamond] = ClearDiamond,
	[Type.LocateScore] = LocateScore,
	[Type.TimeScore] = TimeScore,
	[Type.Locate] = Locate,
}

local Factory = {}

function Factory.create(type, params)
	local creater = assert(_classes[type], 'invalid condtion type ' .. type)
	return creater(params)
end

return Factory