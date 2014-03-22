-- ** GLOBALS **
tile = { BORDER = "BR"}
require("loveframes")
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

local itemImages = {
   love.graphics.newImage("lib/bunny-ears.png"),
   love.graphics.newImage("lib/bunny-hat.png"),
   love.graphics.newImage("lib/black-top-hat.png"),
   love.graphics.newImage("lib/cowbow-hat.png"),
   love.graphics.newImage("lib/red-hat.png"),
   love.graphics.newImage("lib/slime-hat.png")
}

local updateTimer = 0
local prevStats = 0

function love.load()
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
   end
   loveframes.draw()
end

function love.update(dt)
   local state = loveframes:GetState()
   if state == "game" then
      snake:controls()
      sboard:update_time_since_last(dt)
      updateTimer = updateTimer + dt
      if updateTimer > .04 then
         if snake:touching(chip) then
            snake:increase_length()
            sboard:add_score()
            chip:place_randomly(world)
         end
         if snake:is_dead() then
            loveframes.SetState("gameover")
            save_stats()
            reset()
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
            draw_snake_hats(i, j)
         end
         if world.map[i][j] ~= 0 then
         end
      end
   end
end

function print_map()
   for j = 1, #world.map[1] do
      for i = 1, #world.map do
         io.write(world.map[i][j])
      end
      print("")
   end
end

function init_loveframes()
   mainmenu:init()
   gameoverscreen:init()
   store:init()
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

   if file then
      items = file.items
   else
      prevStats = 0
      create_save_file()
      items = {
         Item:new("lib/bunny-ears.png", 2500, "Marvelous bunny ears suitable for any occaision", "Blarget"),
         Item:new("lib/bunny-hat.png", 3000, "Sometimes you just need a living creature on your head", "Blarget"),
         Item:new("lib/black-top-hat.png", 4500, "The classiest of snake hats", "Blarget"),
         Item:new("lib/cowbow-hat.png", 7000, "Yee-haw!", "Blarget"),
         Item:new("lib/red-hat.png", 10000, "I don't even know what this is", "Blarget"),
         Item:new("lib/slime-hat.png", 15000, "Prepared to be slimed!", "Blarget")
      }
   end
   print(items)
   store = Store:new(world.width, world.height, items, prevStats)
   print(store.items[1].image)

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
