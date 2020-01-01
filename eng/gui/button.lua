
function new_gui_button(name, func, x, y, w, h, label)
	local button = new_gui_element(name, x, y, w, h)
	button:set_value("prototype", table.copy(button.value))

	button:set_value("on_click", func)
	button:set_value("text", 
		love.graphics.newText(love.graphics.getFont(), label or "")
	)

	--button:add_event("mousepressed")

	button:add_event("draw", function(self)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = love.mouse.getX()/ww
		local my = love.mouse.getY()/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			love.graphics.setColor(
				0.4, 0.4, 0.4, 1
			)
		else
			love.graphics.setColor(scene:find("gui_layer").value.color)
		end
		love.graphics.rectangle("fill", self.x*ww, self.y*hh, self.w*ww, self.h*hh)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.text, 
			self.x*ww+(self.w*ww-(self.w*ww/2))-self.text:getWidth()/2, 
			self.y*hh+(self.h*hh-(self.h*hh/2))-self.text:getHeight()/2
		)
	end)

	button:add_event("mousepressed", function(self, x, y, button)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = x/ww
		local my = y/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			self:on_click(mx, my, button)
		end
	end)

	return button
end