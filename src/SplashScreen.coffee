define [
  'cs!combo/cg'
], (
  cg
) ->

  class SplashScreen extends cg.Scene
    constructor: ->
      super

      logo = @addChild new cg.SpriteActor
        texture: 'logo'
        anchorX: 0.5
        anchorY: 0.5
        x: cg.width/2
        y: cg.height*0.33

      @text1 = @addChild new cg.Text 'Click/Tap to start',
        align: 'center'
        anchorX: 0.5
        anchorY: 0.5
        x: cg.width/2
        y: 250

      @text2 = @addChild new cg.Text 'Use L/R arrow keys to skip levels',
        align: 'center'
        anchorX: 0.5
        anchorY: 0.5
        x: cg.width/2
        y: 360

      @on cg.input, 'touchDown', ->
        @hide 250, ->
          @pause()
          main = cg('#main')
          main.lives = 3
          main.score = 0
          main.loadLevel(0)
          main.show()
          main.resume()

    setText: (text1='', text2='') ->
      @text1.string = text1
      @text2.string = text2
      return @
