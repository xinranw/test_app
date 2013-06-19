// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
// 
//= require jquery
//= require jquery_ujs
//= require_tree .

  
var ajax_data = [];
/*** Perform AJAX call ***/
function call_ajax(params){
  var ajax_options = {
    type: "GET",
    url: params.url,
    data: {
      ser_type:     params.ser_type,
      ser_value:    params.ser_value,
      city:         params.city,
      time_format:  params.time_format,
      sort:         params.sort,
      res_num:      params.res_num,
      comp:         params.comp,
      start_date:   params.start_date,
      end_date:     params.end_date,
      ser_type2:    params.ser_type2,
      city2:        params.city2,
      start_date2:  params.start_date2,
      end_date2:    params.end_date2,
    },
    dataType: "json",
    success: function(data){
      ajax_data = data;
      // Parse JSON
      var f_data = format_data(data, params);

      // Show/hide appropriate graph
      if (params.ser_value == "heatmap"){
        $(params.chart_name).addClass("hidden");
        $(params.map_name).removeClass("hidden");
      } else {
        $(params.chart_name).removeClass("hidden");
        $(params.map_name).addClass("hidden");
      };

      // Format data for graphing. Graph data
      add_graph(graph_data(f_data, params.ser_value), params);
      
    },
    error: function(){
      console.log("error");
    }
  };
  $.ajax(ajax_options);
}


/* Parse through data to convert dates into date objects and numbers into floats */
function format_data(data, params){
  if (params.ser_value == "heatmap"){
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        data[i][j].x = parseFloat(data[i][j].x);
        data[i][j].y = parseFloat(data[i][j].y);
      }
    }
  } else {
    if (params.sort == "by_time"){
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j].x = new Date(Date.parse(data[i][j].x));
          data[i][j].y = parseFloat(data[i][j].y);
          var xval = data[i][j].x;
          switch(params.time_format){
            case "hour":
            data[i][j].x = xval.getUTCHours();
            break;
            case "day":
            data[i][j].x = xval.getFullYear() + "-" + (xval.getMonth() + 1) + "-" + xval.getDate();
            break;
            case "month":
            data[i][j].x = xval.getFullYear() + "-" + (xval.getMonth() + 1);
            break;
            case "year":
            data[i][j].x = xval.getFullYear() + 1;
            break;
            default:
            alert("wrong time format");
          };
        }
      };
      if (params.time_format == "hour"){
        for (var i = 0; i < data.length; i++){
          var temp = [];
          var count = 0;
          for (var j = 0; j < 24; j++){
            temp[j] = {x: j, y: 0};
            if (data[i][count] && (j == data[i][count].x)){
              temp[j] = data[i][count]; 
              count++;
            };
          };
          data[i] = temp;
        };
      }
    } else if (params.sort == "by_cats" || params.sort == "by_location"){
      var temp = new Array;
      for (var i = 0; i < data.length; i++){
        temp[i] = new Array;
        for (var j = 0; j < cats_num; j++){
          data[i][j].y = parseFloat(data[i][j].y);
          temp[i][j] = data[i][j];
        }
      };
      data = temp;
    };
  }
  return data;
};

/* Convert data into a format that can be used by the graphing function */
function graph_data(data, ser_value){
  if (ser_value == "heatmap"){
    return data;
  } else {
    var test_data = [];
    for (var i = 0; i < data.length; i++){
      test_data.push({key:'Range ' + i, values: data[i]}); 
    };
    return test_data;
  };
}

