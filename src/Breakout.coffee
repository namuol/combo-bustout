define [
  'cs!combo/cg'
  'cs!MainGame'
], (
  cg
  MainGame
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

    constructor: ->
      cg.width = 320
      cg.height = 416
      cg.physics.bounds =
        left: 16
        right: cg.width - 16
        top: 16
        bottom: cg.height

      super
      cg.log 'Combo game initialized!'
      @loadingScreen = new cg.extras.LoadingScreen
      @loadingScreen.begin()

    preloadProgress: (src, data, loaded, count) ->
      super
      @loadingScreen.setProgress loaded/count

    preloadComplete: ->
      super
      @splashScreen = @addChild new cg.extras.SplashScreen.Simple 'logo'

      @loadingScreen.complete().then =>
        @loadingScreen.destroy()
        @splashScreen.splashIn()

      @once @splashScreen, 'done', ->
        cg.log cg.assets
        @splashScreen.destroy()
        @bg = @addChild new cg.SpriteActor texture: 'bg_prerendered'
        @main = @addChild new MainGame

  return Breakout
