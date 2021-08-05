require("dependencies")

local Sword = require("src.Sword")
local Shield = require("src.Shield")
local Healthbar = require("src.Healthbar")

local FightScene = Scene:extend()
local viking1, viking1hp, shield1, sword1, health1
local viking2, viking2hp, shield2, sword2, health2

local function distance(pos1,pos2)
    local x1,y1 = unpack(pos1)
    local x2,y2 = unpack(pos2)
    return math.sqrt(math.pow(x2-x1,2)+math.pow(y2-y1,2))
end

--- Create a fight scene
function FightScene:constructor(combatant1, combatant2, sword1Img, sword2Img, shield1Img, shield2Img)
    local _v1 = love.graphics.newImage( combatant1 )
    viking1 = scaleAndRotate {
        drawable = _v1,
        scale = (VIRTUAL_HEIGHT*0.8)/({_v1:getDimensions()})[2]
    }

    local _v2 = love.graphics.newImage( combatant2 )
    viking2 = scaleAndRotate {
        drawable = _v2,
        scale = (VIRTUAL_HEIGHT*0.8)/({_v2:getDimensions()})[2],
        mirror = true
    }

    local padding = 15
    local itemRadius = VIRTUAL_HEIGHT*0.1
    local iconRadius = itemRadius + padding
    shield1 = Shield(shield1Img, itemRadius, padding, 0, (VIRTUAL_HEIGHT/3)*2-iconRadius, "royal_blue", "cornflower")
    shield2 = Shield(shield2Img, itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, (VIRTUAL_HEIGHT/3)*2-iconRadius, "brown", "mandy")
    sword1 = Sword(sword1Img, itemRadius, padding, 0, VIRTUAL_HEIGHT/3-iconRadius, "royal_blue", "cornflower")
    sword2 = Sword(sword2Img, itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, VIRTUAL_HEIGHT/3-iconRadius, "brown", "mandy")
    health1 = Healthbar("royal_blue", "cornflower", 0, VIKING_HP)
    health2 = Healthbar("brown", "mandy", VIRTUAL_WIDTH/2, VIKING_HP)

    Event.on('hit', function (subject)
        if subject == sword1 then
            health2:damage(distance({subject:target()}, {shield2:target()}))
        elseif subject == sword2 then
            health1:damage(distance({subject:target()}, {shield1:target()}))
        else
            assert(false, "Unexpected HIT event: "..tostring(subject))
        end
    end)

    Event.on('dead', function (subject)
        if subject == health1 then
            print("Player 1 is DEAD!")
        elseif subject == health2 then
            print("Player 2 is DEAD!")
        else
            assert(false, "Unexpected HIT event: "..tostring(subject))
        end
        love.event.quit()
    end)
end

function FightScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.isDown('a') then
        sword1:slash('left')
    elseif love.keyboard.isDown('w') then
        sword1:slash('up')
    elseif love.keyboard.isDown('d') then
        sword1:slash('right')
    elseif love.keyboard.isDown('s') then
        sword1:slash('down')
    end

    if love.keyboard.isDown('j') then
        sword2:slash('left')
    elseif love.keyboard.isDown('i') then
        sword2:slash('up')
    elseif love.keyboard.isDown('l') then
        sword2:slash('right')
    elseif love.keyboard.isDown('k') then
        sword2:slash('down')
    end

    if love.keyboard.isDown('f') then
        shield1:parry('left')
    elseif love.keyboard.isDown('t') then
        shield1:parry('up')
    elseif love.keyboard.isDown('h') then
        shield1:parry('right')
    elseif love.keyboard.isDown('g') then
        shield1:parry('down')
    end

    if love.keyboard.isDown('kp4') then
        shield2:parry('left')
    elseif love.keyboard.isDown('kp8') then
        shield2:parry('up')
    elseif love.keyboard.isDown('kp6') then
        shield2:parry('right')
    elseif love.keyboard.isDown('kp5') then
        shield2:parry('down')
    end

    sword1:update(dt)
    sword2:update(dt)
    shield1:update(dt)
    shield2:update(dt)
    health1:update(dt)
    health2:update(dt)
end

function FightScene:render()
    -- Draw second combatant
    love.graphics.draw(centered(viking1, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2))
    sword1:render()
    shield1:render()

    -- Draw second combatant
    love.graphics.draw(centered(viking2, (VIRTUAL_WIDTH/4)*3, VIRTUAL_HEIGHT/2))
    sword2:render()
    shield2:render()

    -- Draw healthbars
    health1:render()
    health2:render()
end

return FightScene