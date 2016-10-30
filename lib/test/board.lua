local File = require 'lib.common.file'
local Board = require 'lib.play.board'
local HexType = require 'lib.play.hex.type'
local HexFactory = require 'lib.play.hex.factory'
local Block = require 'lib.play.block.block'
local Serializer = require 'lib.common.serializer'

require 'lib.common.table'

local test = {}

function test_all()
	local test_names = table.get_keys(test)
	table.sort(test_names)
	for i, name in ipairs(test_names) do
		local fun = test[name]
		print('test: ' .. name)
		fun()
	end
end

function test.board_locate()
	local board = Board()
	local block = Block({id = 10})
	board:locate(block, 0, 0)
	board:undo_locate(block, 0, 0)
	assert(board:is_empty())
end

function test.board_lineup()
	local board = Board()
	local block1 = Block({id = 1})
	local block2 = Block({id = 2})

	board:locate(block2, -6, 0)
	board:locate(block2, 2, 0)
	local ok, result = board:lineup()
	assert(not ok)

	board:locate(block1, 8, 0)
	local board2 = board:copy()

	local ok, result = board:lineup()
	assert(ok)
	assert(result:get_size() == 2)

	board:undo_lineup(result)
	assert(board:is_equal(board2))
end

function test.file()
	local file1 = 'hello1.txt'
	local file2 = 'hello2.txt'
	local content = 'hello world'
	File.write(file1, content)
	assert(File.read(file1) == content)

	File.copy(file1, file2)
	assert(File.read(file2) == content)

	File.cut(file2, file1)
	assert(not File.exist(file2))

	File.remove(file1)
	assert(not File.exist(file1))
end

function test.serializer()
	local t = {a = 'foo', b = 'bar'}

	local s = Serializer.format(t)
	local t1 = Serializer.parse(s)

	assert(t1.a == t.a)
	assert(t1.b == t.b)
end

function test.board_serialize()
	local board = Board()
	local block1 = Block({id = 1})
	board:locate(block1, -6, 0)

	local s = board:gen_snapshot()
	local board2 = Board()
	board2:apply_snapshot(s)
	assert(board:is_equal(board2))
end

function test.board_save()
	local board = Board()
	local block1 = Block({id = 1})
	board:locate(block1, -6, 0)
	local path = 'board.save'
	board:save(path)

	local board2 = Board()
	board2:load(path)

	assert(board:is_equal(board2))

	File.remove(path)
end

function test.ice_line_up()
	local board = Board()
	board:set_kb_hex(HexFactory.create(HexType.Ice), 0, 0)
	local ok, result = board:lineup()
	assert(not ok)

	board:set_kb_hex(HexFactory.create(HexType.Normal), 0, 2)
	local ok, result = board:lineup()
	assert(ok)
	assert(board:is_empty())
end

function test.bomb_line_up()
	local board = Board()
	board:set_kb_hex(HexFactory.create(HexType.Normal), 0, 0)
	board:set_hex(HexFactory.create(HexType.Bomb), 0, 0)
	local slots = board:get_nearby_slots(0, 0)
	for _, s in ipairs(slots) do
		if s.y ~= 0 then
			board:set_hex(HexFactory.create(HexType.Ice), s.x, s.y)
		end
	end

	local ok, result = board:lineup()
	assert(ok)
	assert(board:is_empty())
end

function test.arrow_lineup()
	local board = Board()
	local normal_hex = HexFactory.create(HexType.Normal)
	local arrow_hex = HexFactory.create(HexType.Arrow, {k = 0})

	board:set_kb_hex(normal_hex, 2, 0)

	-- middle row
	board:set_hex(arrow_hex, 0, 0)
	-- normal_hex:set_tied_up(true)
	board:set_hex(normal_hex, 2, 0)

	local ok, result = board:lineup()
	assert(ok)
	assert(board:is_empty())
end

function test.diamond_lock0_lineup()
	local board = Board()

	board:set_kb_hex(HexFactory.create(HexType.Normal), 2, 0)
	board:set_hex(HexFactory.create(HexType.Diamond, {lock_count = 0}), 0, 0)

	local ok, result = board:lineup()
	assert(board:is_empty())
end

function test.diamond_lock2_lineup()
	local board = Board()

	board:set_hex(HexFactory.create(HexType.Diamond, {lock_count = 2}), 0, 0)
	for i = 1, 3 do
		local slots = board:get_kb_slots(2, 0)
		for _, s in ipairs(slots) do
			if s.x ~= 0 and s.y ~= 0 then
				board:set_hex(HexFactory.create(HexType.Normal), s.x, s.y)
			end
		end
		board:lineup()
	end

	assert(board:is_empty())
end

function test.result_to_string()
	local board = Board()
	board:set_kb_hex(HexFactory.create(HexType.Normal), 0, 0)
	board:set_hex(HexFactory.create(HexType.Bomb), 0, 0)
	local slots = board:get_nearby_slots(0, 0)
	for _, s in ipairs(slots) do
		if s.y ~= 0 then
			board:set_hex(HexFactory.create(HexType.Ice), s.x, s.y)
		end
	end

	local ok, result = board:lineup()
	-- print(result:tostring())
end

function test.board_size()
	local board = Board(4)
	local normal_hex = HexFactory.create(HexType.Normal)
	board:set_kb_hex(normal_hex, 2, 0)

	assert(not board:is_empty())

	local ok, result = board:lineup()
	assert(ok)
	assert(board:is_empty())
end

function test.apply_snapshot_with_different_size()
	local board1 = Board(4)
	local board2 = Board(5)

	assert(not board1:is_equal(board2))

	board1:set_kb_hex(HexFactory.create(HexType.Normal), 2, 0)
	local s = board1:gen_snapshot()
	board2:apply_snapshot(s)
	assert(board1:is_equal(board2))
end

function test.resize()
	local board1 = Board(4)
	local board2 = Board(5)
	board1:set_kb_hex(HexFactory.create(HexType.Normal), 2, 0)
	board2:set_kb_hex(HexFactory.create(HexType.Normal), 2, 0)
	board2:resize(4)
	assert(board1:is_equal(board2))
end

test_all()
