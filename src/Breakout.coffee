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
        brickDeath: ['brickDeath.ogg','brickDeath.mp3','brickDeath.m4a']
        countdownBlip: ['countdownBlip.ogg','countdownBlip.mp3','countdownBlip.m4a']
        powerdown: ['powerdown.ogg','powerdown.mp3','powerdown.m4a']
        powerup: ['powerup.ogg','powerup.mp3','powerup.m4a']
        recover: ['recover.ogg','recover.mp3','recover.m4a']

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
