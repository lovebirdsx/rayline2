require 'lib.common.table'
require 'lib.common.color'

local Serializer = require 'lib.common.serializer'

local test = {}

function test_all()
	local test_names = table.get_keys(test)
	table.sort(test_names)
	for i, name in ipairs(test_names) do
		local fun = test[name]
		print('test: ' .. name)
		fun()
	end
end

function test.parse_twice()
	local block_ids = {1,2,3}
	local s = Serializer.format(block_ids)
	print(s)
	print(string.gsub(s, '\n', ' '))

	local t = {block_ids = s}
	local s2 = Serializer.format(t)
	print(s2)
	print(string.gsub(s2, '\n', ' '))
end

function test.format_path()
	local paths = {'/stages/1/1.stg', 'stages/1/1.stg', '1.stg'}
	for i, path in ipairs(paths) do
		print(string.match(path, '^[/\\]*(.+)'))
	end

end

function test.color()
	print(HSL(177, 0.46, 1))
	print(HSL(42, 0.46, 1))
	print(HSL(40, 0.46, 0.5))
end

test_all()