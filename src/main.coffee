define [
  'cs!combo/cg'
  'cs!combo/physics/Physics'
  'cs!Breakout'
], (
  cg
  Physics
  Breakout
) ->
  return ->
    cg.plugin Physics
    cg.init
      name: 'Breakout'
      container: 'container'
      forceCanvas: !!parseInt(cg.env.getParameterByName('forceCanvas'))
      usetiles: cg.env.getParameterByName('usetiles')?
      backgroundColor: 0x333333

    window.app = cg.stage.addChild new Breakout

    pleasewait = document.getElementById 'pleasewait'
    pleasewait.style.display = 'none'

    container = document.getElementById 'container'
    container.style.display = 'inherit'
