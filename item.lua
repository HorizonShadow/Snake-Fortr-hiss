Item = {}

function Item:new(imageLoc, price, desc, author)
   local i = {
      image = imageLoc,
      price = price,
      description = desc,
      author = author,
      bought = false
   }
   setmetatable(i, {__index = Item})
   return i
end

return Item
