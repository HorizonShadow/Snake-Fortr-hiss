local Snake = require("snake")
local world = {
   scale = 3,
   width = 160,
   height = 144,
   map = {}
}
function love.load()
   love.window.setTitle("Team Fortr-hissss")
   love.window.setMode(world.width * world.scale, world.height * world.scle)
   for i = 1, world.width do
      world.map[i] = {}
      for j = 1, world.height do
         world.map[i][j] = 0
      end
   end
end
