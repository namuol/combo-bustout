define [
  'cs!combo/cg'
  'cs!Brick'
  'cs!Paddle'
  'cs!Ball'
  'cs!Power'
], (
  cg
  Brick
  Paddle
  Ball
  Power
) ->

  levels = [
      name: 'letsa begin'
      bricks: '''
            gog
          obgggbo
           bbbbb
          '''
      powerUps: 1
      powerDowns: 1
    ,
      name: 'how\'s it going?'
      bricks: '''
           gogog
           bbbbb
          gbrbrbg
          gbbbbbg
          gb   bg
           bbbbb
          '''
      powerUps: 1
      powerDowns: 1
    ,
      name: 'tie fighta!'
      bricks: '''
           b g b
          b bob b
          bgbobgb
          b bob b
           b   b
          r r r r
          '''
      powerUps: 2
      powerDowns: 2
    ,
      name: 'swirl'
      bricks: '''
          rgobrgo
          b
          o obrgo
          g g   b
          r r r r
          b bog g
          o     o
          grbogrb
          '''
      powerUps: 2
      powerDowns: 3
  ]

  brickColors =
    b: 0
    o: 1
    r: 2
    g: 3

  LEFT = 48
  TOP = 64

  class MainGame extends cg.Scene
    constructor: ->
      super

      @paddle = @addChild new Paddle
      @countDown = @addChild new cg.SpriteActor
        anim: cg.assets.sheets.numbers.anim [2,1,0], 1000, false
        anchorX: 0.5
        anchorY: 0.5
        x: cg.width/2
        y: 250

      @livesText = @addChild new cg.Text 'lives: 3',
        align: 'left'
        x: 18
        y: cg.height-32

      @scoreText = @addChild new cg.Text 'score: 0',
        align: 'left'
        x: 120
        y: cg.height-32

      @levelText = @addChild new cg.Text 'level: 1',
        align: 'left'
        x: 243
        y: cg.height-32

      @__lives = 3
      Object.defineProperty @, 'lives',
        get: -> @__lives
        set: (val) ->
          @__lives = val
          @livesText.string = 'lives: ' + val
          @livesText.scale = 1.2
          @livesText.tween values: scale: 1

      @__score = 0
      Object.defineProperty @, 'score',
        get: -> @__score
        set: (val) ->
          @__score = val
          @scoreText.string = 'score: ' + val
          @scoreText.scale = 1.2
          @scoreText.tween values: scale: 1

      @__levelNum = 0
      Object.defineProperty @, 'levelNum',
        get: -> @__levelNum
        set: (val) ->
          @__levelNum = val
          @levelText.string = 'level: ' + val
          @levelText.scale = 1.2
          @levelText.tween values: scale: 1

      @countDown.on @countDown.anim, 'end', -> @hide()

      cg.physics.gravity.zero()

    loadLevel: (@levelNum) ->
      level = levels[@levelNum]
      if not level
        @pause()
        @hide()
        cg('#splashscreen').setText('You Win!').resume().show()
        return

      # Clear powerups:
      cg('powerup powerdown').destroy()

      # Clear the bricks:
      cg('brick').destroy()

      # Load the bricks:
      for row,y in level.bricks.split '\n'
        for letter,x in row
          continue  if letter is ' '
          brick = @addChild new Brick
            x: LEFT + x * 32
            y:  TOP + y * 16
            texture: cg.assets.sheets.bricks[brickColors[letter]]
            deadTexture: cg.assets.sheets.bricks[brickColors[letter] + 4]

      toChooseFrom = cg.Group.create cg('brick')
      for num in [0..level.powerUps]
        chosenBrick = cg.rand.pick toChooseFrom
        @addChild new Power.Up chosenBrick
        toChooseFrom.remove chosenBrick

      for num in [0..level.powerDowns]
        chosenBrick = cg.rand.pick toChooseFrom
        @addChild new Power.Down chosenBrick
        toChooseFrom.remove chosenBrick

      cg('brick').set 'scale', 0
      cg('brick').tween
        values: scale: 1
        duration: 500
        delay: (num) -> num*8 + cg.rand 60
        easeFunc: 'elastic.out'

      cg('brick').on 'kill', =>
        @score += 100
        if cg('brick').length is 1
          @delay 500, -> @loadLevel @levelNum + 1

      cg('ball')?.destroy()
      @countDown.show()
      @countDown.anim.rewind()
      @addBall()

    addBall: ->
      ball = @addChild new Ball
      ball.x = cg.width/2 - 50
      ball.y = cg.height/2
      @on ball, 'kill', ->
        if cg('ball').length is 1
          @addBall()
          if --@lives is 0
            @pause()
            @hide()
            cg('#splashscreen').setText('Game Over!').resume().show()

      @delay 3000, ->
        ball.body.v.x = 50
        ball.body.v.y = 100

    update: ->
      super

      # We use `touches` instead of `cg.physics.collide` for artificial control of the bounce:
      do (paddle=@paddle) ->
        cg('ball').each ->
          return  unless @touches paddle
          @body.v.y *= -1
          @body.v.x = ((@x - paddle.x) / paddle.width) * 300
          @body.bottom = paddle.body.top
          @hit()
          paddle.hit()
