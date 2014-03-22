Chip = {}

function Chip:new(x, y)
   local c = {
      x = x or 0,
      y = y or 0
   }
   setmetatable(c, {__index = Chip})
   return c
end

function Chip:place_randomly(world)
   self.x = math.random(1, #world.map[1])
   self.y = math.random(1, #world.map)
   world.map[self.x][self.y] = self
end

return Chip
