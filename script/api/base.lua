print("Loaded base");

_G['dofile'] = function(path)
	return runfile(path:gsub('%.lua', ''))
end

function minetest.get_modpath(mod)
	return 'minetest:' .. mod
end

function minetest.get_connected_players()
	local mt_players = {}
	for _, player in pairs(zepha.players) do
		table.insert(mt_players, minetest.__usertype.PlayerRef(player))
	end
	return mt_players
end

function minetest.item_eat()
	-- Todo
end

function minetest.get_node(pos)
	return { name = minetest.__util.identifier.encode(
		zepha.get_default_dimension():get_block(pos)) }
end

function minetest.set_node(pos, node)
	zepha.get_default_dimension():set_block(pos, 
		minetest.__util.identifier.decode(node.name))
end

function minetest.get_translator()
	return function(str) return str end
end
