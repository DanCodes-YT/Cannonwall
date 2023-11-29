-- CTRL + SHIFT + B
local globals = require "globals"
local Vector2 = globals.Vector2
local ObjectMaker = globals.ObjectMaker

local cursorImage
local cursorPos
local cursorSpeed
local lastMousePosition
local world
local objects = {}

function love.load()
    love.window.setMode(800, 400)
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, true)

    objects.ground = ObjectMaker.create({
        body = love.physics.newBody(world, 800/2, 400-50/2),
        shape = love.physics.newRectangleShape(800, 50),
        zindex = -10
    })

    cursorImage = love.graphics.newImage("cursor.png")
    
    lastMousePosition = Vector2.new(400, 200)
    cursorPos = Vector2.new(0, 0)
    cursorSpeed = 0
end

function love.update(dt)
    if love.mouse.isDown({1}) then
        lastMousePosition = Vector2.new(love.mouse.getX(), love.mouse.getY())
    end
    local lastCursorPos = cursorPos
    cursorPos = cursorPos:Lerp(Vector2.new(lastMousePosition.x - 24, lastMousePosition.y - 24), 1 - 0.0005 ^ dt)
    cursorSpeed = math.floor((lastCursorPos - cursorPos).magnitude)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)
    love.graphics.draw(cursorImage, cursorPos.x, cursorPos.y)
    love.graphics.print(cursorSpeed, 400, 100)
    ObjectMaker.renderObjects()
end