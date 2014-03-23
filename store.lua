Store = {}

function Store:new(w, h, items, points)
   local s = {
      width = w,
      height = h,
      items = items,
      points = points or 0,
      pointsText = nil
   }
   print("updaed store points: ".. s.points)
   setmetatable(s, {__index = Store})
   return s
end

function Store:add_points(p)
   self.points = self.points + p
   self.pointsText:SetText(self.points)
end

function Store:init()
   local frame = loveframes.Create("frame")
      :SetName("Store")
      :Center()
      :SetWidth(self.width)
      :SetHeight(self.height)
      :SetDraggable(false)
      :ShowCloseButton(false)
      :SetState("store")
      :SetScreenLocked(true)
      :SetResizable(false)
   local itemGrid = loveframes.Create("grid", frame)
      :SetPos(5, 30)
      :SetColumns(1)
      :SetRows(#self.items)
      :SetCellWidth(self.width - 25)
      :SetCellHeight(50)
      :SetCellPadding(5)
      :SetItemAutoSize(true)
   for i = 1, #self.items do
      local panel = loveframes.Create("panel")
         :SetState("store")
      local img = loveframes.Create("image", panel)
         :SetImage(self.items[i].image)
         :SetScale(3)
      local desc = loveframes.Create("text", panel)
         :SetText(self.items[i].description)
         :SetPos(64, 5)
      local author = loveframes.Create("text", panel)
         :SetText("Made by: "..self.items[i].author)
         :SetPos(64, 25)
      local price = loveframes.Create("text", panel)
         :SetText("Price: "..self.items[i].price)
         :SetPos(260, 26)
      local buyButton = loveframes.Create("button", panel)
         :SetText("Buy now!")
         :SetWidth(100)
         :SetPos(345, 20)
         :SetAlwaysUpdate(true)
         :SetProperty("price", self.items[i].price)
      if self.items[i].bought then
         buyButton:SetProperty("bought", true)
      end
      buyButton.Update =
         function(object, dt)
            if object:GetProperty("bought") then
               object:SetText("Bought!")
               object:SetEnabled(false)
            elseif self.points < object:GetProperty("price") then
               object:SetText("Not enough points!")
               object:SetEnabled(false)
            else
               object:SetText("Buy now!")
               object:SetEnabled(true)
            end
         end
      buyButton.OnClick =
         function(object, x, y)
            if self.points >= self.items[i].price then
               object:SetProperty("bought", true)
               self.items[i].bought = true
               self.points = self.points - self.items[i].price
               save_stats()
            end
         end
      itemGrid:AddItem(panel, i, 1)
   end
   local backButton = loveframes.Create("button", frame)
      :SetPos(5, self.height - 30)
      :SetText("Main Menu")
   backButton.OnClick = on_back_button_click
   local points = loveframes.Create("text", frame)
      :SetPos(backButton:GetWidth() + 10, self.height - 30)
      :SetText("Your points: "..self.points)
   points.Update =
      function(object, dt)
         object:SetText("Your points: "..self.points)
      end
end

function on_back_button_click(object, x, y)
   loveframes.SetState("mainmenu")
end

return Store
