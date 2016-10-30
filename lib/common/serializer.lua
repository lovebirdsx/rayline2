local class = require 'lib.common.class'

local Serializer = class()

function Serializer.parse(s)
	local t = type(s)
	if t == 'nil' or s == '' then
	    return nil
	elseif t == 'number' or t == 'string' or t == 'boolean' then
	    s = tostring(s)
	else
	    error('can not unserialize a ' .. t .. ' type.')
	end

	s = 'return ' .. s
	local func = loadstring(s)
	if func == nil then
	    return nil
	end
	return func()
end

function Serializer.format(obj)
	local lua = ''
	local t = type(obj)
	if t == 'number' then
	    lua = lua .. obj
	elseif t == 'boolean' then
	    lua = lua .. tostring(obj)
	elseif t == 'string' then
	    lua = lua .. string.format('%q', obj)
	elseif t == 'table' then
	    lua = lua .. '{'
	for k, v in pairs(obj) do
	    lua = lua .. '[' .. Serializer.format(k) .. ']=' .. Serializer.format(v) .. ','
	end
	local metatable = getmetatable(obj)
	    if metatable ~= nil and type(metatable.__index) == 'table' then
	    for k, v in pairs(metatable.__index) do
	        lua = lua .. '[' .. Serializer.format(k) .. ']=' .. Serializer.format(v) .. ','
	    end
	end
	    lua = lua .. '}'
	elseif t == 'nil' then
	    return nil
	else
	    error('can not serialize a ' .. t .. ' type.')
	end
	return lua
end

return Serializer