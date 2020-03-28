local tmt = {}

function tmt:update(dt)
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
end

function new_timer(time, callback, every, rev)
	local t = {}

	t.time = time;
	t.max_time = time;
	t.callback = callback;
	t.every = every or false;
	t.rev = rev or false;

	setmetatable(t, {__index=tmt});

	return t
end