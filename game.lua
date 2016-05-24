game = {}

function game.reset()
  player.load()
  teleport.load()
  bullet.load()
  enemy.load()
end

function game.pause()
  player.paused = true
  teleport.paused = true
  bullet.paused = true
  enemy.paused = true
end

function game.halt()
  player.halt = not player.halt
  teleport.halt = not teleport.halt
  bullet.halt = not bullet.halt
  enemy.halt = not enemy.halt
end

function game.process_keys(key)
  if     key == 'p' then                                -- pause the game
    game.halt()
  elseif key == 'q' then                                -- quit the game
    love.event.quit()
  elseif key == '[' and enemy.difficulty > 0.001 then   -- lower the difficulty
    enemy.difficulty = enemy.difficulty / 10
    player.bulletLim = player.bulletLim + 1
  elseif key == ']' and enemy.difficulty < 1 then       -- increase the difficulty
    enemy.difficulty = enemy.difficulty * 10
    player.bulletLim = player.bulletLim - 1
  end
  cheats.keyhook(key)
end

function game.display_fps()
  if love.timer.getFPS() > 9 then
    love.graphics.print(love.timer.getFPS(), screenWidth - 25, screenHeight - 20)
  end
end