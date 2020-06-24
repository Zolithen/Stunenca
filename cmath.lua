
math.randomseed(os.time())

function math.reseed() math.randomseed(os.time()) end

-- Returns if the given value is in the table
function table.contains(t,s)
  for i,v in pairs(t) do
    if (v==s) then 
      return true
    end
  end
end

-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Returns the angle between two points.
function math.getAngle(x1,y1, x2,y2) return math.atan2(x2-x1, y2-y1) end


-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end

-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

-- Normalizes two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end

-- Returns 'n' rounded to the nearest 'deci'th.
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end

-- Special not-decimal round
function math.sround(n, deci) return math.floor(n*deci+.5)/deci end

-- Randomly returns either -1 or 1.
function math.rsign() return math.random(2) == 2 and 1 or -1 end

-- Randomly return a boolean value
function math.rbool() return math.round(math.random()) == 0 end


-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

function table.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[table.copy(k, s)] = table.copy(v, s) end
  return res
end

function table.is_empty(t)
  return next(t) == nil
end

function math.pboverlapraw(x1, y1, x2, y2, w, h) 
  return (
    (x1 > x2) and
    (x1 < x2 + w) and
    (y1 > y2) and
    (y1 < y2 + h)
  )
end
function math.pboverlap(point, box) 
  return 
  ((point.x > box.x) and 
  (point.x < box.x + box.w)) and 
  ((point.y > box.y) and 
  (point.y < box.y + box.h)) 
end
function math.boverlap(b1, b2)
  return b1.x < b2.x+b2.w and
         b2.x < b1.x+b1.w and
         b1.y < b2.y+b2.h and
         b2.y < b1.y+b1.h
end

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function r_ipairs(t)
    return reversedipairsiter, t, #t + 1
end

function is_hovered(...)
  return math.pboverlapraw(
      love.mouse.getX(), love.mouse.getY(),
      ...
    )
end