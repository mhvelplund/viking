require("dependencies")
local Item = require("src.Item")

--- A shield entity.
--- @class Shield : Item
local Shield = Class:extend(Item)

--- Create a shield.
--- @param image string a filename
--- @param radius number the Shield icon radius
--- @param padding number the padding in pixels between Shield and icon border
--- @param x number the x location of the Shield
--- @param y number the y location of the Shield
--- @param dark string the icon border color
--- @param light string the icon background
function Shield:constructor(image, radius, padding, x, y, dark, light)
    self:initItem(image, radius, padding, x, y, dark, light)
end

--- Draw the Shield on screen.
function Shield:render()
    local canvas = love.graphics.newCanvas(self:getDimensions())
    local original = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.draw(self.icon:getDrawable(), 0, 0)
    local w,h = self:getDimensions()
    local iw,ih = self.img:getDimensions()
    local ix,iy = w/2-iw/2, h/2-ih/2
    love.graphics.draw(self.img, ix, iy)
    love.graphics.setCanvas(original)
    love.graphics.draw(canvas, self.x, self.y)
end

return Shield