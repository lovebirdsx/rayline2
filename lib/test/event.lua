local event = require 'lib.common.event'

local test = {}

local function test_all()
	for name, case in pairs(test) do
		print('----test ', name)
		case()
	end
end

function test.base()
	local e = event()

	local function foo(...)
		print('foo', ...)
	end

	local function bar(...)
		print('bar', ...)
	end

	e.sub(foo)
	e.sub(bar)
	e.notify('hello 1')

	e.unsub(foo)
	e.notify('hello 2')

	e.unsub_all()
	e.notify('hello 3')
end

function test.extend()
	local function create_stage()
		local I = {}

		I.on_stage_start = event()
		I.on_stage_end = event()

		function I.run()
			I.on_stage_start.notify()
			I.on_stage_end.notify()
		end

		return I
	end

	local function create_effect_a(stage)
		local function on_stage_start()
			print('effect on stage start')
		end

		local function on_stage_start2()
			print('effect on stage start2')
		end

		local function on_stage_end()
			print('effect on stage end')
		end

		stage.on_stage_start.sub(on_stage_start)
		stage.on_stage_start.sub(on_stage_start2)
		stage.on_stage_end.sub(on_stage_end)
	end

	local stage = create_stage()
	local effect = create_effect_a(stage)

	stage.run()
end

test_all()
