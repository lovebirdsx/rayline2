local function do_wave(id, cfg)
	dispatch_msg('wave_start', id)

	local enemies = create_enemies(cfg.enemies)
	local round_id = 1
	while not is_dead(enemies) do
		dispatch_msg('round_start', round_id)
		if not is_dead(enemies) then
			wait_player_cast_skills()
		end

		if not is_dead(enemies) then
			wait_player_do_lineup()
		end

		dispatch_msg('round_end', round_id)
		round_id = round_id + 1
	end

	dispatch_msg('wave_end', id)

	local player_monsters = get_player_monsters()
	return is_dead(player_monsters)
end

local function run()
	dispatch_msg('level_start')
	local waves_cfg = get_waves()
	for i, cfg in ipairs(waves_cfg) do
		local result = do_wave(i, cfg)
		if not result then
			game_over()
			break
		end
	end
	win()
end

return run
