io.stdout:setvbuf('no')

local TcpServer = require 'lib.net.tcpsv'
local class = require 'lib.common.class'

local EchoServer = class(function (self, port)
	self.server = TcpServer(port)
end)

function EchoServer:callback(req)
	return req
end

function EchoServer:start()
	self.server:set_callback(self.callback, self)
	self.server:start()
end

local server = EchoServer(10000)
server:start()
