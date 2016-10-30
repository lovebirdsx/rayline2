local class = require 'lib.common.class'

local Step = class(function (self, board, result)
	self._board = board
	self._result = result
	self._actions = {}
	self._events = {}
end)

function Step:add_event(type, slots, params)
	assert(slots)
	table.insert(self._events, {type = type, slots = slots, params = params})
end

function Step:get_events()
	return self._events
end

function Step:get_actions()
	return self._actions
end

function Step:add_hex(h, x, y)
	table.insert(self._actions, {op = 'add', hex = h, x = x, y = y})
end

function Step:del_hex(h, x, y)
	table.insert(self._actions, {op = 'del', hex = h, x = x, y = y})
end

function Step:mod_hex(from, to, x, y)
	table.insert(self._actions, {op = 'mod', from = from, to = to, x = x, y = y})
end

function Step:do_action(a)
	local op = a.op
	if op == 'add' then
		self._board:set_hex(a.hex, a.x, a.y)
	elseif op == 'del' then
		self._board:del_hex(a.x, a.y)
	elseif op == 'mod' then
		self._board:set_hex(a.to, a.x, a.y)
	end
end

function Step:undo_action(a)
	local op = a.op
	if op == 'add' then
		self._board:del_hex(a.x, a.y)
	elseif op == 'del' then
		self._board:set_hex(a.hex, a.x, a.y)
	elseif op == 'mod' then
		self._board:set_hex(a.from, a.x, a.y)
	end
end

function Step:apply_event(e)
	local board = self._board
	local result = self._result
	for _, s in ipairs(e.slots) do
		s.hex:on_event(e.type, s.x, s.y, board, result, e.params)
	end
end

function Step:commit()
	for _, e in ipairs(self._events) do
		self:apply_event(e)
	end

	for _, a in ipairs(self._actions) do
		self:do_action(a)
	end
end

function Step:revert()
	for i = #self._actions, 1, -1 do
		self:undo_action(self._actions[i])
	end
end

function Step:tostring(tab)
	tab = tab or ''
	local ev_strs = {}
	for i, ev in ipairs(self._events) do
		table.insert(ev_strs, string.format('%s\t%s #slots = %g', tab, ev.type, #ev.slots))
	end

	local ac_strs = {}
	for i, a in ipairs(self._actions) do
		if a.op == 'add' then
			table.insert(ac_strs, string.format('%s\tadd %s (%d, %d)', tab, a.hex:tostring(), a.x, a.y))
		elseif a.op == 'del' then
			table.insert(ac_strs, string.format('%s\tdel (%d, %d)', tab, a.x, a.y))
		elseif a.op == 'mod' then
			table.insert(ac_strs, string.format('%s\tmod %s->%s (%d, %d)', tab, a.from:tostring(), a.to:tostring(), a.x, a.y))
		end
	end

	return string.format('%sevents:\n%s\n%sactions:\n%s', tab, table.concat(ev_strs, '\n'), tab, table.concat(ac_strs, '\n'))
end

return Step
