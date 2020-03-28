
function new_text_element_list(parent, name, x, y, w, h)
	local l = new_list(parent, name, x, y, w, h);

	local rect_stencil = function()
		local ww, hh = lg.getWidth(), lg.getHeight();
		love.graphics.rectangle("fill",
			l.x*ww, 
			l.y*hh, 
			l.w*ww, 
			l.h*hh
		)
	end

	l.texts = {};
	l.selected = 1;

	l.add_text = function(self, t)
		table.insert(self.texts, t);
	end

	l.draw = function(self)
		local ww, hh = lg.getWidth(), lg.getHeight();
		lg.setCanvas(self.canvas);

		lg.clear();
		lg.translate(-self.tx, -self.ty);

		-- Draw things inside the scrolled list
		lg.setColor(0.4, 0.4, 0.4, 1);
		lg.rectangle("fill", 0, (self.selected-1)*16, self.w*ww, 16)
		--lg.print("DIE", 0, 100);

		lg.setColor(1, 1, 1, 1);

		for i, v in ipairs(self.texts) do
			--v:draw();
			lg.print(v, 0, (i-1)*16);
		end

		--print("ABOUTA DRAW CHILDS")

		lg.setCanvas();

		--print("Ended rendering canvas");

		lg.translate(self.tx, self.ty);

		lg.stencil(rect_stencil, "replace", 1);

		lg.setStencilTest("greater", 0);

		--print("Fully stted");

		lg.draw(self.canvas, self.x*ww, self.y*hh);
		lg.setStencilTest();

		lg.setColor(0, 1, 0, 1)
		lg.rectangle("line", 
			self.x*ww, self.y*hh, self.w*ww, self.h*hh
		)
		lg.setColor(1, 1, 1, 1)

	end

	l.mousepressed = function(self, x, y)
		local ww, hh = lg.getWidth(), lg.getHeight();
		local mx = x/ww;
		local my = y/hh;

		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			local mmy = y + self.ty - self.y*hh
			self.selected = math.floor(mmy / 16)+1
		end
	end

	return l;
end