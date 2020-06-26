SubWindow = GuiElement:extend("SubWindow");

function SubWindow:init(win, name, x, y, rw, rh, dw, dh, construct)
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

	--self.window = Window(nil, "w", self:get_x(), self:get_y(), "w");
	self.winc = WindowController();
	self.window = self.winc:add_window("www", 0, 0, "1");
	self.window.w = self.full_w;
	self.window.h = self.full_h;
	self.window.expandable = false;
	self.window.focusable = false;
	self.window.stencilable = false;
	self.window.title_bar = false;

	if construct then
		self.construct = construct;
	end

	
	--[[ -- batched implementation ends here 
	self.t, self.tex_ind = win.batch:add_texture_print(
		love.graphics.newFont("assets/Roboto-Thin.ttf", 14),
		text
	);
	self.batch_ind = win.batch:add_rect(1);]]
end

function SubWindow:construct()
	self.winc:add_element("www", "label", "hola mundo", 0, 32);
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

	self.window.x = self:get_x();
	self.window.y = self:get_y();
end

function SubWindow:predraw()
end

function SubWindow:draw()
	love.graphics.setColor(1, 0, 0, 1);
	love.graphics.rectangle("fill", self:outline_box());
	love.graphics.push();
		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", self:draw_box());
    	end, "replace", 1)
		love.graphics.translate(-self.tx, -self.ty);
		self.winc:draw();
		--love.graphics.rectangle("fill", self:draw_box());
		--love.graphics.setColor(1, 0, 0, 1);
		--love.graphics.rectangle("fill", self:test_box());
	love.graphics.pop();
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:draw_box());
    end, "replace", 1)
	love.graphics.setColor(0.5, 0.5, 0.5, 1);
	love.graphics.rectangle("fill", self:hslider_track_box());
	love.graphics.rectangle("fill", self:vslider_track_box());
	love.graphics.setColor(0.7, 0.7, 0.7, 1);
	love.graphics.rectangle("fill", self:hslider_box());
	love.graphics.rectangle("fill", self:vslider_box());
	love.graphics.setColor(0.9, 0.9, 0.9, 1);
	love.graphics.rectangle("fill", self:notch_box());
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
	return self:get_x(), self:get_y(), math.min(self.draw_w, self.parent.w), math.min(self.draw_h, self.parent.h);
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

function SubWindow:hslider_track_box()
	return self:get_x(),
		self:get_y()+self.draw_h-16,
		self.draw_w-16,
		16
end

function SubWindow:vslider_track_box()
	return self:get_x()+self.draw_w-16,
		self:get_y(),
		16,
		self.draw_h-16
end

function SubWindow:notch_box()
	return self:get_x()+self.draw_w-16,
		self:get_y()+self.draw_h-16,
		16,
		16
end

function SubWindow:outline_box()
	return self:get_x()-2,
		self:get_y()-2,
		math.min(self.draw_w, self.parent.w)+4,
		math.min(self.draw_h, self.parent.h)+4
end