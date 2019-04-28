--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Block = require 'src.components.block'
local Text = require 'cherry.components.text'
local colorize = require 'cherry.libs.colorize'

--------------------------------------------------------------------------------

local Life = require 'src.components.life'
local Points = require 'src.components.points'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

local NB_LINES = 8
local NB_ROWS = 5
local NB_COLORS = 4
local SPEED = 200

local boxWidth = NB_ROWS * Block.WIDTH
local boxHeigth = NB_LINES * Block.HEIGHT

--------------------------------------------------------------------------------

local LINES = {}
local ROWS = {}

for l = 1, NB_LINES do
  LINES[l] = boxHeigth / 2 - (l - 1 / 2) * Block.HEIGHT
end

for r = 1, NB_ROWS do
  ROWS[r] = (r - 1 / 2) * Block.WIDTH - boxWidth / 2
end

--------------------------------------------------------------------------------

function Game:initialState()
  local spaces = {}

  for l = 1, NB_LINES do
    spaces[l] = {}
    for r = 1, NB_ROWS do
      spaces[l][r] = nil
    end
  end

  return {
    running = true,
    blocks = spaces,
    life = _G.START_LIFE,
    points = 0
  }
end

function Game:resetState()
  self.state = self:initialState()
end

--------------------------------------------------------------------------------

function Game:resetElements()
end

--------------------------------------------------------------------------------

function Game:createBox()
  self.box = display.newGroup()
  App.hud:insert(self.box)

  self.box.x = W / 2
  self.box.y = H / 2 - 50

  self.box.bg = display.newRect(self.box, 0, 0, boxWidth, boxHeigth)
  self.box.bg:setFillColor(colorize('#000000'))
  self.box.bg:setStrokeColor(colorize('#777777'))
  self.box.bg.strokeWidth = 10
end

--------------------------------------------------------------------------------

function Game:nextSpawn()
  timer.performWithDelay(
    SPEED,
    function()
      if (self.stopping) then
        return
      end
      local success = self:spawnBlock()
      if (not success) then
        self:gameOver()
      else
        if (self.state.running) then
          self:nextSpawn()
        end
      end
    end
  )
end

--------------------------------------------------------------------------------

function Game:spawnBlock()
  local row = math.random(1, NB_ROWS)

  local line
  for l = 1, NB_LINES do
    if (not line and not self.state.blocks[l][row]) then
      line = l
    end
  end

  if (not line) then
    return false
  end

  local color = math.random(1, NB_COLORS)

  local block =
    Block:create(
    {
      parent = self.box,
      l = line,
      r = row,
      x = ROWS[row],
      y = LINES[line],
      color = color,
      removeColor = function()
        self:removeColor(color)
      end
    }
  )

  self.state.blocks[line][row] = block
  return true
end

--------------------------------------------------------------------------------

function Game:removeColor(color)
  if (not self.state.running) then
    return
  end

  local nbBlocksRemoved = 0

  for r = 1, NB_ROWS do
    local nbLinesToGoDown = 0
    for l = 1, NB_LINES do
      local block = self.state.blocks[l][r]
      if (block) then
        if (block.color == color) then
          nbLinesToGoDown = nbLinesToGoDown + 1
          nbBlocksRemoved = nbBlocksRemoved + 1
          block:destroy()
          self.state.blocks[l][r] = nil
        else
          if (nbLinesToGoDown > 0) then
            local newLine = l - nbLinesToGoDown
            self.state.blocks[l][r] = nil
            self.state.blocks[newLine][r] = block
            block:fallTo(LINES[newLine])
          end
        end
      end
    end
  end

  local points = nbBlocksRemoved * nbBlocksRemoved

  self.state.life = self.state.life - _G.PRICE
  self.state.points = self.state.points + points

  self.life:refresh()
  self.points:refresh()
  self.points:displayWonPoints(points)

  if (self.state.life <= 0) then
    self:gameOver()
  end
end

--------------------------------------------------------------------------------

function Game:createLife()
  self.life =
    Life:create(
    {
      parent = App.hud,
      x = W * 0.5 - boxWidth / 2,
      y = self.box.y + boxHeigth / 2 + 100,
      width = boxWidth,
      height = 50
    }
  )
end

--------------------------------------------------------------------------------

function Game:onRun()
  self:createBox()
  self:createLife()
  self.points = Points:create()
  self:nextSpawn()
end

--------------------------------------------------------------------------------

function Game:gameOver()
  self.state.running = false
  local gameOverText =
    Text:create(
    {
      parent = App.hud,
      value = 'Game Over',
      x = W / 2,
      y = H / 3,
      fontSize = 100
    }
  )

  transition.from(
    gameOverText.display,
    {
      alpha = 0,
      delay = 1000
    }
  )
end

--------------------------------------------------------------------------------

function Game:onStop()
end

--------------------------------------------------------------------------------

return Game
