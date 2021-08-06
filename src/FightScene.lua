require("dependencies")

local Sword = require("src.Sword")
local Shield = require("src.Shield")
local Healthbar = require("src.Healthbar")

local FightScene = Scene:extend()
local viking1, shield1, sword1, health1
local viking2, shield2, sword2, health2
local thud, parry, scream
local nordicFont = "fonts/OdinsonLight-vMZD.ttf"
local textFont, titleFont

--- Calculate damage as the distance between the shield and the sword hit
--- @param pos1 table list with sword position as x,y
--- @param pos2 table list with shield position as x,y
--- @return number the distance between the points
local function distance(pos1,pos2)
    local x1,y1 = unpack(pos1)
    local x2,y2 = unpack(pos2)
    return math.sqrt(math.pow(x2-x1,2)+math.pow(y2-y1,2))
end

function FightScene:constructor()
    thud = love.audio.newSource("fx/thud.wav", "static")
    parry = love.audio.newSource("fx/parry.wav", "static")
    scream = love.audio.newSource("fx/scream.wav", "static")
    textFont = love.graphics.newFont( nordicFont, 32 )
    titleFont = love.graphics.newFont( nordicFont, 96 )
end

--- Create a fight scene
function FightScene:enter(combatant1, combatant2, sword1Img, sword2Img, shield1Img, shield2Img)
    self.showOverlay = true
    self.overlayTimer = 3

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

    Timer.tween(self.overlayTimer, {
        [self] = { overlayTimer = 0 },
    }):finish(function ()
        self.showOverlay = false
    end)

    Event.on('hit', function (subject)
        local dead, message, damage
        if subject == sword1 then
            damage = distance({subject:target()}, {shield2:target()})
            dead = health2:damage(damage)
            message = "Player 2 is DEAD!"
        elseif subject == sword2 then
            damage = distance({subject:target()}, {shield1:target()})
            dead = health1:damage(damage)
            message = "Player 1 is DEAD!"
        else
            assert(false, "Unexpected HIT event: "..tostring(subject))
        end

        if (damage < 10) then
            love.audio.play(parry)
        else
            love.audio.play(thud)
        end

        if dead then
            love.audio.play(scream)
            Event.dispatch("dead", message)
        end
    end)
end

function FightScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.showOverlay then
        if love.keyboard.isDown('a') then
            sword1:slash('left')
        elseif love.keyboard.isDown('w') then
            sword1:slash('up')
        elseif love.keyboard.isDown('d') then
            sword1:slash('right')
        elseif love.keyboard.isDown('s') then
            sword1:slash('down')
        end

        if love.keyboard.isDown('left') then
            sword2:slash('left')
        elseif love.keyboard.isDown('up') then
            sword2:slash('up')
        elseif love.keyboard.isDown('right') then
            sword2:slash('right')
        elseif love.keyboard.isDown('down') then
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
    end

    sword1:update(dt)
    sword2:update(dt)
    shield1:update(dt)
    shield2:update(dt)
end

local function drawKey(letter,x,y,size)
    local cw,ch = textFont:getWidth(letter), textFont:getHeight()
    love.graphics.rectangle("line", x,y,size,size)
    love.graphics.print(letter, size/2-cw/2+x, size/2-ch/2+y)
end

local function drawKeys(size,x,y,...)
    local keys = {...}
    drawKey(keys[1],x+size,y,size)
    drawKey(keys[2],x,y+size,size)
    drawKey(keys[3],x+size,y+size,size)
    drawKey(keys[4],x+2*size,y+size,size)
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

    if self.showOverlay then
        local oc = {love.graphics.getColor()}

        love.graphics.setColor(0,0,0,0.8)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
        love.graphics.setColor(color("white"))

        local x,y = 0,0
        local size = 60
        love.graphics.setFont(textFont)
        drawKeys(size, 0,VIRTUAL_HEIGHT/3+50, "w","a","s","d")
        drawKeys(size, 0,(VIRTUAL_HEIGHT/3)*2+50, "t","f","g","h")
        drawKeys(size, VIRTUAL_WIDTH-3*size,VIRTUAL_HEIGHT/3+50, "up","lft","dwn","rgt")
        drawKeys(size, VIRTUAL_WIDTH-3*size,(VIRTUAL_HEIGHT/3)*2+50, "kp8","kp4","kp5","kp6")

        love.graphics.setFont(titleFont)
        local text = tostring(math.ceil(self.overlayTimer))
        local cw,ch = titleFont:getWidth(text), titleFont:getHeight()
        love.graphics.print(text, VIRTUAL_WIDTH/2-cw/2+x, VIRTUAL_HEIGHT/2-ch/2+y)

        love.graphics.setColor(unpack(oc))
    end
end

return FightScene