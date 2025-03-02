local modpath, S = ...

--Magic Wand

minetest.register_craftitem("brewing:magic_wand", {
    description = S("Magic Wand"),
    wield_image = "magic_wand.png",
    inventory_image = "magic_wand.png",
    groups = {},
    on_use = function (itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local user_pos = user:getpos()
        user_pos.y = user_pos.y + 0.5

        local enemy_pos = minetest.get_pointed_thing_position(pointed_thing, true)

        local vel = vector.multiply(vector.subtract(enemy_pos, user_pos), 1)
        vel.y = vel.y + 0.6

        minetest.add_particlespawner({
            amount = 5,
            time = 1,
            minpos = user_pos,
            maxpos = enemy_pos,
            minvel = {x=1, y=1, z=0},
            maxvel = {x=1, y=1, z=0},
            minacc = {x=1, y=1, z=1},
            maxacc = {x=1, y=1, z=1},
            minexptime = 1,
            maxexptime = 1,
            minsize = 1,
            maxsize = 1,
            collisiondetection = false,
            vertical = false,
            texture = "brewing_magic_particle.png",
            playername = "singleplayer"
        })

		local pos = minetest.get_pointed_thing_position(pointed_thing, true)
        if not minetest.is_protected(pos, user:get_player_name()) then
            farming.place_seed(itemstack, user, pointed_thing, "brewing:seed_magic_rose")
        end

        brewing.magic_sound("to_player", user, "brewing_magic_sound")

        if minetest.get_modpath("mana") ~= nil then
            mana.subtract_up_to(user, brewing.settings.mana_magic_wand)
        end
    end,
})

minetest.register_craft({
	type = "shaped",
	output = "brewing:magic_wand",
	recipe = {
		{"", "brewing:magic_crystal_ball", ""},
		{"", "default:stick", ""},
		{"", "default:stick", ""},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "brewing:magic_crystal_ball",
	recipe = "brewing:magic_wand",
	cooktime = 3,
})

minetest.register_craft({
	type = "shaped",
	output = "brewing:magic_wand",
	recipe = {
		{"", "brewing:magic_crystal_ball", ""},
		{"", "default:stick", ""},
		{"", "default:stick", ""},
	}
})

--Magic Blue Tear Wand

minetest.register_craftitem("brewing:magic_blue_tear_wand", {
	description = S("Magic Blue Tear Wand"),
	wield_image = "brewing_magic_blue_tear_wand.png",
	inventory_image = "brewing_magic_blue_tear_wand.png",
	groups = {},
	on_use = function (itemstack, user, pointed_thing)
		-- Freeze Effect
		if pointed_thing.type == "object" then
			brewing.engine.effects.freeze(pointed_thing, user, "player")
			if minetest.get_modpath("mana") ~= nil then
				mana.subtract_up_to(user, brewing.settings.mana_magic_blue_tear_wand)
			end
		elseif pointed_thing.type == "node" then
			local node_above = minetest.get_node(pointed_thing.above)
			local node_above_name = node_above.name
			local pos_above = minetest.get_pointed_thing_position(pointed_thing, above)
			if  minetest.registered_nodes[node_above_name].groups.water then
				minetest.set_node(pos_above, {name = "default:ice"})
				brewing.magic_sound("pos", pointed_thing.above, "brewing_freeze")
			end
		else
			brewing.magic_sound("to_player", user, "brewing_magic_failure")
		end
	end
})

minetest.register_craft({
	type = "shaped",
	output = "brewing:magic_blue_tear_wand",
	recipe = {
		{"", "brewing:magic_blue_tear_gem", ""},
		{"default:steel_ingot", "", ""},
		{"default:steel_ingot", "", ""},
	}
})
