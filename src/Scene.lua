-- Based on: https://github.com/games50/mario/blob/7a96da9/mario/src/states/BaseState.lua
local Class = require "libs.knife.knife.base"

local Scene = Class:extend()

function Scene:enter() end
function Scene:exit() end
function Scene:update(dt) end
function Scene:render() end

return Scene