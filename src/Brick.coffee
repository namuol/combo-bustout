define [
  'cs!combo/cg'
  'cs!CanBeCentered'
], (
  cg
  CanBeCentered
) ->

  class Brick extends cg.SpriteActor
    @mixin CanBeCentered
    constructor: ->
      super

      @className = 'brick'

      @physical = true
      @body.bounce = 1
      @body.friction = 0
      @body.mass = 0
      @center()
      @width = @texture.width
      @height = @texture.height

    kill: ->
      @texture = @deadTexture
      @emit 'kill'
      @delay 0, ->
        @removeClass 'brick'
        @tween
          values:
            scale: 0
          duration: 150
          easeFunc: 'back.in'
        .then -> @destroy()
