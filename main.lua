-- INDEXES START AT 1 FUCK

local Snake = require("snake")
local world = {
   scale = 3,
   width = 160,
   height = 144,
   map = {}
}
local snake = nil
local updateTimer = 0
local scoreHeight = 14
function love.load()
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scale)
   love.graphics.setBackgroundColor(255,255,255)
   snake = Snake:new(world, 6, 6, {0, 0, 0})
   local mapWidth = world.width / snake.width * world.scale
   local mapHeight = ((world.height - scoreHeight) / snake.height * world.scale)
   for i = 1, mapWidth do
      world.map[i] = {}
      for j = 1, mapHeight do
         world.map[i][j] = 0
      end
   end
   print(#world.map[1], #world.map)
   world.map[snake.x][snake.y] = 1
end

function love.draw()
   for i = 1, #world.map do
      for j = 1, #world.map[1] do
         if world.map[i][j] > 0 then
            love.graphics.setColor(snake.color)
            love.graphics.rectangle("fill", i * snake.width, j * snake.height, snake.width, snake.height)
            love.graphics.setColor(255, 255, 255)
            love.graphics.rectangle("line", i, j, snake.width, snake.height)
         end
      end
   end
end

function love.update(dt)
   updateTimer = updateTimer + dt
   if updateTimer > 1 then
      os.execute("clear")
      world.map = snake:update()
      print_map()
      updateTimer = 0
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
