require 'lib.common.table'

local PuzzleLoader = require 'lib.play.stage.puzzle_loader'
local PuzzleStage = require 'lib.play.stage.puzzle'
local NormalHex = require 'lib.play.hex.normal'
local File = require 'lib.common.file'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test: ' .. name .. ' -------------------------')
		case()
	end
end

function test.save_and_load()
	local path = 'stages/test.stg'
	local ip, port = '127.0.0.1', 10000
	PuzzleLoader.sync(ip, port)

	local stage = PuzzleStage()
	stage:get_board():set_hex(NormalHex(), 2, 0)

	local ok = PuzzleLoader.save_to_sv(path, stage)
	assert(ok)

	local stage2 = PuzzleLoader.load_from_sv(path)
	assert(stage2)

	assert(stage:is_equal(stage2))
	PuzzleLoader.sync(ip, port)
end

test_all()
