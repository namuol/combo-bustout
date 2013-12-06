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
      @small.width = 32
      params.texture = @normal
      super params
      @className = 'paddle'

      @width = @texture.width
      @height = @texture.height

      @speed = 250
      @physical = true
      @body.mass = 0
      @body.bounce = 1
      @body.friction = 0
      @y = cg.height - 48

      @center()
      @x = cg.width/2

      @on cg.input, 'mouseMove', ({x}) ->
        @x = Math.min(cg.width-@body.width/2, Math.max(@body.width/2, x))
        @x ?= cg.width/2

    hit: ->

    unshrink: ->
      return  unless @shrunken
      @shrunken = false
      @texture = @normal
      @width = 32
      @body.width = 48
      @center()
      @tween
        values:
          width: 48
        duration: 700
        easeFunc: 'elastic.out'

    shrink: ->
      return  if @shrunken
      @shrunken = true
      @texture = @small
      @width = 64
      @body.width = 32
      @center()
      @tween
        values:
          width: 48
        duration: 700
        easeFunc: 'elastic.out'
