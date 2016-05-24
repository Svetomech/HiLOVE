bullet = {}

function bullet.load()
  bullet.speed = 500
  bullet.width = 5
  bullet.height = 5
  for i,v in ipairs(bullet) do
    bullet[i] = nil
  end
  
  bullet.paused = false
  bullet.halt = false
end

function bullet.spawn(x,y,dir)
  table.insert(bullet, {x = x, y = y, dir = dir})
end

function bullet.move(dt)
  if bullet.paused or bullet.halt then return end
  
  for i,v in ipairs(bullet) do
    if v.dir == 'up' then
      v.y = v.y - bullet.speed * dt
    end
    if v.dir == 'down' then
      v.y = v.y + bullet.speed * dt
    end
    if v.dir == 'right' then
      v.x = v.x + bullet.speed * dt
    end
    if v.dir == 'left' then
      v.x = v.x - bullet.speed * dt
    end
  end
end

function bullet.bound()
  for i,v in ipairs(bullet) do
    if v.x < 0 then
      table.remove(bullet, i)
    end
    if v.y < 0 then
      table.remove(bullet, i)
    end
    if v.x + bullet.width > screenWidth then
      table.remove(bullet, i)
    end
    if v.y + bullet.height > screenHeight then
      table.remove(bullet, i)
    end
  end
end

function bullet.draw()
  for i,v in ipairs(bullet) do
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle('fill',v.x,v.y,bullet.width,bullet.height)
  end
end


-- PARENT FUNC
function UPDATE_BULLET(dt)
  bullet.move(dt)
  bullet.bound()
end

function DRAW_BULLET()
  bullet.draw()
end