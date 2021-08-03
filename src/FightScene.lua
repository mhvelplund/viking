require("dependencies")

local Icon = require("src.Icon")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

local function makeIcon(drawable, dark, light, padding)
    assert(drawable, "No drawable argument provided")
    padding = padding or 1
    dark, light = dark or "black", light or "black"

    local size = (math.max(drawable:getDimensions()) / 2)+padding
    local icon = Icon(size, 5, dark, light)
    local canvas = love.graphics.newCanvas(icon:getDrawable():getDimensions())
    local originalCanvas = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.draw(icon:getDrawable(), 0, 0)
    love.graphics.draw(centered(drawable, size, size))
    love.graphics.setCanvas(originalCanvas)
    return canvas
end

function FightScene:constructor()
    local _v1 = love.graphics.newImage( "img/viking.png" )
    viking1 = scaleAndRotate {
        drawable = _v1,
        scale = (VIRTUAL_HEIGHT*0.8)/({_v1:getDimensions()})[2]
    }

    local _v2 = love.graphics.newImage( "img/mongol.png" )
    viking2 = scaleAndRotate {
        drawable = _v2,
        scale = (VIRTUAL_HEIGHT*0.8)/({_v2:getDimensions()})[2],
        mirror = true
    }

    local _sh1 = love.graphics.newImage( "img/shield.png" )
    _sh1 = scaleAndRotate {
        drawable = _sh1,
        scale = (VIRTUAL_HEIGHT*0.2)/({_sh1:getDimensions()})[2]
    }
    shield1 = makeIcon(_sh1, "royal_blue", "cornflower", 15)

    local _sh2 = love.graphics.newImage( "img/shield.png" )
    _sh2 = scaleAndRotate {
        drawable = _sh2,
        scale = (VIRTUAL_HEIGHT*0.2)/({_sh2:getDimensions()})[2]
    }
    shield2 = makeIcon(_sh2, "brown", "mandy", 15)

    local padding = 15
    local iconRadius = VIRTUAL_HEIGHT*0.1 + padding
    sword1 = require("src.Sword")("img/sword.png", VIRTUAL_HEIGHT*0.1, padding, 0, VIRTUAL_HEIGHT/3-iconRadius, "royal_blue", "cornflower")
    sword2 = require("src.Sword")("img/sword.png", VIRTUAL_HEIGHT*0.1, padding, VIRTUAL_WIDTH-iconRadius*2, VIRTUAL_HEIGHT/3-iconRadius, "brown", "mandy")
end

function FightScene:update(dt)
    if love.keyboard.keysPressed.escape then
        love.event.quit()
    end
end

function FightScene:render()
    -- Draw second combatant
    local sh1w, _ = shield1:getDimensions()
    love.graphics.draw(centered(viking1, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2))
    sword1:render()
    love.graphics.draw(centered(shield1, sh1w/2, (VIRTUAL_HEIGHT/3)*2))

    -- Draw second combatant
    local sh2w, _ = shield2:getDimensions()
    love.graphics.draw(centered(viking2, (VIRTUAL_WIDTH/4)*3, VIRTUAL_HEIGHT/2))
    sword2:render()
    love.graphics.draw(centered(shield2, VIRTUAL_WIDTH-(sh2w/2), (VIRTUAL_HEIGHT/3)*2))

end

return FightScene