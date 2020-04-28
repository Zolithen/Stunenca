function new_sprite(s, imgd)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.sprite = love.graphics.newImage(imgd);
	else
		n.sprite = imgd
	end
	n.component = n;
	n.visible = true;

	n.draw = function(self)
		if not self.visible then return end
		love.graphics.draw(self.sprite, self:get_x(), self:get_y());
	end

	return n
end

--[[
	-- Creates a new spritesheet from the image "gfx/player_sheet.png",
	-- with the given indexing data "player_sheet_data".
	{
		{
			--type="auto" --type of indexing
			x=0, --starting x
			y=0, --starting y
			qx=0, --space between quads horizontally
			qy=0, --space between quads vertically
			qw=16, --width of every quad
			qh=16, --height of every quad
			ax=4, --amount of quads horizontally
			ay=4, --amount of quads vertically
			index={ --way to "call" created quads
				{ 
					type="animation",
					name="idle",
					quads={1,2}	
				},
				{
					type="frame",
					name="test",
					quad=3
				}
			}
		}
	}

	-- Then, creates a graphic component for the player bound to the created
	-- sprite sheet "pspr", giving the player the animation or sprite "idle".

	--- After that, give the player the animation or sprite "walk_left".
	pspr = new_sprite_sheet(player, "gfx/player_sheet.png", player_sheet_data);
	local spr = new_graphic_object_component(player, pspr, "idle");
	--spr.visual = "walk_left";
	spr:set_visual("walk_left");

	draw_goc(spr)
	spr:draw(0, 0);


	-- Second approach
	pspr = new_sprite_sheet(player, "gfx/player_sheet.png", player_sheet_data);
	local spr = new_graphic_object_component(player, pspr, {
		"pidle",
		"pwalk_left",
		"pwalk_right",
		"pwalk_up",
		"pwalk_down"
	}, "pidle");
	spr.visual = "pwalk_left"
	

]]

--[[function new_layered_sprite(s, imgdb) 
	local n = new_node(s, "sprite");

	return n;
end]]


-- Standalone animation
local anim_t = {}

function anim_t:update(dt)
	if self.state == "playing" then
		local l = math.floor(self.timer / (self.speed*#self.frames));
		if l>=1 then self.timer = 0 end
		self.timer = self.timer + dt;
		self.ind = math.floor(self.timer/self.speed)+1;
	end
end

function anim_t:draw()
	if self.ind > #self.frames then self.ind = 1 end
	love.graphics.draw(self.sprs, self.frames[self.ind], 0,0);
end

function new_anim(img)
	local a = {
		sprs = img,
		frames = {},
		state = "playing",
		speed = 1,
		timer = 0,
		ind = 1
	}

	setmetatable(a, {__index=anim_t});

	return a;
end

local img_t = {}

function img_t:draw()
	love.graphics.draw(self.sprs, self.quad, 0, 0);
end

function new_frame(img)
	local a = {
		sprs = img,
		quad = nil
	}

	setmetatable(a, {__index=img_t});

	return a;
end

-- TODO: Optimization
function new_spritesheet(s, imgd, data)
	local n = new_node(s, "spritesheet")

	n.component = n;

	if type(imgd) == "string" then
		n.img = love.graphics.newImage(imgd);
	else
		n.img = imgd
	end

	n.quads = {}
	n.frame_data = {}
	n.anim_data = {}
	local inds = {}

	-- typeless
	for i, v in pairs(data) do
		local sx = v.x; --start x
		local sy = v.y; --start y
		local qx = v.qx; --space between quads horizontally
		local qy = v.qy; --space between quads vertically
		local qw = v.qw; --quad width
		local qh = v.qh; --quad height
		local ax = v.ax; --amount of quads horizontally
		local ay = v.ay; --amount of quads vertically
		local qs = {}; --list of quads created from this data cluster
		-- Create all the quads
		for y = 1, ay do
	 		for x = 1, ax do
	 			local xx = (x-1)*qw+sx+(x-1)*qx
	 			local yy = (y-1)*qh+sy+(y-1)*qy
	 			local q = love.graphics.newQuad(xx, yy, qw, qh, n.img:getDimensions());
	 			table.insert(qs, q);
	 		end
		end

		-- Prepare indexing data for quads
		for j, k in pairs(v.index) do
			if k.type=="frame" then
				n.frame_data[k.name] = k.quad+#n.quads;
			elseif k.type == "animation" then
				n.anim_data[k.name] = {quads={},speed=k.speed}
				for l, q in pairs(k.quads) do
					table.insert(n.anim_data[k.name].quads, q+#n.quads);
				end
			end
		end

		-- Add the quads to the quad list
		for j, k in pairs(qs) do
			table.insert(n.quads, k);
		end

	end

	n.get = function(self, name)
		if self.frame_data[name] then
			--return 
			--local f = self.frame_data[name];
			local fr = new_frame(self.img);
			fr.quad = self.quads[self.frame_data[name]];
			return fr
		else
			local a = self.anim_data[name];
			local an = new_anim(self.img);
			an.speed = a.speed;
			for i, v in pairs(a.quads) do
				an.frames[i]=self.quads[v];
			end
			return an;
		end
	end

	return n
end

function new_graphic_object_component(s, spr, alloc, defs)
	local n = new_node(s, "goc");

	n.spr = spr;
	n.state = defs;

	n.allocated_visuals = {}
	for i, v in ipairs(alloc) do
		n.allocated_visuals[v] = spr:get(v);
	end

	n.update = function(self, dt)
		if self.allocated_visuals[self.state].update then
			self.allocated_visuals[self.state]:update(dt);
		end
	end

	n.draw = function(self)
		self.allocated_visuals[self.state]:draw();
	end

	n.realloc = function(self, al)
		self.allocated_visuals = {}
		for i, v in ipairs(alloc) do
			n.allocated_visuals[v] = spr:get(v);
		end
	end

	n.component = n;

	return n
end







-- Animation node

function new_animation(s, imgd, sx, sy, w, h, ax, ay)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.img = love.graphics.newImage(imgd);
	else
		n.img = imgd
	end

	n.frames = {
	}

	if sx ~= nil then
	for y = 1, ay do
	 	for x = 1, ax do
	 		local xx = (x-1)*w+sx
	 		local yy = (y-1)*h+sy
	 		table.insert(n.frames, love.graphics.newQuad(xx, yy, w, h, n.img:getDimensions()))
	 	end
	end
	end

	n.component = n;
	n.state = "playing";
	n.speed = 0.1;
	n.timer = 0;
	n.ind = 1;
	n.visible = true;

	n.update = function(self, dt)
		if self.state == "playing" and self.visible then
			local l = math.floor(self.timer / (self.speed*#self.frames));
			if l>=1 then self.timer = 0 end
			n.timer = n.timer + dt;
			self.ind = math.floor(self.timer/self.speed)+1;
		end
	end

	n.draw = function(self)
		if not self.visible then return end
		if self.ind > #self.frames then self.ind = 1 end
		love.graphics.draw(self.img, self.frames[self.ind], self:get_x(), self:get_y());
	end

	return n
end

--[[

]]