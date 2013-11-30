define [
  'cs!combo/cg'
  'cs!CanBeCentered'
], (
  cg
  CanBeCentered
) ->

  class Paddle extends cg.SpriteActor
    @mixin CanBeCentered
    constructor: (params={}) ->
      [@normal, @small] = cg.assets.sheets.paddle
      params.texture = @normal
      super params

      @width = @texture.width
      @height = @texture.height

      @speed = 250
      @physical = true
      @body.mass = 0
      @body.bounce = 1
      @body.friction = 0
      @body.gravityScale = 0
      @y = cg.height - 48

      @center()
      @x = cg.width/2

      @on cg.input, 'mouseMove', ({x}) ->
        @x = Math.min(cg.width-@width/2, Math.max(@width/2, x))
        @x ?= cg.width/2

    hit: ->
