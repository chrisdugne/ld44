--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Text = require 'cherry.components.text'
local colorize = require 'cherry.libs.colorize'
local gesture = require 'cherry.libs.gesture'

--------------------------------------------------------------------------------

local Life = require 'src.life'
local Points = require 'src.points'
local Block = require 'src.block'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

local NB_LINES = 8
local NB_ROWS = 5
local NB_COLORS = 4
local SPEED = 200

local BLOCK_WIDTH = H / 12
local BLOCK_HEIGHT = H / 12

local boxWidth = NB_ROWS * BLOCK_WIDTH
local boxHeigth = NB_LINES * BLOCK_HEIGHT

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
      x = self.ROWS[row],
      y = self.LINES[line],
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
            block:fallTo(self.LINES[newLine])
          end
        end
      end
    end
  end

  local points = nbBlocksRemoved * nbBlocksRemoved

  self.state.life = self.state.life - _G.PRICE
  self.state.points = self.state.points + points

  self.life:displayConsume()
  self.points:displayWonPoints(points)
  self.life:refresh()
  self.points:refresh()

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
  self.LINES = {}
  self.ROWS = {}

  for l = 1, NB_LINES do
    self.LINES[l] = boxHeigth / 2 - (l - 1 / 2) * BLOCK_HEIGHT
  end

  for r = 1, NB_ROWS do
    self.ROWS[r] = (r - 1 / 2) * BLOCK_WIDTH - boxWidth / 2
  end

  math.randomseed(os.time())
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

  local restartText =
    Text:create(
    {
      parent = App.hud,
      value = 'Restart',
      x = W / 2,
      y = H / 3 + 200,
      fontSize = 70
    }
  )

  transition.from(
    restartText.display,
    {
      alpha = 0,
      delay = 2000
    }
  )

  transition.to(
    self.box,
    {
      alpha = 0.2
    }
  )

  gesture.onTap(
    restartText.display,
    function()
      transition.to(
        App.hud,
        {
          alpha = 0,
          onComplete = function()
            self:stop(true)
            self:start()
            transition.to(
              App.hud,
              {
                alpha = 1
              }
            )
          end
        }
      )
    end
  )
end

--------------------------------------------------------------------------------

function Game:onStop()
end

--------------------------------------------------------------------------------

return Game
