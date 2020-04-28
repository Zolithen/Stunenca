--[[function love.errorhandler(e)
	print(e);
end]]

love.graphics.setDefaultFilter( "nearest")

require "eng/tree"

wf = require "eng/physics/windfield"
require "eng/gui/gui_element"
require "eng/gui/button"
require "eng/gui/list/list"
require "eng/gui/list/text_element_list"
require "eng/gui/node_tree_viewer"

require "eng/physics/world"
require "eng/physics/circle_collider"
require "eng/physics/rectangle_collider"
require "eng/physics/line_collider"

require "eng/utility/timer"
require "eng/utility/tween"

require "eng/graphics/sprite"
require "eng/graphics/layered_sprite"
require "eng/graphics/spritesheet"

function create_scene()
	-- Create a master node
	local sscene = new_node(nil, "root");

	local player = new_node(sscene, "player");

	-- Create the physics world
	local world = physics_world(sscene, "world", 0, 0);
	
	-- Create a tween controller
	new_tween_controller(sscene);

	-- Adds a new global spritesheet to the scene
	--new_spritesheet(sscene, "assets/colored_tilemap.png", 0, 0, 8, 8, 10, 10, 1, 1);

	-- Add a physics collider to the player
	new_rectangle_collider(player, world, 0, 0, 16, 16, "dynamic");

	-- Add a sprite to the player
	--new_animation(player, "assets/animation_test.png", 0, 0, 8, 8, 20, 2);

	-- Create a static collider in the world
	local c = new_circle_collider(sscene, world, 400, 400, 20);

	-- Create a tween and sync a collider to it (badly, needs rework maybe and only works with rectangle colliders)
	local sh = {x = 0, y = 0}
	flux.to(sh, 1, { x = 50, y = 50 })

	-- Finds the child node of player called "collider" which has a "component" field and return the field
	local col = player:find_component("collider");

	-- Sync the sh tween to the collider and wait for the col to get to x = 50,y=50
	col.node:sync_flux(sh, 50, 50);

	-- Declare a function for a node
	player.draw = function(self)
		love.graphics.setColor(0, 1, 0, 1);
		--love.graphics.rectangle("fill", self.x, self.y, 16, 16)
		love.graphics.setColor(1, 1, 1, 1);
		--love.graphics.rectangle("fill", sh.x, sh.y, 16, 16);
		--love.graphics.print(player:find_component("sprite").ind, 300, 300);
	end

	player.update = function(self, dt)
		-- Get the collider component
		local col = self:find_component("collider");
		local mov = {x=0,y=0}
		if love.keyboard.isDown("a") then 
			mov.x = -1
		end
		if love.keyboard.isDown("d") then 
			mov.x = 1
		end
		if love.keyboard.isDown("s") then 
			mov.y = 1
		end
		if love.keyboard.isDown("w") then 
			mov.y = -1
		end
		if love.keyboard.isDown("r") then
			--world:delete();	
		end
		if love.keyboard.isDown("o") then
			require "toolset/tests"
		end
		col:setLinearVelocity(mov.x*200, mov.y*200);
	end

	-- GUI things

	-- Creates a normal list
	local li = new_list(sscene, "normal_list", 0.0, 0.2, 0.2, 0.2);

	-- Adds a button to the list
	local ossp = new_button(li, "button_ossp", 0, 0, 0.2, 0.1, function() 
		print("Open spritesheet editor") 
		require "toolset/spritesheet_editor"
	end, "Open spritesheet editor");

	local otme = new_button(li, "button_otme", 0, 0.1, 0.2, 0.1, function() 
		print("Open tilemap editor") 
	end, "Open tilemap editor");

	-- Create a list of text
	local si = new_text_element_list(sscene, "textel_list", 0.0, 0.0, 0.2, 0.2);

	-- Add text to the text list
	for i = 1, 1000 do
		si:add_text("text" .. i);
	end

	-- Adds a list of active nodea
	local ntw = new_node_tree_viewer(sscene, "tree_viewer", 0.2, 0.2, 0.2, 0.2, scene);

	-- Random stuff for visualizing with the tree viewer
	local enemy_holder = new_node(sscene, "enemy__holder");

	for i = 1, 10 do
		local e = new_node(enemy_holder, "enemy");
		e.ind = i;
	end

	return sscene
end

-- Instantiate the scene
scene = create_scene();

function love.draw()
	-- Propagates the "draw" event to the node tree
	scene:propagate_event("draw")
end

function love.update(dt)
	-- Propagates the "update" event to the node tree with argument "dt"
	scene:propagate_event("update", dt)
end

function love.mousepressed(x, y, button)
	scene:propagate_event("mousepressed", x, y, button);
end

function love.wheelmoved(dx, dy)
	scene:propagate_event("wheelmoved", dx, dy);
end