local Insertor = require 'lib.play.inserter.inserter'
local ConditionManager = require 'lib.play.condition.manager'
local ScoreCondition = require 'lib.play.condition.score'
local NormalStage = require 'lib.play.stage.normal'
local NormalHex = require 'lib.play.hex.normal'
local PolicyType = require 'lib.play.gen.type'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.inserter_apply_snashot()
	local inserter1 = Insertor()
	local s1 = inserter1:gen_snapshot()
	local inserter2 = Insertor()
	inserter2:apply_snapshot(s1)
	assert(inserter1:is_equal(inserter2))
end

function test.inserter_equal()
	local inserter1 = Insertor({policy_type = PolicyType.Normal, block_count = 0})
	local inserter2 = Insertor({policy_type = PolicyType.Normal, block_count = 0})
	assert(inserter1:is_equal(inserter2))
	inserter2:get_policy():set_type(PolicyType.Simple)
	assert(not inserter1:is_equal(inserter2))
end

function test.condition_manager()
	local mgr1 = ConditionManager()
	mgr1:add_condition(ScoreCondition({score = 10000}))
	local s1 = mgr1:gen_snapshot()
	local mgr2 = ConditionManager()
	mgr2:apply_snapshot(s1)
	assert(mgr1:is_equal(mgr2))
end

function test.gameover()
	local stage = NormalStage()
	assert(not stage:is_gameover())

	local board = stage:get_board()
	board:foreach_hex_slot(function (s)
		board:set_hex(NormalHex(), s.x, s.y)
	end)
	assert(stage:is_gameover())
end

test_all()