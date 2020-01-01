
function new_gui_button(name, func, x, y, w, h)
	local button = new_gui_element(name, x, y, w, h)

	button:set_value("on_click", func)

	--button:add_event("mousepressed")

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