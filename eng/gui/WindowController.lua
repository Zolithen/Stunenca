WindowController = Node:extend("WindowController");
WindowContainer = Node:extend("WindowContainer");

-- TODO : Change from using a custom stack to the tree hierarchy

-- contains the window and the batch
function WindowContainer:init(sc, name)
	Node.init(self, sc, name, 0, 0);
	self.focus = false;
end

function WindowController:init()
	Node.init(self, nil, "controller", 0, 0);
	self.win_stack = {};
	self.el_providers = {}
end

function WindowController:update(dt)
	for i, v in ipairs(self.win_stack) do
		v:propagate_event_reverse("update", dt);
	end
end

function WindowController:draw()
	for i, v in ipairs(self.win_stack) do
		v:propagate_event("draw");
	end
end

function WindowController:mousepressed(x, y, b)
	for i, v in r_ipairs(self.win_stack) do
		v:propagate_event_reverse("mousepressed", x, y, b);
		if self.end_event then break end;
	end
	self.end_event = false;
end

function WindowController:mousemoved(x, y)
	for i, v in r_ipairs(self.win_stack) do
		v:propagate_event_reverse("mousemoved", x, y);
		if self.end_event then break end;
	end
	self.end_event = false;
end

function WindowController:mousereleased(x, y, b)
	for i, v in ipairs(self.win_stack) do
		v:propagate_event_reverse("mousereleased", x, y, b);
	end
end

-- elements
function WindowController:register_element(name, func)
	self.el_providers[name] = func;
end

-- window stuff
function WindowController:add_window(name, x, y, title)
	--local con = WindowContainer(nil, name);
	local win = Window(nil, name, x, y, title);
	win.winc = self;
	table.insert(self.win_stack, win);
	return win;
end

function WindowController:find_window(name)
	for i, v in ipairs(self.win_stack) do
		if v.name == name then return v, i end
	end
	return nil, 0;
end

function WindowController:focus_window(name)
	local con, i = self:find_window(name);
	if con then
		table.remove(self.win_stack, i);
		table.insert(self.win_stack, con);
		--self:update_window_index();
		self:update_window_status();
	end
end

function WindowController:update_window_status()
	for i, v in ipairs(self.win_stack) do
		v.focus = i == #self.win_stack-1;
	end
end

function WindowController:add_element(win, t, ...)
	local w, i = self:find_window(win);
	local e = self.el_providers[t](w, "test", ...);
	if e then

	end
end