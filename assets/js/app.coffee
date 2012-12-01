class App
  constructor:->
    baseMap = Map '#base_canvas', window.baseMapHeatMapPoints
    topMap  = Map '#top_canvas',  window.topMapHeatMapPoints

this.app = App()