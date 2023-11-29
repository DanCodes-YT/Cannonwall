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

function module.renderObjects()
    if not sorted then
        table.sort(createdObjects, function(a, b)
            if a.zindex == b.zindex then
                return a.uid < b.uid
            end

            return a.zindex < b.zindex
        end)
        sorted = true
    end

    for _, obj in pairs(createdObjects) do
        local x = obj.body:getX()
        local y = obj.body:getY()

        love.graphics.setColor(obj.color)

        if obj.image then
            love.graphics.draw(obj.image, x, y, body:getAngle())
        elseif obj.shape:getType() == "polygon" then
            love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
        elseif obj.shape:getType() == "circle" then
            love.graphics.circle("fill", x, y, obj.shape:getRadius())
        end
    end
end

return module