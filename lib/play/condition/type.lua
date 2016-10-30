local Type = {
	Score = 1,
	ClearAll = 2,
	LocateScore = 3,
	TimeScore = 4,
	ClearIcing = 5,
	ClearIce = 6,
	ClearDiamond = 7,
	Locate = 8,
}

function Type.tostring(type)
	for k, v in pairs(Type) do
		if v == type then
			return k
		end
	end
end

return Type
