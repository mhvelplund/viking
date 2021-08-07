require("dependencies")

local Healthbar = Class:extend()

function Healthbar:constructor(dark, light, xOffset, hp)
    self.dark = dark
    self.light = light
    self.width = (VIRTUAL_WIDTH/2)*0.8
    self.height = 30
    self.x = VIRTUAL_WIDTH/4 - self.width/2 + xOffset
    self.y = VIRTUAL_HEIGHT - (self.height + 10)
    self.hp = hp
end

function Healthbar:render()
    local _color = {love.graphics.getColor()}

    love.graphics.setColor(color(self.light))
    love.graphics.rectangle('fill', self.x, self.y, (self.hp/VIKING_HP)*self.width, self.height)

    love.graphics.setColor(color(self.dark))
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

    love.graphics.setColor(unpack(_color))
end

function Healthbar:damage(damage)
    self.hp = math.max(0, self.hp-damage)
    return self.hp == 0
end

return Healthbar