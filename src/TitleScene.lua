require("dependencies")

local TitleScene = Scene:extend()

local nordicFont = "fonts/OdinsonLight-vMZD.ttf"
local titleFont, textFont

local function getFontSize(font, text)
    return font:getWidth(text), font:getHeight()
end

function TitleScene:constructor()
    textFont = love.graphics.newFont( nordicFont, 48 )
    titleFont = love.graphics.newFont( nordicFont, 96 )
end

function TitleScene:enter(title)
    self.title = title
end

function TitleScene:render()
    local fuzz = 6
    local text = self.title
    local tw,th = getFontSize(titleFont, text)
    local x = VIRTUAL_WIDTH/2-tw/2 - fuzz/2 + math.random(0,fuzz)
    local y = VIRTUAL_HEIGHT/3-th/2 - fuzz/2 + math.random(0,fuzz)

    love.graphics.setFont(titleFont)
	love.graphics.print(text, x, y)

    text = "... Press SPACE to fight ..."
    tw,th = getFontSize(textFont, text)

    love.graphics.setFont(textFont)
	love.graphics.print(text, VIRTUAL_WIDTH/2-tw/2, (VIRTUAL_HEIGHT/3)*2-th/2)
end

function TitleScene:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('space') then
        Event.dispatch('startGame')
    end
end

return TitleScene