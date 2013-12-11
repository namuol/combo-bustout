define [
  'cs!combo/cg'
  'cs!combo/physics/Physical'
  'cs!CanBeCentered'
], (
  cg
  Physical
  CanBeCentered
) ->

  class Power extends cg.SpriteActor
    @mixin CanBeCentered
    @plugin Physical
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
      cg.assets.sounds.powerup.play()
      cg('#main').addBall()

  class Down extends Power
    constructor: ->
      @texture = cg.assets.sheets.powerups[1]
      @className = 'powerdown'
      super

    activate: ->
      cg.assets.sounds.powerdown.play()
      cg('paddle').each ->
        @shrink()

      @delay 10000, ->
        cg.assets.sounds.recover.play()
        cg('paddle').each ->
          @unshrink()

  return {
    Up: Up
    Down: Down
  }

