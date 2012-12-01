class Map
  constructor:(id,heatPoints = [],center = [46.803283,-71.239596])->
    @id     = id
    @$el    = $("#"+id)
    @zoomFlag = true
    @center = new google.maps.LatLng(center[0], center[1])
    this.initMap(heatPoints,center)
    this.initEvents()

  initEvents: ->
    @$el.bind('map_center_changed')

  initMap: (heatPoints, center)->
    @map = new google.maps.Map(@$el[0],
      center:    @center
      zoom:      14
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControl: false
      zoomControl: true
      mapTypeControl: false
      scaleControl: false
      streetViewControl: false
      overviewMapControl: false
    )

    mapStyles = [{
      featureType: "all"
      elementType: "all"
      stylers: [{saturation: -100 }]
    },{
      featureType: "all"
      elementType: "labels"
      stylers: [
        visibility: "off"
      ]
    },{
      featureType: "administrative.neighborhood"
      elementType: "labels.text"
      stylers: [
        visibility: "on"
      ]
    }]
    styledMap = new google.maps.StyledMapType(mapStyles, {name: "Styled Map"})

    @map.mapTypes.set("styled", styledMap)
    @map.setMapTypeId("styled")

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

    google.maps.event.addListener(@map, 'zoom_changed', =>
      if @zoomFlag
        $(window).trigger "#{@id}_zoom_changed", [@map.getCenter(), @map.getZoom()]
    )

  zoomOn: ->
    @zoomFlag = true

  zoomOff: ->
    @zoomFlag = false

  reCenter: (newCenter)->
    @map.setCenter(newCenter)

  reZoom: (newCenter, newZoom)->
    @map.setZoom(newZoom)
    @map.setCenter(newCenter)

this.Map = Map