local Vec2 = require("lib.vec2")

---@class Asteroid
---@field position Vec2
---@field velocity Vec2
local Asteroid = {}
Asteroid.__index = Asteroid

---@enum AsteroidTypes
AsteroidType = {
  large = 0,
  medium = 1,
  small = 2,
}

---@param type AsteroidTypes
function get_asteroid_radius(type)
  if type == AsteroidType.large then
    return 40
  elseif type == AsteroidType.medium then
    return 20
  else
    return 10
  end
end

---@param type AsteroidTypes
function get_asteroid_speed(type)
  if type == AsteroidType.large then
    return 10
  elseif type == AsteroidType.medium then
    return 20
  else
    return 40
  end
end

--- Create a new asteroid
---@param position Vec2
---@param type AsteroidTypes
function Asteroid.new(position, type)
  local self = setmetatable({}, Asteroid)
  self.position = position
  self.radius = get_asteroid_radius(type)
  local speed = get_asteroid_speed(type)
  self.velocity = Vec2.from_magnitude_and_angle(speed, math.random() * 2 * math.pi)
  return self
end

function Asteroid:update(dt)
  self.position:add(self.velocity:clone():scale(dt))
end

function Asteroid:draw()
  love.graphics.circle("line", self.position.x, self.position.y, self.radius)
end

return Asteroid
