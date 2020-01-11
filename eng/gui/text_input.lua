function new_gui_text_input(name, x, y, w, h, mw, mh)
	local text_input = new_gui_element(name, x, y, w, h)

	text_input:set_value("mw", mw or 0.1)
	text_input:set_value("mh", mh or 0.02)

	text_input:set_value("text", "")
	text_input:set_value("ins_text", love.graphics.newText(love.graphics.getFont(), ""))
	text_input:set_value("focused", false)

	text_input:add_event("textinput", function(self, text)
		if self.text ~= "backspace" and self.focused then
			self.text = self.text .. text
			self.ins_text = love.graphics.newText(love.graphics.getFont(), self.text)
		end
	end)

	text_input:add_event("keypressed", function(self, key)
		if self.focused then
			if key == "return" then
				self.focused = false
			elseif key == "backspace" then
				local byteoffset = utf8.offset(self.text, -1)
				if byteoffset then
					self.text = string.sub(self.text, 1, byteoffset - 1)
					self.ins_text = love.graphics.newText(love.graphics.getFont(), self.text)
				end
			elseif key == "up" then
			end
		end
	end)

	text_input:add_event("mousepressed", function(self, x, y, button)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = x/ww
		local my = y/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			self.focused = true
		else
			self.focused = false
		end
	end)

	text_input:add_event("draw", function(self)
		if self.focused then 
			love.graphics.setColor(0.4, 0.4, 0.4, 1) 
		else
			love.graphics.setColor(0.2, 0.2, 0.2, 1) 
		end
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		self.w = math.max(self.ins_text:getWidth()/ww, self.mw)
		self.h = math.max(self.ins_text:getHeight()/hh, self.mh)
		love.graphics.rectangle("fill", self.x*ww, self.y*hh, self.w*ww, self.h*hh)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.ins_text, self.x*ww, self.y*hh)
	end)

	--[[button:set_value("prototype", table.copy(button.value))

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
			love.graphics.setColor(0.1, 0.1, 0.1, 1)
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
	end)]]

	return text_input
end