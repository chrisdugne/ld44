--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local ProgressBar = require 'cherry.components.progress-bar'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Life = {}
local COIN_SCALE = 0.7

--------------------------------------------------------------------------------

function Life:create(options)
  local life =
    _.defaults(
    options or {},
    {
      parent = App.hud,
      x = W * 0.5,
      y = H * 0.5
    }
  )

  setmetatable(life, {__index = Life})
  life.lifeBar =
    ProgressBar:new(
    _.extend(
      options,
      {
        hideText = true,
        useRects = true
      }
    )
  )

  life:createText()
  life:createCoin()
  return life
end

--------------------------------------------------------------------------------

-- todo relative X positioning
function Life:createText()
  self.text =
    Text:create(
    {
      parent = App.hud,
      value = App.game.state.life,
      x = W * 0.5,
      y = self.y + 100,
      anchorX = 1,
      font = _G.FONTS.default,
      fontSize = 70,
      grow = true
    }
  )
end
--------------------------------------------------------------------------------

function Life:createCoin()
  self.coin =
    display.newImage(
    App.hud,
    'assets/images/game/coin.png',
    self.text.x + 10,
    self.text.y
  )

  self.coin.anchorX = 0
  animation.bounce(
    self.coin,
    {
      scaleTo = COIN_SCALE
    }
  )
end

--------------------------------------------------------------------------------

function Life:refresh()
  self.lifeBar:reach(App.game.state.life / _G.START_LIFE * 100)
  self.text:setValue(App.game.state.life)
  animation.bounce(
    self.coin,
    {
      scaleTo = COIN_SCALE
    }
  )
end

--------------------------------------------------------------------------------

return Life
