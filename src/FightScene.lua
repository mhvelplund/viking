require("dependencies")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

function FightScene:constructor()
    viking1 = love.graphics.newImage( "img/viking.png" )
    viking2 = love.graphics.newImage( "img/mongol.png" )
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

local function scaleAndRotate(drawable, options)
    options = options or {}
    local dw,dh = drawable:getDimensions()
    local scale = options.scale or 1
    local w = options.width or dw*scale
    local h = options.height or dh*scale
    local mirror = options.mirror and -1 or 1
    local rotation = options.rotation or 0
    local wscale, hscale = scale,scale

    if w ~= dw and not wscale then
        wscale = w/dw
    end

    if h ~= dh and not hscale then
        hscale = h/dh
    end

    wscale = wscale * mirror

    local canvas = love.graphics.newCanvas(w,h)
    local original = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.draw( drawable, w/2, h/2, (math.pi/180)*rotation, wscale, hscale, dw/2, dh/2)
    love.graphics.setCanvas(original)
    return canvas
end

function FightScene:render()
    -- Draw second combatant
    local v1 = scaleAndRotate(viking1, {
        scale = (VIRTUAL_HEIGHT*0.8)/({viking1:getDimensions()})[2]
    })
    local v1w,v1h = v1:getDimensions()
    local v1x, v1y = (VIRTUAL_WIDTH/4)-(v1w/2), (VIRTUAL_HEIGHT/2)-(v1h/2)
    love.graphics.draw( v1, v1x,v1y)

    -- -- Draw second combatant
    local v2 = scaleAndRotate(viking2, {
        scale = (VIRTUAL_HEIGHT*0.8)/({viking2:getDimensions()})[2],
        mirror = true
    })
    local v2w,v2h = v2:getDimensions()
    local v2x, v2y = (VIRTUAL_WIDTH/4)*3-(v2w/2), (VIRTUAL_HEIGHT/2)-(v2h/2)
    love.graphics.draw( v2, v2x,v2y)
end

return FightScene