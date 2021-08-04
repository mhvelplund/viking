require("dependencies")
local Item = require("src.Item")

local function animateSlash(behavior, subject)
    local rotation,targetX,targetY

    local w,h = subject:getDimensions()
    if subject.direction == 'up' then
        rotation = 0
        targetX = w/2
        targetY = 5
    elseif subject.direction == 'right' then
        rotation = 90
        targetX = w-5
        targetY = h/2
    elseif subject.direction == 'down' then
        rotation = 180
        targetX = w/2
        targetY = h-5
    else
        rotation = -90
        targetX = 5
        targetY = h/2
    end

    subject.animation = Timer.tween(behavior.frame.duration, {
        [subject] = { 
            rotation = rotation,
            targetTransparency = 1,
            targetX = targetX,
            targetY = targetY,
        },
    })
end

local function animateHit(behavior, subject)
    local w,h = subject:getDimensions()

    subject.animation = Timer.tween(behavior.frame.duration, {
        [subject] = { hitTransparency = 1 },
    })

    subject.animation:finish(function ()
        subject.targetTransparency = 0
        subject.targetX = w/2
        subject.targetY = h/2
        subject.hitTransparency = 0
        Event.dispatch('hit', subject)
        subject.direction = nil
    end)
end

local function animateCancel(behavior, subject)
    local w,h = subject:getDimensions()
    subject.targetTransparency = 0
    subject.targetX = w/2
    subject.targetY = h/2

    subject.animation:remove() -- cancel existing animation
end

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

    self.state = Behavior(
        {
            default = {
                { duration = 1/60 },
            },
            slash = {
                { duration = 60/60, action = animateSlash, after = "hit" },
            },
            hit = {
                { duration = 3/60, action = animateHit, after = "default" },
            },
            cancel = {
                { duration = 10/60, action = animateCancel, after = "default" },
            },
        },
        self
    )
    self.direction = nil
    self.hitTransparency = 0
    self.targetTransparency, self.targetX, self.targetY = 0, radius+padding, radius+padding
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

    local _color = {love.graphics.getColor()}

    -- Display the target marker
    love.graphics.setColor(1,1,1,self.targetTransparency)
    love.graphics.circle("fill", self.x+self.targetX, self.y+self.targetY, 5)

    -- Display the hit marker
    love.graphics.setColor(1,1,1,self.hitTransparency)
    love.graphics.circle("fill", self.x+w/2, self.y+w/2, w/2)

    love.graphics.setColor(unpack(_color))
end

function Sword:update (dt)
    self.state:update(dt)
end

function Sword:slash(direction)
    if self.state.state == "default" then
        self.direction = direction
        self.state:setState("slash")
    elseif (self.state.state == "slash") and self.direction ~= direction then
        self.direction = direction
        self.state:setState("cancel")
    end
end

return Sword