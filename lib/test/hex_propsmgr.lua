local Manager = require 'lib.play.hex.propsmgr'
local Type = require 'lib.play.hex.type'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.apply_snapshot()
	local mgr1 = Manager()
	mgr1:get_props(Type.Normal):set('color_id', 3)
	local s = mgr1:gen_snapshot()

	local mgr2 = Manager()
	mgr2:apply_snapshot(s)

	assert(mgr1:is_equal(mgr2))
end

function test.get_all()
	local mgr1 = Manager()
	local props = mgr1:get_props(Type.Normal)
	props:set('color_id', 3)

	local props_map = props:get_all()
	assert(props_map['color_id'] == 3)
end

function test.cmp()
	local mgr1, mgr2 = Manager(), Manager()
	assert(mgr1:is_equal(mgr2))

	mgr1:set_selected_type(Type.Icing)
	assert(not mgr1:is_equal(mgr2))

	mgr2:set_selected_type(Type.Icing)
	assert(mgr1:is_equal(mgr2))
end

test_all()