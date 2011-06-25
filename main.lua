require "levels"
require "dingoo_font"
require "util"
require "control_conf"

game = {}
game.mode = 0  -- 0=start,1=game,2=pause
 
-- start screen data
game.startMode = {}
game.startMode.backGround = love.graphics.newImage("img/StartScreen.png")
game.startMode.timer = 0
game.startMode.show_start = true

-- game mode
game.level = 0
game.gameMode = {}
game.game_timer = 0

-- game mode
gameMode = {}
gameMode.pause       = -1
gameMode.start       = 0
gameMode.main        = 1 
gameMode.editor      = 2
gameMode.score       = 3
gameMode.settings 	 = 4
gameMode.leveleditor = 5

-- ingame mode
mainGameMode = {}
mainGameMode.help 		= 1
mainGameMode.main 		= 2
mainGameMode.complete 	= 3
mainGameMode.try 		= 4

-- mode during game play
game.gameMode.main_game_mode = mainGameMode.help

-- help mode
game.gameMode.help_timer_max = 5
game.gameMode.help_timer = 0

-- level complete 
game.gameMode.complete_timer_max = 5
game.gameMode.complete_timer = 0

-- reset mode
game.gameMode.reset_timer = 5


-- actual game
game.gameMode.normal_block 	   = love.graphics.newImage("img/Box/Normal.png")
game.gameMode.normal_block_inv = love.graphics.newImage("img/Box/Normal_inv.png")
-- green randomly give a block
game.gameMode.green_block 	   = love.graphics.newImage("img/Box/green.png")
game.gameMode.green_block_inv  = love.graphics.newImage("img/Box/green_inv.png")
-- red randomly take a block
game.gameMode.red_block 	   = love.graphics.newImage("img/Box/red.png")
game.gameMode.red_block_inv    = love.graphics.newImage("img/Box/red_inv.png")

-- pause mode
game.pauseMode = {}
game.pauseMode.choice = 0 -- 0=pause, 1=help, 2=instr, 3=reset, 4=exit

-- settings mode
game.settingsMode = {}
game.settingsMode.choice = 0


-- player
player = {}
player.image = love.graphics.newImage("img/Player/normal.png");
player.x = 150
player.y = 200
player.speed = 40
player.orig_speed = 60
player.speed_inc = 50
player.give_blocks = {}
player.take_blocks = {}
player.give_shot = love.graphics.newImage("img/Player/shot_give.png")
player.take_shot = love.graphics.newImage("img/Player/shot_take.png")

--------------------
-- load functions --
--------------------

function love.load() 
  love.mouse.setVisible(false) 

  local success = love.graphics.setMode(320, 240, false, 0)
  -- quit if not successful
  if (not success) then
  	love.quit()
  end
  
  love.graphics.setCaption("Code Copy")
  
  -- set fonts
  font_data = love.image.newImageData("img/Fonts/font_complete.png")
  font_normal = dingoo_font.setFontImage(font_data, " ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?[]", 12, 4)
  
  font_data = love.image.newImageData("img/Fonts/font_white_small.png")
  font_white_small = dingoo_font.setFontImage(font_data, " ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?[]", 6, 2)
  
  font_data = love.image.newImageData("img/Fonts/font_red_small.png")
  font_red_small = dingoo_font.setFontImage(font_data, " ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?[]", 6, 2)

  font_data = love.image.newImageData("img/Fonts/font_complete_small.png")
  font_normal_small = dingoo_font.setFontImage(font_data, " ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?[]", 6, 2)
end

----------------------
-- update functions --
----------------------

function love.update(dt)
  if (game.mode == gameMode.pause) then
    updatePause(dt)
  elseif (game.mode == gameMode.start) then
    updateStart(dt)
  elseif (game.mode == gameMode.main) then
    updateGame(dt)
  elseif (game.mode == gameMode.settings) then
    updateSettings(dt)
  elseif (game.mode == gameMode.leveleditor) then
  	leveleditor.update(dt)
  end
end

