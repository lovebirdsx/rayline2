local M = {}

M.ModiferType = {
	Add = 1,
	Multiple = 2,
	Set = 3
}

function M.create()
	time = time or INFINITE

	local I = {}
	local _modifier_map = {}

	function I.add_modifer(attr_id, amount, type)
		_modifier_map[attr_id] = {type = type or M.ModiferType.Add, amount = amount}
	end

	function I.apply_attr(attr_id, attr)
		local modifer = _modifier_map[attr_id]
		if modifer then
			local type = modifer.type
			if type == M.ModiferType.Add then
				return attr + modifer.amount
			elseif type == M.ModiferType.Multiple then
				return attr * modifer.amount
			elseif type == M.ModiferType.Set then
				return modifer.amount
			else
				assert(false, 'unknown modifer type ' .. tostring(type))
			end
		else
			return attr
		end
	end
end

return M
