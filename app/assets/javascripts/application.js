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

  

/* Parse through data to convert dates into date objects and numbers into floats */
function format_data(data, ser_value, time_format, comp, sort, cats_num){
  if (ser_value == "heatmap"){
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        data[i][j].x = parseFloat(data[i][j].x);
        data[i][j].y = parseFloat(data[i][j].y);
      }
    }
  } else {
    if (sort == "by_time"){
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j].x = new Date(Date.parse(data[i][j].x));
          data[i][j].y = parseFloat(data[i][j].y);
          var xval = data[i][j].x;
          switch(time_format){
            case "hour":
            data[i][j].x = xval.getHours();
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
          // if (comp){
          //   switch(time_format){
          //     case "day":
          //     data[i][j].x = (xval.getMonth() + 1) + "-" + xval.getDate();
          //     break;
          //     case "month":
          //     data[i][j].x = (xval.getMonth() + 1);
          //     break;
          //     case "year":
          //     data[i][j].x = xval.getFullYear() + 1;
          //     break;
          //     default:
          //     ;
          //   }
          // };
        }
      };
    } else if (sort == "by_cats" || sort == "by_location"){
      var data_sub = new Array;
      for (var i = 0; i < data.length; i++){
        data_sub[i] = new Array;
        for (var j = 0; j < cats_num; j++){
          data[i][j].y = parseFloat(data[i][j].y);
          data_sub[i][j] = data[i][j];
        }
      };
      data = data_sub;
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
function add_graph(data, ser_value, ser_type, city, sort, elem){
  debugger;
  var newyork, la, sf, miami, atlanta, austin, chicago, dallas, denver, houston, vegas, philadelphia, phoenix, portland, seattle, dc, sd;
  var cities = {
    "": {name: "", coords: new google.maps.LatLng(40.742037, -73.987563)},
    "newyork": {name: "newyork", coords: new google.maps.LatLng(40.742037, -73.987563)},
    "la": {name: "la", coords: new google.maps.LatLng(34.052234, -118.243685)},
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

  if (ser_value == "heatmap"){
    var map, pointarray, heatmap;
    var map_data = [];

    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        map_data[j] = 
          //new google.maps.LatLng(data[i][j].x, data[i][j].y)
          {location: new google.maps.LatLng(data[i][j].x, data[i][j].y), weight: data[i][j].count};
      };
    };

    function initialize() {
      var mapOptions = {
        zoom: 12,
        center: cities[city].coords,
      };

      map = new google.maps.Map($(elem)[0],
          mapOptions);

      var pointArray = new google.maps.MVCArray(map_data);

      heatmap = new google.maps.visualization.HeatmapLayer({
        data: pointArray,
        dissipating: true,
        radius: 50,
        opacity: 0.8,
      });

      heatmap.setMap(map); 
    }

    initialize();
  } else {
    var width = nv.utils.windowSize().width - 40,
    height = nv.utils.windowSize().height - 40;
    var chart = nv.models.multiBarChart();

    chart.multibar
      .hideable(true);

    chart.reduceXTicks(sort == "by_time").staggerLabels(false);
    
    chart.margin({left: 80});
    if (sort == "by_cats" || sort == "by_location") 
      chart.margin({ bottom: 150});
    
    var xAxisLabel = ""
    if (sort == "by_cats") 
      xAxisLabel = "Service Categories"
    else if (sort == "by_location")
      xAxisLabel = "Zones"
    else if (sort == "by_time")
      xAxisLabel = $("#time_format").val()

    chart.xAxis
        .showMaxMin(false)
        .axisLabel(xAxisLabel)
        .rotateLabels((sort == "by_time") ? 0 : -40);        

    chart.yAxis
        .showMaxMin(true)
        .tickFormat(d3.format(',1f'));
    
    var yAxisLabel = "";

    switch (ser_type){
      case "bookings":
        yAxisLabel = "Bookings";
        break;
      case "loots":
        yAxisLabel = "Loots";
      case "signups":
        yAxisLabel = "New User Signups"
    }


    if (ser_value == "rev")
      yAxisLabel = yAxisLabel + " Revenue (Thousands of $)";
    else if (ser_value == "num")
      yAxisLabel = "Number of " +  yAxisLabel;
    else 
      alert("invalid service value");

    chart.yAxis.axisLabel(yAxisLabel);

    d3.select('#chart1 svg')
        .datum(data)
      .transition().duration(200).call(chart);

    nv.utils.windowResize(chart.update);

    chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });
    return chart;
  };
};