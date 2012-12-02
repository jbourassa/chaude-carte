class App
  constructor:->
    @baseMap = new Map 'base_canvas', 'quebec', window.baseMapHeatMapPoints
    @topMap  = new Map 'top_canvas', 'trees',  window.topMapHeatMapPoints
    @$dragger  = $('#dragger')
    this.initEvents()

  initEvents: ->
    $('#dragger').on 'mousedown',    this.draggerDown
    $('#dragger').on 'mouseup',      this.draggerUp
    $(window).bind 'top_canvas_center_changed',  this.syncCenterBaseMap
    $(window).bind 'base_canvas_center_changed', this.syncCenterTopMap
    $(window).bind 'top_canvas_zoom_changed',    this.syncZoomBaseMap
    $(window).bind 'base_canvas_zoom_changed',   this.syncZoomTopMap
    $("#top_map_dataset_select").change this.changeDataSet

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

  syncCenterBaseMap: (e,newCenter)=>
    @baseMap.reCenter newCenter

  syncCenterTopMap: (e,newCenter)=>
    @topMap.reCenter newCenter

  syncZoomBaseMap: (e,newCenter, newZoom)=>
    @topMap.zoomOff()
    @baseMap.reZoom newCenter, newZoom
    @topMap.zoomOn()

  syncZoomTopMap: (e,newCenter, newZoom)=>
    @baseMap.zoomOff()
    @topMap.reZoom newCenter, newZoom
    @baseMap.zoomOn()

  changeDataSet: (e)=>
    @topMap.initDataSet($(e.currentTarget).val())

this.app = new App
