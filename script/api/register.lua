--
-- Helpers
--

local function format_tile(tile)
	local mod_sep = tile:find('_')
	local mod_name = tile:sub(1, mod_sep - 1)

	return 'minetest:' .. mod_name .. ':' .. tile:gsub('%.png', '')
end

local convert_drawtype = {
	normal = 'base:block',
	plantlike = 'base:cross_large',
	airlike = 'base:none'
}

--
-- Register Globalstep
--

local MT_GLOBALSTEP = 0.1
function minetest.register_globalstep(fn)
	if zepha.server then
		zepha.after(function()
			fn(MT_GLOBALSTEP)
			return true
		end, MT_GLOBALSTEP)
	end
end

--
-- Register Node
--

function minetest.register_node(identifier, mt_def)
	local def = {}
	
	def.yields = mt_def.drop
	mt_def.drop = nil
	
	def.name = mt_def.description
	mt_def.description = nil
	
	def.textures = {}
	for _, tile in ipairs(mt_def.tiles or {}) do
		table.insert(def.textures, format_tile(tile))
	end
	if mt_def.tiles and mt_def.tiles.name then 
		table.insert(def.textures, format_tile(mt_def.tiles.name)) 
	end
	mt_def.tiles = nil

	def.light_propagates = mt_def.sunlight_propogates
	mt_def.sunlight_propogates = nil

	def.model = convert_drawtype[mt_def.drawtype] or 'base:block'
	mt_def.drawtype = nil
	def.culls = def.model == 'base:block' and true or false

	def.solid = mt_def.walkable == nil and true or mt_def.walkable
	mt_def.walkable = nil

	def.selection_box = mt_def.pointable ~= nil and not mt_def.pointable and {} or nil
	mt_def.pointable = false

	if mt_def.light_source then
		local res = math.floor(mt_def.light_source * 1.5)
		def.light_source = { res, res, res }
		mt_def.light_source = nil
	end

	def.tags = mt_def.groups
	mt_def.groups = nil

	for key, val in pairs(mt_def) do
		def[key] = val
	end

	zepha.register_block('!' .. 'minetest:' .. 
		identifier:gsub('!', ''), def)
end

--
-- Register ABM
--

function minetest.register_abm()
	-- Todo
end

--
-- Register Craftitem
--

function minetest.register_craftitem(identifier, mt_def)
	local def = {}

	def.name = mt_def.description
	mt_def.description = nil

	def.textures = {}
	table.insert(def.textures, format_tile(mt_def.inventory_image))
	mt_def.inventory_image = nil

	def.tags = mt_def.groups
	mt_def.groups = nil

	for key, val in pairs(mt_def) do
		def[key] = val
	end

	zepha.register_item('!' .. 'minetest:' .. 
		identifier:gsub('!', ''), def)
end

--
-- Register Craft
--

function minetest.register_craft(mt_def)
	local def = {}

	def.output = 'minetest:' .. mt_def.output
	def.recipe = {}

	for _, mt_val in ipairs(mt_def.recipe) do
		if type(mt_val) == 'table' then
			local tbl = {}
			for _, mt_item in ipairs(mt_val) do
				table.insert(tbl, 'minetest:' .. mt_item)
			end
			table.insert(def.recipe, tbl)
		else
			if #def.recipe == 0 then
				table.insert(def.recipe, {})
				table.insert(def.recipe[1], 'minetest:' .. mt_val)
			end
		end
	end

	crafting.register_recipe(def)
end

--
-- Register Alias
--

function minetest.register_alias(mt_def)
	-- TODO
end
