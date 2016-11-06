require 'lib.common.table'

local M = {}

local cfgs = {
	{
		id = 1,
		name = '测试关卡1',
		wave = {
			{'火龙2'},
			{'水龙2'},
			{'木龙2'},
			{'光龙2'},
			{'暗龙2'},
		}
	},

	{
		id = 2,
		name = '测试关卡2',
		wave = {
			{'火龙3'},
			{'水龙3'},
			{'木龙3'},
			{'光龙3'},
			{'暗龙3'},
		}
	}
}

local cfgs_by_name = table.array_to_kv(cfgs, 'name')

function M.get_cfg_by_name(name)
	return cfgs_by_name[name]
end

return M