-- ** GLOBALS **
tile = { BORDER = "BR"}
require("loveframes")
boop = love.audio.newSource("lib/boop.wav")
buysomething = love.audio.newSource("lib/buysomething.wav")
entergame = love.audio.newSource("lib/openstore.wav")
enterstore = love.audio.newSource("lib/enterstore.wav")
exitstore = love.audio.newSource("lib/exitstore.wav")
losegame = love.audio.newSource("lib/losegame.wav")
openstore = love.audio.newSource("lib/openstore.wav", "static")
sellsomething = love.audio.newSource("lib/sellsomething.wav")


musics = {
   love.audio.newSource("lib/mus1.mp3"),
   love.audio.newSource("lib/mus2.mp3"),
   love.audio.newSource("lib/mus3.mp3"),
   love.audio.newSource("lib/mus4.mp3"),
   love.audio.newSource("lib/mus5.mp3")
}
backgroundMusic = nil
-- ** END GLOBALS **

-- ** REQUIRES **
local Item = require("item")
local ser = require("ser")
local Mainmenu = require("mainmenu")
local Store = require("store")
local GameOverScreen = require("gameoverscreen")
local Snake = require("snake")
local Scoreboard = require("scoreboard")
local Chip = require("chip")
local Highscore = require('highscore')
local About = require('about')
-- ** END REQUIRES

local world = {
   width = love.window.getWidth(),
   height = love.window.getHeight(),
   map = {}
}
local snake = nil
local sboard = nil
local chip = nil
local mainmenu = nil
local gameoverscreen = nil
local store = nil
local highscore = nil
local about = nil

local itemImages = {
   love.graphics.newImage("lib/bunny-ears.png"),
   love.graphics.newImage("lib/cowbow-hat.png"),
   love.graphics.newImage("lib/red-hat.png"),
   love.graphics.newImage("lib/slime-hat.png"),
   love.graphics.newImage("lib/black-top-hat.png"),
   love.graphics.newImage("lib/bunny-hat.png")
}

local updateTimer = 0
local prevStats = 0

function love.load()
   entergame:setVolume(.5)
   losegame:setVolume(.5)
   boop:setVolume(.5)
   play_random_background_music()
   entergame:setPitch(2)
   boop:setPitch(2)
   loveframes.SetState("mainmenu")
   init()
end

function love.quit()
   save_stats()
end

function love.mousepressed(x, y, button)
   loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
   loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
   loveframes.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
   loveframes.keyreleased(key, unicode)
end

function love.textinput(text)
   loveframes.textinput(text)
end

function love.draw()

   if loveframes:GetState() == "game" then
      sboard:draw()
      draw_map()
   elseif loveframes:GetState() == "highscores" then
      if not highscore.visible then
         highscore:display()
         highscore.visible = true
      end
   end
   loveframes.draw()

end

function love.update(dt)
   if not backgroundMusic:isPlaying() then
      play_random_background_music()
   end
   local state = loveframes:GetState()
   if state == "reset" then
      entergame:rewind()
      entergame:play()
      save_stats()
      reset()
   end
   if state == "game" then
      snake:controls()
      sboard:update_time_since_last(dt)
      updateTimer = updateTimer + dt
      if updateTimer > .04 then
         if snake:touching(chip) then
            boop:rewind()
            boop:play()
            snake:increase_length()
            sboard:add_score()
            chip:place_randomly(world)
         end
         if snake:is_dead() then
            losegame:rewind()
            losegame:play()
            gameoverscreen:SetScore(sboard.score)
            loveframes.SetState("gameover")
         end
         snake:update(world)
         updateTimer = 0
      end
   else
      loveframes.update(dt)
   end
end

function init()
   init_graphics()
   init_classes()
   init_map()
   init_snake()
   chip:place_randomly(world)
   init_loveframes()
end

