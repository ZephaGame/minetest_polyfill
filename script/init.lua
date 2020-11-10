_G['minetest'] = {}

minetest.__usertype = {}

runfile(_PATH .. "usertype/itemstack")
runfile(_PATH .. "usertype/object")
runfile(_PATH .. "usertype/player")

minetest.__util = {}

runfile(_PATH .. "util/identifier")

runfile(_PATH .. "api")
