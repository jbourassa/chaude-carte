class App
  constructor:->
    @baseMap = Map '#base_canvas', window.baseMapHeatMapPoints
    @topMap  = Map '#top_canvas',  window.topMapHeatMapPoints
    @$dragger  = $('#dragger')
    this.initEvents()

  initEvents: ->
    $('#dragger').on('mousedown', this.draggerDown)
    $('#dragger').on('mouseup',   this.draggerUp)

  draggerDown: =>
    $(window).on('mousemove', this.draggerMove)

  draggerUp: =>
    $(window).off('mousemove', this.draggerMove)

  draggerMove: (e)=>
    pos = e.clientX

    @$dragger.css('left', "#{pos}px")

    posRatio  = pos * 100 / $(window).width()
    wrapWidth = 100 - posRatio

    canvasWidth      = 100 / wrapWidth * 100
    canvasMarginLeft = (100 - wrapWidth) / 100 * canvasWidth * -1

    $('.map-wrap').css('width', "#{wrapWidth}%")
    $('.map-wrap .map-canvas')
      .css('margin-left', "#{canvasMarginLeft}%")
      .css('width', "#{canvasWidth}%")

this.app = new App
