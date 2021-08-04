require("dependencies")
local Item = require("src.Item")

local function animateParry(behavior, subject)
    local targetX, targetY, actualX, actualY
    local w,h = subject:getDimensions()
    local iw,ih = subject.img:getDimensions()

    if subject.direction == 'up' then
        targetX, targetY = w/2, 5
        actualX = w/2-iw/2
        actualY = 0
    elseif subject.direction == 'right' then
        targetX, targetY = w-5, h/2
        actualX = w-iw
        actualY = h/2-ih/2
    elseif subject.direction == 'down' then
        targetX, targetY = w/2, h-5
        actualX = w/2-iw/2
        actualY = h-ih
    else
        targetX, targetY = 5, h/2
        actualX = 0
        actualY = h/2-ih/2
    end

    subject.animation = Timer.tween(behavior.frame.duration, {
        [subject] = { 
            targetX = targetX,
            targetY = targetY,
            actualX = actualX,
            actualY = actualY,
        },
    })
end

local function animateCancel(behavior, subject)
    local w,h = subject:getDimensions()
    subject.targetX = w/2
    subject.targetY = h/2
    subject.animation:remove() -- cancel existing animation
end

--- A shield entity.
--- @class Shield : Item
local Shield = Item:extend()

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

    local w,h = self:getDimensions()
    local iw,ih = self.img:getDimensions()
    self.targetX = w/2
    self.targetY = h/2
    self.actualX = w/2-iw/2
    self.actualY = h/2-ih/2

    self.state = Behavior(
        {
            default = {
                { duration = 1/60 },
            },
            parry = {
                { duration = 60/60, action = animateParry, after = "default" },
            },
            cancel = {
                { duration = 10/60, action = animateCancel, after = "default" },
            },
        },
        self
    )
end

function Shield:update (dt)
    self.state:update(dt)
end

--- Draw the Shield on screen.
function Shield:render()
    local canvas = love.graphics.newCanvas(self:getDimensions())
    local original = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.draw(self.icon:getDrawable(), 0, 0)
    love.graphics.draw(self.img, self.actualX, self.actualY)
    love.graphics.setCanvas(original)
    love.graphics.draw(canvas, self.x, self.y)
end

function Shield:parry(direction)
    if self.state.state == "default" then
        self.direction = direction
        self.state:setState("parry")
    elseif (self.state.state == "parry") and self.direction ~= direction then
        self.direction = direction
        self.state:setState("cancel")
    end
end

function Shield:target()
    return self.targetX, self.targetY
end

return Shield