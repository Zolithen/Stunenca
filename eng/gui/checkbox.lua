function new_gui_checkbox(name, func, x, y, w, h, label)
	local checkbox = new_gui_element(name, x, y, w, h)
	checkbox:set_value("prototype", table.copy(checkbox.value))

	--[[checkbox:set_value("on_click", func)
	checkbox:set_value("text", 
		love.graphics.newText(love.graphics.getFont(), label or "")
	)]]

	checkbox:add_event("draw", function(self)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = love.mouse.getX()/ww
		local my = love.mouse.getY()/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			love.graphics.setColor(
				0.4, 0.4, 0.4, 1
			)
		else
			love.graphics.setColor(0.1, 0.1, 0.1, 1)
		end
		love.graphics.rectangle("fill", self.x*ww, self.y*hh, self.w*ww, self.h*hh)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.text, 
			self.x*ww+(self.w*ww-(self.w*ww/2))-self.text:getWidth()/2, 
			self.y*hh+(self.h*hh-(self.h*hh/2))-self.text:getHeight()/2
		)
	end)

	checkbox:add_event("mousepressed", function(self, x, y, button)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = x/ww
		local my = y/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			--self:on_click(mx, my, checkbox)
		end
	end)

	return checkbox
end

-- Lua stands for Lua Unified Acronym