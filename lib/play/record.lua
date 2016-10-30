local class = require 'lib.common.class'
local PuzzleConfig = require 'lib.config.puzzle'
local Helper = require 'lib.common.helper'
local Config = require 'lib.config.base'

local Record = class(function (self)
	self.chp_id = 1
	self.stg_id = 1
	self.select_stg_id = 1
	self.select_chp_id = 1
end)

function Record:reset()
	self.chp_id = 1
	self.stg_id = 1
end

function Record:get_chp_id()
	return self.chp_id
end

function Record:get_stg_id()
	return self.stg_id
end

function Record:is_passed(chp_id, stg_id)
	if chp_id < self.chp_id then
		return true
	elseif chp_id > self.chp_id then
		return false
	else
		if stg_id < self.stg_id then
			return true
		else
			return false
		end
	end
end

function Record:can_play(chp_id, stg_id)
	return self:is_passed(chp_id, stg_id) or (chp_id == self.chp_id and stg_id == self.stg_id)
end

function Record:get_select_stg_id()
	return self.select_stg_id
end

function Record:get_select_chp_id()
	return self.select_chp_id
end

function Record:set_select_stg_id(stg_id)
	self.select_stg_id = stg_id
end

function Record:set_select_chp_id(chp_id)
	self.select_chp_id = chp_id
end

function Record:get_select_puzzle_path()
	return PuzzleConfig.get_stage_path(self.select_chp_id, self.select_stg_id)
end

function Record:is_current_stg(chp_id, stg_id)
	return chp_id == self.chp_id and stg_id == self.stg_id
end

function Record:complete_current_stg()
	if self:is_current_stg(self.select_chp_id, self.select_stg_id) then
		local stg_id = self.stg_id + 1
		local max_stg_count = PuzzleConfig.get_stage_count(self.stg_id)
		if stg_id <= max_stg_count then
			self.stg_id = stg_id
		else
			local chp_id = self.chp_id + 1
			local max_chp_count = PuzzleConfig.get_chp_count()
			if chp_id <= max_chp_count then
				self.stg_id = 1
				self.chp_id = chp_id
			end
		end
	end
end

function Record:gen_snapshot()
	return {
		chp_id = self.chp_id,
		stg_id = self.stg_id,
		select_chp_id = self.select_chp_id,
		select_stg_id = self.select_stg_id,
	}
end

function Record:apply_snapshot(s)
	self.chp_id = s.chp_id
	self.stg_id = s.stg_id
	self.select_chp_id = s.select_chp_id
	self.select_stg_id = s.select_stg_id
end

function Record:load(path)
	path = path or Config.RecordFile
	local snapshot = Helper.load_table(path)
	if snapshot then
		self:apply_snapshot(snapshot)
	end
end

function Record:save(path)
	path = path or Config.RecordFile
	local snapshot = self:gen_snapshot()
	return Helper.save_table(path, snapshot)
end

local instance
function Record.instance()
	if not instance then
		instance = Record()
		instance:load()
	end

	return instance
end

return Record
