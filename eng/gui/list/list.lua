
function new_list(parent, name, x, y, w, h)
	local l = gui_element(parent, name);

	l.x, l.y, l.w, l.h = x or 0, y or 0, w or 0, h or 0;

	l.tx = 0;
	l.ty = 0;

	l.canvas = lg.newCanvas();

	l.get_y = function(self)
		if self.parent then
			return (self.y or 0) + ( (self.parent:get_y() or 0) ) - self.ty/lg.getHeight();
		else
			return (self.y or 0) - self.ty/lg.getHeight();
		end
	end

	l.get_x = function(self)
		if self.parent then
			return (self.x or 0) + ( (self.parent:get_x() or 0) ) - self.tx/lg.getWidth();
		else
			return (self.x or 0) - self.tx/lg.getWidth();
		end
	end

	local rect_stencil = function()
		local ww, hh = lg.getWidth(), lg.getHeight();
		love.graphics.rectangle("fill",
			l.x*ww, 
			l.y*hh, 
			l.w*ww, 
			l.h*hh
		)
	end

	l.on_add_children = function(self, n, ind)
		n.cancel_event = true;
	end

	l.draw = function(self)
		local ww, hh = lg.getWidth(), lg.getHeight();
		lg.setCanvas(self.canvas);

		lg.clear();
		lg.translate(-self.tx, -self.ty);

		-- Draw things inside the scrolled list
		lg.setColor(0.4, 0.4, 0.4, 1);
		--lg.print("DIE", 0, 100);

		for i, v in ipairs(self.children) do
			v:draw();
		end

		lg.setCanvas();

		lg.setColor(1, 1, 1, 1);

		lg.translate(self.tx, self.ty);

		lg.stencil(rect_stencil, "replace", 1);

		lg.setStencilTest("greater", 0);
		lg.draw(self.canvas, self.x*ww, self.y*hh);
		lg.setStencilTest();

		lg.setColor(0, 1, 0, 1)
		lg.rectangle("line", 
			self.x*ww, self.y*hh, self.w*ww, self.h*hh
		)
		lg.setColor(1, 1, 1, 1)

	end

	l.wheelmoved = function(self, dx, dy)
		local ww, hh = lg.getWidth(), lg.getHeight();
		local mx = love.mouse.getX()/ww
		local my = love.mouse.getY()/hh
		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			local scram = 10;
			if love.keyboard.isDown("lctrl") then
				scram = 100;
			end
			self.ty = math.max(self.ty - (dy*scram), 0)
			--print(self.ty)
		end
	end

	l.mousepressed = function(self, x, y, button)
		for i, v in ipairs(self.children) do
			v:propagate_event_raw("mousepressed", x, y, button);
		end
	end

	return l;
end