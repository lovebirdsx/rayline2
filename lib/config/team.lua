require 'lib.common.table'

local M = {}
local cfgs = {
	{name='标准', monsters={'火龙1', '水龙1', '木龙1', '光龙1', '暗龙1'}}
}

local cfgs_by_name = table.array_to_kv(cfgs, 'name')

function M.get_cfg_by_name(name)
	return cfgs_by_name[name]
end

return M