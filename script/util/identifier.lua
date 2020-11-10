minetest.__util.identifier = {}

function minetest.__util.identifier.encode(identifier)
	return identifier:sub(identifier:find(':') + 1, #identifier)
end

function minetest.__util.identifier.decode(identifier)
	return 'minetest:' .. identifier
end
