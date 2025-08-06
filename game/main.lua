https = nil
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")

local Vec2 = require("lib.vec2")

local projectile = require("projectile")
local asteroid = require("asteroid")

require("ship")

Inputs = {
  accelerate = false,
  turn_left = false,
  turn_right = false,
  fire = false,
}

Projectiles = {}
local start_asteroids = 24
Asteroids = {}

function Inputs.update()
  Inputs.accelerate = love.keyboard.isDown("up")
  Inputs.turn_left = love.keyboard.isDown("left")
  Inputs.turn_right = love.keyboard.isDown("right")
  Inputs.fire = love.keyboard.isDown("space")
end

function love.load()
  https = runtimeLoader.loadHTTPS()
  for i = 1, start_asteroids do
    table.insert(Asteroids, asteroid.new(Vec2.new(math.random(0, 800), math.random(0, 800)), AsteroidType.large))
  end
  overlayStats.load() -- Should always be called last
end

function love.draw()
  -- Your game draw here
  Ship:draw()
  for _, p in ipairs(Projectiles) do
    p:draw()
  end
  for _, a in ipairs(Asteroids) do
    a:draw()
  end
  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  -- Your game update here
  Inputs.update()
  Ship:update(dt)
  -- Spawn projectiles
  if Inputs.fire then
    table.insert(Projectiles, projectile.new(Ship.position, Ship.heading))
  end
  -- Update projectiles
  for _, p in ipairs(Projectiles) do
    p:update(dt)
  end
  -- Update asteroids
  for _, a in ipairs(Asteroids) do
    a:update(dt)
    -- Check for asteroid ship collision
    if is_collision_cicles(Ship.position, Ship.size, a.position, a.radius) then
      reset()
    end
  end
  -- Cleanup loop
  for i = #Projectiles, 1, -1 do
    if not Projectiles[i].alive then
      table.remove(Projectiles, i)
    end
  end
  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end

function reset()
  Ship:reset()
  Asteroids = {}
  Projectiles = {}
  for i = 1, start_asteroids do
    table.insert(Asteroids, asteroid.new(Vec2.new(math.random(0, 800), math.random(0, 800)), AsteroidType.large))
  end
end

--- Returns true if circles are intersecting
---@param c1 Vec2
---@param r1 number
---@param c2 Vec2
---@param r2 number
---@return boolean
function is_collision_cicles(c1, r1, c2, r2)
  local distance_between_centers = c1:distance(c2)
  local sum_of_radii = r1 + r2
  return distance_between_centers <= sum_of_radii
end
