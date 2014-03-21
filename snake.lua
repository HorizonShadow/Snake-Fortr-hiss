Snake = {}

function Snake:new(world, x, y)
   local s = {
      world = world,
      x = x,
      y = y
   }
   setmetatable(s, {__index = Snake})
   return s
end
