local PuzzleStage = require 'lib.play.stage.puzzle'
local PuzzleConfig = require 'lib.config.puzzle'
local Serializer = require 'lib.common.serializer'
local Config = require 'lib.config.base'
local Cache = require 'lib.common.cache'
local Helper = require 'lib.common.helper'

local PuzzleLoader = {}
local _cache = Cache(go and sys.get_save_file(Config.SaveAppId, '') or 'cache')

local function read_stage(snapshot)
	if snapshot then
		local stage = PuzzleStage()
		stage:apply_snapshot(snapshot)
		return stage
	end
end

function PuzzleLoader.load_res(path)
	local snapshot = Helper.load_res_table(path)
	return read_stage(snapshot)
end

function PuzzleLoader.load(path)
	local snapshot = Helper.load_table(path)
	return read_stage(snapshot)
end

function PuzzleLoader.load_from_sv(path)
	local snapshot = _cache:get_table(path)
	return read_stage(snapshot)
end

function PuzzleLoader.save_to_sv(path, stage)
	return _cache:set_table(path, stage:gen_snapshot())
end

function PuzzleLoader.sync(ip, port)
	return _cache:sync(ip, port)
end

function PuzzleLoader.debug()
	_cache:debug()
end

return PuzzleLoader
