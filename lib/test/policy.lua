local GenType = require 'lib.play.gen.type'
local Policy = require 'lib.play.gen.Policy'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.gen_result()
	local policy = Policy(GenType.Normal)
	local record = {}

	local gen_times = 10000
	for i = 1, gen_times do
		local id = policy:gen_id()
		if not record[id] then
			record[id] = 1
		else
			record[id] = record[id] + 1
		end
	end

	for id, times in ipairs(record) do
		local rate = times / gen_times
		print(('id = %d rate = %.4f'):format(id, rate))
	end
end

test_all()
