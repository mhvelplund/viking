require("dependencies")

--- A circular icon.
--- @class Icon
local Icon = Class:extend()

--- Create a circular icon.
---
--- @param radius number the number of pixels of the circle radius
--- @param border number the width dark border, default 5
--- @param dark string the border color, default black
--- @param light string the icon color, default black
function Icon:constructor(radius, border, dark, light)
    assert(radius)
    border = border or 5
    dark, light = dark or "black", light or "black"

    self.canvas = love.graphics.newCanvas(radius*2, radius*2)
    local originalCanvas = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.setColor(color(light))
    love.graphics.circle("fill", radius, radius, radius)
    love.graphics.setColor(color(dark))
    love.graphics.setLineWidth(border)
    love.graphics.circle("line", radius, radius, radius)
    love.graphics.setColor(color("white"))
    love.graphics.setCanvas(originalCanvas)
end

--- Return the canvas containing the icon.
--- @return love.Texture texture
function Icon:getDrawable()
    return self.canvas
end

return Icon