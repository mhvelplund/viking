require "dependencies"

SceneManager = require("src.SceneManager")
FightScene = require("src.FightScene")

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 1080, 720

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Viking')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local windowWidth, windowHeight = love.window.getDesktopDimensions()

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, windowWidth/2, windowHeight/2, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    local combatants = {
        "img/centurion.png",
        "img/mongol.png",
        -- "img/roman.png",
        "img/viking_2h_hammer.png",
        "img/viking_sword_hammer.png",
        "img/viking_swords.png",
        "img/viking.png",
    }
    local combatant1, combatant2 = table.remove(combatants, math.random(1, #combatants)), table.remove(combatants, math.random(1, #combatants))

    local shields = {
        "img/shield.png",
        "img/shield2.png",
        "img/shield3.png",
    }
    local shield1, shield2 = table.remove(shields, math.random(1, #shields)), table.remove(shields, math.random(1, #shields))

    local swords = {
        "img/sword.png",
        "img/sword2.png",
        "img/sword3.png",
    }
    local sword1, sword2 = table.remove(swords, math.random(1, #swords)), table.remove(swords, math.random(1, #swords))

    gScenes = SceneManager {
        ['fight'] = function() return FightScene(combatant1, combatant2, sword1, sword2, shield1, shield2) end,
    }
    gScenes:change('fight')

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
