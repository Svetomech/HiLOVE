require 'player'
require 'teleport'
require 'bullet'
require 'enemy'
require 'cheats'
require 'game'

function love.load()
  screenWidth, screenHeight = love.graphics.getDimensions()
  fullscreenMode = love.window.getFullscreen()
  
  --Loading fonts
  gameFont = love.graphics.newFont("ARCADECLASSIC.TTF",20)
  love.graphics.setFont(gameFont)
  --
  
  --Loading libraries
  game.reset()
  --
  
  love.graphics.setBackgroundColor(255,255,255)
end

function love.keypressed(key)
  game.process_keys(key)
  teleport.tp(key)
  player.shoot(key)
end

function love.update(dt)
  UPDATE_PLAYER(dt)
  UPDATE_TELEPORT(dt)
  UPDATE_BULLET(dt)
  UPDATE_ENEMY(dt)
end

function love.draw()
  DRAW_TELEPORT()
  DRAW_PLAYER()
  game.display_fps()
  DRAW_ENEMY()
  DRAW_BULLET()
  
  -- Drawing borderline
  love.graphics.setLineWidth(3)
  love.graphics.rectangle('line', 0, 0, screenWidth, screenHeight)
  --
end