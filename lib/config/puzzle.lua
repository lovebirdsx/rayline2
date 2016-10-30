require 'lib.common.table'

local PuzzleConfig = {}

local _chp_cfg = {
	{id = 1, name = 'Casual', 	dir = '1', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 2, name = 'Easy', 	dir = '2', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 3, name = 'Normal', 	dir = '3', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 4, name = 'Hard', 	dir = '4', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 5, name = 'Harder', 	dir = '5', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 6, name = 'Crazy', 	dir = '6', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 7, name = 'Insane', 	dir = '7', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
	{id = 8, name = 'Godlike', 	dir = '8', stages = {'1.stg', '2.stg', '3.stg', '4.stg', '5.stg', '6.stg', '7.stg', '8.stg'}},
}

local _chp_cfg_by_id = table.array_to_kv(_chp_cfg, 'id')
local _chp_cfg_by_name = table.array_to_kv(_chp_cfg, 'name')

function PuzzleConfig.get_chp_count()
	return assert(#_chp_cfg)
end

local function get_cfg(chp_id)
	return assert(_chp_cfg_by_id[chp_id], 'chp_id ' .. chp_id)
end

function PuzzleConfig.get_name(chp_id)
	return get_cfg(chp_id).name
end

function PuzzleConfig.get_dir(chp_id)
	return get_cfg(chp_id).dir
end

function PuzzleConfig.get_stages(chp_id)
	return get_cfg(chp_id).stages
end

function PuzzleConfig.get_stage_count(chp_id)
	return #PuzzleConfig.get_stages(chp_id)
end

function PuzzleConfig.get_stage_file(chp_id, stg_id)
	return assert(PuzzleConfig.get_stages(chp_id)[stg_id], 'stg_id %s' .. stg_id)
end

function PuzzleConfig.get_stage_path(chp_id, stg_id)
	local dir = PuzzleConfig.get_dir(chp_id)
	local file = PuzzleConfig.get_stage_file(chp_id, stg_id)
	return string.format('stages/puzzle/%s/%s', dir, file)
end

return PuzzleConfig
