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

function Snake:update()
   self:increment()
   self:move()
end

function Snake:increment()
   for i = 1, self.world.width do
      for j = 1, self.world.height do
         if self.world.map[i][j] == self.length then
            self.world.map[i][j] = 0
         elseif self.world.map[i][j] > 0 then
            self.world.map[i][j] = self.world.map[i][j] + 1
         end
      end
   end
end

function Snake:move()
   if self.direction == direction.UP then
      if self.world.map[self.x][self.y-1] > 0 then
         self.world.map[self.x][self.y-1] = 1
      end
   end
end

return Snake
