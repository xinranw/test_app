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
function format_data(data, time_format, comp, sort, cats_num){
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
  
  return data;
};

/* Convert data into a format that can be readily used by nvd3.js */
function graph_data(data){
  var test_data = [];
  for (var i = 0; i < data.length; i++){
    test_data.push({key:'Range ' + i, values: data[i]}); 
  };
  return test_data;
}

/* To graph data */
function add_graph(data, ser_type, ser_value, sort){
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

  if (ser_type == "bookings")
    yAxisLabel = "Bookings";
  else if (ser_type == "loots")
    yAxisLabel = "Loots";
  else if (ser_type == "signups")
    yAxisLabel = "New User Signups"
  else 
    alert("invalid service type");

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