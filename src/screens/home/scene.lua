--------------------------------------------------------------------------------

local composer = require 'composer'
local _ = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local Button = require 'cherry.components.button'
local Options = require 'cherry.components.options'

--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create(event)
  Options:create(self.view)

  self.startButton =
    Button:create(
    {
      parent = self.view,
      bg = false,
      text = {
        value = 'Start!',
        fontSize = 90,
        color = App.colors.text
      },
      x = W / 2,
      y = H / 2,
      action = function()
        Router:open(App.screens.PLAYGROUND)
      end
    }
  )
end

--------------------------------------------------------------------------------

function scene:resetView()
  self.startButton.alpha = 1
end

--------------------------------------------------------------------------------

function scene:show(event)
  if (event.phase == 'did') then
    self:resetView()

    animation.bounce(Options.toggleActionsButton, {scaleTo = .7})
    animation.bounce(Options.leaderboardButton, {scaleTo = .7})

    transition.from(
      self.startButton,
      {
        alpha = 0
      }
    )
  end
end

--------------------------------------------------------------------------------

function scene:hide(event)
  if (event.phase == 'did') then
    transition.to(
      self.startButton,
      {
        alpha = 0
      }
    )
  end
end

function scene:destroy(event)
end

--------------------------------------------------------------------------------

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

--------------------------------------------------------------------------------

return scene
