Chip = {}

function Chip:new(x, y, w, h)
   local c = {
      x = x or 0,
      y = y or 0,
      width = w or 0,
      height = h or 0
   }
   setmetatable(c, {__index = Chip})
   return c
end

function Chip:place_randomly(world)
   math.randomseed(os.time())
   self.x = math.random(2, #world.map-1)
   self.y = math.random(2, #world.map[1]-1)
   world.map[self.x][self.y] = self
   print(self.x, self.y)
end

function Chip:draw()
   love.graphics.setColor(91, 91, 91)
   love.graphics.circle("fill", (self.x - 1) * self.width + self.width / 2, (self.y - 1) * self.height + self.height / 2, self.width / 2, 100)
   love.graphics.setColor(0, 0, 0)
   love.graphics.circle("fill", (self.x - 1) * self.width + self.width / 2, (self.y - 1) * self.height + self.height / 2, self.width / 4, 100)
end

return Chip
