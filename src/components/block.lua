--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local colorize = require 'cherry.libs.colorize'
local gesture = require 'cherry.libs.gesture'

--------------------------------------------------------------------------------

local Block = {
  HEIGHT = 120,
  WIDTH = 120
}

--------------------------------------------------------------------------------

function Block:create(options)
  local block =
    _.defaults(
    options or {},
    {
      parent = App.hud,
      x = W * 0.5,
      y = H * 0.5,
      color = 1
    }
  )

  block.image =
    display.newImageRect(
    block.parent,
    'assets/images/game/block.png',
    Block.WIDTH,
    Block.HEIGHT
  )

  block.image.x = options.x
  block.image.y = options.y
  block.image:setFillColor(colorize(App.colors[block.color]))

  transition.from(
    block.image,
    {
      alpha = 0,
      y = -H / 2,
      transition = easing.outQuad,
      time = 900
    }
  )

  gesture.onTap(
    block.image,
    function()
      options.removeColor()
    end
  )

  setmetatable(block, {__index = Block})
  return block
end

--------------------------------------------------------------------------------

function Block:destroy()
  display.remove(self.image)
end

--------------------------------------------------------------------------------

return Block
