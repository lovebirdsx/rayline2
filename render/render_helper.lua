local M = {xoffset = 0, yoffset = 0, zoom_factor = 1, screen_scale_x = 1, screen_scale_y = 1}

function M.change_aspect(xoffset, yoffset, zoom_factor)
	if M.zoom_factor ~= zoom_factor or M.xoffset ~= xoffset or M.yoffset ~= yoffset then
		M.zoom_factor = zoom_factor
		M.xoffset = xoffset
		M.yoffset = yoffset
		M.screen_scale_x = render.get_window_width() / render.get_width()
		M.screen_scale_y = render.get_window_height() / render.get_height()

		print('zoom_factor', M.zoom_factor)
		print('xoffset', M.xoffset)
		print('yoffset', M.yoffset)
		print('screen_scale_x', M.screen_scale_x)
		print('screen_scale_y', M.screen_scale_y)
	end
end

function M.action_to_pos(action)
	return vmath.vector3(M.xoffset + action.screen_x / M.zoom_factor, M.yoffset + action.screen_y / M.zoom_factor, 0)
end

function M.action_to_dpos(action)
	return vmath.vector3(action.dx * M.screen_scale_x / M.zoom_factor, action.dy * M.screen_scale_y / M.zoom_factor, 0)
end

return M
