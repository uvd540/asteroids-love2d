local Vec2 = require("lib.vec2")

Ship = {
  position = Vec2.new(400, 400),
  velocity = Vec2.new(),
  size = 10,
  heading = 0,
  acceleration = 500,
  turn_speed = 2 * math.pi,
  deceleration = 100,
}

function Ship:reset()
  self.position = Vec2.new(400, 400)
  self.velocity = Vec2.new()
  self.heading = 0
end

function Ship:update(dt)
  if Inputs.turn_left then
    self.heading = self.heading - (self.turn_speed * dt)
  end
  if Inputs.turn_right then
    self.heading = self.heading + (self.turn_speed * dt)
  end
  if Inputs.accelerate then
    self.velocity:add(Vec2.from_angle(self.heading):scale(self.acceleration * dt))
  end
  self.velocity:move_towards(Vec2.new(), self.deceleration * dt)
  self.position:add(self.velocity:clone():scale(dt))
  self.position:wrap(Vec2.new(), Vec2.new(800, 800))
end

function Ship:draw()
  local pt0 = Vec2.new(self.size, 0)
  local pt1 = pt0:clone():rotate(math.pi * 2 / 3)
  local pt2 = pt1:clone():rotate(math.pi * 2 / 3)
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.rotate(self.heading)
  love.graphics.line(pt0.x, pt0.y, pt1.x, pt1.y)
  love.graphics.line(pt0.x, pt0.y, pt2.x, pt2.y)
  pt1:scale(0.5)
  pt2:scale(0.5)
  love.graphics.line(pt1.x, pt1.y, pt2.x, pt2.y)
  love.graphics.pop()
end
