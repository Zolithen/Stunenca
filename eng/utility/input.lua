InputManager = Node:extend("InputManager");

function InputManager:init(sc)
	Node.init(self, sc, "InputManager", 0, 0);
	self.activators = {};
	self.map = {};
end

function InputManager:send(k, p)
	self.activators[k] = p;
end

function InputManager:pressed(k)
	return self.activators[k] 
		   or self.activators[self.map[k]]
end

function InputManager:hook_up(m, k)
	self.map[m] = k;
end

function InputManager:keypressed(k)
	self.activators[k] = true;
end

function InputManager:keyreleased(k)
	self.activators[k] = false;
end