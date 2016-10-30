local class = require 'lib.common.class'

local Scheduler = class(function (self)
    self.threads = {}
    self.t = 0
    self.clock = os.clock
end)

function Scheduler:set_clock(clock)
    self.clock = clock
end

-- selects a coroutine from the list and runs it
function Scheduler:select()
    local time = self.clock()
    local shortest_wait_time = nil
    for thread_i = 1, #self.threads do
        local thread = self.threads[thread_i]
        local state, ret = thread.state
        if state == 'wait' then
            if time >= thread.resume_time then
                thread.resume_time = nil
                thread.state = 'running'
                table.remove(self.threads, thread_i)
                ret = {coroutine.resume(thread.co, time-thread.suspend_time, unpack(thread.arg))}
                thread.suspend_time = nil
                thread.arg = nil
            else
                local wait_time = thread.resume_time - time
                if not shortest_wait_time or wait_time < shortest_wait_time then
                    shortest_wait_time = wait_time
                end
            end
        elseif state == 'suspend' then
            thread.state = 'running'
            table.remove(self.threads, thread_i)
            ret = {coroutine.resume(thread.co, unpack(thread.arg))}
            thread.arg = nil
        elseif state == 'new' then
            thread.state = 'running'
            table.remove(self.threads, thread_i)
            ret = {coroutine.resume(thread.co, unpack(thread.arg))}
            thread.arg = nil
        end

        if ret then
            local ok = table.remove(ret, 1)
            local action = table.remove(ret, 1)
            if ok then
                local status = coroutine.status(thread.co)
                if status == 'dead' then
                    thread.state = 'dead'
                else
                    if action == 'suspend' then
                        thread.arg = ret
                        thread.state = 'suspend'
                        table.insert(self.threads, thread)
                    elseif action == 'wait' then
                        local wait_val = table.remove(ret, 1)
                        local wait_time = tonumber(wait_val)
                        if not wait_time then
                            return false, 'thread returned non-numeric wait time ('..tostring(wait_val)..')'
                        end
                        thread.arg = ret
                        thread.suspend_time = time
                        thread.resume_time = time+wait_time
                        thread.state = 'wait'
                        table.insert(self.threads, 1, thread)
                    end
                end
            else
                return false, action
            end
            return true, 0
        end
    end

    if shortest_wait_time then
        return true, shortest_wait_time
    end

    return false, 'no threads to select'
end

-- creates a new thread and adds it to the list (but does not run it straight away)
function Scheduler:spawn(func, ...)
    table.insert(self.threads, {
        state = 'new',
        co = coroutine.create(func),
        arg = {...},
    })
end

-- creates a new thread and adds it to the top of the list, and suspends the current thread
function Scheduler:run(func, ...)
    table.insert(self.threads, 1, {
        state = 'new',
        co = coroutine.create(func),
        arg = {...},
    })
    coroutine.yield('suspend')
end

-- suspsends the current thread and adds it to the bottom of the list
-- returns the arguments passed
function Scheduler:suspend(...)
    return coroutine.yield('suspend', ...)
end

-- suspends the current thread and gives it a wait condition
-- returns the actual time waited and the arguments passed
function Scheduler:wait(time, ...)
    return coroutine.yield('wait', time, ...)
end

function Scheduler:wait_condition(c, ...)
    while not c(...) do
        self:wait(0.01)
    end
end

function Scheduler:clock()
    return self.clock()
end

return Scheduler
