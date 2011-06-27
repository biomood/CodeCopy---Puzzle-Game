require "menu"

-- menu select
local editorMode = {
	menu 	  = 1,
	editor 	  = 2,
	select 	  = 3,
	userLevel = 4
}
local editorMode = editorMode.menu

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

local function update(dt)
end 

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

---------------------------------
-- Level editor draw functions --
---------------------------------

local function draw()
end

-- draw the menu 
local function drawMenu()
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