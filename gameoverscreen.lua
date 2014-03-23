GameOverScreen = {}

function GameOverScreen:new(w, h)
   local g = {
      width = w,
      height = h,
      score = 0,
      scoreText = nil
   }
   setmetatable(g, {__index = GameOverScreen})
   return g
end

function GameOverScreen:make(s)
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

   local nameInput = loveframes.Create("textinput", frame)
      :SetPos(100, 100)
      :SetWidth(200)
   local scoreText = loveframes.Create("text", frame)
      :SetPos(100, 150)
      :SetText(s)
   local submitHighscore = loveframes.Create("button", frame)
      :SetPos(100, 175)
   submitHighscore.OnClick =
      function(object, x, y)
         submit_highscore(s, nameInput:GetText())
      end
   playButton.OnClick = on_play_button_click
   storeButton.OnClick = on_store_button_click
   mainMenuButton.OnClick = on_main_menu_button_click
end

function submit_highscore(score, name)
   print("working")
   local http = require("socket.http")
   local ltn12 = require("ltn12")
   print(http)
   local reqbody = "name="..name.."&score="..score
   local respbody = {} -- for the response body

   local result, respcode, respheaders, respstatus = http.request {
      method = "POST",
      url = "http://obscure-spire-3612.herokuapp.com/submit",
      source = ltn12.source.string(reqbody),
      headers = {
         ["content-type"] = "application/x-www-form-urlencoded",
         ["content-length"] = tostring(#reqbody)
      },
      sink = ltn12.sink.table(respbody)
   }
   -- get body as string by concatenating table filled by sink
   respbody = table.concat(respbody)
   print("respbody", respcode)
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
