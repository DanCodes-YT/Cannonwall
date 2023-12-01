-- Linux: CTRL + SHIFT + B
-- Windows: ALT + L
io.stdout:setvbuf('no')

local globals = require "modules.globals"
local Vector2 = globals.Vector2
local ObjectMaker = globals.ObjectMaker
local Gamera = globals.Gamera

local cursorImage
local cursorPos
local cursorSpeed
local lastMousePosition
local world
local objects = {}
local camera

function love.load()
    love.physics.setMeter(24)
    world = love.physics.newWorld(0, 9.81*24, true)
    camera = Gamera.new(0, 0, 800, 400)

    cursorImage = love.graphics.newImage("assets/images/cursor.png")
    
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
    objects.cursor.fixture:setRestitution(0.5)

    for i = 1, 5, 1 do
        objects["wall"..i] = ObjectMaker.create({
            body = love.physics.newBody(world, 800/2, 40 * i, "dynamic"),
            shape = love.physics.newRectangleShape(20, 30),
            color = {0, 0, 0},
            zindex = -10
        })
    end

    objects.cursor.body:setAngle(math.rad(50))
end

function love.update(dt)
    world:update(dt)

    if love.mouse.isDown({1}) then
        local mx, my = camera:toWorld(love.mouse.getX(), love.mouse.getY())
        lastMousePosition =  Vector2.new(mx, my)
        local direction = (lastMousePosition - Vector2.new(objects.cursor.body:getX(), objects.cursor.body:getY())).unit
        objects.cursor.body:applyForce(direction.x * 1000, direction.y * 2000)
    end
    local lastCursorPos = cursorPos
    cursorPos = cursorPos:Lerp(Vector2.new(lastMousePosition.x - 24, lastMousePosition.y - 24), 1 - 0.0005 ^ dt)
    cursorSpeed = math.floor((lastCursorPos - cursorPos).magnitude)
end

function love.draw()
    camera:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)
    love.graphics.print(love.timer.getFPS(), 400, 100)
    camera:draw(function()
        ObjectMaker.renderObjects()
    end)
end