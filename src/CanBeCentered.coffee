define ->
  
  CanBeCentered =
    center: ->
      @pivotX = @width/2
      @pivotY = @height/2
      @body.offset.x = @pivotX
      @body.offset.y = @pivotY
