
function new_node_tree_viewer(parent, name, x, y, w, h)
	local l = new_list(parent, name, x, y, w, h);

	l.selected = 0;

	local rect_stencil = function()
		local ww, hh = lg.getWidth(), lg.getHeight();
		love.graphics.rectangle("fill",
			l.x*ww, 
			l.y*hh, 
			l.w*ww, 
			l.h*hh
		)
	end

	l.draw_branch = function(self, v, d, yy)
		love.graphics.print(v.name, ((d-1)*16), yy);
		for i, k in ipairs(v.children) do
			yy = yy + 16;
			yy = self:draw_branch(k, d+1, yy);
		end
		return yy
	end

	l.draw = function(self)
		local ww, hh = lg.getWidth(), lg.getHeight();
		lg.setCanvas(self.canvas);

		lg.clear();
		lg.translate(-self.tx, -self.ty);

		lg.setColor(0.4, 0.4, 0.4, 1);
		lg.rectangle("fill", 0, (self.selected-1)*16, self.w*ww, 16)
		--lg.print("DIE", 0, 100);

		lg.setColor(1, 1, 1, 1);

		self:draw_branch(scene, 1, 0);

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

	l.mousepressed = function(self, x, y, button)
		local ww, hh = lg.getWidth(), lg.getHeight();
		local mx = x/ww;
		local my = y/hh;

		if math.pointraw(mx, my, self.x, self.y, self.w, self.h) then
			local mmy = y + self.ty - self.y*hh
			self.selected = math.floor(mmy / 16)+1
		end
	end

	l.get_selected_node = function(self)
		--local apl = self:plain(scene);
	end

	return l;
end