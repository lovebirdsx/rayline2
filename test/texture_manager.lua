local M = {}

local textures = {}

function M.load(path)
	local ref_count = textures[path]
	if ref_count and ref_count > 0 then
		textures[path] = ref_count + 1
		return path
	end

	local data = sys.load_resource(path)
    local img = image.load(data)
    if not img then
        print('can not load image from ' .. path)
        return nil
    end

    if gui.new_texture(path, img.width, img.height, img.type, img.buffer) then
        textures[path] = 1
        return path
    else
       	print('unable to create texture to ' .. path)
    end
end

function M.free(tex)
	ref_count = textures[tex]
	ref_count = ref_count - 1
	if ref_count > 0 then
		textures[tex] = ref_count
	else
		textures[tex] = nil
		gui.delete_texture(tex)
	end
end

return M