-- update start values
function updateStart(dt)
  -- flash start button
  game.startMode.timer = game.startMode.timer + dt
  if (game.startMode.timer > 1) then
    game.startMode.show_start = not game.startMode.show_start
    game.startMode.timer = 0
  end
end

-- update pause values
function updatePause(dt)

end

-- update the settings value
function updateSettings(dt)
end

-- update main game methods
function updateGame(dt)
  if (game.gameMode.main_game_mode == mainGameMode.help) then
    updateGameHelp(dt)
  elseif (game.gameMode.main_game_mode == mainGameMode.main) then
    updateGameMain(dt)
  elseif (game.gameMode.main_game_mode == mainGameMode.complete) then
    updateGameComplete(dt)
  elseif (game.gameMode.main_game_mode == mainGameMode.try) then
    updateRetryLevel(dt)
  end
end

-- update the help screen at the start of a level
function updateGameHelp(dt)
  game.gameMode.help_timer = game.gameMode.help_timer + dt
  if (game.gameMode.help_timer > game.gameMode.help_timer_max) then
    game.gameMode.main_game_mode = mainGameMode.main
  end
end

-- update the main game mode
function updateGameMain(dt)
  if (love.keyboard.isDown(control.left)) then
    -- check limit
    if (player.x <= 20) then
      player.x = 20
    else 
      -- move left
      player.x = player.x - (player.speed*dt)
      -- increase the speed
      player.speed = player.speed + (dt*player.speed_inc)
    end
  elseif (love.keyboard.isDown(control.right)) then
    -- check limit
    if (player.x >= 280) then
      player.x = 280
    else
      -- move right
      player.x = player.x + (player.speed*dt)
      -- increase the speed
      player.speed = player.speed + (dt*player.speed_inc)
    end
  end
  
  local remGiveShots = {}
  local remTakeShots = {}
  
  -- move the give shots
  for i,v in ipairs(player.give_blocks) do
    v.y = v.y - (dt*100)
    -- check if off screen
    if (v.y < 0) then
      table.insert(remGiveShots, i)
    end
  end
  
  -- move the take shots
  for i,v in ipairs(player.take_blocks) do
    v.y = v.y - (dt*100)
    -- check if off screen
    if (v.y < 0) then
      table.insert(remTakeShots, i)
    end
  end
  
  -- remove shots
  for i,v in ipairs(remGiveShots) do
    table.remove(player.give_blocks, v)
  end
  for i,v in ipairs(remTakeShots) do
    table.remove(player.take_blocks, v)
  end
  
  -- update time
  levels.levels[game.level].timer_max = levels.levels[game.level].timer_max - dt
  -- out of time, show retry screen
  local timer = math.floor(levels.levels[game.level].timer_max)
  if (timer == -1) then
    game.gameMode.main_game_mode = mainGameMode.try
  end
  
end

-- update the complete screen at the mode
function updateGameComplete(dt)
  game.gameMode.complete_timer = game.gameMode.complete_timer + dt
  
  -- move to the next level
  if (game.gameMode.complete_timer > game.gameMode.complete_timer_max) then
    nextLevel()
  end 
end

-- update the retry level screen
function updateRetryLevel(dt)
  game.gameMode.reset_timer = game.gameMode.reset_timer - dt
  
  local timer = math.floor(game.gameMode.reset_timer)
  if (timer == -1) then
    retryLevel()
  end
end

--------------------
-- draw functions --
--------------------

function love.draw()
  if (game.mode == gameMode.pause) then
    drawPause()
  elseif (game.mode == gameMode.start) then
    drawStart()
  elseif (game.mode == gameMode.main) then
    drawGame()
  elseif (game.mode == gameMode.settings) then
    drawSettings()
  elseif (game.mode == gameMode.leveleditor) then
  	leveleditor.draw();
  end
end

-- draw start screen
function drawStart()
  love.graphics.clear()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(game.startMode.backGround, 0, 0, 0, 1, 1, 0)
  
  if (game.startMode.show_start) then
    dingoo_font.dingPrint(font_normal, 'PRESS START', 75, 178)
  end
  
  dingoo_font.dingPrint(font_normal_small, 'OR SELECT FOR SETTINGS', 75, 220)
