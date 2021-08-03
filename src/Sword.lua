require("dependencies")
local Icon = require("src.Icon")

local Sword = Class:extend()

--- A sword entity.

--- @param image string
--- @param radius number
--- @param padding number
--- @param x number
--- @param y number
--- @param dark string
--- @param light string
function Sword:constructor(image, radius, padding, x, y, dark, light)
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
    self.rotation = 0
end

function Sword:getDimensions()
    return self.icon:getDrawable():getDimensions()
end

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