local M = {}

function M.create(stage)
	local I = {}
	local _buff_info_list = {}

	function I._on_round_end(round)
		local record = {}
		for i, info in ipairs(_buff_info_list) do
			if info.expired_round and info.expired_round == round then
				table.insert(record, i)
			end
		end

		for i = #record, 1, -1 do
			table.remove(_buff_info_list, record[i])
		end
	end

	function I._init()
		stage.on_round_end.sub(I._on_round_end)
	end

	function I.foreach(cb)
		for _, info in ipairs(_buff_info_list) do
			cb(info.buff)
		end
	end

	function I.del_by_type(type)
		for i, info in ipairs(_buff_info_list) do
			if info.buff.type() == type then
				table.remove(_buff_info_list, i)
				return
			end
		end
	end

	function I.add(buff, round)
		if buff.is_incompatible() then
			I.del_by_type(buff.type())
		end

		table.insert(_buff_info_list, {buff = buff, expired_round = round and round + stage.round()})
	end

	function I.del(buff)
		for i, info in ipairs(_buff_info_list) do
			if info.buff == buff then
				table.remove(_buff_info_list, i)
				return
			end
		end
	end

	I._init()
	return I
end

return M
