class Map
  constructor:(id,heatPoints = [],center = [46.803283,-71.189596])->
    @$el    = $(id)
    @center = new google.maps.LatLng(center[0], center[1])
    @map    = new google.maps.Map(@$el[0],
      center:    @center
      zoom:      14
      mapTypeId: google.maps.MapTypeId.SATELLITE
    )
    @heatmap = new google.maps.visualization.HeatmapLayer(
      data: heatPoints
    )
    heatmap.setMap(map)

this.Map = Map