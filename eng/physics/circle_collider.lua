function new_circle_collider(s, w, x, y, r)
	local c = new_node(s, "collider");

	c.x = x;
	c.y = y;
	c.r = r;

	c.box = w.world:newCircleCollider(x, y, r);
	table.insert(w.colliders, c.box)

	c.update = function(self, dt)
		if c.parent then
			c.parent.x = self.box:getX();
			c.parent.y = self.box:getY();
		end
	end

	return c
end