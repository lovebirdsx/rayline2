local Type = require 'lib.play.hex.type'

local Empty = require 'lib.play.hex.empty'
local Normal = require 'lib.play.hex.normal'
local Ice = require 'lib.play.hex.ice'
local Bomb = require 'lib.play.hex.bomb'
local Icing = require 'lib.play.hex.icing'
local Arrow = require 'lib.play.hex.arrow'
local Diamond = require 'lib.play.hex.diamond'

local _classes = {
	[Type.Empty] = Empty,
	[Type.Normal] = Normal,
	[Type.Ice] = Ice,
	[Type.Bomb] = Bomb,
	[Type.Icing] = Icing,
	[Type.Arrow] = Arrow,
	[Type.Diamond] = Diamond,
}

local Factory = {}
function Factory.create(type, params)
	local creater = assert(_classes[type], 'invalid hex type ' .. type)
	return creater(params)
end

return Factory
