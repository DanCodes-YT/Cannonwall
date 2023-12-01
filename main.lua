-- Linux: CTRL + SHIFT + B
-- Windows: ALT + L
io.stdout:setvbuf('no')

local conf = require "conf"
local vector2 = require "modules.vector2"
local objectMaker = require "modules.objectmaker"
local gamera = require "modules.gamera"

local windowSize = conf.windowSize
local currentWindowSize = vector2.new(windowSize.x, windowSize.y)

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
    camera = gamera.new(0, 0, windowSize.x, windowSize.y)

    cursorImage = love.graphics.newImage("assets/images/cursor.png")
    
    lastMousePosition = vector2.new(400, 200)
    cursorPos = vector2.new(0, 0)
    cursorSpeed = 0

    objects.cursor = objectMaker.create({
        body = love.physics.newBody(world, lastMousePosition.x - 24, lastMousePosition.y - 24, "dynamic"),
        shape = love.physics.newRectangleShape(48, 48),
        color = {0, 0, 0},
        image = cursorImage,
        zindex = -10
    })
    objects.cursor.fixture:setRestitution(0.5)

    objects.border1 = objectMaker.create({
        body = love.physics.newBody(world, 0, 200),
        shape = love.physics.newEdgeShape(0, 200, 0, -200),
        color = {0, 0, 0}
    })

    objects.border2 = objectMaker.create({
        body = love.physics.newBody(world, 800, 200),
        shape = love.physics.newEdgeShape(0, 200, 0, -200),
        color = {0, 0, 0}
    })

    objects.border3 = objectMaker.create({
        body = love.physics.newBody(world, 400, 0),
        shape = love.physics.newEdgeShape(-400, 0, 400, 0),
        color = {0, 0, 0}
    })

    objects.border4 = objectMaker.create({
        body = love.physics.newBody(world, 400, 400),
        shape = love.physics.newEdgeShape(-400, 0, 400, 0),
        color = {0, 0, 0}
    })

    for i = 1, 200, 1 do
        local newObject = objectMaker.create({
            body = love.physics.newBody(world, 800/2, 100, "dynamic"),
            shape = love.physics.newRectangleShape(math.random(10, 30), math.random(20, 40)),
            color = {0, 0, 0},
            zindex = -10
        })
        newObject.fixture:setRestitution(0.3)
        objects["wall"..i] = newObject
    end

    objects.cursor.body:setAngle(math.rad(50))
end

function love.update(dt)
    if love.mouse.isDown({1}) then
        local mx, my = camera:toWorld(love.mouse.getX(), love.mouse.getY())
        lastMousePosition =  vector2.new(mx, my)
        local direction = (lastMousePosition - vector2.new(objects.cursor.body:getX(), objects.cursor.body:getY())).unit
        objects.cursor.body:applyForce(direction.x * 30000, direction.y * 30000)
    end
    local lastCursorPos = cursorPos
    cursorPos = cursorPos:Lerp(vector2.new(lastMousePosition.x - 24, lastMousePosition.y - 24), 1 - 0.0005 ^ dt)
    cursorSpeed = math.floor((lastCursorPos - cursorPos).magnitude)
    world:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)
    love.graphics.print(love.timer.getFPS(), camera:toScreen(400, 100))
    camera:setWindow(0, 0, windowSize.x, windowSize.y)
    camera:draw(function(l, t, w, h)
        objectMaker.renderObjects(l, t, w, h)
    end)
end

function love.resize(w, h)
    windowSize.x = w
    windowSize.y = h
end