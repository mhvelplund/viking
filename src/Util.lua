local Util = {}

local dawnBringer32 = {
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

--- Return a Love2D compatible Dawnbringer32 color.
--- @param name string the Dawnbringer32 palette name of the color
--- @param alpha number an optional alpha value, default 1.0
--- @return number r,number g,number b ,number a Love2D compatible color in RGBA
function Util.color(name, alpha)
    alpha = alpha or 1
    local c = dawnBringer32[name]
    assert(c, "Unknown color: "..name)
    return c[1]/255, c[2]/255, c[3]/255, alpha
end

--- Return coordinates for a centered texture.
--- @param texture love.Texture
--- @param x number
--- @param y number
--- @return love.Texture texture, number x, number y
function Util.centered(texture, x, y)
    assert(texture, "No texture argument provided")
    x = x or 0
    y = y or 0
    local w,h = texture:getDimensions()
    return texture, x-(w/2), y-(h/2)
end

--- Scale, mirror, and rotate a drawable.
---
--- @class Options
--- @field drawable love.Texture the image to operate on
--- @field scale number the scale for the texture, default 1
--- @field width number the width for the texture, default original width * scale
--- @field height number the height for the texture, default original width * scale
--- @field mirror boolean mirror the image horizontally, default false
--- @field rotation number the number of degrees clockwise to rotate the drawable, default 0
---
--- @param options Options
--- @return love.Canvas canvas
function Util.scaleAndRotate(options)
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

return Util