function draw_snake_hats(x, y)
   love.graphics.setColor(255,255,255)
   local offset = 0
   for i = 1, #store.items do
      if store.items[i].bought then
         love.graphics.draw(itemImages[i], ((x - 1.5) * snake.width + snake.width / 2), ((y - 2) * snake.height + snake.height / 2) + offset)
         offset = offset - 12
      end
   end
end

function draw_background_tile(x, y)
   love.graphics.setColor(107, 107, 107)
   love.graphics.rectangle("fill", (x-1) * snake.width, (y-1) * snake.height, snake.width, snake.height)
   love.graphics.setColor(0, 0, 0)
   love.graphics.rectangle("fill", ((x-1) * snake.width) + (snake.width / 4), ((y-1) * snake.height) + (snake.height / 4), snake.width / 2, snake.height / 2)
end

function init_snake()
   world.map[snake.x][snake.y] = 1
end

function draw_map()
   chip:draw()
   for i = 1, #world.map do
      for j = 1, #world.map[1] do
         if type(world.map[i][j]) == "table" then
            -- do nothing
         elseif world.map[i][j] == tile.BORDER then
            draw_background_tile(i, j)
         elseif world.map[i][j] > 0 then
            snake:draw(i, j)
            if world.map[i][j] == 1 then
               draw_snake_hats(i, j)
            end
         end
         if world.map[i][j] ~= 0 then
         end
      end
   end
end


function init_loveframes()
   mainmenu:init()
   store:init()
   gameoverscreen:init()
   about:init()
end

function init_graphics()
   love.graphics.setBackgroundColor(255,255,255)
end

function init_classes()
   local file = load_prev_stats()
   local items = {}

   sboard = Scoreboard:new(0, 390, world.width, 42)
   snake = Snake:new(16, 24, 15, 15, {0, 0, 0})
   chip = Chip:new(0, 0, 15, 15)
   mainmenu = Mainmenu:new(world.width, world.height)
   gameoverscreen = GameOverScreen:new(world.width, world.height)
   highscore = Highscore:new(world.width, world.height)
   about = About:new(world.width, world.height)
   if file then
      items = file.items
   else
      prevStats = 0
      create_save_file()
      items = {
         Item:new("lib/bunny-ears.png", 1000, "Marvelous bunny ears suitable for any occaision", "Blarget"),
         Item:new("lib/cowbow-hat.png", 5000, "Yee-haw!", "Blarget"),
         Item:new("lib/red-hat.png", 7500, "I don't even know what this is", "Blarget"),
         Item:new("lib/slime-hat.png", 10000, "Prepared to be slimed!", "Blarget"),
         Item:new("lib/black-top-hat.png", 15000, "The classiest of snake hats", "Blarget"),
         Item:new("lib/bunny-hat.png", 20000, "Sometimes you just need a living creature on your head", "Blarget")
      }
   end
   store = Store:new(world.width, world.height, items, prevStats)

end

function init_map()
   local mapWidth = world.width / snake.width
   local mapHeight = ((world.height - sboard.height) / snake.width)
   for i = 1, mapWidth do
      world.map[i] = {}
      for j = 1, mapHeight do
         if (j == 1)
         or (j == mapHeight)
         or (i == 1)
         or (i == mapWidth) then
            world.map[i][j] = tile.BORDER
         else
            world.map[i][j] = 0
         end
      end
   end
end

function reset()
   init()
   loveframes.SetState("game")
end

function play_random_background_music()
   math.randomseed(os.time())
   backgroundMusic = musics[math.random(1,5)]
   backgroundMusic:play()
end
function create_save_file()
   local save = io.open("snake.sav", "w")
   save:write(ser({
      score = 0,
      items = items
   }))
   save:close()
   return { score = 0 }
end

function save_stats()
   local file = io.open("snake.sav", "w")
   if file then
      file:write(ser({
         score = store.points + sboard.score,
         items = store.items
      }))
   end
   file:close()
end

function load_prev_stats()
   local file = io.open("snake.sav", "r")
   if file then
      local stats = loadstring(file:read("*a"))()
      file:close()
      if stats then
         prevStats = stats.score
         return stats
      end
   end
   return nil
end
