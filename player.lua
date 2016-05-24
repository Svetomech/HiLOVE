player = {}

function player.load()
  player.speed = 2250       -- player.buffs(), [X]
  player.friction = 5       -- bonuses.lua, 9.5
  player.width = 50         -- bonuses.lua
  player.height = 50        -- bonuses.lua
  player.x = 5              -- teleport.lua, love.math.random(screenWidth - player.width)
  player.y = 5              -- teleport.lua, love.math.random(screenHeight - player.height)
  
  player.health = 1000      -- player.buffs()
  player.invincible = false -- cheats.lua
  player.bulletLim = 2      -- game.lua
  player.score = 0          -- enemy.lua
  player.xvel = 0
  player.yvel = 0
  player.resetTimer = 0
  player.resetTimerLim = 3
  
  player.paused = false
  player.halt = false
end

function player.shoot(key)
  if (#bullet >= player.bulletLim) or player.paused or player.halt then return end
  
  if key == 'up' then
    bullet.spawn(player.x + player.width / 2 - bullet.width / 2, player.y - bullet.height, key)
  end
  if key == 'down' then
    bullet.spawn(player.x + player.width / 2 - bullet.width / 2, player.y + player.height, key)
  end
  if key == 'left' then
    bullet.spawn(player.x - bullet.width, player.y + player.height / 2 - bullet.height / 2, key)
  end
  if key == 'right' then
    bullet.spawn(player.x + player.width, player.y + player.height / 2 - bullet.height / 2, key)
  end
end

function player.handle_death(dt)
  if player.invincible then return end
  
  if player.health <= 0 then
    game.pause()
    
    player.resetTimer = player.resetTimer + dt
    if player.resetTimer >= player.resetTimerLim then
      game.reset()
    end
  end
end

function player.display_health()
  if player.health > 0 then
    if player.halt then 
      love.graphics.setColor(0,150,150)
      love.graphics.print("Game is paused", 5, 0)
      return
    end
    
    love.graphics.setColor(0,150,0)
    love.graphics.print(math.floor(player.health), 5, 0)
  else
    love.graphics.setColor(150,0,0)
    love.graphics.print("You are dead", 5, 0)
  end
end

function player.display_score()
  love.graphics.setColor(0,0,0)
  love.graphics.print(player.score, 5, 15)
end

function player.physics(dt)
  if player.halt then return end
  
  player.x = player.x + player.xvel * dt
  player.y = player.y + player.yvel * dt
  player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
  player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end

function player.move(dt)
  if player.paused or player.halt then return end
  
  if love.keyboard.isDown('d') and player.xvel < player.speed then
    player.xvel = player.xvel + player.speed * dt
  end
  if love.keyboard.isDown('a') and player.xvel > -player.speed then
    player.xvel = player.xvel - player.speed * dt
  end
  if love.keyboard.isDown('s') and player.yvel < player.speed then
    player.yvel = player.yvel + player.speed * dt
  end
  if love.keyboard.isDown('w') and player.yvel > -player.speed then
    player.yvel = player.yvel - player.speed * dt
  end
end

function player.bound()
  if player.x < 0 then
    if #enemy > 0 then
      player.health = player.health - 10
    end
    player.x = 0
    player.xvel = 0
  end
  if player.y < 0 then
    if #enemy > 0 then
      player.health = player.health - 10
    end
    player.y = 0
    player.yvel = 0
  end
  if player.x + player.width > screenWidth then
    if #enemy > 0 then
      player.health = player.health - 10
    end
    player.x = screenWidth - player.width
    player.xvel = 0
  end
  if player.y + player.height > screenHeight then
    if #enemy > 0 then
      player.health = player.health - 10
    end
    player.y = screenHeight - player.height
    player.yvel = 0
  end
end

function player.buffs(dt)
  if player.paused or player.halt then return end
  
  player.health = player.health + (2 * #bullet - #enemy) * dt
end

function player.draw(x,y,a,w,h)
  x = x or player.x
  y = y or player.y
  a = a or 255
  w = w or player.width
  h = h or player.height
  
  love.graphics.setColor(255,174,66,a)
  love.graphics.rectangle('fill', x, y, w, h)
end


-- PARENT FUNC
function UPDATE_PLAYER(dt)
  player.physics(dt)
  player.move(dt)
  player.bound()
  player.handle_death(dt)
  player.buffs(dt)
end

function DRAW_PLAYER()
  if not teleport.activated then
    player.draw()
  end
  player.display_health()
  player.display_score()
end