define ->

  CanBeCentered =
    center: ->
      @pivotX = @width/2
      @pivotY = @height/2
      @body.offset.x = @pivotX
      @body.offset.y = @pivotY

  class Brick extends cg.Actor
    @mixin CanBeCentered
    constructor: ->
      super
      @className = 'brick'

      @physical = true
      @body.bounce = 1
      @body.friction = 0
      @body.mass = 0
      @body.gravityScale = 0


      @gfx = @addChild new cg.rendering.Graphics
      @gfx.beginFill 0xFFFFFF
      @gfx.drawRect 0, 0, @width, @height
      @gfx.endFill()
      @center()

    kill: ->
      @delay 0, ->
        @removeClass 'brick'
        @tween
          values:
            scale: 0
          duration: 100
          easeFunc: 'back.in'
        .then -> @destroy()

  class Ball extends cg.Actor
    @mixin CanBeCentered
    constructor: ->
      super
      @className = 'ball'
      @width = 5
      @height = 5
      @physical = true
      @body.bounce = 1
      @body.friction = 0
      @body.gravityScale = 0
      @speed = 150

      @gfx = @addChild new cg.rendering.Graphics
      @gfx.beginFill 0xFFFFFF
      @gfx.drawRect 0, 0, @width, @height
      @gfx.endFill()

      @body.left = cg.width/2 - @width/2
      @body.bottom = cg.height - 40
      @center()
      @delay 2000, ->
        @body.v.x = 50
        @body.v.y = 200
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

  class Paddle extends cg.Actor
    @mixin CanBeCentered
    constructor: ->
      super
      @width = 50
      @height = 10
      @speed = 250
      @physical = true
      @body.mass = 0
      @body.bounce = 1
      @body.friction = 0
      @body.gravityScale = 0

      @controls = new cg.input.ControlMap 'paddle',
        left: 'left'
        right: 'right'

      @gfx = @addChild new cg.rendering.Graphics
      @gfx.beginFill 0xFFFFFF
      @gfx.drawRect 0, 0, @width, @height
      @gfx.endFill()

      @body.bottom = cg.height
      @body.left = cg.width/2 - @width/2

      @center()
    hit: ->
      @_hit?.stop()
      @gfx.y += 2
      @_hit = cg.tween @gfx,
        values:
          y: -2
        relative: true
        duration: 200
        easeFunc: 'elastic.out'
    update: ->
      super

      if @actions.left.held()
        @body.v.x = -@speed
      else if @actions.right.held()
        @body.v.x = @speed
      else
        @body.v.zero()

  PADDING = 2
  BRICK_WIDTH = 30
  BRICK_HEIGHT = 10
  COLUMNS = 12
  ROWS = 8

  class MainGame extends cg.Scene
    constructor: ->
      super
      cg.input.on 'keyDown:space', ->
        cg.timeScale = if cg.timeScale is 1 then 0.1 else 1

      @paddle = @addChild new Paddle
      @ball = @addChild new Ball
      @bricks = []

      cg.width = COLUMNS * (BRICK_WIDTH + PADDING) + PADDING
      cg.physics.bounds.right = cg.width

      x = 0
      while x < COLUMNS
        y = 0
        while y < ROWS
          @addChild new Brick
            width: BRICK_WIDTH
            height: BRICK_HEIGHT
            x: PADDING + x * (BRICK_WIDTH + PADDING)
            y: PADDING + (BRICK_HEIGHT + PADDING)*3 + y * (BRICK_HEIGHT + PADDING)
          ++y
        ++x
      cg.classes.brick.set 'scale', 0
      cg.classes.brick.tween
        values: scale: 1
        duration: 500
        delay: (num) -> num * 4
        easeFunc: 'elastic.out'

    update: ->
      super

      if @ball.touches @paddle
        @ball.body.v.y *= -1
        @ball.body.v.x = ((@ball.x - @paddle.x) / @paddle.width) * 300
        @ball.body.bottom = @paddle.body.top
        @ball.hit()
        @paddle.hit()
        console.log 'bounce!'

  class Breakout extends cg.Scene
    assets:
      textures:
        logo: 'assets/logo.png'
    constructor: ->
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
        @splashScreen.destroy()
        @main = @addChild new MainGame

  return Breakout
