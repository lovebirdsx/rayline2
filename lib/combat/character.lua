local event = require 'lib.common.event'
local buff_mgr = require 'lib.combat.buff_mgr'

local M = {}

function M.create(cfg)
	local I = {}
	local _raw_attr_map = {}
	local _buff_mgr = buff_mgr.create(cfg.stage)

	function I.attr(attr_id)
		local attr = _raw_attr_map[attr_id] or 1
		_buff_mgr.foreach(function (buff)
			attr = buff.apply_attr(attr_id, attr)
		end)
		return attr
	end

	function I.set_raw_attr(attr_id, value)
		_raw_attr_map[attr_id] = value
	end

	function I.set_raw_attrs(t)
		for k, v in pairs(t) do
			_raw_attr_map[k] = v
		end
	end

	function I.buff_mgr()
		return _buff_mgr
	end

	function I.cast_skill(skill_id, target)

	end
end

return M
