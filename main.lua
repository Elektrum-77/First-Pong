io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest")


function love.load()
  love.window.maximize()
  
  require "color_lib"
  
  
  sW, sH = love.graphics.getDimensions()
  
  
  mainFont = love.graphics.newFont(20)
  love.graphics.setFont(mainFont)
  
  init = {}
  update = {}
  settingsChange = {}
  draw = {}
  draw.order = {}
  
  mP = {}
  mR = {}
  mW = {}
  kP = {}
  kR = {}
  
  
  players = {}
  players.color = {{0.3, 0.3, 0.3},{0.3, 0.3, 0.3}}
  players.config_key = require "players_key_config"
  players.speed = 1.5
  players.max_stamina = 5
  players.height = sH/5
  
  function players:init()
    self.y = sH/2
    self.stamina = 0
  end
  
  function players:update(dt, id)
    
    local c1 = self.color[id][1]
    local c2 = self.color[id][2]
    local c3 = self.color[id][3]
    
    c1 = c1+ dt*1.1*(0.9+(id%2)/5)
    if c1 > 1 then c1 = -1 end
    if c1 > -0.3 and c1 < 0 then c1 = 0.3 end
      
    c2 = c2+ dt*1.2*(0.9+(id%2)/5)
    if c2 > 1 then c2 = -1 end
    if c2 > -0.3 and c2 < 0 then c2 = 0.3 end
      
    c3 = c3+ dt*1.3*(0.9+(id%2)/5)
    if c3 > 1 then c3 = -1 end
    if c3 > -0.3 and c3 < 0 then c3 = 0.3 end
    
    print(c1, c2, c3)
    self.color[id] = {c1, c2, c3}
    
    local speed = self.speed
    if love.keyboard.isDown(self.config_key[id].speed) then
      if self.stamina > 0 then
        speed = 3
        self.stamina = self.stamina - dt
      end
    elseif self.stamina < self.max_stamina then
      self.stamina = self.stamina + dt
    end
    if love.keyboard.isDown(self.config_key[id].up) and
    self.y - dt * 150 * speed > self.height/2 then
      
      self.y = self.y - dt * 150 * speed
    end
    if love.keyboard.isDown(self.config_key[id].down) and
    self.y + dt * 150 * speed < sH - self.height/2 then
      
      self.y = self.y + dt * 150 * speed
    end
    
  end
  
  function players:draw(id)
    
    local a = (255 * self.stamina / self.max_stamina) / 255
    setColor({math.abs(self.color[id][1]), math.abs(self.color[id][2]), math.abs(self.color[id][3]), a})
    love.graphics.rectangle("fill", (id-1)*(sW-200)+100 - (id-1)*20, self.y - self.height/2, 20, self.height)
    setColor(Color.white)
  end
  
  function players.__index(table, key)
    return players[key]
  end
  
  players[1] = {}
  players[2] = {}
  
  for k,v in ipairs(players) do
    setmetatable(v, players)
    v:init()
  end
  
  score = {0, 0}
  
  ball = 
  {
    x = sW/2,
    y = sH/2,
    vx = 0,
    vy = 0,
    radius = sH/30,
    speed = 0,
    a = 0,
    color = {0.3, 0.3, 0.3},
    acc = 0.5
  }
  
  function ball:update(dt)
    
    local c1 = self.color[1]
    local c2 = self.color[2]
    local c3 = self.color[3]
    
    c1 = c1+ dt*1.1
    if c1 > 1 then c1 = -1 end
    if c1 > -0.3 and c1 < 0 then c1 = 0.3 end
      
    c2 = c2+ dt*1.2
    if c2 > 1 then c2 = -1 end
    if c2 > -0.3 and c2 < 0 then c2 = 0.3 end
      
    c3 = c3+ dt*1.3
    if c3 > 1 then c3 = -1 end
    if c3 > -0.3 and c3 < 0 then c3 = 0.3 end
    
    self.color = {c1, c2, c3}
    
    self.vx = math.cos(self.a)
    self.vy = math.sin(self.a)*-1
    
    local nx = self.x + self.vx * dt * 150 * self.speed
    local ny = self.y + self.vy * dt * 150 * self.speed
    
    self.x = nx
    self.y = ny
    
    if self.x - self.radius < 0 then
      score[2] = score[2] + 1
      self.x = sW/2
      self.y = sH/2
      self.speed = 2 * math.sqrt(self.speed-1)
    end
    
    if self.x + self.radius > sW then
      score[1] = score[1] + 1
      self.x = sW/2
      self.y = sH/2
      self.speed = 2
    end
    
    if nx + self.radius > sW-120 and
    self.x - self.radius*2 < sW-100 and
    math.cos(self.a) > 0 and
    ny - self.radius < players[2].y + players[2].height/2 and
    ny + self.radius > players[2].y - players[2].height/2 then
      self.a = math.pi - self.a
      self.speed = self.speed + 0.5
      self.a = self.a + math.rad((self.y - players[2].y)/(players.height/2)*22.5)
    end
    
    if self.x + self.radius*2 > 100 and
    nx - self.radius < 120 and
    math.cos(self.a) < 0 and
    ny - self.radius < players[1].y + players[1].height/2 and
    ny + self.radius > players[1].y - players[1].height/2 then
      self.a = math.pi - self.a
      self.speed = self.speed + 0.5
      self.a = self.a - math.rad((self.y - players[1].y)/(players.height/2)*22.5)
    end
    
    if self.y - self.radius < 0 then
      self.y = self.y + self.radius - ny
      self.a = 0 - self.a
      self.speed = self.speed + 0.1
    end
    
    if self.y + self.radius > sH then
      self.y = self.y - ny + sH - self.radius
      self.a = 0 - self.a
      self.speed = self.speed + 0.1
    end
  end
  
  function ball:draw()
    
    setColor({math.abs(self.color[1]), math.abs(self.color[2]), math.abs(self.color[3]), 0.05})
    love.graphics.circle("fill",self.x, self.y, self.radius + 2*self.radius)
    setColor({math.abs(self.color[1]), math.abs(self.color[2]), math.abs(self.color[3]), 0.1})
    love.graphics.circle("fill",self.x, self.y, self.radius + 1.7*self.radius)
    setColor({math.abs(self.color[1]), math.abs(self.color[2]), math.abs(self.color[3]), 0.15})
    love.graphics.circle("fill",self.x, self.y, self.radius + 1.2*self.radius)
    
    local color = {math.abs(self.color[1]), math.abs(self.color[2]), math.abs(self.color[3])}
    setColor(color)
    
    love.graphics.circle("fill",self.x, self.y, self.radius)
  end
  
  function score:draw()
    
    for id,v in ipairs(score) do
      local string = "score : "..v
      local x = (id-1)*(sW-325)+120
      setColor(Color.black)
      love.graphics.rectangle("fill", x - 2, 50 - 2, string.len(string) * 10 + 4, 20 + 6) -- text background
      setColor({math.abs(players.color[id][1]), math.abs(players.color[id][2]), math.abs(players.color[id][3])})
      love.graphics.print(string, (id-1)*(sW-325)+120, 50)
    end
    
    if ball.speed == 0 then -- if the ball doesn't have a speed then the game hasn't start
      setColor(Color.white)
      love.graphics.print("press space to start", sW/2 -105, sH/2 + ball.radius)
    end
    
  end
  
end

function love.keypressed(key)
  kP[key] = true
  
  if key == "space" and ball.speed == 0 then
    local rand = love.math.random()
    if rand >= 0.5 then
      ball.speed = 1
    else
      ball.speed = 1
      ball.a = math.pi
    end
  end
  
end

function love.keyreleased(key)
  kP[key] = false
end

function love.mousepressed(x, y, button)
  mP[button] = true
end

function love.mousereleased(x, y, button)
  mP[button] = false
end

function love.wheelmoved(x, y)
end

function love.update(dt)
  
  for id,v in ipairs(players) do
    v:update(dt, id)
  end
  
  ball:update(dt)
  
end

function love.draw()
  
  for id,v in ipairs(players) do
    v:draw(id)
  end
  
  ball:draw()
  score:draw()
  
  setColor(Color.yellow)
  love.graphics.rectangle("fill", sW/2, sH/2, 1, 1)
  setColor(Color.white)
  
end
