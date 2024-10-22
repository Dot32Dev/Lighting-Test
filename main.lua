local tiles={}
local world = {}
local seed = love.math.random(1000, 9999)
local player = {}

function love.load()
  require("Intro")
  require("blocks")
  introInitialise("Test")

  screen = {}
  screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)
  screen.cursor = {image={love.graphics.newImage("cursor.png"), love.graphics.newImage("cursorO.png")},x=0,y=0}

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


  tiles.wide = 25*2
  tiles.high = math.floor(19*2.5)
  tiles.size = 16

  for x=1, tiles.wide do
    local t = {}
    local noise1 = love.math.noise(x/100,seed)*22
    local noise2 = love.math.noise(x/20,seed)*6
    local noise3 = love.math.noise(x/10,seed)*2
    for y=1, tiles.high do
      if y <= noise1+noise2+noise3 then
        table.insert(t, 1)
        if x == math.floor(tiles.wide/2) then
          world.y = math.floor(love.graphics.getHeight()/tiles.size/2)-(y-1)
          player.x = x-1
          player.y = y-1
        end
      elseif y <= noise1*1.5+noise2/1.5+noise3/2+5 then
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
  propagate_lighting(8)

  world.x = 0 + (math.floor(love.graphics.getWidth()/tiles.size/2)-(player.x+1)-0)*0.3
end

function love.update(dt)
	introUpdate(dt)

  screen.cursor.x = math.min(math.max(--[[]]math.floor((love.mouse.getX()-world.x*tiles.size)/tiles.size--[[]]), 0), tiles.wide-1)
  screen.cursor.y = math.min(math.max(--[[]]math.floor((love.mouse.getY()-world.y*tiles.size)/tiles.size--[[]]), 0), tiles.high-1)

  if love.mouse.isDown(1) then
    tiles[screen.cursor.x+1][screen.cursor.y+1] = 1
    update_world()
  end
  if love.mouse.isDown(2) then
    tiles[screen.cursor.x+1][screen.cursor.y+1] = 2
    update_world()
  end
  if love.mouse.isDown(3) then
    tiles[screen.cursor.x+1][screen.cursor.y+1] = 3
    update_world()
  end

  local speed = 10/tiles.size
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    player.x = player.x - speed
  end
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    player.x = player.x + speed
  end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    player.y = player.y - speed
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    player.y = player.y + speed
  end

  world.x = world.x + (math.floor(love.graphics.getWidth()/tiles.size/2)-(player.x+1)-world.x)*0.3
  world.y = world.y + (math.floor(love.graphics.getHeight()/tiles.size/2)-(player.y+1)-world.y)*0.3
end

function love.draw()
  local tx = world.x*tiles.size --% tiles.size-tiles.size
  local ty = world.y*tiles.size --% tiles.size-tiles.size
  love.graphics.translate(tx, ty)

  --Draw Sky
  love.graphics.setColour(0.57*0.9, 0.78*0.9, 0.77*0.9)
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", 0, 0, tiles.wide*tiles.size, tiles.high*tiles.size)

  --Draw Tiles
	for x=1, tiles.wide do
    for y=1, tiles.high do
      if (x-1)*tiles.size+tx > love.graphics.getWidth() then
        break
      end
      if blocks[tiles[x][y]].type ~= "air" then
        love.graphics.setColour(tiles.light[x][y],tiles.light[x][y],tiles.light[x][y])
        love.graphics.draw(blocks[tiles[x][y]].image[math.min(#blocks[tiles[x][y]].image, tiles.autotile[x][y]+1)][(math.floor(random(x,y)) % #blocks[tiles[x][y]].image[math.min(#blocks[tiles[x][y]].image, tiles.autotile[x][y]+1)])+1], (x-1)*tiles.size, (y-1)*tiles.size, nil, tiles.size/16)
      end
      --love.graphics.print(tiles.light[x][y], (x-1)*tiles.size, (y-1)*tiles.size)
    end
  end

  --Draw Cursor
  love.graphics.setColour(1,1,1, 0.5)
  love.graphics.draw(screen.cursor.image[1], screen.cursor.x*tiles.size, screen.cursor.y*tiles.size, nil, tiles.size/16)
  love.graphics.setColour(1,1,1, 1)
  love.graphics.draw(screen.cursor.image[2], screen.cursor.x*tiles.size, screen.cursor.y*tiles.size, nil, tiles.size/16)

  --Draw Player
  --love.graphics.circle("fill", player.x*tiles.size+tiles.size/2, player.y*tiles.size+tiles.size/2, tiles.size/2)

  love.graphics.translate(-tx, -ty)

  love.graphics.setColour(0,0,0,0.1)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getFont():getWidth("Mouse buttons to mine/place blocks"), love.graphics.getFont():getHeight()*3)
  love.graphics.setColour(1,1,1)
  love.graphics.print("Seed: "..seed)
  love.graphics.print("\nWASD to move, R to regen\nMouse buttons to mine/place blocks")
  --love.graphics.print("\n"..math.floor(love.mouse.getX()/tiles.size)..'\n'..math.floor(love.mouse.getY()/tiles.size))
  --love.graphics.print("\n"..world.x..'\n'..world.y)

  introDraw()
end

function random(x,y)
  return x*y*seed*math.cos(x^2)*(x+y)
end

function love.keypressed(k)
  if k == "r" then
    seed = love.math.random(1000, 9999)

    for x=1, tiles.wide do
      local noise1 = love.math.noise(x/100,seed)*22
      local noise2 = love.math.noise(x/20,seed)*6
      local noise3 = love.math.noise(x/10,seed)*2
      for y=1, tiles.high do
        if y <= noise1+noise2+noise3 then
          tiles[x][y] = 1
          if x == math.floor(tiles.wide/2) then
            world.y = math.floor(love.graphics.getHeight()/tiles.size/2)-y
            player.x = x-1
            player.y = y-1
          end
        elseif y <= noise1*1.5+noise2/1.5+noise3/2+5 then
          tiles[x][y] = 2
        else
          tiles[x][y] = 3
        end

      end
    end

    update_world()

    world.x = world.x + (math.floor(love.graphics.getWidth()/tiles.size/2)-(player.x+1)-world.x)*0.3
  end

  if k == "f11" and love.system.getOS() == "Windows" then
      love.window.setFullscreen(true)
  end
end

function kill_lighting()
  for x=1, tiles.wide do
    for y=1, tiles.high do
      local v = 0
      if tiles.autotile[x][y] ~= 15 then
        v = 1
      end

      tiles.light[x][y] = v
    end
  end
end

function propagate_lighting(reet)
  local falloff = 0.2
  kill_lighting()
  for i=1, reet do
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
end

function update_world()
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
    propagate_lighting(8)
end