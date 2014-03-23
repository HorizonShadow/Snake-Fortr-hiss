Mainmenu = {}

function Mainmenu:new(w, h)
   local m = {
      width = w,
      height = h
   }
   setmetatable(m, {__index = Mainmenu})
   return m
end

function Mainmenu:init()
   local frame = loveframes.Create("frame")
      :SetName("Main Menu")
      :Center()
      :SetDraggable(false)
      :SetScreenLocked(true)
      :ShowCloseButton(false)
      :SetHeight(self.height)
      :SetWidth(self.width)
      :SetResizable(false)
      :SetState("mainmenu")
      :SetSkin("Orange")
   local playButton = loveframes.Create("button", frame)
      :SetText("Play")
      :SetPos(200, 200)
      :CenterX()
   local storeButton = loveframes.Create("button", frame)
      :SetText("Store")
      :SetPos(200, 250)
      :CenterX()
   local highscoreButton = loveframes.Create("button", frame)
      :SetText("Leaderboards")
      :SetPos(200, 300)
      :CenterX()
   local aboutButton = loveframes.Create("button", frame)
      :SetText("About")
      :SetPos(200, 350)
      :CenterX()
   playButton.OnClick = on_play_button_click
   storeButton.OnClick = on_store_button_click
   aboutButton.OnClick = on_about_button_click
   highscoreButton.OnClick = on_highscore_button_click
end


function on_highscore_button_click(object, x, y)

   loveframes.SetState("highscores")
end
function on_play_button_click(object, x, y)
   loveframes.SetState("reset")
end

function on_store_button_click(object, x, y)
   loveframes.SetState("store")
end

function on_about_button_click(object, x, y)
   loveframes.SetState("about")
end

return Mainmenu
