-- Linux: CTRL + SHIFT + B
-- Windows: ALT + L
io.stdout:setvbuf('no')

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
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 9.81*32, true)

    cursorImage = love.graphics.newImage("cursor.png")
    
    lastMousePosition = Vector2.new(400, 200)
    cursorPos = Vector2.new(0, 0)
    cursorSpeed = 0

    objects.ground = ObjectMaker.create({
        body = love.physics.newBody(world, 800/2, 400-50/2),
        shape = love.physics.newRectangleShape(800, 50),
        color = {0.1, 0.1, 0.1},
        zindex = -10
    })

    objects.cursor = ObjectMaker.create({
        body = love.physics.newBody(world, lastMousePosition.x - 24, lastMousePosition.y - 24, "dynamic"),
        shape = love.physics.newRectangleShape(48, 48),
        color = {0, 0, 0},
        image = cursorImage,
        zindex = -10
    })

    objects.cursor.body:setAngle(math.rad(50))
end

function love.update(dt)
    world:update(dt)

    if love.mouse.isDown({1}) then
        lastMousePosition = Vector2.new(love.mouse.getX(), love.mouse.getY())
        objects.cursor.body:applyForce(0, -1000)
    end
    local lastCursorPos = cursorPos
    cursorPos = cursorPos:Lerp(Vector2.new(lastMousePosition.x - 24, lastMousePosition.y - 24), 1 - 0.0005 ^ dt)
    cursorSpeed = math.floor((lastCursorPos - cursorPos).magnitude)
    --objects.cursor.body:setPosition(cursorPos.x, cursorPos.y)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)
    --love.graphics.draw(cursorImage, cursorPos.x, cursorPos.y)
    love.graphics.print(love.timer.getFPS(), 400, 100)
    ObjectMaker.renderObjects()
end