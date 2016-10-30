local Config = {}

if go then

Config.HexScale = 0.425
Config.HexWidth = 64
Config.HexHeight = 56

Config.BlockHexScale = 0.575
Config.SelectorHexScale = 0.5
Config.SaveAppId = 'rayline'

Config.HexColors = {
	vmath.vector4(255 / 255, 165 / 255, 138 / 255, 1),
	vmath.vector4(255 / 255, 220 / 255, 138 / 255, 1),
	vmath.vector4(138 / 255, 255 / 255, 153 / 255, 1),
	vmath.vector4(138 / 255, 255 / 255, 249 / 255, 1),
	vmath.vector4(138 / 255, 142 / 255, 255 / 255, 1),
	vmath.vector4(178 / 255, 138 / 255, 255 / 255, 1),
	vmath.vector4(255 / 255, 138 / 255, 181 / 255, 1),
}
Config.MaxHexColorId = #Config.HexColors

end

Config.FSIP = '100.64.140.252'
Config.FSPort = 10000
Config.RecordFile = 'stages.rec'

return Config