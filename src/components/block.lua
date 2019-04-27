--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local colorize = require 'cherry.libs.colorize'

--------------------------------------------------------------------------------

local Block = {
  HEIGHT = 120,
  WIDTH = 120
}

--------------------------------------------------------------------------------

function Block:create(options)
  options =
    _.defaults(
    options or {},
    {
      parent = App.hud,
      x = W * 0.5,
      y = H * 0.5,
      color = 1
    }
  )

  self.image =
    display.newImageRect(
    options.parent,
    'assets/images/game/block.png',
    self.WIDTH,
    self.HEIGHT
  )

  self.image.x = options.x
  self.image.y = options.y
  self.image:setFillColor(colorize(App.colors[options.color]))

  transition.from(
    self.image,
    {
      y = -H / 2,
      transition = easing.outQuad
    }
  )

  return self
end

--------------------------------------------------------------------------------

return Block
