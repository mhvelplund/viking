require("dependencies")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

function FightScene:constructor()
    viking1 = love.graphics.newImage( "img/viking.png" )

    -- viking2 = love.graphics.newImage( "img/viking.png" )

    local vg2 = love.graphics.newImage( "img/viking.png" )
    local vg2w,vg2h = vg2:getDimensions()
    viking2 = love.graphics.newCanvas(vg2w,vg2h)
    love.graphics.setCanvas(viking2)
        love.graphics.clear()
        -- love.graphics.setBlendMode("alpha")
        love.graphics.draw( vg2, vg2w,0,0,-1,1)
    love.graphics.setCanvas()

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
    local w,h = VIRTUAL_WIDTH,VIRTUAL_HEIGHT
    local v1w,v1h = viking1:getDimensions()
    local v2w,v2h = viking2:getDimensions()

    local scale1 = (h*0.8)/v1h
    local scale2 = (h*0.8)/v2h

    local v1x, v1y = (w/4)-(v1w/2)*scale1, (h/2)-(v1h/2)*scale1
    local v2x, v2y = (w/4)*3-(v2w/2)*scale2, (h/2)-(v2h/2)*scale2

    love.graphics.draw( viking1, v1x,v1y,0,scale1,scale1)
    print("viking1 @"..tostring(v1x)..","..tostring(v1y))
    print("   v1w: "..tostring(v1w).."   scale1: "..tostring(scale1).."   deduct: "..tostring((v1w/2)*scale1))
    love.graphics.draw( viking2, v2x,v2y,0,scale2,scale2)
    print("viking2 @"..tostring(v2x)..","..tostring(v2y))
    print("   v2w: "..tostring(v2w).."   scale2: "..tostring(scale2).."   deduct: "..tostring((v2w/2)*scale2))
end

return FightScene