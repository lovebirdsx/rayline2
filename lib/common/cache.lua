local class = require 'lib.common.class'
local File = require 'lib.common.file'
local FileClient = require 'lib.net.file.client'
local Serializer = require 'lib.common.serializer'
local Config = require 'lib.config.base'

local VERSION_MAP_FILE = 'stages/version.list'

local Cache = class(function (self, path)
	self.path = path

	self:_read_lc_version_map()
end)

function Cache:sync(ip, port)
	local fc = FileClient(ip or Config.FSIP, port or Config.FSPort)

	local ok, err = self:_read_sv_version_map(fc)
	if not ok then
		File.write_table(self:_format_path(VERSION_MAP_FILE), self.lc_version_map)
		return false, err
	end

	local need_up_vm = false

	local function read_from_sv(file, sv_v)
		local ok, content = fc:read(file)
		if ok then
			local path = self:_format_path(file)
			File.write(path, content)
			self.lc_version_map[file] = sv_v
			print(string.format('read sv: %s ok', file))
		else
			print(string.format('read sv: %s failed', file))
		end
	end

	local function write_to_sv(file)
		local path = self:_format_path(file)
		local content = File.read(path)
		if content then
			local ok = fc:save(file, content)
			if ok then
				need_up_vm = true
				print(string.format('write sv: %s ok', file))
			else
				print(string.format('write sv: %s failed', file))
			end
		else
			print(string.format('read lc: %s failed', path))
		end
	end

	for file, sv_v in pairs(self.sv_version_map) do
		local lc_v = self.lc_version_map[file]
		if not lc_v or lc_v < sv_v then
			read_from_sv(file, sv_v)
		elseif lc_v and lc_v > sv_v then
			write_to_sv(file)
		end
	end

	for file, lc_v in pairs(self.lc_version_map) do
		if not self.sv_version_map[file] then
			write_to_sv(file)
		end
	end

	if need_up_vm then
		local ok = fc:write_table(VERSION_MAP_FILE, self.lc_version_map)
		if ok then
			print(string.format('write sv : %s ok', VERSION_MAP_FILE))
		else
			print(string.format('write sv : %s failed', VERSION_MAP_FILE))
		end
	end

	File.write_table(self:_format_path(VERSION_MAP_FILE), self.lc_version_map)

	return true
end

function Cache:_read_lc_version_map()
	local path = self:_format_path(VERSION_MAP_FILE)
	self.lc_version_map = File.read_table(path)
end

function Cache:_read_sv_version_map(file_cl)
	local ok, t = file_cl:read_table(VERSION_MAP_FILE)
	if not ok then
		print(string.format('read sv: %s failed: %s', VERSION_MAP_FILE, t))
		self.sv_version_map = {}
		return false, t
	else
		self.sv_version_map = t
		return true
	end
end

function Cache:_format_path(path)
	local path = string.match(path, '^[/\\]*(.+)')
	return self.path .. '/' .. string.gsub(path, '[\\/]', '-')
end

function Cache:get(path)
	local cache_path = self:_format_path(path)
	local str = File.read(cache_path)
	return str
end

function Cache:set(path, content)
	local cache_path = self:_format_path(path)
	if File.write(cache_path, content) then
		if self.lc_version_map[path] then
			self.lc_version_map[path] = self.lc_version_map[path] + 1
		else
			self.lc_version_map[path] = 1
		end
		File.write_table(self:_format_path(VERSION_MAP_FILE), self.lc_version_map)
		return true
	end

	return false
end

function Cache:get_table(path)
	local s = self:get(path)
	if s then
		local r = Serializer.parse(s)
		if not r then
			print(string.format('parse content from %s failed', path))
		end
		return r
	end
end

function Cache:set_table(path, t)
	local s = Serializer.format(t)
	return self:set(path, s)
end

function Cache:debug()
	print('local version map:')
	for file, version in pairs(self.lc_version_map) do
		print(string.format('\t%s: %g', file, version))
	end
	print('remote version map:')
	for file, version in pairs(self.sv_version_map) do
		print(string.format('\t%s: %g', file, version))
	end
end

return Cache
