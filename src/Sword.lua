require("dependencies")
local Item = require("src.Item")

--- A sword entity.
--- @class Sword : Item
local Sword = Item:extend()

--- Create a sword.
--- @param image string a filename
--- @param radius number the sword icon radius
--- @param padding number the padding in pixels between sword and icon border
--- @param x number the x location of the sword
--- @param y number the y location of the sword
--- @param dark string the icon border color
--- @param light string the icon background
function Sword:constructor(image, radius, padding, x, y, dark, light)
    self:initItem(image, radius, padding, x, y, dark, light)
    self.rotation = 0
end

--- Draw the sword on screen.
function Sword:render()
    local canvas = love.graphics.newCanvas(self:getDimensions())
    local original = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.draw(self.icon:getDrawable(), 0, 0)
    local w,h = self:getDimensions()
    local iw,ih = self.img:getDimensions()
    local ix,iy = w/2-iw/2, h/2-ih/2
    love.graphics.draw(self.img, ix, iy)
    love.graphics.setCanvas(original)

    local rotated = scaleAndRotate {
        drawable = canvas,
        rotation = self.rotation
    }

    love.graphics.draw(rotated, self.x, self.y)
end

return Sword