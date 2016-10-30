-- this moudle can only use in defold

local Config = require 'lib.config.base'
local Serializer = require 'lib.common.serializer'
local RenderHelper = require 'render.render_helper'

local Helper = {}

local function get_save_path(path)
	if type(path) ~= 'string' then
		path = Helper.hash_to_str(path)
	end

	-- http://www.defold.com/ref/sys/#sys.get_save_file:application_id-file_name
	return sys.get_save_file(Config.SaveAppId, path)
end

function Helper.load_res_table(path)
	-- avoid load res error
	if string.sub(path,1,1) ~= '/' then
		path = '/' .. path
	end

	local str = sys.load_resource(path)
	if str then
		return Serializer.parse(str)
	end
end

function Helper.save_table(path, t)
	local defold_path = get_save_path(path)
	local str = Serializer.format(t)
	sys.save(defold_path, {snapshot_str = str})
end

function Helper.load_table(path)
	local defold_path = get_save_path(path)
	local result = sys.load(defold_path)
	local str = result.snapshot_str
	if str then
		return Serializer.parse(str)
	end
end

local str_by_hash = {}
function Helper.hash_to_str(hash)
	return assert(str_by_hash[hash], 'can not find str for hash')
end

function Helper.reg_str(str)
	str_by_hash[hash(str)] = str
end

local _tables = {}
local _key_id = 1
function Helper.push_table(t)
	_tables[_key_id] = t
	local result_key_id = _key_id
	_key_id = _key_id + 1
	return result_key_id
end

function Helper.pop_table(id)
	local t = _tables[id]
	_tables[id] = nil
	return t
end

function Helper.is_pc()
	local sys_info = sys.get_sys_info()
	local sys_name = sys_info.system_name
	return sys_name == 'Windows' or sys_name == 'Linux' or sys_name == 'Darwin'
end

function Helper.get_block_center_offset(block, scale)
	local w = math.floor(Config.HexWidth / 2 * scale)
    local h = math.floor(Config.HexHeight / 2 * scale)

    local min_x, min_y, max_x, max_y
    for _, s in ipairs(block:get_slots()) do
    	local x = s.x * w
    	local y = s.y * h

    	if not min_x then
    		min_x, min_y, max_x, max_y = x, y, x, y
    	else
    		if x < min_x then min_x = x end
    		if x > max_x then max_x = x end
    		if y < min_y then min_y = y end
    		if y > max_y then max_y = y end
    	end
    end

    return -vmath.vector3((min_x + max_x) / 2, (min_y + max_y) / 2, 0)
end

function Helper.action_to_pos(action)
	return RenderHelper.action_to_pos(action)
end

function Helper.action_to_dpos(action)
	return RenderHelper.action_to_dpos(action)
end

return Helper
