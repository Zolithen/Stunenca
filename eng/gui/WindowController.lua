WindowController = Node:extend("WindowController");
WindowContainer = Node:extend("WindowContainer");

-- TODO : Change the stack position of the windows when focused

-- contains the window and the batch
function WindowContainer:init(sc)
	Node.init(self, sc, "wcontainer", 0, 0);
end

function WindowController:init()
	Node.init(self, nil, "controller", 0, 0);
	self.win_stack = {};
end

function WindowController:update(dt)
	for i, v in ipairs(self.win_stack) do
		v:propagate_event("update", dt);
	end
end

function WindowController:draw()
	for i, v in ipairs(self.win_stack) do
		v:propagate_event("draw");
	end
end

function WindowController:mousepressed(x, y, b)
	for i, v in r_ipairs(self.win_stack) do
		v:propagate_event("mousepressed", x, y, b);
		if self.end_event then break end;
	end
	self.end_event = false;
end

function WindowController:mousereleased(x, y, b)
	for i, v in ipairs(self.win_stack) do
		v:propagate_event("mousereleased", x, y, b);
	end
end

function WindowController:add_window(name, x, y, title)
	local con = WindowContainer(nil);
	local win = Window(con, name, x, y, title);
	win.winc = self;
	table.insert(self.win_stack, win);
	table.insert(self.win_stack, win.batch);
	return win;
end
