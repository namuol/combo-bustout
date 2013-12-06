define [
  'cs!combo/cg'
  'cs!MainGame'
  'cs!SplashScreen'
], (
  cg
  MainGame
  SplashScreen
)->

  class Breakout extends cg.Scene
    assets:
      textures:
        bg_prerendered: 'assets/bg_prerendered.png'
        logo: 'assets/logo.png'
      sheets:
        numbers:  ['assets/numbers.png', 32, 48]
        powerups: ['assets/powerups.png', 16, 16]
        paddle:   ['assets/paddle.png', 48, 16]
        bricks:   ['assets/bricks.png', 32, 16]
        ball:     ['assets/ball.png', 16,16]
      sounds:
        brickDeath: ['assets/brickDeath.ogg','assets/brickDeath.mp3','assets/brickDeath.m4a']
        countdownBlip: ['assets/countdownBlip.ogg','assets/countdownBlip.mp3','assets/countdownBlip.m4a']
        powerdown: ['assets/powerdown.ogg','assets/powerdown.mp3','assets/powerdown.m4a']
        powerup: ['assets/powerup.ogg','assets/powerup.mp3','assets/powerup.m4a']
        recover: ['assets/recover.ogg','assets/recover.mp3','assets/recover.m4a']

    constructor: ->
      cg.width = 320
      cg.height = 416
      cg.physics.bounds =
        left: 16
        right: cg.width - 16
        top: 16
        bottom: false

      super
      @loadingScreen = new cg.extras.LoadingScreen

      @loadingScreen.begin()

      cg.Text.defaults.color = 'black'
      cg.Text.defaults.font = '14pt sans-serif'

    preloadProgress: (src, data, loaded, count) ->
      super
      @loadingScreen.setProgress loaded/count

    preloadComplete: ->
      super
      @bg = @addChild new cg.SpriteActor texture: 'bg_prerendered'

      @loadingScreen.complete().then =>
        @loadingScreen.destroy()

        @addChild new MainGame
          id: 'main'
          visible: false
          paused: true

        @addChild new SplashScreen
          id: 'splashscreen'

  return Breakout
