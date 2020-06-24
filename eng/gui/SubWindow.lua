SubWindow = GuiElement:extend("SubWindow");

function SubWindow:init(win, name, x, y, rw, rh, dw, dh)
	SubWindow.super.init(self, win, name, x, y);
	self.full_w = rw;
	self.full_h = rh;
	self.draw_w = dw;
	self.draw_h = dh;

	self.hslider_x = 0;
	self.vslider_y = 0;

	self.vmoving = false;
	self.hmoving = false;

	self.mox = 0;
	self.moy = 0;

	self.tx = 0;
	self.ty = 0;
	--[[ -- batched implementation ends here 
	self.t, self.tex_ind = win.batch:add_texture_print(
		love.graphics.newFont("assets/Roboto-Thin.ttf", 14),
		text
	);
	self.batch_ind = win.batch:add_rect(1);]]
end

function SubWindow:update(dt)
	if self.hmoving then
		self.hslider_x = math.clamp(
			0,
			love.mouse.getX() - self.mox - self:get_x(),
			self.draw_w-32
		);
		self.tx = (
			((self.full_w-self.draw_w)/(self.draw_w-32))*self.hslider_x
		);
	end
	if self.vmoving then
		self.vslider_y = math.clamp(
			0,
			love.mouse.getY() - self.moy - self:get_y(),
			self.draw_h-32
		);
		self.ty = (
			((self.full_h-self.draw_h)/(self.draw_h-32))*self.vslider_y
		);
	end
end

function SubWindow:draw()
	love.graphics.push();
		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", self:draw_box());
    	end, "replace", 1)
		love.graphics.translate(-self.tx, -self.ty);
		love.graphics.rectangle("fill", self:draw_box());
		love.graphics.setColor(1, 0, 0, 1);
		love.graphics.rectangle("fill", self:test_box());
	love.graphics.pop();
	love.graphics.setColor(0.7, 0.7, 0.7, 1);
	love.graphics.rectangle("fill", self:hslider_box());
	love.graphics.rectangle("fill", self:vslider_box());
	love.graphics.setColor(1, 1, 1, 1);
	self.parent:stencil();
end

function SubWindow:mousepressed(x, y, b)
	if is_hovered(self:hslider_box()) then
		self.hmoving = true;
		local xx, yy = self:hslider_box();
		self.mox = x - xx;
		self.moy = y - yy;
	elseif is_hovered(self:vslider_box()) then
		self.vmoving = true;
		local xx, yy = self:vslider_box();
		self.mox = x - xx;
		self.moy = y - yy;
	end
end

function SubWindow:mousereleased()
	self.hmoving = false;
	self.vmoving = false;
end

function SubWindow:draw_box()
	return self:get_x(), self:get_y(), self.draw_w, self.draw_h;
end

function SubWindow:test_box()
	return self:get_x()+16, self:get_y()+16, self.full_w-32, self.full_h-32;
end

function SubWindow:hslider_box()
	return self:get_x()+self.hslider_x,
		self:get_y()+self.draw_h-16,
		16,
		16
end

function SubWindow:vslider_box()
	return self:get_x()+self.draw_w-16,
		self:get_y()+self.vslider_y,
		16,
		16
end