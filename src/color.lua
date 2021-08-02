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
local function color(name, alpha)
    alpha = alpha or 1
    local c = dawnBringer32[name]
    assert(c, "Unknown color: "..name)
    return c[1]/255, c[2]/255, c[3]/255, alpha
end

return color