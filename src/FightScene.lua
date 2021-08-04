require("dependencies")

local Sword = require("src.Sword")
local Shield = require("src.Shield")

local FightScene = Scene:extend()
local viking1, viking1hp, shield1, sword1
local viking2, viking2hp, shield2, sword2

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
    viking1hp = 300

    local _v2 = love.graphics.newImage( combatant2 )
    viking2 = scaleAndRotate {
        drawable = _v2,
        scale = (VIRTUAL_HEIGHT*0.8)/({_v2:getDimensions()})[2],
        mirror = true
    }
    viking2hp = 300

    local padding = 15
    local itemRadius = VIRTUAL_HEIGHT*0.1
    local iconRadius = itemRadius + padding
    shield1 = Shield(shield1Img, itemRadius, padding, 0, (VIRTUAL_HEIGHT/3)*2-iconRadius, "royal_blue", "cornflower")
    shield2 = Shield(shield2Img, itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, (VIRTUAL_HEIGHT/3)*2-iconRadius, "brown", "mandy")
    sword1 = Sword(sword1Img, itemRadius, padding, 0, VIRTUAL_HEIGHT/3-iconRadius, "royal_blue", "cornflower")
    sword2 = Sword(sword2Img, itemRadius, padding, VIRTUAL_WIDTH-iconRadius*2, VIRTUAL_HEIGHT/3-iconRadius, "brown", "mandy")

    Event.on('hit', function (subject)
        if subject == sword1 then
            viking2hp = viking2hp-distance({subject:target()}, {shield2:target()})
            print("Viking2 HP:", viking2hp)
        elseif subject == sword2 then
            viking1hp = viking1hp-distance({subject:target()}, {shield1:target()})
            print("Viking1 HP:", viking1hp)
        else
            assert(false, "Unexpected HIT event: "..tostring(subject))
        end
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

end

return FightScene