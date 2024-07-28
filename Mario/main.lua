_G.love = require('love')
function love.load()
  
  platforms = {
      {x = 0, y = 550, width = 1200 , height = 50}
  }

  -- Load the player image
  player = {}
  player.image = love.graphics.newImage("Images/mario1.png")
  player.x = 100
  player.y = 300
  player.yVelocity = 0
  player.isJumping = false
  player.speed = 200
  gravity = 800
  jumpForce = -400
  player.coin=0

  coin={}
  coin.image = love.graphics.newImage("Images/coin.png")
  coin.x= love.math.random(tonumber(1000))
  coin.y= 460
  coin.height = 200

  groundImage = love.graphics.newImage("Images/tile.png")
  --aba yo chai for camera
  cameraX = 0
  cameraY = 0

end



function checkCollision(player, platform)
    
  if player.x < platform.x + platform.width and
     player.x + player.image:getWidth() > platform.x and
     player.y < platform.y + platform.height and
     player.y + player.image:getHeight() > platform.y then
      return true
  else
      return false
  end
end

function checkCoinCollision(player, coin)
    if player.x < coin.x + coin.image:getWidth() and
       player.x + player.image:getWidth() > coin.x and
       player.y < coin.y + coin.image:getHeight() and
       player.y + player.image:getHeight() > coin.y then
        return true
    else
        return false
    end
end


function love.update(dt)


  -- Handle left and right movement
  if love.keyboard.isDown("right") then
      player.x = player.x + player.speed * dt
  elseif love.keyboard.isDown("left") then
      player.x = player.x - player.speed * dt
  end
  
  -- Define screen center positions
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- Update camera position based on player position


  -- Apply gravity
  player.yVelocity = player.yVelocity + gravity * dt

  -- Update player position
  player.y = player.y + player.yVelocity * dt

  -- Check for collisions with platforms
  for _, platform in ipairs(platforms) do
      if checkCollision(player, platform) then
          player.y = platform.y - player.image:getHeight()
          player.yVelocity = 0
          player.isJumping = false
      end
  end

  -- Jumping logic
  if love.keyboard.isDown("space") and not player.isJumping then
      player.yVelocity = jumpForce
      player.isJumping = true
  end

  -- Bound player to the screen
  if player.y > 600 - player.image:getHeight() then
      player.y = 600 - player.image:getHeight()
      player.yVelocity = 0
      player.isJumping = false
  end

  -- Optional: allow up and down movement for testing purposes
  if love.keyboard.isDown("down") then
      player.y = player.y + player.speed * dt
  end
  if love.keyboard.isDown("up") then
      player.y = player.y - player.speed * dt
  end

   
    -- Define screen center positions
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Update camera position based on player position
    cameraX = cameraX + (player.x - screenWidth / 2 - cameraX) * dt * 5
    cameraY = cameraY + (player.y - screenHeight / 2 - cameraY) * dt * 5


    -- Check for coin collection
    if checkCoinCollision(player, coin) then
        player.coin = player.coin + 1

        -- Respawn the coin at a new random position
        coin.x = love.math.random(50, 1000)
        coin.height = love.math.random(50, 60 )

        -- Debug prints
        print("Coin collected! New position: ", coin.x, coin.y)
    end

    -- Debug prints for player and coin positions
    print("Player position: ", player.x, player.y)
    print("Coin position:   ", coin.x, coin.y)
end
    


function love.draw()
    love.graphics.push()  -- Save the current transformation state
    love.graphics.translate(-cameraX, -cameraY)

    -- Draw everything with the camera offset applied
    love.graphics.draw(player.image, player.x, player.y)

    if not player.collect then
        love.graphics.draw(coin.image, coin.x, coin.y)
    end

    love.graphics.print("Coins: " .. player.coin, 10 + cameraX, 10 + cameraY)
    
     -- Draw the ground
     local groundHeight = love.graphics.getHeight() - groundImage:getHeight()
     for i = 0, math.ceil(love.graphics.getWidth() / groundImage:getWidth()) do
         love.graphics.draw(groundImage, i * groundImage:getWidth(), groundHeight)
     end
--aile ko lagi as platform isnt ready
 --   for _, platform in ipairs(platforms) do
   --     love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    --end

    love.graphics.pop()  -- Restore the previous transformation state
end

