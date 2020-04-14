function new_circle_collider(s, w, x, y, r, t)
	local c = new_node(s, "collider");

	c.x = x;
	c.y = y;
	c.r = r;
	if c.parent.name == "root" then
		c.update_position = false;
	else
		c.update_position = true;
	end

	c.component = w.world:newCircleCollider(x, y, r);
	c.component:setType(t or "static");
	table.insert(w.colliders, c.component)

	c.update = function(self, dt)
		if not c.update_position then return end;
		if c.parent then
			c.parent.x = self.component:getX();
			c.parent.y = self.component:getY();
		end
	end

	return c
end