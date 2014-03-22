-- INDEXES START AT 1 FUCK

-- ** GLOBALS **
tile = { BORDER = "BR"}
-- ** END GLOBALS **

require("loveframes")
local Mainmenu = require("mainmenu")
local GameOverScreen = require("gameoverscreen")
local Snake = require("snake")
local Scoreboard = require("scoreboard")
local Chip = require("chip")
local world = {
   scale = 3,
   width = 160,
   height = 144,
   map = {}
}
local snake = nil
local sboard = nil
local chip = nil
local mainmenu = nil
local gameoverscreen = nil
local updateTimer = 0
local state = "mainmenu"

function love.load()
   loveframes.SetState("mainmenu")
   init()
   init_loveframes()
end

function init()
   init_window()
   init_graphics()
   init_classes()
   init_map()
   init_snake()
   chip:place_randomly(world)
end

function love.mousepressed(x, y, button)
   loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
   loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
   loveframes.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
   loveframes.keyreleased(key, unicode)
end

function love.textinput(text)
   loveframes.textinput(text)
end

function love.draw()
   sboard:draw()
   draw_map()
   loveframes.draw()
end

function love.update(dt)
   local state = loveframes:GetState()
   if state == "game" then
      snake:controls()
      sboard:update_time_since_last(dt)

      updateTimer = updateTimer + dt
      if updateTimer > 0.04 then
         if snake:touching(chip) then
            snake:increase_length()
            sboard:add_score()
            chip:place_randomly(world)
         end
         if snake:is_dead() then
            loveframes.SetState("gameover")
            reset()
         end
         snake:update(world)
         updateTimer = 0
      end
   else
      loveframes.update(dt)
      if state == "store" then

      elseif state == "mainmenu" then

      end
   end
end

function draw_snake_tile(x, y)
   love.graphics.setColor(166, 166, 166)
   love.graphics.circle("fill", (x - 1) * snake.width + snake.width / 2, (y - 1) * snake.height + snake.height / 2, snake.width / 2, 100)
   love.graphics.setColor(snake.color)
   love.graphics.circle("fill", (x - 1) * snake.width + snake.width / 2, (y - 1) * snake.height + snake.height / 2, snake.width / 4, 100)
end

function draw_background_tile(x, y)
   love.graphics.setColor(107, 107, 107)
   love.graphics.rectangle("fill", (x-1) * snake.width, (y-1) * snake.height, snake.width, snake.height)
   love.graphics.setColor(0, 0, 0)
   love.graphics.rectangle("fill", ((x-1) * snake.width) + (snake.width / 4), ((y-1) * snake.height) + (snake.height / 4), snake.width / 2, snake.height / 2)
end
function init_snake()
   world.map[snake.x][snake.y] = 1
end

function draw_map()
   chip:draw()
   for i = 1, #world.map do
      for j = 1, #world.map[1] do
         if type(world.map[i][j]) == "table" then
            -- do nothing
         elseif world.map[i][j] == tile.BORDER then
            draw_background_tile(i, j)
         elseif world.map[i][j] > 0 then
            draw_snake_tile(i, j)
         end
         if world.map[i][j] ~= 0 then
         end
      end
   end
end

function print_map()
   for j = 1, #world.map[1] do
      for i = 1, #world.map do
         io.write(world.map[i][j])
      end
      print("")
   end
end

function init_loveframes()
   mainmenu:init()
   gameoverscreen:init()
end

function init_window()
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scale)
end

function init_graphics()
   love.graphics.setBackgroundColor(255,255,255)
end

function init_classes()
   sboard = Scoreboard:new(0, 130 * world.scale, world.width * world.scale, 14 * world.scale)
   snake = Snake:new(16, 24, 5 * world.scale, 5 * world.scale, {0, 0, 0})
   chip = Chip:new(0, 0, 5 * world.scale, 5 * world.scale)
   mainmenu = Mainmenu:new(world.width * world.scale, world.height * world.scale)
   gameoverscreen = GameOverScreen:new(world.width * world.scale, world.height * world.scale)
end

function init_map()
   local mapWidth = (world.width / snake.width) * world.scale
   local mapHeight = ((world.height * world.scale - sboard.height) / snake.width)
   for i = 1, mapWidth do
      world.map[i] = {}
      for j = 1, mapHeight do
         if (j == 1)
         or (j == mapHeight)
         or (i == 1)
         or (i == mapWidth) then
            world.map[i][j] = tile.BORDER
         else
            world.map[i][j] = 0
         end
      end
   end
end

function reset()
   init()
end
