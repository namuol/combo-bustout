define ->

  CanBeCentered =
    center: ->
      @pivotX = @body.width/2
      @pivotY = @body.height/2
      @body.offset.x = @pivotX
      @body.offset.y = @pivotY
