require("dependencies")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

-- Draw the drawable in mirrored from on a canvas and return that.
local function mirrorDrawable(drawable)
    local w,h = drawable:getDimensions()
    local canvas = love.graphics.newCanvas(w,h)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.draw( drawable, w,0,0,-1,1)
    love.graphics.setCanvas()
    return canvas
end

-- Rotate a drawable a number of degrees counterclockwise, and return it on a canvas.
local function rotateDrawable(drawable,rotation)
    local w,h = drawable:getDimensions()
    local canvas = love.graphics.newCanvas(w,h)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.draw( drawable, w/2,w/2,(math.pi/180)*rotation,1,1,w/2,w/2)
    love.graphics.setCanvas()
    return canvas
end

function FightScene:constructor()
    -- Load the first viking image
    viking1 = love.graphics.newImage( "img/viking.png" )

    -- Load a mirrored version onto a canvas
    viking2 = mirrorDrawable(love.graphics.newImage( "img/mongol.png" ))

    shield1 = love.graphics.newImage( "img/shield.png" )
    shield2 = love.graphics.newImage( "img/shield.png" )
    sword1 = love.graphics.newImage( "img/sword.png" )
    sword2 = love.graphics.newImage( "img/sword.png" )
end

function FightScene:update(dt)
    if love.keyboard.keysPressed.escape then
        love.event.quit()
    end
end

function FightScene:render()
    -- Draw second combatant
    local v1w,v1h = viking1:getDimensions()
    local scale1 = (VIRTUAL_HEIGHT*0.8)/v1h
    local v1x, v1y = (VIRTUAL_WIDTH/4)-(v1w/2)*scale1, (VIRTUAL_HEIGHT/2)-(v1h/2)*scale1
    love.graphics.draw( viking1, v1x,v1y,0,scale1,scale1)

    -- Draw second combatant
    local v2w,v2h = viking2:getDimensions()
    local scale2 = (VIRTUAL_HEIGHT*0.8)/v2h
    local v2x, v2y = (VIRTUAL_WIDTH/4)*3-(v2w/2)*scale2, (VIRTUAL_HEIGHT/2)-(v2h/2)*scale2
    love.graphics.draw( viking2, v2x,v2y,0,scale2,scale2)
end

return FightScene