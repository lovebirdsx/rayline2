require 'lib.common.table'

local M = {}

local cfgs = {
	{id = 1, name = '火龙1',  mons_file='MONS_00001', card_file='card_0001'},
	{id = 2, name = '火龙2',  mons_file='MONS_00002', card_file='card_0002'},
	{id = 3, name = '火龙3',  mons_file='MONS_00003', card_file='card_0003'},
	{id = 4, name = '火龙4',  mons_file='MONS_00004', card_file='card_0004'},
	{id = 5, name = '水龙1',  mons_file='MONS_00005', card_file='card_0005'},
	{id = 6, name = '水龙2',  mons_file='MONS_00006', card_file='card_0006'},
	{id = 7, name = '水龙3',  mons_file='MONS_00007', card_file='card_0007'},
	{id = 8, name = '水龙4',  mons_file='MONS_00008', card_file='card_0008'},
	{id = 9, name = '木龙1',  mons_file='MONS_00009', card_file='card_0009'},
	{id = 10, name = '木龙2', mons_file='MONS_00010', card_file='card_0010'},
	{id = 11, name = '木龙3', mons_file='MONS_00011', card_file='card_0011'},
	{id = 12, name = '木龙4', mons_file='MONS_00012', card_file='card_0012'},
	{id = 13, name = '光龙1', mons_file='MONS_00013', card_file='card_0013'},
	{id = 14, name = '光龙2', mons_file='MONS_00014', card_file='card_0014'},
	{id = 15, name = '光龙3', mons_file='MONS_00015', card_file='card_0015'},
	{id = 16, name = '光龙4', mons_file='MONS_00016', card_file='card_0016'},
	{id = 17, name = '暗龙1', mons_file='MONS_00017', card_file='card_0017'},
	{id = 18, name = '暗龙2', mons_file='MONS_00018', card_file='card_0018'},
	{id = 19, name = '暗龙3', mons_file='MONS_00019', card_file='card_0019'},
	{id = 20, name = '暗龙4', mons_file='MONS_00020', card_file='card_0020'},
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
