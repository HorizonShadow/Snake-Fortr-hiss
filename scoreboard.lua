Scoreboard = {}

function Scoreboard:new(x, y, w, h, color)
   local s = {
      x = x,
      y = y,
      width = w,
      height = h,
      score = 0,
      food = 0,
      hiScore = 0
   }
   setmetatable(s, {__index = Scoreboard})
   return s
end

function Scoreboard:draw()
   love.graphics.setColor(166, 166, 166)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   love.graphics.setColor(0,0,0)
   love.graphics.print("score: "..self.score, self.x, self.y)
   love.graphics.setColor(love.graphics.getBackgroundColor())
end
return Scoreboard
