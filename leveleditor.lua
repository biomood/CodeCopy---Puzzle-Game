require "menu"

-- menu select
local editorMode = {
	menu 	  = 1,
	editor 	  = 2,
	select 	  = 3,
	userLevel = 4
}
local editorModeChoice = editorMode.menu

-- in editor
local inEditMode = {
	pattern  = 1,
	starting = 2
}
local inEditChoice = inEditMode.pattern

-- menu for the editor 
local menu = menu.createMenu({"NEW", "PLAY", "EDIT", "BACK"})

local function initLevelEditor()
  
end


-----------------------------------
-- Level editor update functions --
-----------------------------------

-- update the menu
local function updateMenu(dt)
end

-- update the editor
local function updateLevelEditor(dt)
end

-- update the level menu
local function updateLevelSelect(dt)
end

-- update the current user level in play
local function updateUserLevel()
end

-- general update function
local function update(dt)
  if (editorModeChoice == editorMode.menu) then
    updateMenu(dt)
  elseif (editorModeChoice == editorMode.editor) then
  elseif (editorModeChoice == editorMode.select) then
  elseif (editorModeChoice == editorMode.userLevel) then
  end
end 


---------------------------------
-- Level editor draw functions --
---------------------------------

-- draw the menu 
local function drawMenu()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", 90, 20, 140, 200)
  dingoo_font.dingPrint(font_normal, 'NEW', 123, 35)
  dingoo_font.dingPrint(font_normal, 'PLAY', 123, 69)
  dingoo_font.dingPrint(font_normal, 'EDIT', 123, 103)
  dingoo_font.dingPrint(font_normal, 'BACK', 123, 137)
end

-- draw the level editor
local function drawLevelEditor()
end

-- draw the select menu level
local function drawLevelSelect()
end

-- draw the user level in play
local function drawUserLevel()
end

-- general draw function
local function draw()
  if (editorModeChoice == editorMode.menu) then
    drawMenu()
  elseif (editorModeChoice == editorMode.editor) then
  elseif (editorModeChoice == editorMode.select) then
  elseif (editorModeChoice == editorMode.userLevel) then
  end
end

--------------------------
-- Level file functions --
--------------------------

-- save the current level in editor with level name
local function saveLevel(levelName)
end

-- load the level with given level name
local function loadLevel(levelName)
end

-- return a list of all user created levels
local function getAllLevels()
end

-------------------------------------
-- level editor keyboard functions --
-------------------------------------

local function keyReleased(key)
end


-- package
leveleditor = {
	draw = draw,
	update = update,
	keyReleased = keyReleased
}