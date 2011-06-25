require "string"

---------------------------------------------------------
-- a font library for the dingoo, as native has faults --
---------------------------------------------------------


-- creates a table of images from a font
-- ImageData source, String char_list, Number char_width, Number seperator_width
local function setFontImage(source, char_list, char_width, seperator_width)
  local font = {}
  font.char_width = char_width
  font.char_height = source:getHeight()
  font.seperator_width = seperator_width
  
  -- iterate through string and get correct image for each character
  for i=1, char_list:len() do
    -- get the single substr at i
    local char = char_list:sub(i, i)
    
    -- create new imagedata for char
    local char_data = love.image.newImageData(font.char_width, font.char_height)
    
    -- copy the section of the char image we want for this character
    local j = i -1
    local src_x = (j*char_width) + (i*seperator_width)
    char_data:paste(source, 0, 0, src_x, 0, font.char_height)
    
    font[char] = love.graphics.newImage(char_data)
  end
  
  return font
end

-- print the text at the selected x,y
-- returns true if displayed, false if not
local function dingPrint(font, text, x, y)
  -- iterate through each char and print
  for i=1, text:len() do
    local j = i -1
    -- set correct position
    local xpos = x + (j*font.char_width) + (j*font.seperator_width)
    -- get the correct character to display
    local char = text:sub(i, i)
    
    -- check if the char is in the table
    if (font[char] ~= nil) then
      love.graphics.draw(font[char], xpos, y, 0, 1, 1, 0, 0)
    else
      return false
    end 
    
  end
  
  return true
end

-- package
dingoo_font = {
	setFontImage = setFontImage,
	dingPrint = dingPrint,
}
