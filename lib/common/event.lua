local function event()
	local I = {}
	local _obs = {}

	function I.sub(fun)
		_obs[fun] = true
	end

	function I.unsub(fun)
		_obs[fun] = nil
	end

	function I.unsub_all()
		_obs = {}
	end

	function I.notify(...)
		for fun, _ in pairs(_obs) do
			fun(...)
		end
	end

	return I
end

return event
