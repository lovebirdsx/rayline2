local class = require 'lib.common.class'
local Block = require 'lib.play.block.block'
local Policy = require 'lib.play.gen.policy'
local PolicyType = require 'lib.play.gen.type'

local Inserter = class(function (self, params)
	params = params or {}

	local policy_type = params.policy_type or PolicyType.Normal
	local block_count = params.block_count or 3

	self.policy = Policy(policy_type)

	self.blocks = {}
	for i = 1, block_count do
		table.insert(self.blocks, self:_random_block())
	end

	self.need_refill = params.need_refill or true
end)

function Inserter:_random_block()
	local block_id = self.policy:gen_id()
	return Block({id = block_id})
end

function Inserter:set_policy_type(type)
	local origin_type = self.policy:get_type()
	if origin_type ~= type then
		self.policy:set_type(type)

		for i = 1, self:get_block_count() do
			self:refill(i)
		end
	end
end

function Inserter:get_policy_type()
	return self.policy:get_type()
end

function Inserter:get_policy()
	return self.policy
end

function Inserter:get_block(id)
	return self.blocks[id]
end

function Inserter:get_need_refill()
	return self.need_refill
end

function Inserter:set_need_refill(bool)
	self.need_refill = bool
end

function Inserter:remove(id)
	local block = table.remove(self.blocks, id)
	return block
end

-- return nealy create block
function Inserter:refill(id)
	assert(self:get_need_refill())
	local new_b = self:_random_block()
	self.blocks[id] = new_b
	return new_b
end

function Inserter:add(block)
	block = block or self:_random_block()
	table.insert(self.blocks, block)
end

function Inserter:set(id, block)
	assert(1 <= id and id <= self:get_block_count())
	self.blocks[id] = block
end

function Inserter:get_block_count()
	return #self.blocks
end

function Inserter:gen_snapshot()
	local snapshot = {
		need_refill = self.need_refill,
		policy = self.policy:gen_snapshot(),
		blocks = {}
	}

	for _, b in ipairs(self.blocks) do
		table.insert(snapshot.blocks, b:gen_snapshot())
	end
	return snapshot
end

function Inserter:apply_snapshot(s)
	local blocks = {}
	for _, bs in ipairs(s.blocks) do
		local block = Block()
		block:apply_snapshot(bs)
		table.insert(blocks, block)
	end
	self.blocks = blocks
	self.need_refill = s.need_refill
	if s.policy then self.policy:apply_snapshot(s.policy) end
end

function Inserter:is_equal(other)
	if self:get_block_count() ~= other:get_block_count() then return false end
	if self:get_need_refill() ~= other:get_need_refill() then return false end
	if not self.policy:is_equal(other.policy) then return false end

	for i, b in ipairs(self.blocks) do
		local b2 = other.blocks[i]
		if not b:is_equal(b2) then return false end
	end

	return true
end

function Inserter:tostring()
	return ('Block: %d  Refill: %s  Policy: %s'):format(self:get_block_count(), tostring(self:get_need_refill()), self.policy:tostring())
end

return Inserter
