local Vec2 = require("lib.vec2")

---@class Projectile
---@field position Vec2
---@field velocity Vec2
---@field radius number
---@field alive boolean
local Projectile = {}
Projectile.__index = Projectile

local PROJECTILE_SPEED = 500
local PROJECTILE_LIFETIME = 1

--- Create a new projectile
---@param position Vec2
---@param heading number
---@return Projectile
function Projectile.new(position, heading)
  local self = setmetatable({}, Projectile)
  self.position = position:clone() or Vec2.new()
  self.velocity = Vec2.from_magnitude_and_angle(PROJECTILE_SPEED, heading)
  self.radius = 4
  self.time_to_live = PROJECTILE_LIFETIME
  return self
end

--- Update projectile
---@param dt number
function Projectile:update(dt)
  self.time_to_live = self.time_to_live - dt
  self.alive = self.time_to_live > 0
  self.position:add(self.velocity:clone():scale(dt))
  self.position:wrap(Vec2.zero(), Vec2.new(800, 800))
end

--- Draw projectile
function Projectile:draw()
  love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
end

return Projectile
