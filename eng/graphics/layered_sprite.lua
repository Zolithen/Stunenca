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