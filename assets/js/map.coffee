class Map
  constructor:(id,dataSetName,heatPoints = [], gradient, center = [46.803283,-71.299596])->
    @id     = id
    @name = dataSetName
    @$el    = $("#"+id)
    @zoomFlag = true
    @center = new google.maps.LatLng(center[0], center[1])
    this.initMap(heatPoints, center)
    this.initEvents()
    this.initDataSet(dataSetName, gradient)

  initEvents: ->
    @$el.bind('map_center_changed')

  initDataSet: (name, gradient)->
    @name = name
    $.ajax
      type: 'GET'
      url: "/#{name}.json"
      success: (data) =>
        this.generateHeathMap(data, gradient)

  initMap: (heatPoints, center)->
    @map = new google.maps.Map(@$el[0],
      center:    @center
      zoom:      13
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControl: false
      zoomControl: true
      zoomControlOptions: {
          style: google.maps.ZoomControlStyle.SMALL
          position: google.maps.ControlPosition.LEFT_BOTTOM
      },
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

  generateHeathMap: (data, gradient)->
    @heatmap?.setMap(null)
    formated = data.map((point)->
      location: new google.maps.LatLng(point.latlon[0], point.latlon[1])
      weight:   point.weight || 1
    )

    @heatmap = new google.maps.visualization.HeatmapLayer(
      data: formated,
      opacity: 0.9,
      gradient: this.getGradient()
    )
    @heatmap.setMap(@map)

  getGradient: ->
    if @name == 'trees'
      [
        'rgba(0, 125, 33, 0)',
        '#007d21',
        '#008f28',
        '#00f91e'
      ]
    else if @name == 'quebec'
      [
        'rgba(0, 237, 242, 0)',
        '#00edf2',
        '#00bfbb',
        '#00a862',
        '#009600',
        '#edcd00',
        '#e7de00',
        '#f6af05'
      ]
    else if @name == 'bus_stops'
      [
        'rgba(0, 237, 242, 0)',
        '#102a7d',
        '#a2fa54'
      ]
    else
      [
        'rgba(255, 3, 3, 0)',
        '#ff0303',
        '#bb0641',
        '#cd0d89',
        '#ff9700',
        '#f7cb00'
      ]

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