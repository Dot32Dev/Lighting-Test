local tiles={}
local world = {x=0,y=0}
local seed = love.math.random(1000, 9999)

function love.load()
  require("Intro")
  require("blocks")
  introInitialise("Games")

  screen = {}
  screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)
  screen.cursor = love.graphics.newImage("cursor.png")

  --[[Creates Australian-English translations of the colour functions]]
  love.graphics.getBackgroundColour = love.graphics.getBackgroundColor
  love.graphics.getColour           = love.graphics.getColor
  love.graphics.getColourMask       = love.graphics.getColorMask
  love.graphics.getColourMode       = love.graphics.getColorMode
  love.graphics.setBackgroundColour = love.graphics.setBackgroundColor
  love.graphics.setColour           = love.graphics.setColor
  love.graphics.setColourMask       = love.graphics.setColorMask
  love.graphics.setColourMode       = love.graphics.setColorMode

  love.graphics.setBackgroundColour(0.57, 0.78, 0.77)


  tiles.wide = 25
  tiles.high = 19 
  tiles.size = 32

  for x=1, tiles.wide do
    local t = {}
    for y=1, tiles.high do
      if y <= 10+love.math.noise(x/20,seed)*6 then
        table.insert(t, 1)
      elseif y <= 15+love.math.noise(x/20,seed)*3 then
        table.insert(t, 2)
      else
        table.insert(t, 3)
      end
    end
    table.insert(tiles, t)
  end

  tiles.autotile = {}
  for x=1, tiles.wide do
    local t = {}
    for y=1, tiles.high do
      local v = 0
      if y == 1 or blocks[tiles[x][y-1]].type ~= "air" then
        v = v + 1
      end
      if x == tiles.wide or blocks[tiles[x+1][y]].type ~= "air" then
        v = v + 2
      end
      if y == tiles.high or blocks[tiles[x][y+1]].type ~= "air" then
        v = v + 4
      end
      if x == 1 or blocks[tiles[x-1][y]].type ~= "air" then
        v = v + 8
      end

      table.insert(t, v)
    end
    table.insert(tiles.autotile, t)
  end

  tiles.light = {}
  for x=1, tiles.wide do
    local t = {}
    for y=1, tiles.high do
      local v = 0
      if tiles.autotile[x][y] ~= 15 then
        v = 1
      end
      table.insert(t, v)
    end
    table.insert(tiles.light, t)
  end
  propagate_lighting()
end

function love.update(dt)
	introUpdate(dt)

  --propagate_lighting()
end

function love.draw()
  -- local tx = -400*tiles.size/32+love.graphics.getWidth()/2-world.x*tiles.size
  -- local ty = -300*tiles.size/32+love.graphics.getHeight()/2-world.y*tiles.size
  -- love.graphics.translate(tx, ty)

	for x=1, tiles.wide do
    for y=1, tiles.high do
      if blocks[tiles[x][y]].type ~= "air" then
        love.graphics.setColour(tiles.light[x][y],tiles.light[x][y],tiles.light[x][y])
        love.graphics.draw(blocks[tiles[x][y]].image[math.min(#blocks[tiles[x][y]].image, tiles.autotile[x][y]+1)][(math.floor(random(x,y)) % #blocks[tiles[x][y]].image[math.min(#blocks[tiles[x][y]].image, tiles.autotile[x][y]+1)])+1], (x-1)*tiles.size, (y-1)*tiles.size, nil, tiles.size/16)
      end
      --love.graphics.print(tiles.light[x][y], (x-1)*tiles.size, (y-1)*tiles.size)
    end
  end

  love.graphics.setColour(1,1,1)
  love.graphics.draw(screen.cursor, 400, 300, nil, tiles.size/16)

  --love.graphics.translate(-tx, -ty)

  love.graphics.print("Seed: "..seed)

  introDraw()
end

function random(x,y)
  return x*y*seed*math.cos(x^2)*(x+y)
end

function love.keypressed(k)
  if k == "r" then
    seed = love.math.random(1000, 9999)

    for x=1, tiles.wide do
      for y=1, tiles.high do

        if y <= 10+love.math.noise(x/20,seed)*6 then
          tiles[x][y] = 1
        elseif y <= 15+love.math.noise(x/20,seed)*3 then
          tiles[x][y] = 2
        else
          tiles[x][y] = 3
        end

      end
    end

    for x=1, tiles.wide do
      for y=1, tiles.high do
        local v = 0
        if y == 1 or blocks[tiles[x][y-1]].type ~= "air" then
          v = v + 1
        end
        if x == tiles.wide or blocks[tiles[x+1][y]].type ~= "air" then
          v = v + 2
        end
        if y == tiles.high or blocks[tiles[x][y+1]].type ~= "air" then
          v = v + 4
        end
        if x == 1 or blocks[tiles[x-1][y]].type ~= "air" then
          v = v + 8
        end

        tiles.autotile[x][y] = v
      end
    end

    for x=1, tiles.wide do
      for y=1, tiles.high do
        local v = 0
        if tiles.autotile[x][y] ~= 15 then
          v = 1
        end

        tiles.light[x][y] = v
      end
    end
    propagate_lighting()
  end

  if k == "f11" and love.system.getOS() == "Windows" then
      love.window.setFullscreen(true)
  end
end

function propagate_lighting()
  local falloff = 0.2
  for x=1, tiles.wide do
    for y=1, tiles.high do
      if y ~= 1 and tiles.light[x][y-1]-falloff > tiles.light[x][y] then
        tiles.light[x][y] = tiles.light[x][y-1]-falloff
      end
      if x ~= tiles.wide and tiles.light[x+1][y]-falloff > tiles.light[x][y] then
        tiles.light[x][y] = tiles.light[x+1][y]-falloff
      end
      if y ~= tiles.high and tiles.light[x][y+1]-falloff > tiles.light[x][y] then
        tiles.light[x][y] = tiles.light[x][y+1]-falloff
      end
      if x ~= 1 and tiles.light[x-1][y]-falloff > tiles.light[x][y] then
        tiles.light[x][y] = tiles.light[x-1][y]-falloff
      end
    end
  end
end