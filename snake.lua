Snake = {}
local direction = { UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}
function Snake:new(world, x, y, color)
   local s = {
      world = world,
      color = color,
      width = 5 * world.scale,
      height = 5 * world.scale,
      direction = direction.UP,
      length = 1,
      x = x,
      y = y
   }
   setmetatable(s, {__index = Snake})
   return s
end

function Snake:update()
   self:increment()
   self:move()
   return self.world.map
end

function Snake:controls()
   if love.keyboard.isDown("d") and self.direction ~= direction.LEFT then
      self.direction = direction.RIGHT
   elseif love.keyboard.isDown("w") and self.direction ~= direction.DOWN then
      self.direction = direction.UP
   elseif love.keyboard.isDown("a") and self.direction ~= direction.RIGHT then
      self.direction = direction.LEFT
   elseif love.keyboard.isDown("s") and self.direction ~= direction.UP then
      self.direction= direction.DOWN
   end
end
function Snake:increment()
   for i = 1, #self.world.map do
      for j = 1, #self.world.map[1] do
         if self.world.map[i][j] == self.length then
            self.world.map[i][j] = 0
         elseif type(self.world.map[i][j]) ~= "string" and self.world.map[i][j] > 0 then
            self.world.map[i][j] = self.world.map[i][j] + 1
         end
      end
   end
end

function Snake:move()
   if self.direction == direction.UP and self.world.map[self.x][self.y - 1] == 0 then
      self.y = self.y - 1
   elseif self.direction == direction.DOWN and self.world.map[self.x][self.y + 1] == 0 then
      self.y = self.y + 1
   elseif self.direction == direction.LEFT and self.world.map[self.x - 1][self.y] == 0 then
      self.x = self.x - 1
   elseif self.direction == direction.RIGHT and self.world.map[self.x + 1][self.y] == 0 then
      self.x = self.x + 1
   end
   self.world.map[self.x][self.y] = 1
end

return Snake
