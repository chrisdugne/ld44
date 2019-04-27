--------------------------------------------------------------------------------

local game = require 'src.extensions.game'

--------------------------------------------------------------------------------

App:start(
  {
    name = 'Startup',
    version = '0.0.1',
    IOS_ID = '',
    ANALYTICS_TRACKING_ID = '',
    API_GATEWAY_URL = '',
    API_GATEWAY_KEY = '',
    -----------------------------------------
    -- 'production', 'development', 'editor'
    ENV = 'production',
    -----------------------------------------
    showHeadphonesScreen = false,
    -----------------------------------------
    background = {
      color = '#3a3f46'
    },
    screens = {
      HOME = 'home.scene'
    },
    colors = {
      text = '#ededed'
    },
    globals = {},
    fonts = {
      default = 'cherry/assets/PatrickHand-Regular.ttf'
    },
    scoreFields = {
      {
        name = 'points',
        label = 'Points',
        image = 'cherry/assets/images/gui/items/trophy.png',
        scale = 0.4
      }
    },
    extension = {
      game = game
    }
  }
)
