function new_gui_element(name, x, y, w, h)
	local element = new_game_node(name)

	element:set_value("x", x)
	element:set_value("y", y)
	element:set_value("w", w)
	element:set_value("h", h)

	element.value.get_x = function(self)
		
	end

	element.value.get_y = function(self)
		
	end

	element.value.set_x = function(self, x)
		
	end

	element.value.set_y = function(self, y)
		
	end

	element:add_event("draw", function(self)
		if scene:find("gui_layer") then
			if scene:find("gui_layer").value.color then
				love.graphics.setColor(scene:find("gui_layer").value.color)
			end
		end
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		love.graphics.rectangle("fill", self.x*ww, self.y*hh, self.w*ww, self.h*hh)
		love.graphics.setColor(1, 1, 1, 1)
	end)

	--[[element:add_event("mousepressed", function(self, x, y, button)

	end)]]

	return element
end