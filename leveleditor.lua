


local levelEditMode = {
	pattern  = 1,
	starting = 2
}
local editorChoice = levelEditMode.pattern

-----------------------------------
-- Level editor update functions --
-----------------------------------

local function update(dt)
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

function keyReleased(key)
end


-- package
leveleditor = {
	draw = draw,
	update = update
	
}