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

function new_graphical_effect(t, m) 
	local ge = {
		type = t,
		mod = m
	}

	return ge
end

--[[function new_graphical_layer()

end]]

function new_graphical_layer(s, img, qd)
	local l = {
		index = #s.layers+1,
		img = img,
		quad = qd,
		effects = {}
	};
	table.insert(s.layers, l);

	return l;
end

function new_layered_sprite(s, imgd, sx, sy, w, h, ax, ay, dx, dy) 
	local n = new_node(s, "layered_sprite");

	n.layers = {}

	if type(imgd) == "string" then
		n.img = love.graphics.newImage(imgd);
	else
		n.img = imgd;
	end


	--[[
		for y = 1, self.ny do
			n.quads[y] = {}
	 		for x = 1, self.nx do
	 			local xx = (x-1)*self.w+self.sx+(x-1)*self.dx
	 			local yy = (y-1)*self.h+self.sy+(y-1)*self.dy
	 			n.quads[y][x] = love.graphics.newQuad(xx, yy, self.w, self.h, self.sheet:getDimensions())
	 		end
	 	end
	]]
	--0, 0, 8, 8, 1, 1, 0, 0
	for y = 1, ay do
	 	for x = 1, ax do
	 		local xx = (x-1)*w+sx+(x-1)*dx
	 		local yy = (y-1)*h+sy+(y-1)*dy
	 		new_graphical_layer(n, n.img, love.graphics.newQuad(xx, yy, w, h, n.img:getDimensions()));
	 		--table.insert(n.frames, love.graphics.newQuad(xx, yy, w, h, n.sheet:getDimensions()))
	 	end
	end

	n.draw = function(self)
		love.graphics.push()
		love.graphics.translate(self.x, self.y);
		for i, v in pairs(n.layers) do
			love.graphics.push();
			for j, k in pairs(v.effects) do
				-- TODO: make this less of a mess
				if k.type == "color" then
					love.graphics.setColor(k.mod);
				elseif k.type == "rotate" then
					love.graphics.rotate(k.mod);
				elseif k.type == "scale" then
					love.graphics.scale(k.mod[1], k.mod[2]);
				elseif k.type == "translate" then
					love.graphics.translate(k.mod[1], k.mod[2]);
				end
			end
			--
			love.graphics.draw(v.img, v.quad);
			love.graphics.setColor(1, 1, 1, 1);
			love.graphics.pop();
		end
		love.graphics.pop()
	end

	return n;
end

--[[

	Effect:
		type: string
		mod: number[]

	Layer:
		img: Image
		mods: Effect[]
		visible: boolean

	Sprite:
		layers: Layer[]

	Animation:
		frames: Sprite[]
		speed: number

	Spritesheet: Node
		index_data: table

	GraphicComponent: Node
		spr_sheet: Spritesheet


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
	spr.visual = "walk_left";

	draw_goc(spr)
	spr:draw(0, 0);

]]

--[[function new_layered_sprite(s, imgdb) 
	local n = new_node(s, "sprite");

	return n;
end]]

function new_sprite_sheet(s, imgd, data)
	local n = new_node(s, "spritesheet")

	n.component = n;

	if type(imgd) == "string" then
		n.sheet = love.graphics.newImage(imgd);
	else
		n.sheet = imgd
	end

	n.quads = {}
	n.index_data = {}
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
		for y = 1, ay do
	 		for x = 1, ax do
	 			local xx = (x-1)*qw+sx+(x-1)*qx
	 			local yy = (y-1)*qh+sy+(y-1)*qy
	 			local q = love.graphics.newQuad(xx, yy, qw, qh, n.sheet:getDimensions());
	 			--table.insert(qs, );
	 			table.insert(qs, q);
	 			--new_graphical_layer(n, n.img, love.graphics.newQuad(xx, yy, w, h, n.img:getDimensions()));
	 			--table.insert(n.frames, love.graphics.newQuad(xx, yy, w, h, n.sheet:getDimensions()))
	 			
	 		end
		end
		for j, k in pairs(v.index) do
			if k.type=="frame" then
				n.index_data[k.name] = k.quad+#n.quads;
			elseif k.type == "animation" then
				for l, q in pairs(v.quads) do
					
				end
			end
		end

		for j, k in pairs(qs) do
			table.insert(n.quads, k);
		end
		--[[table.insert(inds, data.index);

		for i, v in pairs(data) do

		end]]



	end

	n.get_quad = function(self, name)
		return self.quads[self.index_data[name]];
	end

	return n
end

function new_graphic_object_component(s, spr, defs)
	local n = new_node(s, "goc");

	n.img = spr;
	n.state = defs;

	n.component = n;

	n.draw = function(self)
		--if self.img:get_quad()
	end

	return n
end









function new_animation(s, imgd, sx, sy, w, h, ax, ay)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.sheet = love.graphics.newImage(imgd);
	else
		n.sheet = imgd
	end

	n.frames = {
	}

	 for y = 1, ay do
	 	for x = 1, ax do
	 		local xx = (x-1)*w+sx
	 		local yy = (y-1)*h+sy
	 		table.insert(n.frames, love.graphics.newQuad(xx, yy, w, h, n.sheet:getDimensions()))
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
		love.graphics.draw(self.sheet, self.frames[self.ind], self:get_x(), self:get_y());
	end

	return n
end

--[[

]]