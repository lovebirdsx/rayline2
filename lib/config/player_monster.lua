require 'lib.common.table'

local M = {}

local cfgs = {
	{id =1, name ='火龙1', model_name='火龙1', hp=2000, attack=200, recover=10, skill='改变世界-火'},
	{id =2, name ='水龙1', model_name='水龙1', hp=2000, attack=200, recover=10, skill='神圣之水'},
	{id =3, name ='木龙1', model_name='木龙1', hp=2000, attack=200, recover=10, skill='誓死抵抗'},
	{id =4, name ='光龙1', model_name='光龙1', hp=2000, attack=200, recover=10, skill='愤怒一击'},
	{id =5, name ='暗龙1', model_name='暗龙1', hp=2000, attack=200, recover=10, skill='清空一切'},
}

local cfgs_by_id = table.array_to_kv(cfgs, 'id')
local cfgs_by_name = table.array_to_kv(cfgs, 'name')

function M.get_cfg_by_id(id)
	return cfgs_by_id[id]
end

function M.get_cfg_by_name(name)
	return cfgs_by_name[name]
end

return M
