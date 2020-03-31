local tmt = {}

--[[function tmt:update(dt)
	if self.time > 0 then
		self.time = self.time - dt
	else
		if not self.every then 
			self:callback() 
			if self.rev then
				self.time = self.max_time
			else
				self = nil
			end
		else
			self = nil
		end
	end
	if self.every then
		self:callback()
	end
end]]

function tmt:update(dt)
	if self.done then return true end;
	if self.time > 0 then
		if self.type == "for" then
			self.times_called = self.times_called + 1;
			self:callback(dt, self.time, self.times_called);
		end
		self.time = self.time - dt;
	else
		self.times_called = self.times_called + 1;
		if self.type == "after" or self.type == "for" then
			self.done = true;
			self:callback(dt, self.time, self.times_called);
		else
			self.time = self.max_time;
			return self:callback(dt, self.time, self.times_called);
		end
	end
	return false;
end

-- Executes a function after the time has passed, then deletes itself
function new_timer_after(time, callback)
	local t = {}

	t.time = time;
	t.max_time = time;
	t.callback = callback;
	t.done = false;
	t.times_called = 0;
	t.type = "after";

	setmetatable(t, {__index=tmt});

	return t
end

-- Executes a function every time.
function new_timer_every(time, callback)
	local t = {}

	t.time = time;
	t.max_time = time;
	t.callback = callback;
	t.done = false;
	t.times_called = 0;
	t.type = "every";

	setmetatable(t, {__index=tmt});

	return t
end

-- Executes a function every frame for time
function new_timer_for(time, callback)
	local t = {}

	t.time = time;
	t.max_time = time;
	t.callback = callback;
	t.done = false;
	t.times_called = 0;
	t.type = "for";

	setmetatable(t, {__index=tmt});

	return t
end