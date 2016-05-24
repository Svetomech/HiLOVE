cheats = {}

function cheats.tgm()
  player.invincible = not player.invincible
end

function cheats.killall()
  if #bullet ~= 0 then return end
  for i = 0, screenWidth do
    bullet.spawn(i, 0, 'down')
    bullet.spawn(i, screenHeight - bullet.height, 'up')
  end
  for i = 0, screenHeight do
    bullet.spawn(0, i, 'right')
    bullet.spawn(screenWidth - bullet.width, i, 'left')
  end
  for i,v in ipairs(enemy) do
    enemy[i] = nil
  end
end

function cheats.freeze_enemies()
  enemy.paused = not enemy.paused
end

function cheats.unleash_enemy()
  enemy.limitWeakness = not enemy.limitWeakness
end

function cheats.no_collision()
  enemy.pCollisionEnabled = not enemy.pCollisionEnabled
end

function cheats.odd_physics()
  enemy.eCollisionEnabled = not enemy.eCollisionEnabled
end

function cheats.keyhook(key)
  if     key == 'i' then                                -- toggle god mode
    cheats.tgm()
  elseif key == 'k' then                                -- kill all enemies
    cheats.killall()
  elseif key == 'l' then                                -- freeze time (enemies only)
    cheats.freeze_enemies()
  --elseif key == 'j' then
    
  elseif key == 'kp1' then                              -- debug function #1
    cheats.unleash_enemy()
  elseif key == 'kp2' then                              -- debug function #2
    cheats.no_collision()
  elseif key == 'kp3' then                              -- debug function #3
    cheats.odd_physics()
  end
end