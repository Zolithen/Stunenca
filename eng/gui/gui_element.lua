function gui_element(...)
	local g = new_node(...);

	g.get_y = function(self)
		if self.parent then
			return (self.y or 0) + ( (self.parent:get_y() or 0) );
		else
			return self.y or 0;
		end
	end

	g.get_x = function(self)
		if self.parent then
			return (self.x or 0) + ( (self.parent:get_x() or 0) );
		else
			return self.x or 0;
		end
	end

	return g;
end