Snake = {}
local direction = { UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}
function Snake:new(world, x, y, color)
   local s = {
      world = world,
      color = color,
      width = 10 * world.scale,
      height = 10 * world.scale,
      direction = direction.UP,
      length = 1,
      x = x,
      y = y
   }
   world.map[x][y] = 1
   setmetatable(s, {__index = Snake})
   return s
end
return Snake
