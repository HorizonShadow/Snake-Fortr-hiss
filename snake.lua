Snake = {}

function Snake:new(world, x, y, color)
   local s = {
      world = world,
      color = color,
      width = 10 * world.scale,
      height = 10 * world.scale,
      x = x,
      y = y
   }
   setmetatable(s, {__index = Snake})
   return s
end
