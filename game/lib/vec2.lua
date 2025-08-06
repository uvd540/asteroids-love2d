---@class Vec2
---@field x number
---@field y number
local Vec2 = {}
Vec2.__index = Vec2

---Create a new 2d vector
---@param x number
---@param y number
---@return Vec2
function Vec2.new(x, y)
  local self = setmetatable({}, Vec2)
  self.x = x or 0
  self.y = y or 0
  return self
end

---{0, 0} vector
---@return Vec2
function Vec2.zero()
  return Vec2.new(0, 0)
end

---Clones an existing 2d vector
---@return Vec2
function Vec2:clone()
  return Vec2.new(self.x, self.y)
end

---Creates a 2d unit vector centered at (0, 0) rotated by the given angle
---@param angle number Angle in radians
---@return Vec2
function Vec2.from_angle(angle)
  return Vec2.new(math.cos(angle), math.sin(angle))
end

--- Create a vector from magnitude and angle
---@param magnitude number
---@param angle number
---@return Vec2
function Vec2.from_magnitude_and_angle(magnitude, angle)
  return Vec2.from_angle(angle):scale(magnitude)
end

---Add another vector to the current vector
---@param other Vec2
---@return Vec2
function Vec2:add(other)
  self.x = self.x + other.x
  self.y = self.y + other.y
  return self
end

---Subtract another vector to the current vector
---@param other Vec2
---@return Vec2
function Vec2:subtract(other)
  self.x = self.x - other.x
  self.y = self.y - other.y
  return self
end

---Scale the current vector
---@param s number
---@return Vec2
function Vec2:scale(s)
  self.x = self.x * s
  self.y = self.y * s
  return self
end

--- Rotates the current vector by a given angle
---@param angle number Angle in radians
---@return Vec2
function Vec2:rotate(angle)
  local cos_a = math.cos(angle)
  local sin_a = math.sin(angle)
  local x = self.x
  local y = self.y
  self.x = x * cos_a - y * sin_a
  self.y = x * sin_a + y * cos_a
  return self
end

--- Distance to another vector
---@param other Vec2
---@return number
function Vec2:distance(other)
  local dx2 = (self.x - other.x) * (self.x - other.x)
  local dy2 = (self.y - other.y) * (self.y - other.y)
  return math.sqrt(dx2 + dy2)
end

--- Moves a given vector towards a target vector
---@param target Vec2
---@param max_magnitude_change number
function Vec2:move_towards(target, max_magnitude_change)
  local dx = target.x - self.x
  local dy = target.y - self.y
  local dist = math.sqrt(dx * dx + dy * dy)
  if dist <= max_magnitude_change or dist == 0 then
    self.x = target.x
    self.y = target.y
  else
    local ratio = max_magnitude_change / dist
    self.x = self.x + dx * ratio
    self.y = self.y + dy * ratio
  end
  return self
end

--- Wraps the given vector within the range
---@param min Vec2
---@param max Vec2
function Vec2:wrap(min, max)
  local width = max.x - min.x
  local height = max.y - min.y
  self.x = ((self.x - min.x) % width) + min.x
  self.y = ((self.y - min.y) % height) + min.y
  return self
end

return Vec2
