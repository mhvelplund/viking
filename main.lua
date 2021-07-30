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

    gScenes = SceneManager {
        ['fight'] = function() return FightScene() end,
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