/* To graph data */
function add_graph(data, params){
  var newyork, la, sf, miami, atlanta, austin, chicago, dallas, denver, houston, vegas, philadelphia, phoenix, portland, seattle, dc, sd;
  var cities = {
    "": {name: "", coords: new google.maps.LatLng(40.742037, -73.987563)},
    "newyork": {name: "newyork", coords: new google.maps.LatLng(40.742037, -73.987563)},
    "la": {name: "la", coords: new google.maps.LatLng(34.092809,-118.328661)},
    "sf": {name: "sf", coords: new google.maps.LatLng(37.77493,-122.419415)},
    "miami": {name: "miami", coords: new google.maps.LatLng()},
    "atlanta": {name: "atlanta", coords: new google.maps.LatLng()},
    "austin": {name: "austin", coords: new google.maps.LatLng()},
    "chicago": {name: "chicago", coords: new google.maps.LatLng()},
    "dallas": {name: "dallas", coords: new google.maps.LatLng()}
    // {name: "denver", coords: new google.maps.LatLng()},
    // {name: "houston", coords: new google.maps.LatLng()},
    // {name: "vegas", coords: new google.maps.LatLng()},
    // {name: "philadelphia", coords: new google.maps.LatLng()},
    // {name: "phoenix", coords: new google.maps.LatLng()},
    // {name: "portland", coords: new google.maps.LatLng()},
    // {name: "seattle", coords: new google.maps.LatLng()},
    // {name: "dc", coords: new google.maps.LatLng()},
    // {name: "sd", coords: new google.maps.LatLng()},
  }

  if (params.ser_value == "heatmap"){
    var map, pointarray, heatmap;
    var map_data = [];
    google.maps.visualRefresh = true;
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        map_data[j] = 
          //new google.maps.LatLng(data[i][j].x, data[i][j].y)
          {location: new google.maps.LatLng(data[i][j].x, data[i][j].y), weight: data[i][j].count};
      };
    };
      
    function getNewRadius(zoom, max_count, city){
      switch (city) {
        case "newyork":
        case "":
          if (zoom < 12)
            return 7 - max_count / 150;
          else if (zoom == 12)
            return 10 - max_count / 150;
          else if (zoom == 13)
            return 20 - max_count / 60;
          else if (zoom == 14)
            return 30;
          else 
            return 40;
        case "la":
          if (zoom < 11)
            return 20;
          else if (zoom == 11)
            return max_count * (-0.045) + 32;
          else if (zoom == 12)
            return max_count * (-0.095) + 49;
          else if (zoom == 13)
            return max_count * (-0.09) + 59;
          else if (zoom == 14)
            return max_count * (-0.045) + 62;
          else 
            return 75;
      }
    }

    function getNewMaxIntensity(zoom, max_count, city){
      if (zoom < 11)
        return max_count * 2.5;
      else if (zoom == 11)
        return -34.2925 + max_count * 1.93;
      else if (zoom == 12)
        return -58.74 + max_count * 1.86;
      else if (zoom == 13)
        return -47.23 + max_count * 1.43;
      else if (zoom == 14)
        return -44.02 + max_count * 1.23 ;
      else 
        return Math.max(5, max_count * 2 - 45);
    }
    
    function initialize() {
      var mapOptions = {
        zoom: 13,
        center: cities[city].coords,
      };

      map = new google.maps.Map($(elem)[0],
          mapOptions);

      var pointArray = new google.maps.MVCArray(map_data);

      heatmap = new google.maps.visualization.HeatmapLayer({
        data: pointArray,
        dissipating: true,
        radius: Math.round(getNewRadius(map.getZoom(), map_data[0].weight, params.city)),
        opacity: 0.6,
        maxIntensity: Math.round(getNewMaxIntensity(map.getZoom(), map_data[0].weight, params.city)),
        gradient: [
          'rgba(0, 255, 255, 0)',
          'rgba(0, 255, 255, 1)',
          'rgba(0, 191, 255, 1)',
          'rgba(0, 127, 255, 1)',
          'rgba(0, 63, 255, 1)',
          'rgba(0, 0, 255, 1)',
          'rgba(0, 0, 223, 1)',
          'rgba(0, 0, 191, 1)',
          'rgba(0, 0, 159, 1)',
          'rgba(0, 0, 127, 1)',
          'rgba(63, 0, 91, 1)',
          'rgba(127, 0, 63, 1)',
          'rgba(191, 0, 31, 1)',
          'rgba(255, 0, 0, 1)'
        ]
      });

      heatmap.setMap(map); 

      google.maps.event.addListener(map, 'zoom_changed', function () {
        heatmap.setOptions({
          radius: Math.round(getNewRadius(map.getZoom(), map_data[0].weight, params.city)),
          maxIntensity: Math.round(getNewMaxIntensity(map.getZoom(), map_data[0].weight, params.city)),
        });
      });
    }

    initialize();

  } else {
    var width = nv.utils.windowSize().width - 40,
    height = nv.utils.windowSize().height - 40;
    var chart = nv.models.multiBarChart();

    chart.multibar
      .hideable(true);

    chart.reduceXTicks(params.sort == "by_time").staggerLabels(false);
    
    chart.margin({left: 80});
    if (params.sort == "by_cats" || params.sort == "by_location") 
      chart.margin({ bottom: 150});
    
    var xAxisLabel = ""
    if (params.sort == "by_cats") 
      xAxisLabel = "Service Categories"
    else if (params.sort == "by_location")
      xAxisLabel = "Zones"
    else if (params.sort == "by_time")
      xAxisLabel = $(params.time_format).val()

    chart.xAxis
        .showMaxMin(false)
        .axisLabel(xAxisLabel)
        .rotateLabels((params.sort == "by_time") ? 0 : -40);        

    chart.yAxis
        .showMaxMin(true)
        .tickFormat(d3.format(',1f'));
    
    var yAxisLabel = "";

    switch (params.ser_type){
      case "bookings":
        yAxisLabel = "Bookings";
        break;
      case "loots":
        yAxisLabel = "Loots";
      case "signups":
        yAxisLabel = "New User Signups"
    }


    if (params.ser_value == "rev")
      yAxisLabel = yAxisLabel + " Revenue($)";
    else if (params.ser_value == "num")
      yAxisLabel = "Number of " +  yAxisLabel;
    else 
      alert("invalid service value");

    chart.yAxis.axisLabel(yAxisLabel);

    d3.select(params.chart_name + ' svg')
        .datum(data)
      .transition().duration(200).call(chart);

    nv.utils.windowResize(chart.update);

    chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });
    return chart;
  };
};

