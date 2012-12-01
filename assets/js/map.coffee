class Map
  constructor:(id,heatPoints = [],center = [46.803283,-71.189596])->
    @id     = id
    @$el    = $("#"+id)
    @center = new google.maps.LatLng(center[0], center[1])
    this.initMap(heatPoints,center)
    this.initEvents()

  initEvents: ->
    @$el.bind('map_center_changed')

  initMap: (heatPoints, center)->
    @map    = new google.maps.Map(@$el[0],
      center:    @center
      zoom:      14
      mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    heatmap = new google.maps.visualization.HeatmapLayer(
      data: heatPoints
    )
    heatmap.setMap(@map)

    google.maps.event.addListener(@map, 'center_changed', =>
      clearTimeout @timeout
      @timeout = setTimeout =>
        $(window).trigger "#{@id}_center_changed", @map.getCenter()
      , 0
    )

  reCenter: (newCenter)->
    @map.setCenter(newCenter)

this.Map = Map