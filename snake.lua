Snake = {}
local direction = {
   UP = {x = 0, y = -1},
   DOWN = {x = 0, y = 1},
   LEFT = {x = -1, y = 0},
   RIGHT = {x = 1, y = 0}
}
function Snake:new(x, y, w, h, color)
   local s = {
      color = color,
      width = w,
      height = h,
      direction = direction.UP,
      length = 1,
      x = x,
      y = y
   }
   setmetatable(s, {__index = Snake})
   return s
end

function Snake:update(world)
   self:increment(world)
   self:move(world)
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
function Snake:increment(world)
   for i = 1, #world.map do
      for j = 1, #world.map[1] do
         if world.map[i][j] == self.length then
            world.map[i][j] = 0
         elseif type(world.map[i][j]) ~= "string"
         and type(world.map[i][j]) ~= "table"
         and world.map[i][j] > 0 then
            world.map[i][j] = world.map[i][j] + 1
         end
      end
   end
end

function Snake:touching(chip)
   return self.x == chip.x and self.y == chip.y
end

function Snake:increase_length()
   self.length = self.length + 4
end

function Snake:move(world) --can move over anything but
   local nextPos = world.map[self.x + self.direction.x][self.y + self.direction.y]
   if nextPos == 0
   or type(nextPos) == "table" then
      self.x = self.x + self.direction.x
      self.y = self.y + self.direction.y
   end
   world.map[self.x][self.y] = 1
end

return Snake
