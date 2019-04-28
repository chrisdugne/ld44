--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Points = {}
local POINTS_Y = H / 18

--------------------------------------------------------------------------------

function Points:create(options)
  local component =
    _.defaults(
    options or {},
    {
      parent = App.hud,
      x = W * 0.5,
      y = H * 0.5
    }
  )

  setmetatable(component, {__index = Points})

  component:createText()
  return component
end

--------------------------------------------------------------------------------

function Points:createText()
  self.text =
    Text:create(
    {
      parent = App.hud,
      value = App.game.state.points,
      x = W * 0.5,
      y = POINTS_Y,
      font = _G.FONTS.default,
      fontSize = 120,
      grow = true
    }
  )
end

--------------------------------------------------------------------------------

function Points:displayWonPoints(nbBlocksRemoved)
  local pts =
    Text:create(
    {
      parent = App.hud,
      value = '+ ' .. nbBlocksRemoved,
      x = W * 0.5,
      y = H / 3,
      font = _G.FONTS.default,
      fontSize = 90,
      grow = true
    }
  )

  transition.to(
    pts.display,
    {
      alpha = 0,
      time = 800,
      y = POINTS_Y,
      transition = easing.inBack,
      onComplete = function()
        pts:destroy()
      end
    }
  )
end

--------------------------------------------------------------------------------

function Points:refresh()
  self.text:setValue(App.game.state.points)
end

--------------------------------------------------------------------------------

return Points
