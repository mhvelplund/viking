require "dependencies"

SceneManager = require("src.SceneManager")
FightScene = require("src.FightScene")
TitleScene = require("src.TitleScene")

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 1080, 720
VIKING_HP = 500

local function getCombatants()
    local combatants = {
        "img/centurion.png",
        "img/mongol.png",
        -- "img/roman.png",
        "img/viking_2h_hammer.png",
        "img/viking_sword_hammer.png",
        "img/viking_swords.png",
        "img/viking.png",
    }
    return table.remove(combatants, math.random(1, #combatants)), table.remove(combatants, math.random(1, #combatants))
end

local function getShields()
    local shields = {
        "img/shield.png",
        "img/shield2.png",
        "img/shield3.png",
    }
    return table.remove(shields, math.random(1, #shields)), table.remove(shields, math.random(1, #shields))
end

local function getSwords()
    local swords = {
        "img/sword.png",
        "img/sword2.png",
        "img/sword3.png",
    }
    return table.remove(swords, math.random(1, #swords)), table.remove(swords, math.random(1, #swords))
end

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Vikingr!')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local windowWidth, windowHeight = love.window.getDesktopDimensions()

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, windowWidth/2, windowHeight/2, {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    gScenes = SceneManager {
        ['title'] = function() return TitleScene() end,
        ['fight'] = function() return FightScene() end,
    }

    gScenes:change("title", "Vikingr!")

    Event.on("startGame", function()
        local combatant1, combatant2 = getCombatants()
        local shield1, shield2 = getShields()
        local sword1, sword2 = getSwords()
        gScenes:change("fight", combatant1, combatant2, sword1, sword2, shield1, shield2)
    end)

    Event.on('dead', function(text)
        gScenes:change("title", text)
    end)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gScenes:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()
    gScenes:render()
    Push:finish()
end