end

-- draw pause screen
function drawPause()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", 90, 20, 140, 200)
  dingoo_font.dingPrint(font_normal, 'PAUSE', 123, 35)
  dingoo_font.dingPrint(font_normal, 'HELP', 123, 69)
  dingoo_font.dingPrint(font_normal, 'INSTR', 123, 103)
  dingoo_font.dingPrint(font_normal, 'RESET', 123, 137)
  dingoo_font.dingPrint(font_normal, 'EXIT', 123, 171)
  
  -- draw the select key
  love.graphics.setColor(0, 0, 0, 255)
  -- display updated choice
  if (game.pauseMode.choice == 0) then
    love.graphics.rectangle('fill', 103, 42, 10, 10)
  elseif (game.pauseMode.choice == 1) then
    love.graphics.rectangle('fill', 103, 76, 10, 10)
  elseif (game.pauseMode.choice == 2) then
    love.graphics.rectangle('fill', 103, 110, 10, 10)
  elseif (game.pauseMode.choice == 3) then
  	love.graphics.rectangle('fill', 103, 144, 10, 10)
  elseif (game.pauseMode.choice == 4) then
  	love.graphics.rectangle('fill', 103, 178, 10, 10)
  end
end

-- draw settings screen
function drawSettings()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", 90, 20, 140, 200)
  dingoo_font.dingPrint(font_normal, 'EDITOR', 123, 35)
  dingoo_font.dingPrint(font_normal, 'SCORE', 123, 69)
  dingoo_font.dingPrint(font_normal, 'INSTR', 123, 103)
  dingoo_font.dingPrint(font_normal, 'RETURN', 123, 137)
  dingoo_font.dingPrint(font_normal, 'EXIT', 123, 171)
  
  -- draw the select key
  love.graphics.setColor(0, 0, 0, 255)
  
  if (game.settingsMode.choice == 0) then
    love.graphics.rectangle('fill', 103, 42, 10, 10)
  elseif (game.settingsMode.choice == 1) then
    love.graphics.rectangle('fill', 103, 76, 10, 10)
  elseif (game.settingsMode.choice == 2) then
    love.graphics.rectangle('fill', 103, 110, 10, 10)
  elseif (game.settingsMode.choice == 3) then
  	love.graphics.rectangle('fill', 103, 144, 10, 10)
  elseif (game.settingsMode.choice == 4) then
  	love.graphics.rectangle('fill', 103, 178, 10, 10)
  end
end

-- draw main game screen
function drawGame()
  love.graphics.clear()
  -- help mode
  if (game.gameMode.main_game_mode == mainGameMode.help) then
    drawGameHelp()
  elseif (game.gameMode.main_game_mode == mainGameMode.main) then
    drawGameMain()
  elseif (game.gameMode.main_game_mode == mainGameMode.complete) then
    drawGameComplete()
  elseif (game.gameMode.main_game_mode == mainGameMode.try) then
    drawRetryLevel()
  end
end

