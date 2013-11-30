define [
  'cs!combo/cg'
  'cs!CanBeCentered'
], (
  cg
  CanBeCentered
) ->

  class Ball extends cg.SpriteActor
    @mixin CanBeCentered
    constructor: ->
      @anim = new cg.Animation cg.assets.sheets.ball, 40
      super
      @className = 'ball'
      @width = 16
      @height = 16
      @physical = true
      @body.bounce = 1
      @body.friction = 0
      @body.gravityScale = 0
      @speed = 150

      @body.left = cg.width/2 - @width/2
      @body.bottom = cg.height - 100
      @center()

      @delay 2000, ->
        @body.v.x = 50
        @body.v.y = 200
        @physical = true

    hit: ->
      @scale = 2
      @_hit?.stop()
      @_hit = @tween
        values:
          scale: 1
        easeFunc: 'elastic.out'

    update: ->
      super
      if cg.classes.brick
        for brick,i in cg.classes.brick
          if cg.physics.collide @body, brick.body
            collided = true
            @hit()
            brick.kill()

      # Force the ball to move at a constant speed at all times:
      @body.v.$norm().$mul(@speed)
