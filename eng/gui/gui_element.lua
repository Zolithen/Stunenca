function new_gui_element(name, func)
	local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
	local element = new_game_node(name)

	element.value.get_x = function(self)
		
	end

	element.value.get_y = function(self)
		
	end

	element.value.set_x = function(self, x)
		
	end

	element.value.set_y = function(self, y)
		
	end

	--[[element:add_event("mousepressed", function(self, x, y, button)

	end)]]

	return element
end