https = nil
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")

require("ship")

Inputs = {
  accelerate = false,
  turn_left = false,
  turn_right = false,
  fire = false,
}

function Inputs:reset()
  for k, v in pairs(self) do
    v = false
  end
end

function Inputs.update()
  Inputs.accelerate = love.keyboard.isDown("up")
  Inputs.turn_left = love.keyboard.isDown("left")
  Inputs.turn_right = love.keyboard.isDown("right")
end

function love.load()
  https = runtimeLoader.loadHTTPS()
  Inputs:reset()
  -- Your game load here
  overlayStats.load() -- Should always be called last
end

function love.draw()
  -- Your game draw here
  Ship:draw()
  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  -- Your game update here
  Inputs.update()
  Ship:update(dt)
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
