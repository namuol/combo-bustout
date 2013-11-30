define [
  'cs!combo/cg'
  'cs!Brick'
  'cs!Paddle'
  'cs!Ball'
], (
  cg
  Brick
  Paddle
  Ball
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
      @ball = @addChild new Ball

      @loadLevel 0

    loadLevel: (levelNum) ->
      level = levels[levelNum]

      # Clear the bricks:
      cg.classes.brick?.destroy()
      for row,y in level.bricks.split '\n'
        for letter,x in row
          continue  if letter is ' '
          brick = @addChild new Brick
            x: LEFT + x * 32
            y:  TOP + y * 16
            texture: cg.assets.sheets.bricks[brickColors[letter]]
            deadTexture: cg.assets.sheets.bricks[brickColors[letter] + 4]

      cg.classes.brick.set 'scale', 0
      cg.classes.brick.tween
        values: scale: 1
        duration: 500
        delay: (num) -> num*8 + cg.rand 60
        easeFunc: 'elastic.out'

    update: ->
      super

      # We use `touches` instead of `cg.physics.collide` for artificial control of the bounce:
      if @ball.touches @paddle
        @ball.body.v.y *= -1
        @ball.body.v.x = ((@ball.x - @paddle.x) / @paddle.width) * 300
        @ball.body.bottom = @paddle.body.top
        @ball.hit()
        @paddle.hit()
        console.log 'bounce!'