-- draws the help game screen
function drawGameHelp()
  love.graphics.clear()
  -- display the blocks to remove
  for i=0, 5 do
    for j=1, 14 do
      if (levels.levels[game.level].maze[i*14+j] == 1) then
        love.graphics.draw(game.gameMode.normal_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      elseif (levels.levels[game.level].maze[i*14+j] == 2) then
        love.graphics.draw(game.gameMode.green_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      elseif (levels.levels[game.level].maze[i*14+j] == 3) then
        love.graphics.draw(game.gameMode.red_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      end
    end
  end
  -- display help text
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('fill', 0, 170, 320, 30)
  dingoo_font.dingPrint(font_normal, levels.levels[game.level].level_name, 80, 173)
    
  local time_diff = (game.gameMode.help_timer_max - math.floor(game.gameMode.help_timer))
  dingoo_font.dingPrint(font_normal, tostring(time_diff), 260, 173)
end

-- draws the main game
function drawGameMain()
 love.graphics.setColor(255, 255, 255, 255)
	
  -- display game blocks
  for i=0, 5 do
    for j=1, 14 do
      if (levels.levels[game.level].start[i*14+j] == 1) then
        love.graphics.draw(game.gameMode.normal_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      elseif (levels.levels[game.level].start[i*14+j] == 2) then
        love.graphics.draw(game.gameMode.green_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      elseif (levels.levels[game.level].start[i*14+j] == 3) then
        love.graphics.draw(game.gameMode.red_block, (j*20), (i*20)+20, 0, 1, 1, 0)
      end
    end
  end
    

  love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, 0)
  
  --display shots (give)
  for i,v in ipairs(player.give_blocks) do
    love.graphics.draw(player.give_shot, v.x, v.y, 0, 1, 1, 0)
  end
  -- display shots (take)
  for i,v in ipairs(player.take_blocks) do
    love.graphics.draw(player.take_shot, v.x, v.y, 0, 1, 1, 0)
  end
  
  
  local timer = math.floor(levels.levels[game.level].timer_max)
  -- if less than 10 seconds, show red
  if (timer > 10) then
    dingoo_font.dingPrint(font_white_small, tostring(levels.levels[game.level].timer_max), 280, 220)
  else
    dingoo_font.dingPrint(font_red_small, tostring(levels.levels[game.level].timer_max), 280, 220)
  end
end

-- draw the level complete screen
function drawGameComplete()
  local rounded_time = math.floor(game.gameMode.complete_timer)
  local mod = rounded_time % 2
  
  -- switch between inverted and normal maze colourss
  if (mod == 0) then
    for i=0, 5 do
      for j=1, 14 do
        if (levels.levels[game.level].start[i*14+j] == 1) then
          love.graphics.draw(game.gameMode.normal_block, (j*20), (i*20)+20, 0, 1, 1, 0)
        elseif (levels.levels[game.level].start[i*14+j] == 2) then
          love.graphics.draw(game.gameMode.green_block, (j*20), (i*20)+20, 0, 1, 1, 0)
        elseif (levels.levels[game.level].start[i*14+j] == 3) then
          love.graphics.draw(game.gameMode.red_block, (j*20), (i*20)+20, 0, 1, 1, 0)
        end
      end
    end
  else
    for i=0, 5 do
      for j=1, 14 do
        if (levels.levels[game.level].start[i*14+j] == 1) then
          love.graphics.draw(game.gameMode.normal_block_inv, (j*20), (i*20)+20, 0, 1, 1, 0)
        elseif (levels.levels[game.level].start[i*14+j] == 2) then
          love.graphics.draw(game.gameMode.green_block_inv, (j*20), (i*20)+20, 0, 1, 1, 0)
        elseif (levels.levels[game.level].start[i*14+j] == 3) then
          love.graphics.draw(game.gameMode.red_block_inv, (j*20), (i*20)+20, 0, 1, 1, 0)
        end
      end
    end
  end
end


function drawRetryLevel()
  -- display white block
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('fill', 0, 170, 320, 30)
  love.graphics.rectangle('fill', 0, 50, 320, 30)
  dingoo_font.dingPrint(font_normal, "FAILED", 80, 53)
  
  -- display time to reset
  local timer = math.floor(game.gameMode.reset_timer)
  dingoo_font.dingPrint(font_normal, "RETRY IN "..tostring(timer), 80, 173)
end

------------------------
-- keyboard functions --
------------------------

-- for when using computer
function love.keyreleased(key)
  -- start game
  if (game.mode == gameMode.start) then
  	-- start the game
    startKeyReleased(key)
  -- game mode  
  elseif (game.mode == gameMode.main) then
    gameKeyReleased(key)
  -- pause mode  
  elseif (game.mode == gameMode.pause) then
    pauseKeyReleased(key)
  -- settings mode
  elseif (game.mode == gameMode.settings) then
    settingsKeyReleased(key)
  elseif (game.mode == gameMode.leveleditor) then
    leveleditor.keyreleased(key)
  end
end

-- process key releases during the start screen
function startKeyReleased(key)
  if (key == control.start) then
    game.mode = gameMode.main
  elseif (key == control.select) then
    game.mode = gameMode.settings
  end
end

-- process key releases during the game screen
function gameKeyReleased(key)
  if (key == control.left or key == control.right) then
    -- reset the speed
    player.speed = player.orig_speed 
  elseif (key == control.L) then
     -- give a block
     fireGiveBlock()
  elseif (key == control.R) then
     -- take a block
     fireTakeBlock()
  elseif (key == control.start) then
    -- pause the game
    game.mode = gameMode.pause
  elseif (key == control.Y) then
    -- activate the top give shot
    if (table.getn(player.give_blocks) > 0) then
      local bx = player.give_blocks[1].x
      local by = player.give_blocks[1].y
      
      
      local block_index = checkBlockCollision(bx, by) 
      if (block_index > 0) then
      	local block_type = levels.levels[game.level].start[block_index]
      	
      	-- execute specific block actions
      	if (block_type == 2) then
      	  activateGreenBlock(block_index)
      	elseif (block_type == 3) then
      	  activateRedBlock(block_index)
      	end
      	
        -- replace block with normal block
        levels.levels[game.level].start[block_index] = 1
      end
      
      table.remove(player.give_blocks, 1)
      
      -- check if the current level is complete
      if (levels.levelComplete(game.level)) then
        game.gameMode.main_game_mode = mainGameMode.complete
      end
    end
    
    if (table.getn(player.take_blocks) > 0) then
      local bx = player.take_blocks[1].x
      local by = player.take_blocks[1].y
    
      local block_index = checkBlockCollision(bx, by)
      
      if (block_index > 0) then
        local block_type = levels.levels[game.level].start[block_index]
      	
      	-- execute specific block actions
      	if (block_type == 2) then
      	  activateGreenBlock(block_index)
      	elseif (block_type == 3) then
      	  activateRedBlock(block_index)
      	end
      	
        levels.levels[game.level].start[block_index] = 0
      end
      
      table.remove(player.take_blocks, 1)
      
      -- check if the current level is complete
      if (levels.levelComplete(game.level)) then
        game.gameMode.main_game_mode = mainGameMode.complete
      end
    end
  elseif (key == control.A) then
    -- activate the top take shot
    
  end
end

-- process key releases during the pause screen
function pauseKeyReleased(key)
  -- move the select menu
  if (key == control.up) then
    if (game.pauseMode.choice == 0) then
      return;
    else
      game.pauseMode.choice = game.pauseMode.choice - 1
    end
  elseif (key == control.down) then
    if (game.pauseMode.choice == 4) then
      return;
    else
      game.pauseMode.choice = game.pauseMode.choice + 1
    end
  end
  -- start, select menu option
  if (key == control.start) then
    if (game.pauseMode.choice == 0) then
      -- return to the main game
      game.mode = gameMode.main
    elseif (game.pauseMode.choice == 1) then
      help()
    elseif (game.pauseMode.choice == 2) then
    elseif (game.pauseMode.choice == 3) then
     reset()
    elseif (game.pauseMode.choice == 4) then
      love.event.push('q')
    end
  end
  -- B, return to main game
  if (key == control.B) then
    game.mode = 1
  end
end

-- process key releases during the settings screen
function settingsKeyReleased(key)
  if (key == control.up) then
    if (game.settingsMode.choice == 0) then
      return;
    else
      game.settingsMode.choice = game.settingsMode.choice - 1
    end
  elseif (key == control.down) then
    if (game.settingsMode.choice == 4) then
      return;
    else
      game.settingsMode.choice = game.settingsMode.choice + 1
    end
  end
  
  if (key == control.start) then
    if (game.settingsMode.choice == 0) then
      game.mode = gameMode.leveleditor
    end
  end
  
end

-- dingoo controls
function love.joystickreleased(joystick, button)
  if (game.mode == 0) then
    if (button == control.start) then
      game.mode = gameMode.main
    end
  end
end


-----------------
-- fire blocks --
-----------------

function fireGiveBlock()
 local give = {}
 give.x = player.x + (player.image:getWidth()/4)
 give.y = player.y - 10
 
 table.insert(player.give_blocks, give)
end

function fireTakeBlock()
  local take = {}
  take.x = player.x + (player.image:getWidth()/4)
  take.y = player.y - 10
  
  table.insert(player.take_blocks, take)
end

-- sets all of the blocks up/down/left/right of the index to 0
function activateGreenBlock(block_index)
  -- up
  if (levels.levels[game.level].start[block_index-14] ~= nil) then
    levels.levels[game.level].start[block_index-14] = 0
  end
  -- down
  if (levels.levels[game.level].start[block_index+14] ~= nil) then
    levels.levels[game.level].start[block_index+14] = 0
  end
  -- left
  if (levels.levels[game.level].start[block_index-1] ~= nil) then
    levels.levels[game.level].start[block_index-1] = 0
  end
  -- right
  if (levels.levels[game.level].start[block_index+1] ~= nil) then
    levels.levels[game.level].start[block_index+1] = 0
  end
end

-- sets all of the blocks up/down/left/right of the index to 1
function activateRedBlock(block_index)
  -- up
  if (levels.levels[game.level].start[block_index-14] ~= nil) then
    levels.levels[game.level].start[block_index-14] = 1
  end
  -- down
  if (levels.levels[game.level].start[block_index+14] ~= nil) then
    levels.levels[game.level].start[block_index+14] = 1
  end
  -- left
  if (levels.levels[game.level].start[block_index-1] ~= nil) then
    levels.levels[game.level].start[block_index-1] = 1
  end
  -- right
  if (levels.levels[game.level].start[block_index+1] ~= nil) then
    levels.levels[game.level].start[block_index+1] = 1
  end
end

--------------------
-- game functions --
--------------------

-- check collision with blocks
-- returns index of block if collision, 0 if no collision
function checkBlockCollision(bx, by)
  bx = math.floor(bx)
  by = math.floor(by)
  
  -- get the x coords of the hit block
  local modx = bx % 10
  bx = bx - modx
  bx = bx - 20
  modx = bx % 20
  bx = bx - modx
  xr = bx / 20
  xr = xr + 1
  
  -- get the y coords of the hit block
  local mody = by % 10
  by = by - mody
  mody = by % 20
  by = by - mody
  yr = by / 20
  yr = yr + 1
  
  -- get index
  local pos_index = ((yr - 1) * 14) + xr
  
  if (pos_index <= table.getn(levels.levels[game.level].start)) then
    return pos_index
  else
    return 0
  end
end

-- reset the game to start
function reset()
  game.mode = gameMode.start
  game.level = 0
  game.startMode.timer = 0
  game.startMode.show_start = true
  game.gameMode.main_game_mode = mainGameMode.help 
  game.gameMode.help_timer = 0
  
  -- reset all the levels
  for i=0,100 do
    if (levels.levels[i] ~= nil) then
      levels.levels[i].start = util.copyTable(levels.levels[i].reset)
    end
  end
end

-- move onto the next level
function nextLevel()
  game.level = game.level + 1

  game.gameMode.main_game_mode = mainGameMode.help 
  game.gameMode.help_timer = 0
  
  game.gameMode.complete_timer = 0
  
  if (levels.levels[game.level] ~= nil) then
    levels.levels[game.level].start = util.copyTable(levels.levels[game.level].reset)
  else
    reset()
  end
end

-- retry the current level
function retryLevel()
  game.gameMode.main_game_mode = mainGameMode.help 
  game.gameMode.help_timer = 0
  
  game.gameMode.complete_timer = 0
  levels.levels[game.level].start = util.copyTable(levels.levels[game.level].reset)
  
  -- reset the level timer
  levels.levels[game.level].timer_max = levels.levels[game.level].reset_timer
end

function help()
  -- want to return to the main game
  game.mode = gameMode.main
  -- display the help screen for 5 seconds
  game.gameMode.help_timer = 0
  game.gameMode.main_game_mode = mainGameMode.help

  levels.levels[game.level].timer_max = levels.levels[game.level].timer_max - 5
end

----------------------
-- useful functions --
----------------------

-- tidy up when quiting
function love.quit()
  --os.exit(0)
end


