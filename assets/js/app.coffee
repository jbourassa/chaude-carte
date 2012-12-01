class App
  constructor:->
    @baseMap = new Map 'base_canvas', window.baseMapHeatMapPoints
    @topMap  = new Map 'top_canvas',  window.topMapHeatMapPoints
    @$dragger  = $('#dragger')
    this.initEvents()

  initEvents: ->
    $('#dragger').on 'mousedown',    this.draggerDown
    $('#dragger').on 'mouseup',      this.draggerUp
    $(window).bind 'top_canvas_center_changed',  this.syncBaseMap
    $(window).bind 'base_canvas_center_changed', this.syncTopMap

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

  syncBaseMap: (e,newCenter)=>
    @baseMap.reCenter newCenter

  syncTopMap: (e,newCenter)=>
    @topMap.reCenter newCenter

this.app = new App
