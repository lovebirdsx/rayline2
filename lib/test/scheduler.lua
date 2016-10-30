io.stdout:setvbuf('no')

local Scheduler = require 'lib.common.scheduler'

local test = {}

function test_case(case_fun)
    local sched = Scheduler()

    local time = 0
    local function clock()
        return time
    end

    sched:set_clock(clock)

    case_fun(sched)

    while true do
        local ok, min_wait = sched:select()
        if ok then
            time = time + min_wait
        else
            print('finish: ' .. min_wait)
            break
        end
    end
end

function test_all()
    for name, case in pairs(test) do
        print('test.' .. name)
        test_case(case)
    end
end

function test.basic(sched)
for i = 1, 5 do
    sched:spawn(function()
        print("outer started", sched:clock())
        sched:spawn(function()
            print("inner started", sched:clock())
            print(sched:wait(i*.5))
            print("inner finished", sched:clock())
        end)
        print("outer finished", sched:clock())
    end)
end
end

function test.condition(sched)
    local foo_ok = false
    local function foo()
        print('foo start', sched:clock())
        sched:wait(1)
        foo_ok = true
        print('foo end', sched:clock())
    end

    local function bar()
        print('bar start', sched:clock())
        sched:wait_condition(function ()
           return foo_ok
        end)
        print('bar end', sched:clock())
    end

    sched:spawn(foo)
    sched:spawn(bar)
end

-- test_case(test.condition)
test_all()
