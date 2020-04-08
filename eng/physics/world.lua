function physics_world(s, n, xg, yg)
	local w = new_node(s, n or "world");

	w.world = wf.newWorld(xg or 0, yg or 0, true);
	w.colliders = {}

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