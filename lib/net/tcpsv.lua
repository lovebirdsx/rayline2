require 'lib.common.table'

local class = require 'lib.common.class'
local Serializer = require 'lib.common.serializer'
local import = require

local TcpServer = class(function (self, port)
	self.port = port
	self.timeout = 3
	self.socket = socket or import 'socket'
end)

-- function callback(self, table)
-- 	   return table
-- end
function TcpServer:set_callback(cb, data)
	self.callback = cb
	self.data = data
end

function TcpServer:set_timeout(timeout)
	self.timeout = timeout
end

function TcpServer:start()
	local server = assert(self.socket.bind('*', self.port))
	local ip, port = server:getsockname()
	print(string.format('tcp server start at %s:%g', ip, port))

	-- server:setoption('linger', {on=true, timeout=3})
	while true do
		local client = server:accept()
		client:settimeout(self.timeout)
		local req_s, err = client:receive()
		if not err then
			local req = Serializer.parse(req_s)
			if not req then
				print(string.format('parse req_s[%s] failed, from %s:%g', req_s, client:getsockname()))
			else
				local resp = self.callback(self.data, req)
				if resp then
					local resp_s = Serializer.format(resp)
					client:send(resp_s:gsub('\n', ' ') .. '\n')
				else
					print(string.format('failed req[%s] from %s:%g', table.tostring(req), client:getsockname()))
				end
			end
		else
			print(string.format('error: %s when receive from %s:%g', err, client:getsockname()))
		end

		client:close()
	end
end

return TcpServer
