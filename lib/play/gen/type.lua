local Type = {
	Simple = 1,
	Normal = 2,
	Hard = 3,
	SimpleHard = 4,
	NormalHard = 5,
	SimpleNormal = 6,
	Normal2 = 7,	
}

function Type.tostring(type)
	for t, v in pairs(Type) do
		if type == v then
			return t
		end
	end
end

return Type
