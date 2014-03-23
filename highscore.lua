Highscore = {}

function Highscore:new(w, h)
   local h = {
      width = w,
      height = h,
      visible = false
   }
   setmetatable(h, {__index = Highscore})
   return h
end

function Highscore:display()

   local scores = get_scores()

   local frame = loveframes.Create("frame")
      :SetName("Leaderboard")
      :Center()
      :SetDraggable(false)
      :SetScreenLocked(true)
      :ShowCloseButton(false)
      :SetHeight(self.height)
      :SetWidth(self.width)
      :SetResizable(false)
      :SetState("highscores")
      :SetSkin("Orange")
   local scoreGrid = loveframes.Create("grid", frame)
      :SetPos(70, 30)
      :SetColumns(1)
      :SetRows(#scores)
      :SetCellHeight(25)
      :SetCellWidth(self.width - 85)
      :SetCellPadding(5)
      :SetItemAutoSize(true)
   local numberGrid = loveframes.Create("grid", frame)
      :SetPos(5, 30)
      :SetColumns(1)
      :SetCellWidth(50)
      :SetRows(#scores)
      :SetCellHeight(25)
      :SetCellPadding(5)
      :SetItemAutoSize(true)

   local backButton = loveframes.Create("button", frame)
      :SetPos(5, self.height - 30)
      :SetText("Main Menu")
   backButton.OnClick = on_back_button_click

   for i = 1, #scores do
      local num = loveframes.Create("text")
         :SetState("highscores")
         :SetText(i)
      local panel = loveframes.Create("panel")
         :SetState("highscores")
      local name = loveframes.Create("text", panel)
         :SetText(scores[i].name)
         :SetPos(5, 5)
         :SetFont(love.graphics.newFont(18))
      local score = loveframes.Create("text", panel)
         :SetText(scores[i].score)
         :SetPos(300, 5)
         :SetFont(love.graphics.newFont(17))
      numberGrid:AddItem(num, i, 1)
      scoreGrid:AddItem(panel, i, 1)
   end
end

function on_back_button_click(object, x, y)
   loveframes.SetState("mainmenu")
end

function get_scores()
   local http = require("socket.http")
   local result, respcode, respheaders, respstatus = http.request("http://obscure-spire-3612.herokuapp.com/topten")
   return loadstring("return "..result)()
end

return Highscore
