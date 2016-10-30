local CClearAll = require 'lib.play.condition.clear_all'
local CScore = require 'lib.play.condition.score'
local CLocateScore = require 'lib.play.condition.locate_score'
local CTimeScore = require 'lib.play.condition.time_score'
local PuzzleStage = require 'lib.play.stage.puzzle'
local NormalHex = require 'lib.play.hex.normal'
local EmptyHex = require 'lib.play.hex.empty'
local Block = require 'lib.play.block.block'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.clear_all()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	cm:add_condition(CClearAll())

	local board = stage:get_board()
	board:set_hex(NormalHex(), 0, 0)

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	board:set_hex(EmptyHex(), 0, 0)

	assert(stage:is_ok())
	assert(not stage:is_failed())
end

function test.score()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	cm:add_condition(CScore {score = 1000})

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	stage:add_score(1000)

	assert(stage:is_ok())
	assert(not stage:is_failed())
end

function test.locate_score_ok()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	local board = stage:get_board()

	cm:add_condition(CLocateScore {locate_count = 2, score = 1000})

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	stage:add_score(1000)
	board:locate(Block {id = 1}, 0, 0)
	board:locate(Block {id = 1}, 2, 0)

	assert(stage:is_ok())
	assert(not stage:is_failed())
end

function test.locate_score_failed()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	local board = stage:get_board()

	cm:add_condition(CLocateScore {locate_count = 2, score = 1000})

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	board:locate(Block {id = 1}, 0, 0)
	board:locate(Block {id = 1}, 2, 0)

	assert(not stage:is_ok())
	assert(stage:is_failed())
end

function test.time_score_ok()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	cm:add_condition(CTimeScore {score = 1000, time = 30})

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	stage:add_score(1000)
	stage:update(30)

	assert(stage:is_ok())
	assert(not stage:is_failed())
end

function test.time_score_failed()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	cm:add_condition(CTimeScore {score = 1000, time = 30})

	assert(not stage:is_ok())
	assert(not stage:is_failed())

	stage:add_score(900)
	stage:update(30)

	assert(not stage:is_ok())
	assert(stage:is_failed())
end

function test.manager_tostring()
	local stage = PuzzleStage()
	local cm = stage:get_condition_manager()

	cm:add_condition(CTimeScore {score = 1000, time = 30})
	cm:add_condition(CClearAll {})

	-- local c = CLocateScore()
	-- c:set_locate_count(nil)
	-- c:set_score(nil)
	-- cm:add_condition(c)

	print(cm:tostring())
	print(cm:get_status_string())
end

test_all()
