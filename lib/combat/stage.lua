local event = require 'lib.common.event'
local team = require 'lib.combat.team'
local wave = require 'lib.combat.wave'

local M = {}

function M.create(cfg)
	local I = {}

	local _waves = {}
	local _wave_id = 1
	local _max_wave = cfg.max_wave
	local _player_team = team.create()

	I.on_stage_start = event()
	I.on_stage_end = event()
	I.on_stage_win = event()
	I.on_stage_fail = event()
	I.on_round_start = event()
	I.on_round_end = event()
	I.on_wave_start = event()
	I.on_wave_end = event()

	function I._init()
		for i = 1, _max_wave do
			table.insert(_waves, wave.create())
		end
	end

	function I.start()
		I.on_stage_start.notify()
	end

	function I.is_win()
		return _wave_id == max_wave and I.current_wave().is_end()
	end

	function I.win()
		I.on_stage_end.notify()
		I.on_stage_win.notify()
	end

	function I.is_fail()
		return _player_team.is_dead()
	end

	function I.fail()
		I.on_stage_end.notify()
		I.on_stage_fail.notify()
	end

	function I.max_wave()
		return _max_wave
	end

	function I.player_team()
		return _player_team
	end

	function I.enemy_team()
		return I.current_wave().enemy_team()
	end

	function I.current_wave()
		return _waves[_wave_id]
	end

	function I.move_to_next_wave()
		assert(I.current_wave().is_end() and _wave_id < _max_wave)
		_wave_id = _wave_id + 1
	end

	return I
end

return M
