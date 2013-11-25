define [
  'cs!combo/cg'
  'cs!Breakout'
], (
  cg
  Breakout
) ->
  return ->
    cg.init
      name: 'Breakout'
      container: 'container'
      forceCanvas: !!parseInt(cg.env.getParameterByName('forceCanvas'))
      backgroundColor: 0x333333

    window.app = cg.stage.addChild new Breakout

    pleasewait = document.getElementById 'pleasewait'
    pleasewait.style.display = 'none'

    container = document.getElementById 'container'
    container.style.display = 'inherit'
