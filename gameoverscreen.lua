GameOverScreen = {}

function GameOverScreen:new(w, h)
   local g = {
      width = w,
      height = h
   }
   setmetatable(g, {__index = GameOverScreen})
   return g
end

function GameOverScreen:init()
   local frame = loveframes.Create("frame")
      :SetName("Game Over")
      :Center()
      :SetDraggable(false)
      :SetScreenLocked(true)
      :ShowCloseButton(false)
      :SetHeight(self.height)
      :SetWidth(self.width)
      :SetResizable(false)
      :SetState("gameover")
      :SetSkin("Orange")
   local playButton = loveframes.Create("button", frame)
      :SetText("Play Again")
      :SetPos(200, 200)
   local storeButton = loveframes.Create("button", frame)
      :SetText("Store")
      :SetPos(200, 250)
   local mainMenuButton = loveframes.Create("button", frame)
      :SetText("Main Menu")
      :SetPos(200, 350)
   playButton.OnClick = on_play_button_click
   storeButton.OnClick = on_store_button_click
   mainMenuButton.OnClick = on_main_menu_button_click
end

function on_play_button_click()
   loveframes.SetState("game")
end

function on_store_button_click()
   loveframes.SetState("store")
end

function on_main_menu_button_click()
   loveframes.SetState("mainmenu")
end

return GameOverScreen
