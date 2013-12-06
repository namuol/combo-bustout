define [
  'cs!combo/cg'
  'cs!CanBeCentered'
], (
  cg
  CanBeCentered
) ->

  class Power extends cg.SpriteActor
    @mixin CanBeCentered
    constructor: (@brick) ->
      super {}

      @width = @texture.width
      @height = @texture.height
      @physical = true
      @visible = false
      @center()

      @x = @brick.x
      @y = @brick.y

      @on @brick, 'kill', ->
        @visible = true
        @body.v.y = 100

    update: ->
      super
      return  unless @visible
      for paddle in cg('paddle')
        if @touches paddle
          @activate()
          @destroy()
          break

  class Up extends Power
    constructor: ->
      @texture = cg.assets.sheets.powerups[0]
      @className = 'powerup'
      super

    activate: ->
      cg('#main').addBall()

  class Down extends Power
    constructor: ->
      @texture = cg.assets.sheets.powerups[1]
      @className = 'powerdown'
      super

    activate: ->
      cg('paddle').each ->
        @shrink()
        @delay 10000, ->
          @unshrink()

  return {
    Up: Up
    Down: Down
  }
