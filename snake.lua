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

function Snake:draw()
   love.graphics.setColor(self.color)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   love.graphics.setColor(love.graphics.getBackgroundColor())
end
