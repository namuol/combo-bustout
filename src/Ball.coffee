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
      @speed = 200

      @body.left = cg.width/2 - @width/2
      @body.bottom = cg.height - 100
      @center()

    hit: ->
      @scale = 2
      @_hit?.stop()
      @_hit = @tween
        values:
          scale: 1
        easeFunc: 'elastic.out'

    kill: ->
      @emit 'kill'
      @destroy()

    update: ->
      super
      for brick,i in cg('brick')
        if cg.physics.collide @body, brick.body
          collided = true
          @hit()
          brick.kill()

      # Force the ball to move at a constant speed at all times:
      @body.v.$norm().$mul(@speed)

      if @body.top > cg.height
        @kill()
