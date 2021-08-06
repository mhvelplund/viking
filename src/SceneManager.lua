-- Based on: https://github.com/games50/mario/blob/7a96da9/mario/src/StateMachine.lua
require "dependencies"

local SceneManager = Class:extend()

function SceneManager:constructor(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function SceneManager:change(stateName,...)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	love.graphics.reset( )
	self.current:enter(unpack({...}))
end

function SceneManager:update(dt)
	self.current:update(dt)
end

function SceneManager:render()
	self.current:render()
end

return SceneManager