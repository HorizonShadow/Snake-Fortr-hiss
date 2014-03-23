About = {}

function About:new(w, h)
   local a = {
      width = w,
      height = h
   }
   setmetatable(a, {__index = About})
   return a
end

function About:init()
   local info = [[
                           Created for the BaconGameJam 07
    Completed in its entirety between March 21st and March 23rd 2014

                                    Author: Joshua LeBlanc

                                       Special thanks to:

                                 Kenny Shields (loveframes)
                                       Robin Wellner (Ser)
                           LÖVE Development Team (LÖVE2D)
                                    Stacy Metivier (Sound)



                                                Links:

                              Ser: https://github.com/gvx/Ser
         loveframes: http://nikolairesokav.com/projects/loveframes
                           LÖVE2D: http://www.love2d.org
   ]]
   local frame = loveframes.Create("frame")
      :SetSize(self.width, self.height)
      :SetState("about")
      :Center()
      :SetDraggable(false)
      :SetScreenLocked(true)
      :ShowCloseButton(false)
      :SetResizable(false)
      :SetSkin("Orange")

   local generalInfo = loveframes.Create("text", frame)
      :SetPos(0, 30)
      :SetLinksEnabled(true)
      :SetDetectLinks(true)
      :SetText(info)
      :CenterX()
   generalInfo.OnClickLink = open_url

   local backButton = loveframes.Create("button", frame)
      :SetPos(0, 350)
      :SetText("Main Menu")
      :CenterX()
   backButton.OnClick = on_back_button_click
end

function on_back_button_click(object, x, y)
   loveframes.SetState("mainmenu")
end

-- Attempts to open a given URL in the system default browser, regardless of Operating System.
local open_cmd -- this needs to sta outside the function, or it'll re-sniff every time...
function open_url(obj, url)
   url = string.gsub(url, " ", "")
   if not open_cmd then
      if package.config:sub(1,1) == '\\' then -- windows
         open_cmd = function(url)
         -- Should work on anything since (and including) win'95
            os.execute(string.format('start "%s"', url))
         end
        -- the only systems left should understand uname...
      elseif (string.gsub(io.popen("uname -s"):read'*a', "\n$", "")) == "Darwin" then -- OSX/Darwin ? (I can not test.)
         open_cmd = function(url)
            -- I cannot test, but this should work on modern Macs.
            os.execute(string.format('open "%s"', url))
         end
      else -- that ought to only leave Linux
         open_cmd = function(url)
            -- should work on X-based distros.
            os.execute(string.format('xdg-open "%s"', url))
         end
      end
    end

    open_cmd(url)
   end
return About
