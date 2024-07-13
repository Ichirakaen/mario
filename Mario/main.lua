function love.load()
  -- Set the window size
  love.window.setMode(800, 600)

  platforms = {
      {x = 0, y = 550, width = 800, height = 50}
  }

  -- Load the player image
  player = {}
  player.image = love.graphics.newImage("Images/mario1.png")
  player.x = 100
  player.y = 300
  player.yVelocity = 0
  player.isJumping = false
  player.speed = 200

  gravity = 500
  jumpForce = -300
end

function love.draw()
  love.graphics.draw(player.image, player.x, player.y)

  for _, platform in ipairs(platforms) do
      love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
  end
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

function love.update(dt)
  -- Handle left and right movement
  if love.keyboard.isDown("right") then
      player.x = player.x + player.speed * dt
  elseif love.keyboard.isDown("left") then
      player.x = player.x - player.speed * dt
  end

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
end
