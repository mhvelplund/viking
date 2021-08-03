require("dependencies")

local Sword = require("src.Sword")
local Shield = require("src.Shield")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

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

    local padding = 15
    local itemRadius = VIRTUAL_HEIGHT*0.1
    local iconRadius = itemRadius + padding
    shield1 = Shield("img/shield.png", itemRadius, padding, 0, (VIRTUAL_HEIGHT/3)*2-iconRadius, "royal_blue", "cornflower")
    shield2 = Shield("img/shield.png", itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, (VIRTUAL_HEIGHT/3)*2-iconRadius, "brown", "mandy")
    sword1 = Sword("img/sword.png", itemRadius, padding, 0, VIRTUAL_HEIGHT/3-iconRadius, "royal_blue", "cornflower")
    sword2 = Sword("img/sword.png", itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, VIRTUAL_HEIGHT/3-iconRadius, "brown", "mandy")
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
    shield1:render()

    -- Draw second combatant
    local sh2w, _ = shield2:getDimensions()
    love.graphics.draw(centered(viking2, (VIRTUAL_WIDTH/4)*3, VIRTUAL_HEIGHT/2))
    sword2:render()
    shield2:render()

end

return FightScene