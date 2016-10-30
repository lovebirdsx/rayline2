local class = require 'lib.common.class'

local Base = class(function (self, params)
end)

function Base:get_type()
	assert(false, 'get_type not implement')
end

function Base:get_board()
	assert(false, 'get_board not implement')
end

function Base:get_inserter()
	assert(false, 'get_inserter not implement')
end

function Base:get_condition_manager()
	assert(false, 'get_condition_manager not implement')
end

function Base:is_gameover()
	assert(false, 'is_gameover not implement')
end

function Base:apply_snapshot(s)
	assert(false, 'apply_snapshot not implement')
end

function Base:gen_snapshot()
	assert(false, 'gen_snapshot not implement')
end

function Base:is_equal(other)
	assert(false, 'is_equal not implement')
end

return Base
