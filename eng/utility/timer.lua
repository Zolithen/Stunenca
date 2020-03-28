local tmt = {}

function tmt:update(dt)
	if self.time > 0 then
		self.time = self.time - dt
	else
		if not self.every then self:callback() end
	end
	if self.every then
		self:callback()
	end
end

function new_timer(time, callback, every)
	local t = {}

	t.time = time;
	t.callback = callback
	t.every = every or false

	setmetatable(t, {__index=tmt});

	return t
end