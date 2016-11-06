require 'lib.common.table'

local M = {}

local cfgs = {
	{
		name = '防御盾',
		desc = '受到伤害将减少{%d}',
		add_fun = '增加伤害减免',
		rem_fun = '移除伤害减免',
		params = {percent=0.5},
		round = 4
	},
}

local cfgs_by_name = table.array_to_kv(cfgs, 'name')

function M.get_cfg_by_name(name)
	return cfgs_by_name[name]
end

return M
