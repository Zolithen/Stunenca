function new_line_collider(s, w, x, y, x2, y2, t)
	local c = new_node(s, "collider");

	c.x = x;
	c.y = y;
	c.x2 = x2;
	c.y2 = y2;

	c.component = w.world:newLineCollider(x, y, x2, y2);
	c.component:setType(t or "static");
	table.insert(w.colliders, c.component)

	c.update = function(self, dt)
		if c.parent then
			c.parent.x = self.component:getX();
			c.parent.y = self.component:getY();
		end
	end

	return c
end