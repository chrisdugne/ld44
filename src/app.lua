--------------------------------------------------------------------------------

local game = require 'src.extensions.game'

--------------------------------------------------------------------------------

App:start(
  {
    name = 'LD44',
    version = '0.0.1',
    IOS_ID = '',
    ANALYTICS_TRACKING_ID = '',
    API_GATEWAY_URL = '',
    API_GATEWAY_KEY = '',
    -----------------------------------------
    -- 'production', 'development', 'editor'
    ENV = 'development',
    -----------------------------------------
    showHeadphonesScreen = false,
    useNamePicker = false,
    -----------------------------------------
    background = {
      color = '#000000'
    },
    colors = {
      '#DA1D38',
      '#33a14a',
      '#ffe35b',
      '#911eb4',
      text = '#ededed'
    },
    globals = {
      START_LIFE = 10,
      PRICE = 1
    },
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
