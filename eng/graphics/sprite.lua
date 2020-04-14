function new_sprite(s, imgd)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.sprite = love.graphics.newImage(imgd);
	else
		n.sprite = imgd
	end
	n.component = n;

	n.draw = function(self)
		love.graphics.draw(self.sprite, self:get_x(), self:get_y());
	end

	return n
end