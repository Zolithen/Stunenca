function love.errorhandler(e)
	print(e);
end

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

function create_scene()
	local sscene = new_node(nil, "root");

	-- Declaring childrens of nodes
	--scene:add(new_node());

	local player = new_node(sscene, "player");
	local world = physics_world(sscene, "world", 0, 0);
	--world:query
	new_tween_controller(sscene);
	new_rectangle_collider(player, world, 0, 0, 16, 16, "dynamic");
	local c = new_circle_collider(sscene, world, 400, 400, 20);

	local sh = {x = 0, y = 0}

	flux.to(sh, 4, { x = 200, y = 300 })
	local col = player:find_component("collider");
	col.node:sync_flux(sh, 200, 300);
	--new_line_collider(sscene, world, 40, 40, 400, 400);
	--local sea = new_node();
	
	--[[sea.draw = function(self)
		love.graphics.setColor(0, 0, 1, 1);
		love.graphics.rectangle("fill", 0, 0, 200, 200)
		love.graphics.setColor(1, 1, 1, 1);
		sscene:propagate_event("p", "aogklshna");
		--return true;
	end]]

	player.draw = function(self)
		love.graphics.setColor(0, 1, 0, 1);
		love.graphics.rectangle("fill", self.x, self.y, 16, 16)
		love.graphics.setColor(1, 1, 1, 1);
		love.graphics.print(sh.x, 200, 300);
		love.graphics.rectangle("fill", sh.x, sh.y, 16, 16);
	end

	player.update = function(self, dt)
		--local col = player:find_name("collider").box;
		local col = self:find_component("collider");
		--col:setMass(100000000000000000);
		local mov = {x=0,y=0}
		if love.keyboard.isDown("a") then 
			--self.x = self.x - 3;
			--setLinearVelocity
			mov.x = -1
			--col:setLinearVelocity(-200, 0);
		end
		if love.keyboard.isDown("d") then 
			--self.x = self.x + 3;
			mov.x = 1
			--col:setLinearVelocity(200, 0);
		end
		if love.keyboard.isDown("s") then 
			--self.y = self.y + 3;
			mov.y = 1
			--col:setLinearVelocity(0, 200);
		end
		if love.keyboard.isDown("w") then 
			--self.y = self.y - 3;
			mov.y = -1
			--col:setLinearVelocity(0, -200);
		end
		if love.keyboard.isDown("r") then
			--world:delete();	
		end
		col:setLinearVelocity(mov.x*200, mov.y*200);
	end

	player.p = function(self, s)
		print(s)
	end

	--local b = new_button(sscene, "button_hola", 0, 0, 0.1, 0.1, function() print("hola") end, "hola");

	local li = new_list(sscene, "normal_list", 0.0, 0.2, 0.2, 0.2);

	local bbb = new_button(li, "button_in", 0, 0, 0.1, 0.1, function() 
		print("holas") 
		li:delete()
	end, "holas");

	--[[local d = new_node(bbb, "thingy");
	d.a = 10
	local f = new_node(bbb, "thingy");
	f.a = 20
	print(bbb:find_name("thingy")[2].a);]]

	local si = new_text_element_list(sscene, "textel_list", 0.0, 0.0, 0.2, 0.2);

	for i = 1, 1000 do
		si:add_text("text" .. i);
	end

	local ntw = new_node_tree_viewer(sscene, "tree_viewer", 0.2, 0.2, 0.2, 0.2, scene);

	local enemy_holder = new_node(sscene, "enemy__holder");

	for i = 1, 1 do
		local e = new_node(enemy_holder, "enemy");
		e.ind = i;
		e.draw = function(self)
			--lg.rectangle("fill", i*4, i*4, 16, 16);
		end
	end

	return sscene
end

scene = create_scene();

--[[sea.ff = true;
player.dd = true;

print(scene:find(function(n) return n.ff end)[1])]]

function love.draw()
	scene:propagate_event("draw")
end

function love.update(dt)
	scene:propagate_event("update", dt)
end

function love.mousepressed(x, y, button)
	scene:propagate_event("mousepressed", x, y, button);
end

function love.wheelmoved(dx, dy)
	scene:propagate_event("wheelmoved", dx, dy);
end

--[[
	Structure of a node:
		- Parent
		- Value
		- Metatable
]]