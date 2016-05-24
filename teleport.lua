teleport = {}

function teleport.load()
  teleport.speed = 10
  teleport.op = 63
  teleport.width = 0
  teleport.height = 0
  teleport.x = player.x
  teleport.y = player.y
  
  teleport.activated = false
  teleport.disposeTimer = 0
  teleport.disposeTimerLim = 3
  
  teleport.paused = false
  teleport.halt = false
end

function teleport.adjust_location(dt)
  if teleport.paused or teleport.halt or teleport.activated then return end
  
  if teleport.disposeTimer >= teleport.disposeTimerLim then
    teleport.x = player.x
    teleport.y = player.y
    teleport.disposeTimer = 0
  end
  teleport.disposeTimer = teleport.disposeTimer + dt
end

function teleport.working(dt)
  if not teleport.activated then return end
  
  player.width, player.height = player.width - teleport.speed, player.height - teleport.speed
  teleport.width, teleport.height = teleport.width + teleport.speed, teleport.height + teleport.speed
  
  if player.width == 0 and player.height == 0 then
    player.width, player.height = teleport.width, teleport.height
    teleport.width, teleport.height = 0, 0
    player.x, player.y = teleport.x, teleport.y
    
    player.xvel, player.yvel = 0, 0
    teleport.activated = false
  end
end

function teleport.tp(key)
  if teleport.paused or teleport.halt or teleport.activated then return end
  if math.floor(player.x) == math.floor(teleport.x) and math.floor(player.y) == math.floor(teleport.y) then return end
  
  if key == 'space' then
    teleport.activated = true
  end
end

function teleport.display_time()
  love.graphics.setColor(teleport.disposeTimer*85,0,0)
  love.graphics.print(math.floor(teleport.disposeTimer), screenWidth - 15, 0)
end

function teleport.draw()
  if teleport.halt then return end
  
  if not teleport.activated then
    player.draw(teleport.x, teleport.y, teleport.op)
  else
    player.draw(player.x, player.y, nil, player.width, player.height)
    player.draw(teleport.x, teleport.y, nil, teleport.width, teleport.height)
  end
end


-- PARENT FUNC
function UPDATE_TELEPORT(dt)
  teleport.adjust_location(dt)
  teleport.working(dt)
end

function DRAW_TELEPORT()
  teleport.draw()
  teleport.display_time()
end