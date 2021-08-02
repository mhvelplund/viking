require("dependencies")

local FightScene = Scene:extend()
local viking1, shield1, sword1
local viking2, shield2, sword2

DB32 = {
    ["black"] = {0, 0, 0},
    ["valhalla"] = {34, 32, 52},
    ["loulou"] = {69, 40, 60},
    ["oiled_cedar"] = {102, 57, 49},
    ["rope"] = {143, 86, 59},
    ["tahiti_gold"] = {223, 113, 38},
    ["twine"] = {217, 160, 102},
    ["pancho"] = {238, 195, 154},
    ["golden_fizz"] = {251, 242, 54},
    ["atlantis"] = {153, 229, 80},
    ["christi"] = {106, 190, 48},
    ["elf_green"] = {55, 148, 110},
    ["dell"] = {75, 105, 47},
    ["verdigris"] = {82, 75, 36},
    ["opal"] = {50, 60, 57},
    ["deep_koamaru"] = {63, 63, 116},
    ["venice_blue"] = {48, 96, 130},
    ["royal_blue"] = {91, 110, 225},
    ["cornflower"] = {99, 155, 255},
    ["viking"] = {95, 205, 228},
    ["light_steel_blue"] = {203, 219, 252},
    ["white"] = {255, 255, 255},
    ["heather"] = {155, 173, 183},
    ["topaz"] = {132, 126, 135},
    ["dim_gray"] = {105, 106, 106},
    ["smokey_ash"] = {89, 86, 82},
    ["clairvoyant"] = {118, 66, 138},
    ["brown"] = {172, 50, 50},
    ["mandy"] = {217, 87, 99},
    ["plum"] = {215, 123, 186},
    ["rain_forest"] = {143, 151, 74},
    ["stinger"] = {138, 111, 48}
}

local function centered(drawable, x, y)
    assert(drawable, "No drawable argument provided")
    x = x or 0
    y = y or 0
    local w,h = drawable:getDimensions()
    return drawable, x-(w/2), y-(h/2)
end

local function color(name,alpha)
    alpha = alpha or 1
    local color = DB32[name]
    assert(color, "Unknown color: "..name)
    return color[1]/255, color[2]/255, color[3]/255, alpha
end

local function scaleAndRotate(options)
    options = options or {}

    local drawable = options.drawable
    assert(drawable, "No drawable argument provided")

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

local function makeIcon(drawable, dark, light, padding)
    assert(drawable, "No drawable argument provided")
    padding = padding or 1
    dark, light = dark or "black", light or "black"

    local lineWidth, originalColor = love.graphics.getLineWidth(), {love.graphics.getColor()}
    local size = (math.max(drawable:getDimensions()) / 2)+padding
    local canvas = love.graphics.newCanvas(size*2, size*2)
    local originalCanvas = love.graphics.getCanvas() -- this is needed because the push library is already using a canvas
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(color(light))
    love.graphics.circle("fill", size, size, size)
    love.graphics.setColor(color(dark))
    love.graphics.setLineWidth(5)
    love.graphics.circle("line", size, size, size)
    love.graphics.setColor(color("white"))
    love.graphics.draw(centered(drawable, size, size))
    love.graphics.setLineWidth(lineWidth)
    love.graphics.setColor(unpack(originalColor))
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

    local _sw1 = love.graphics.newImage( "img/sword.png" )
    _sw1 = scaleAndRotate {
        drawable = _sw1,
        scale = (VIRTUAL_HEIGHT*0.2)/({_sw1:getDimensions()})[2]
    }
    sword1 = makeIcon(_sw1, "royal_blue", "cornflower", 15)

    local _sw2 = love.graphics.newImage( "img/sword.png" )
    _sw2 = scaleAndRotate {
        drawable = _sw2,
        scale = (VIRTUAL_HEIGHT*0.2)/({_sw2:getDimensions()})[2]
    }
    sword2 = makeIcon(_sw2, "brown", "mandy", 15)
end

function FightScene:update(dt)
    if love.keyboard.keysPressed.escape then
        love.event.quit()
    end
end

function FightScene:render()
    -- Draw second combatant
    local sh1w, _, sw1w, _ = shield1:getDimensions(), sword1:getDimensions()
    love.graphics.draw(centered(viking1, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2))
    love.graphics.draw(centered(sword1, sw1w/2, VIRTUAL_HEIGHT/3))
    love.graphics.draw(centered(shield1, sh1w/2, (VIRTUAL_HEIGHT/3)*2))

    -- Draw second combatant
    local sh2w, _, sw2w, _ = shield2:getDimensions(), sword2:getDimensions()
    love.graphics.draw(centered(viking2, (VIRTUAL_WIDTH/4)*3, VIRTUAL_HEIGHT/2))
    love.graphics.draw(centered(sword2, VIRTUAL_WIDTH-(sw2w/2), VIRTUAL_HEIGHT/3))
    love.graphics.draw(centered(shield2, VIRTUAL_WIDTH-(sh2w/2), (VIRTUAL_HEIGHT/3)*2))
end

return FightScene