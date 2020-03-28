

function new_button(parent, name, x, y, w, h, on_click, text)
	local b = gui_element(parent, name);

	b.x, b.y, b.w, b.h, b.on_click = x or 0, y or 0, w or 0, h or 0, on_click or function() end;

	b.text = love.graphics.newText(love.graphics.getFont(), text or "");

	b.draw = function(self)
		--print(self.x)
		local ww, hh = lg.getWidth(), lg.getHeight();
		local mx = love.mouse.getX()/ww
		local my = love.mouse.getY()/hh
		--print("button node has a pos of", self:get_x(), self:get_y());
		if math.pointraw(mx, my, self:get_x(), self:get_y(), self.w, self.h) then
			love.graphics.setColor(
				0.4, 0.4, 0.4, 1
			)
		else
			love.graphics.setColor(0.1, 0.1, 0.1, 1);
		end
		love.graphics.rectangle("fill",self.x*ww, self.y*hh, self.w*ww, self.h*hh);
		love.graphics.setColor(1, 1, 1, 1);
		love.graphics.draw(self.text, 
			self.x*ww+(self.w*ww-(self.w*ww/2))-self.text:getWidth()/2, 
			self.y*hh+(self.h*hh-(self.h*hh/2))-self.text:getHeight()/2
		)
	end

	b.mousepressed = function(self, x, y, button)
		local ww, hh = lg.getWidth(), lg.getHeight();
		local mx = x/ww
		local my = y/hh
		if math.pointraw(mx, my, self:get_x(), self:get_y(), self.w, self.h) then
			--print("got into")
			self:on_click(mx, my, button)
			return true;
			--print("spñíkfghbasñoukfvbsalifkhjsba flkasjvf ask,jmfsabfklsajbfkln.sabf dsafk,asnv faslkj,hf");
		end
	end

	return b;
end