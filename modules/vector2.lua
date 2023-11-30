local Vector2 = {}

function Vector2.new(x, y)
  local mt = {}
  local unit,magnitude

  x = x or 0
  y = y or 0

  function mt:__index(i)
    if i == "magnitude" then
      if not magnitude then
        magnitude = (x*x + y*y)^.5
      end

      return magnitude
    elseif i == "unit" then
      if not magnitude then
        magnitude = self.magnitude
      end

      if not unit then
        unit = Vector2.new(x/magnitude, y/magnitude)
      end

      return unit
    elseif i == "x" then
      return x
    elseif i == "y" then
      return y
    elseif i == "xy" then
      return x, y
    else
      return Vector2[i]
    end
  end

  --[[function mt:__newindex(i, v)
    error("Vector2 object is immutible")
  end]]--

  function mt:__add(v)
    if v:type() == "Vector2" then
      return Vector2.new(x + v.x, y + v.y)
    end
  end

  function mt:__sub(v)
    if v:type() == "Vector2" then
      return Vector2.new(x - v.x, y - v.y)
    end
  end

  function mt:__mul(v)
    if type(v) == "number" then
      return Vector2.new(v*x, v*y)
    elseif v:type() == "Vector2" then
      return Vector2.new(x*v.x, y*v.y)
    end
  end

  function mt:__div(v)
    if type(v) == "number" then
      return Vector2.new(x/v, y/v)
    elseif v:type() == "Vector2" then
      return Vector2.new(x/v.x, y/v.y)
    end
  end

  function mt:__unm()
    return Vector2.new(-x, -y)
  end

  function mt:__tostring()
    return tostring(x) .. ", " .. tostring(y)
  end

  mt.__metatable = "Vector2"


  return setmetatable({}, mt)
end

function Vector2:Dot(v)
  assert(v and v.type and v:type("Vector2"), "Incorrect argument #1, Vector2 expected")

  return self.x*v.x + self.y*v.y
end

function Vector2:Lerp(v, a)
  assert(v and v.type and v:type("Vector2"), "Incorrect argument #1, Vector2 expected")
  assert(type(a) == "number", "Incorrect argument #2, number expected")

  local x,y = self.x,self.y

  return Vector2.new(x + a*(v.x - x), y + a*(v.y - y))
end

function Vector2:type()
  return "Vector2"
end

return Vector2