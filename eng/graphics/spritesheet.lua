--[[
	s -> parent node
	img -> dir to an image or an image directly
	sx -> start x
	sy -> start y
	w -> quad width
	h -> quad height
	nx -> number of quads in the x axis
	ny -> number of quads in the y axis
	dx -> pixels between quads in the x axis
	dy -> pixels between quads in the y axis
	data -> Dictionary data for naming quads
]]

--test class
--[[function new_spritesheet(s, img, sx, sy, w, h, nx, ny, dx, dy, data)
	local n = new_node(s, "spritesheet");

	n.component = n;
	if type(img) == "string" then
		n.sheet = love.graphics.newImage(img);
	else
		n.sheet = img
	end

	n.quads = {}
	n.sx = sx;
	n.sy = sy;
	n.w = w;
	n.h = h;
	n.nx = nx;
	n.ny = ny;
	n.dx = dx;
	n.dy = dy;

	-- TODO
	n.data = data or {}

	n.create_quads = function(self)
		for y = 1, self.ny do
			n.quads[y] = {}
	 		for x = 1, self.nx do
	 			local xx = (x-1)*self.w+self.sx+(x-1)*self.dx
	 			local yy = (y-1)*self.h+self.sy+(y-1)*self.dy
	 			n.quads[y][x] = love.graphics.newQuad(xx, yy, self.w, self.h, self.sheet:getDimensions())
	 		end
	 	end
	end

	n:create_quads();

	n.get_quadxy = function(self, x, y)
		return self.quads[y][x]
	end

	n.get_quad = function(self, name)
		local p = self.data[name];
		if p.type == nil or p.type == "sprite" then
			return self.quads[p.x][p.y];
		else
			
		end

	end

	n.draw = function(self)
		for i = 1, #self.quads do
			for j = 1, #self.quads[i] do
				local q = self.quads[i][j];
				local x, y, w, h = q:getViewport();
				love.graphics.draw(self.sheet, 
					q, 
					x+300,
					y+300
				)
			end
		end
	end

	n.change = function(self, d)
		if type(d) == "string" then
			n.sheet = love.graphics.newImage(d);
		else
			n.sheet = d
		end
		self:create_quads();
	end

	return n
end]]