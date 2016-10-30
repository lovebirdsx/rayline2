require 'lib.common.table'

local class = require 'lib.common.class'
local Type = require 'lib.play.hex.type'
local Props = require 'lib.play.hex.props'
local Factory = require 'lib.play.hex.factory'

local PropsManager = class(function (self)
	self.props_map = {}
	for type = 1, Type.Max do
		local props = Props()
		self.props_map[type] = props
		local hex = Factory.create(type)
		for k, v in pairs(hex:get_properties()) do
			props:set(k, v)
		end
	end

	self.selected_type = Type.Normal
end)

function PropsManager:set_selected_type(type)
	self.selected_type = type
end

function PropsManager:get_selected_type()
	return self.selected_type
end

function PropsManager:get_selected_props()
	return self.props_map[self.selected_type]
end

function PropsManager:get_props(type)
	return self.props_map[type]
end

function PropsManager:gen_snapshot()
	local s = {}
	s.selected_type = self.selected_type

	local props_map = {}
	for type, props in pairs(self.props_map) do
		props_map[type] = props:gen_snapshot()
	end

	s.props_map = props_map

	return s
end

function PropsManager:apply_snapshot(s)
	self.selected_type = s.selected_type
	for type, props_snap in pairs(s.props_map) do
		self.props_map[type]:apply_snapshot(props_snap)
	end
end

function PropsManager:is_equal(other)
	if self.selected_type ~= other.selected_type then
		return false
	end

	if table.size(self.props_map) ~= table.size(other.props_map) then
		return false
	end

	for type, props in pairs(self.props_map) do
		local props2 = other.props_map[type]
		if not props2 or not props:is_equal(props2) then
			return false
		end
	end

	return true
end

function PropsManager:tostring()
	local r = {}
	for type, props in pairs(self.props_map) do
		table.insert(r, ('%s = %s'):format(type, props:tostring()))
	end
	return table.concat(r, '\n')
end

return PropsManager
