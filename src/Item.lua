require("dependencies")
local Icon = require("src.Icon")

--- Base class for renderable items
--- @class Item : Class
--- @field icon Icon the icon background
--- @field img love.Canvas the item graphics
--- @field x number the x location of the item
--- @field y number the y location of the item
local Item = Class:extend()

function Item:initItem(image, radius, padding, x, y, dark, light)
    assert(image)
    local _img = love.graphics.newImage(image)
    local ow,oh = _img:getDimensions()

    padding = padding or 0
    radius = radius or math.max(ow,oh)/2

    self.x = x or 0; self.y = y or 0

    self.img = scaleAndRotate {
        drawable = _img,
        scale = (radius*2) / math.max(ow,oh)
    }

    self.icon = Icon(radius+padding, 5, dark, light)
end

function Item:getDimensions()
    return self.icon:getDrawable():getDimensions()
end

function Item:render()
end

return Item