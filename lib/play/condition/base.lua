local class = require 'lib.common.class'

local Base = class(function (self, params)

end)

function Base:bind(stage)
	assert(false, 'bind not implement')
end

function Base:get_status_string()
	assert(false, 'get_status_string not implement')
end

function Base:is_ok()
	assert(false, 'is_ok not implement')
end

function Base:gen_snapshot()
	assert(false, 'gen_snapshot not implement')
end

function Base:apply_snapshot()
	assert(false, 'apply_snapshot not implement')
end

function Base:get_type()
	assert(false, 'get_type not implement')
end

function Base:get_type_string()
	assert(false, 'get_type_string not implement')
end

function Base:get_filed_names()
	assert(false, 'get_filed_names not implement')
end

function Base:is_equal(other)
	assert(false, 'is_equal not implement')
end

function Base:tostring()
	assert(false, 'tostring not implement')
end

return Base
