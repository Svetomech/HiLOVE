enemy = {}

function enemy.load()
  enemy.speed = 1000
  enemy.friction = 5
  if enemy.difficulty == nil then
    enemy.difficulty = 0.01 
  end
  enemy.weakness = 3
  enemy.limitWeakness = true
  enemy.amountMin = 1 --2
  enemy.amountMax = 3 --4
  enemy.width = 50
  enemy.height = 50
  enemy.pCollisionEnabled = true
  enemy.eCollisionEnabled = true
  for i,v in ipairs(enemy) do
    enemy[i] = nil
  end
  
  enemy.amount = love.math.random(enemy.amountMin,enemy.amountMax - enemy.weakness + 2)
  enemy.side = love.math.random(1,4) --0,4
  enemy.spawnTimer = 0
  enemy.spawnTimerLim = love.math.random(enemy.weakness,enemy.weakness + 2)
  
  enemy.paused = false
  enemy.halt = false
end

function enemy.spawn(x,y)
  table.insert(enemy, {x = x, y = y, xvel = 0, yvel = 0})
end

function enemy.generate(dt)
  if enemy.paused or enemy.halt then return end
  
  enemy.spawnTimer = enemy.spawnTimer + dt
  
  if enemy.spawnTimer >= enemy.spawnTimerLim then
    for i=1,enemy.amount do
      if enemy.side == 1 then
        enemy.spawn(screenWidth / 2 - enemy.width / 2, -enemy.height)
      elseif enemy.side == 2 then
        enemy.spawn(-enemy.width, screenHeight / 2 - enemy.height / 2)
      elseif enemy.side == 3 then
        enemy.spawn(screenWidth / 2 - enemy.width / 2, screenHeight)
      elseif enemy.side == 4 then
        enemy.spawn(screenWidth, screenHeight / 2 - enemy.height / 2)
      end
      enemy.side = love.math.random(1,4)
    end
    
    enemy.amount = love.math.random(enemy.amountMin,enemy.amountMax - enemy.weakness + 2)
    enemy.spawnTimerLim = love.math.random(enemy.weakness,enemy.weakness + 2)
    enemy.spawnTimer = 0
  end
end

function enemy.bullet_collide()
  for i,v in ipairs(enemy) do
    for ia,va in ipairs(bullet) do
      if va.x + bullet.width > v.x and
         va.x < v.x + enemy.width and
         va.y + bullet.height > v.y and
         va.y < v.y + enemy.height then
          table.remove(enemy, i)
          table.remove(bullet, ia)
          player.score = player.score + 10 * math.floor(love.math.random(0,math.abs(v.xvel + v.yvel)))
      end
    end
  end
end

function enemy.player_collide()
  if not enemy.pCollisionEnabled then return end
  
  for i,v in ipairs(enemy) do
    if player.x + player.width > v.x and
       player.x < v.x + enemy.width and
       player.y + player.height > v.y and
       player.y < v.y + enemy.height then
        player.xvel = 0
        player.yvel = 0
        table.remove(enemy, i)
        player.health = player.health - math.floor(love.math.random(0,math.abs(v.xvel + v.yvel)))
    end
  end
end

function enemy.enemy_collide()
  if not enemy.eCollisionEnabled then return end
  
  for i,v in ipairs(enemy) do
    for ia,va in ipairs(enemy) do
      if i == ia then break end
      
      if va.x + enemy.width > v.x and
         va.x < v.x + enemy.width and
         va.y + enemy.height > v.y and
         va.y < v.y + enemy.height then
          va.xvel = va.xvel - math.abs(va.x + enemy.width - v.x)
          v.xvel = v.xvel + math.abs(va.x + enemy.width - v.x)
          --оттолкнуть va влево, v вправо
          va.yvel = va.yvel - math.abs(va.y + enemy.height - v.y)
          v.yvel = v.yvel + math.abs(va.y + enemy.height - v.y)
          --va - вверх, v - вниз
      end
    end
  end
end

function enemy.physics(dt)
  if enemy.halt then return end
  
  for i,v in ipairs(enemy) do
    v.x = v.x + v.xvel * dt
    v.y = v.y + v.yvel * dt
    v.xvel = v.xvel * (1 - math.min(dt*enemy.friction, 1)) 
    v.yvel = v.yvel * (1 - math.min(dt*enemy.friction, 1)) 
  end
end

function enemy.AI(dt)
  if enemy.paused or enemy.halt then return end
  
  for i,v in ipairs(enemy) do
    if (player.x + player.width / 2 > v.x + enemy.width / 2) and (v.xvel < enemy.speed) then
      v.xvel = v.xvel + enemy.speed * dt
    end
    if (player.x + player.width / 2 < v.x + enemy.width / 2) and (v.xvel > -enemy.speed) then
      v.xvel = v.xvel - enemy.speed * dt
    end
      
    if (player.y + player.height / 2 > v.y + enemy.height / 2) and (v.yvel < enemy.speed) then
      v.yvel = v.yvel + enemy.speed * dt
    end
    if (player.y + player.height / 2 < v.y + enemy.height / 2) and (v.yvel > -enemy.speed) then
      v.yvel = v.yvel - enemy.speed * dt
    end
  end
  
  enemy.speed = (player.speed - player.speed / 3) - 333 * enemy.weakness
  if not enemy.limitWeakness or enemy.weakness - enemy.difficulty * dt > 0 then
    enemy.weakness = enemy.weakness - enemy.difficulty * dt
  end
end

function enemy.display_difficulty()
  if enemy.difficulty == 1 then
    love.graphics.print('IMPOSIBRU!', 5, screenHeight - 20)
  elseif enemy.difficulty == 0.1 then
    love.graphics.print('Hard', 5, screenHeight - 20)
  elseif enemy.difficulty == 0.01 then
    love.graphics.print('Normal', 5, screenHeight - 20)
  elseif enemy.difficulty == 0.001 then
    love.graphics.print('Easy peasy', 5, screenHeight - 20)
  end
end

function enemy.draw()
  for i,v in ipairs(enemy) do
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', v.x, v.y, enemy.width, enemy.height)
    
    if not player.paused and not player.halt then
      love.graphics.setColor(love.math.random(0,255),love.math.random(0,255),love.math.random(0,255))
    end
    love.graphics.print(math.floor(love.math.random(0,math.abs(v.xvel + v.yvel))), v.x, v.y + 30)
  end
end


-- PARENT FUNC
function UPDATE_ENEMY(dt)
  enemy.physics(dt)
  enemy.AI(dt)
  enemy.generate(dt)
  enemy.bullet_collide()
  enemy.player_collide()
  enemy.enemy_collide()
end

function DRAW_ENEMY()
  enemy.display_difficulty()
  enemy.draw()
end