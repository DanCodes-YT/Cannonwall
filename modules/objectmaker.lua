local Vector2 = require "modules.vector2"

local module = {}
local createdObjects = {}
local sorted = false
local object = {}
object.__index = object

local lastUid = 0

function module.create(data)
    assert(data.body and data.shape, "A body/shape is missing")
    local newObject = setmetatable({}, object)
    newObject.uid = lastUid + 1
    newObject.zindex = data.zindex or 0
    newObject.body = data.body
    newObject.shape = data.shape
    newObject.fixture = love.physics.newFixture(data.body, data.shape, data.density or 1)
    newObject.image = data.image or nil
    newObject.color = data.color or {0, 0, 0}
    table.insert(createdObjects, newObject)
    sorted = false
    return newObject
end

function object:destroy(shape)
    if self.destroyed then return end

    self.destroyed = true
    self.body:destroy()

    if shape then
        self.shape:release()
    end

    setmetatable(self, nil)
end

function module.renderObjects(l, t, w, h)
    w = w + l
    h = h + t

    if not sorted then
        table.sort(createdObjects, function(a, b)
            if a.zindex == b.zindex then
                return a.uid < b.uid
            end

            return a.zindex < b.zindex
        end)
        sorted = true
    end

    for i, obj in pairs(createdObjects) do
        if obj.destroyed then
            table.remove(createdObjects, i)
            goto continue
        end

        local angle = obj.body:getAngle()
        local x = obj.body:getX()
        local y = obj.body:getY()
        local tlx, tly, brx, bry = obj.shape:computeAABB(x, y, angle)
        
        local topLeft = Vector2.new(tlx, tly)
        local bottomRight = Vector2.new(brx, bry)

        love.graphics.setColor(obj.color)

        if obj.image then
            love.graphics.draw(obj.image, x, y, angle, 1, 1, obj.image:getWidth()/2, obj.image:getHeight()/2)
            love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
        elseif obj.shape:getType() == "polygon" then
            love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
        elseif obj.shape:getType() == "circle" then
            love.graphics.circle("fill", x, y, obj.shape:getRadius())
        else
            love.graphics.line(obj.body:getWorldPoints(obj.shape:getPoints()))
        end
        ::continue::
    end
end

return module