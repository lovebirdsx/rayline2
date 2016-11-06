require 'lib.common.table'

local M = {}

local cfgs = {
	{id =1,  name ='火龙1', model_name='火龙1', hp=20000, attack=800, defence=10, round=5},
	{id =2,  name ='火龙2', model_name='火龙2', hp=20000, attack=800, defence=10, round=5},
	{id =3,  name ='火龙3', model_name='火龙3', hp=20000, attack=800, defence=10, round=5},
	{id =4,  name ='火龙4', model_name='火龙4', hp=20000, attack=800, defence=10, round=5},
	{id =5,  name ='水龙1', model_name='水龙1', hp=20000, attack=800, defence=10, round=5},
	{id =6,  name ='水龙2', model_name='水龙2', hp=20000, attack=800, defence=10, round=5},
	{id =7,  name ='水龙3', model_name='水龙3', hp=20000, attack=800, defence=10, round=5},
	{id =8,  name ='水龙4', model_name='水龙4', hp=20000, attack=800, defence=10, round=5},
	{id =9,  name ='木龙1', model_name='木龙1', hp=20000, attack=800, defence=10, round=5},
	{id =10, name ='木龙2', model_name='木龙2', hp=20000, attack=800, defence=10, round=5},
	{id =11, name ='木龙3', model_name='木龙3', hp=20000, attack=800, defence=10, round=5},
	{id =12, name ='木龙4', model_name='木龙4', hp=20000, attack=800, defence=10, round=5},
	{id =13, name ='光龙1', model_name='光龙1', hp=20000, attack=800, defence=10, round=5},
	{id =14, name ='光龙2', model_name='光龙2', hp=20000, attack=800, defence=10, round=5},
	{id =15, name ='光龙3', model_name='光龙3', hp=20000, attack=800, defence=10, round=5},
	{id =16, name ='光龙4', model_name='光龙4', hp=20000, attack=800, defence=10, round=5},
	{id =17, name ='暗龙1', model_name='暗龙1', hp=20000, attack=800, defence=10, round=5},
	{id =18, name ='暗龙2', model_name='暗龙2', hp=20000, attack=800, defence=10, round=5},
	{id =19, name ='暗龙3', model_name='暗龙3', hp=20000, attack=800, defence=10, round=5},
	{id =20, name ='暗龙4', model_name='暗龙4', hp=20000, attack=800, defence=10, round=5},
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
