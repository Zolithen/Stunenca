function new_gui_list(name, x, y, w, h, l)
	local list = new_gui_element(name, x, y, w, h)

	list:set_value("ty", 0)
	list:set_value("li", (l or {}))
	list:set_value("selected", 1)

	local function rect_stencil()
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		love.graphics.rectangle("fill",
			list.value.x*ww, 
			list.value.y*hh, 
			list.value.w*ww, 
			list.value.h*hh
		)
	end

	list:set_value("canvas", love.graphics.newCanvas())

	list:add_event("draw", function(self)
		self.ty = math.max(self.ty, 0)

		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		love.graphics.translate(0, -self.ty)
		love.graphics.setColor(0.4, 0.4, 0.4, 1)
		love.graphics.rectangle("fill", 0, (self.selected-1)*16, self.w*ww, 16)
		love.graphics.setColor(1, 1, 1, 1)
		for i, v in ipairs(self.li) do
			love.graphics.print(v, 0, (i-1)*16)
		end
		love.graphics.setCanvas()

		love.graphics.translate(0, self.ty)

		love.graphics.stencil(rect_stencil, "replace", 1)

		love.graphics.setStencilTest("greater", 0)
		love.graphics.draw(self.canvas, self.x*ww, self.y*hh)
		love.graphics.setStencilTest()

		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("line", 
			self.x*ww, self.y*hh, self.w*ww, self.h*hh
		)
		love.graphics.setColor(1, 1, 1, 1)
	end)

	list:add_event("wheelmoved", function(self, dx, dy)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = love.mouse.getX()/ww
		local my = love.mouse.getY()/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			self.ty = self.ty - (dy*10)
		end
	end)

	list:add_event("mousepressed", function(self, x, y)
		local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
		local mx = x/ww
		local my = y/hh

		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then

		end

	end)

	return list
end