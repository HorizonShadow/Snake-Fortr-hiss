-- INDEXES START AT 1 FUCK

local Snake = require("snake")
local Scoreboard = require("scoreboard")
local tile = { BORDER = "BR", CHIP = "CH"}
local world = {
   scale = 3,
   width = 160,
   height = 144,
   map = {}
}
local snake = nil
local sboard = nil
local updateTimer = 0



function love.load()
   init_window()
   init_graphics()
   init_classes()
   init_map()
   place_snake_head()
   place_starting_chip()
end

function love.draw()
   sboard:draw()
   draw_map()
end

function love.update(dt)
   snake:controls()

   updateTimer = updateTimer + dt
   if updateTimer > 0.05 then
      world.map = snake:update()
      updateTimer = 0
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

function place_starting_chip()
   --pick random x,y. Place tile.CHIP
end

function place_snake_head()
   world.map[snake.x][snake.y] = 1
end

function draw_map()
   for i = 1, #world.map do
      for j = 1, #world.map[1] do
         if world.map[i][j] == tile.BORDER then
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

function init_window()
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scale)
end

function init_graphics()
   love.graphics.setBackgroundColor(255,255,255)
end

function init_classes()
   sboard = Scoreboard:new(0, 130 * world.scale, world.width * world.scale, 14 * world.scale)
   snake = Snake:new(world, 6, 6, {0, 0, 0})
end

function init_map()
   local mapWidth = world.width / snake.width * world.scale
   local mapHeight = ((world.height - sboard.height / world.scale) / snake.height * world.scale)
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
