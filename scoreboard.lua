Scoreboard = {}

function Scoreboard:new(x, y, w, h, color)
   local s = {
      x = x,
      y = y,
      width = w,
      height = h,
      score = 0,
      food = 0,
      hiScore = 0,
      time_since_last = 0
   }
   setmetatable(s, {__index = Scoreboard})
   return s
end

function Scoreboard:reset()
   self.score = 0
   self.hiscore = 0
   self.time_since_last = 0
   self.food = 0
end

function Scoreboard:update_time_since_last(t)
   self.time_since_last = self.time_since_last + t
end

function Scoreboard:add_score()
   self.score = self.score + (100 / self.time_since_last)
end

function Scoreboard:draw()
   love.graphics.setColor(166, 166, 166)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   love.graphics.setColor(0,0,0)
   love.graphics.print("score: "..self.score, self.x, self.y)
   love.graphics.setColor(love.graphics.getBackgroundColor())
end
return Scoreboard
