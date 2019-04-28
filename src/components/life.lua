--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local ProgressBar = require 'cherry.components.progress-bar'

--------------------------------------------------------------------------------

local Life = {}

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

  return life
end
--------------------------------------------------------------------------------

function Life:refresh()
  self.lifeBar:reach(App.game.state.life / _G.START_LIFE * 100)
end

--------------------------------------------------------------------------------

return Life
