--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Block = require 'src.components.block'
local Text = require 'cherry.components.text'
local colorize = require 'cherry.libs.colorize'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

local NB_LINES = 8
local NB_ROWS = 2
local NB_COLORS = 4
local SPEED = 500

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

  return _.extend(
    {
      blocks = spaces
    }
  )
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
  self.box.y = H / 2 - 100

  self.box.bg = display.newRect(self.box, 0, 0, boxWidth, boxHeigth)
  self.box.bg:setFillColor(colorize('#000000'))
  self.box.bg:setStrokeColor(colorize('#ffffff'))
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
      if (success) then
        self:nextSpawn()
      else
        self:gameOver()
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
  for r = 1, NB_ROWS do
    local nbLinesToGoDown = 0
    for l = 1, NB_LINES do
      local block = self.state.blocks[l][r]
      if (block) then
        if (block.color == color) then
          nbLinesToGoDown = nbLinesToGoDown + 1
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
end

--------------------------------------------------------------------------------

function Game:onRun()
  self:createBox()
  self:nextSpawn()
end

--------------------------------------------------------------------------------

function Game:gameOver()
  Text:create(
    {
      parent = App.hud,
      value = 'Game Over',
      x = W / 2,
      y = H / 3,
      fontSize = 100
    }
  )
end

--------------------------------------------------------------------------------

function Game:onStop()
end

--------------------------------------------------------------------------------

return Game
