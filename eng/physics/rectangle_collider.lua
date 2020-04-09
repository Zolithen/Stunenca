function new_rectangle_collider(s, w, x, y, ww, h, t)
	local c = new_node(s, "collider");

	c.x = x;
	c.y = y;
	c.w = ww;
	c.h = h;

	c.component = w.world:newRectangleCollider(x, y, ww, h);
	c.component:setType(t or "static");
	c.component.node = c;
	c.component.w = ww;
	c.component.h = h;
	c.synced = false
	table.insert(w.colliders, c.component)

	c.update = function(self, dt)
		if c.parent then
			c.parent.x = self.component:getX()-self.w/2;
			c.parent.y = self.component:getY()-self.h/2;
		end
		if c.synced then
			if c.sync.x ~= c.tox and c.sync.y ~= c.toy then 
				c.component:setX(c.sync.x+c.w/2);
				c.component:setY(c.sync.y+c.h/2);
			else
				c.synced = false
			end
		end
	end

	c.sync_flux = function(self, tt, x, y)
		c.synced = true
		c.sync = tt;
		c.tox = x;
		c.toy = y;
	end

	return c
end