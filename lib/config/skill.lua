require 'lib.common.table'

local M = {}

local cfgs = {
	{
		name ='愤怒一击',
		desc = '对所有敌人造成{damage}点伤害',
		type = '全体攻击',
		params = {damage=1000},
		round = 10,
	},

	{
		name ='神圣之水',
		desc = '恢复{hp}生命',
		type = '恢复生命',
		params = {hp=1000},
		round = 4,
	},

	{
		name ='清空一切',
		desc = '清空盘面上所有的珠子',
		type = '清空盘面',
		params = {},
		round = 15,
	},

	{
		name ='改变世界-火',
		desc = '盘面上所有珠子变成{bead_type}珠',
		type = '珠子变色',
		params = {bead_type='火'},
		round = 5,
	},

	{
		name ='攻击加强-火',
		desc = '{monster_type}属性宠物攻击变成{mutiple}倍',
		type = '攻击加强',
		params = {monster_type='火', mutiple=2},
		round = 7,
	},

	{
		name = '誓死抵抗',
		desc = '{round}回合内,受到的攻击减少{percent}',
		type = '伤害减免',
		params = {round=3, percent=0.5},
		round = 7,
	},
}

local cfgs_by_name = table.array_to_kv(cfgs, 'name')

function M.get_cfg_by_name(name)
	return cfgs_by_name[name]
end

return M
