local Snake = require("snake")
local world = {
   scale = 3,
   width = 160,
   height = 144,
   map = {}
}
local snake = nil
function love.load()
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scale)
   love.graphics.setBackgroundColor(255,255,255)
   for i = 1, world.width do
      world.map[i] = {}
      for j = 1, world.height do
         world.map[i][j] = 0
      end
   end
   snake = Snake:new(world, 6, 6, {0, 0, 0})
end

function love.draw()
   for i = 1, world.width do
      for j = 1, world.height do
         if world.map[i][j] > 0 then
            love.graphics.setColor(snake.color)
            love.graphics.rectangle("fill", i * snake.width, j * snake.height, snake.width, snake.height)
            love.graphics.setColor(255, 255, 255)
            love.graphics.rectangle("line", i, j, snake.width, snake.height)
         end
      end
   end
end
