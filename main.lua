-- INDEXES START AT 1 FUCK

local Snake = require("snake")
local Scoreboard = require("scoreboard")
local tile = { BORDER = "BR"}
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
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scale)
   love.graphics.setBackgroundColor(255,255,255)

   sboard = Scoreboard:new(0, 130 * world.scale, world.width * world.scale, 14 * world.scale)
   snake = Snake:new(world, 6, 6, {0, 0, 0})

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
   print(#world.map[1], #world.map)
   world.map[snake.x][snake.y] = 1
end

function love.draw()
   sboard:draw()
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

function love.update(dt)
   snake:controls()

   updateTimer = updateTimer + dt
   if updateTimer > 0.05 then
      os.execute("clear")
      world.map = snake:update()
      print_map()
      updateTimer = 0
   end
end
function draw_snake_tile(x, y)
   love.graphics.setColor(snake.color)
   love.graphics.rectangle("fill", (x-1) * snake.width, (y-1) * snake.height, snake.width, snake.height)
end
function draw_background_tile(x, y)
   borderColor = {166, 166, 166}
   fillColor = {0, 0, 0}
   love.graphics.setColor(107, 107, 107)
   love.graphics.rectangle("fill", (x-1) * snake.width, (y-1) * snake.height, snake.width, snake.height)
   love.graphics.setColor(0, 0, 0)
   love.graphics.rectangle("fill", ((x-1) * snake.width) + (snake.width / 4), ((y-1) * snake.height) + (snake.height / 4), snake.width / 2, snake.height / 2)
end

function print_map()
   for j = 1, #world.map[1] do
      for i = 1, #world.map do
         io.write(world.map[i][j])
      end
      print("")
   end
end
