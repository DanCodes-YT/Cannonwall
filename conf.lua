local vector2 = require "modules.vector2"

local data = {}
data.windowSize = vector2.new(800, 400)

function love.conf(t)
    t.window.title = "Cannonwall"
    t.window.vsync = 1
    t.window.width = data.windowSize.x
    t.window.height = data.windowSize.y
    t.window.resizable = true
end

return data