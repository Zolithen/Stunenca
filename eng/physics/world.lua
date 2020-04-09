function physics_world(s, n, xg, yg)
	local w = new_node(s, n or "world");

	w.world = wf.newWorld(xg or 0, yg or 0, true);
	w.colliders = {}

	w.query_rectangle = function(self, x, y, w, h, c)
		return self.world:queryRectangleArea(x, y, w, h, c);
	end

	w.query_circle = function(self, x, y, r, c)
		return self.world:queryCircleArea(x, y, r, c);
	end

	w.query_polygon = function(self, v, c)
		return self.world:queryPolygonArea(v, c);
	end

	w.query_line = function(self, x, y, x2, y2, c)
		return self.world:queryLineArea(x, y, x2, y2, c);
	end

	w.add_collision_class = function(self, collision_class_name, collision_class)
		return self.world:addCollisionClass(collision_class_name, collision_class)
	end

	w.update = function(self, dt)
		self.world:update(dt);
	end

	w.draw = function(self)
		self.world:draw()
	end

	w.on_delete = function(self)
		for i, v in pairs(self.colliders) do
			v:destroy();
		end
	end

	return w
end