local screenWidth = 160;
local screenHeight = 144;
local screenScale = 3;
function love.load()
   love.window.setMode(screenWidth * screenScale, screenHeight * screenScale)
end
