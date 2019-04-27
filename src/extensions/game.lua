--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Button = require 'cherry.components.button'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

function Game:initialState()
  return _.extend({})
end

function Game:resetState()
  self.state = self:initialState()
end

function Game:resetElements()
end

--------------------------------------------------------------------------------

function Game:onRun()
  Text:create(
    {
      parent = App.hud,
      x = W / 2,
      y = H / 2,
      value = 'Playground',
      fontSize = 80,
      font = _G.FONTS.default,
      color = App.colors.text
    }
  )

  Button:create(
    {
      parent = App.hud,
      text = {
        value = 'back',
        fontSize = 50,
        color = App.colors.dark
      },
      x = W / 2,
      y = H * 0.8,
      action = function()
        Router:open(App.screens.HOME)
      end
    }
  )
end

--------------------------------------------------------------------------------

function Game:onStop(noScore)
end

--------------------------------------------------------------------------------

return Game
