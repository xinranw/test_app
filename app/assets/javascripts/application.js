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
  // Set options for ajax call
  var ajax_options = {
    type: "GET",
    url: params.url,
    data: {
      constants:
      {
        ser_value:    params.ser_value,
        time_format:  params.time_format,
        sort:         params.sort,
        res_num:      params.res_num,
        comp:         params.comp
      },
      range1:
      {
        ser_type:     params.ser_type1,
        city:         params.city1,
        start_date:   params.start_date1,
        end_date:     params.end_date1
      },
      range2:
      {
        ser_type:     params.ser_type2,
        city:         params.city2,
        start_date:   params.start_date2,
        end_date:     params.end_date2
      }
    },
    dataType: "json",
    success: function(data){
      ajax_data = data;
      // Parse JSON
      var f_data = format_data(data, params);

      // Format data for graphing. Graph data
      add_graph(graph_data(f_data, params), params);
    },
    error: function(){
      console.log("error");
    }
  };
  $.ajax(ajax_options);
}

/* Parse through data to convert dates into date objects and numbers into floats */
function format_data(data, params){

  /* Stores hash keys from data */
  var keys = [];
  for (var i = 0; i < data.length; i++){
    keys[i] = [];
    for (var key in data[i][0]){
      keys[i].push(key);
    }
  }
  /* For heatmap data:
  ** Parse latitude (x) and longitude (y) **/
  if (params.ser_value == "heatmap"){
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        data[i][j][keys[i][0]] = parseFloat(data[i][j][keys[i][0]]);
        data[i][j][keys[i][1]] = parseFloat(data[i][j][keys[i][1]]);
      }
    }
  } else {
    /* For time-based data 
    ** Format the x axis datetime based on time format dropdown */
    if (params.sort == "by_time" || params.sort == "by_time_cum"){
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j][keys[i][0]] = new Date(Date.parse(data[i][j][keys[i][0]]));
          data[i][j][keys[i][1]] = parseFloat(data[i][j][keys[i][1]]);
        }
      }
      /*** Fill in hours with no data ***/
      if (params.time_format == "hour"){
        var today = new Date();
        // Array to be filled with all hours and corresponding sql data
        var temp = [];
        // To keep count for iterating through the sql data array
        var count = 0;
        for (var i = 0; i < data.length; i++){
          count = 0;
          temp = [];
          for (var j = 0; j < 24; j++){
            temp[j] = $.extend({}, data[i][0]);
            temp[j][keys[i][1]] = 0;
            temp[j][keys[i][0]] = new Date();
            temp[j][keys[i][0]].setMinutes(0);
            temp[j][keys[i][0]].setHours(j);
            if (data[i][count] && (j == data[i][count][keys[i][0]].getHours())){
              temp[j][keys[i][1]] = data[i][count][keys[i][1]];
              count++;
            }
          }
          data[i] = temp;
        }
      } /*** Fill in days with no data ***/
      else if (params.time_format == "day"){     
        var start = data[0][0][keys[0][0]];
        var end = data[0][data[0].length-1][keys[0][0]];
        // if (params.comp){
        //   start = new Date(
        //     Math.min(start, data[1][0][keys[0][0]]));
        //   end = new Date(
        //     Math.max(end, data[1][data[1].length-1][keys[0][0]]));
        // }
        // Array to be filled with all days and corresponding sql data
        var temp = [];
        // To keep count for iterating through the sql data array
        var count = 0;
        // Days between start and end
        var duration = (end - start) / 60 / 60 / 24 / 1000;
        for (var i = 0; i < data.length; i++){
          start = data[i][0][keys[0][0]];
          end = data[i][data[0].length-1][keys[0][0]];
          temp = [];
          count = 0;
          for (var j = 0; j < duration; j++){
            temp[j] = $.extend({}, data[0][0]);
            temp[j][keys[i][0]] = start.clone().add(j).days();
            temp[j][keys[i][1]] = 0;
            if (data[i][count] && 
              data[i][count][keys[i][0]].getDay() == temp[j][keys[i][0]].getDay() && 
              data[i][count][keys[i][0]].getMonth() == temp[j][keys[i][0]].getMonth() && 
              data[i][count][keys[i][0]].getFullYear() == temp[j][keys[i][0]].getFullYear()) {
              temp[j] = data[i][count];
            count++;
          }
        }
        data[i] = temp;
      }
    } 
    if (params.comp && params.comp_type == "diff"){
      if (params.time_format == "month"){
        var dur_start = data[0][0][keys[0][0]];
        var dur_end = data[0][data[0].length-1][keys[0][0]];
        var array_i = 0;
        var duration = (dur_end.getFullYear() - dur_start.getFullYear() - 1) * 12 + dur_end.getMonth() + (12 - dur_start.getMonth());
        for (var i = 0; i < data.length; i++){
          dur_start = data[i][0][keys[0][0]];
          dur_end = data[i][data[i].length-1][keys[0][0]];
          var dur_temp = (dur_end.getFullYear() - dur_start.getFullYear() - 1) * 12 + dur_end.getMonth() + (12 - dur_start.getMonth());
          if (dur_temp > duration){
            duration = dur_temp;
            array_i = i;
          }
        }
        var start = new Date(data[array_i][0][keys[0][0]].getTime());
        var end = new Date(data[array_i][data[array_i].length-1][keys[0][0]].getTime());
        var temp = [];
        var count = 0;
        for (var i = 0; i < data.length; i++){
          temp = [];
          count = 0;
          for (var j = 0; j < duration; j++){
            temp[j] = $.extend({}, data[0][0]);
            temp[j][keys[i][0]] = new Date(start.clone().add(j).months().getTime());
            temp[j][keys[i][1]] = 0;
            if (data[i][count] && data[i][count][keys[i][0]].getMonth() == temp[j][keys[i][0]].getMonth()){
              temp[j][keys[i][1]] = data[i][count][keys[i][1]];
              count++;
            }
          }
          data[i] = temp;
        }
      } else if (params.time_format == "day"){
        var dur_start = data[0][0][keys[0][0]];
        var dur_end = data[0][data[0].length-1][keys[0][0]];
        var array_i = 0;
        var duration = Math.floor((dur_end - dur_start) / ( 1000 * 60 * 60 * 24));
        for (var i = 0; i < data.length; i++){
          dur_start = data[i][0][keys[0][0]];
          dur_end = data[i][data[i].length-1][keys[0][0]];
          var dur_temp = Math.floor((dur_end - dur_start) / ( 1000 * 60 * 60 * 24));
          if (dur_temp > duration){
            duration = dur_temp;
            array_i = i;
          }
        }
        var start = new Date(data[array_i][0][keys[0][0]].getTime());
        var end = new Date(data[array_i][data[array_i].length-1][keys[0][0]].getTime());
        var temp = [];
        var count = 0;
        for (var i = 0; i < data.length; i++){
          temp = [];
          count = 0;
          for (var j = 0; j < duration; j++){
            temp[j] = $.extend({}, data[0][0]);
            temp[j][keys[i][0]] = new Date(start.clone().add(j).days().getTime());
            temp[j][keys[i][1]] = 0;
            if (data[i][count] && data[i][count][keys[i][0]].getMonth() == temp[j][keys[i][0]].getMonth() && data[i][count][keys[i][0]].getDate() == temp[j][keys[i][0]].getDate() ){
              temp[j][keys[i][1]] = data[i][count][keys[i][1]];
              count++;
            }
          }
          data[i] = temp;
        }
      }
    }
    if (params.sort == "by_time" || params.sort == "by_time_cum"){
      /* Convert times into unixtime for d3.js to graph */
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j][keys[i][0]] = data[i][j][keys[i][0]].getTime();
        }
      }
    }
  } /*** For categorical data ***/
  else {
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < params.res_num; j++){
        data[i][j][keys[i][0]] = data[i][j][keys[i][0]];
        data[i][j][keys[i][1]] = parseFloat(data[i][j][keys[i][1]]);
      }
    }
  }
}
return data;
}

/* Convert data into a format that can be used by the graphing function */
function graph_data(data, params){
  if (params.view == "table"){
    return data;
  }

  /* Stores hash keys again from data */
  var keys = [];
  for (var i = 0; i < data.length; i++){
    keys[i] = [];
    for (var key in data[i][0]){
      keys[i].push(key);
    }
  }
  /* Converts hash keys froms names to "x" and "y" for d3 to use */
  for (var i = 0; i < data.length; i++){
    for (var j = 0; j < data[i].length; j++){
      data[i][j].x = data[i][j][keys[i][0]];
      data[i][j].y = data[i][j][keys[i][1]];
    }
  }
  if (params.ser_value == "heatmap"){
    return data;
  } else if (params.sort == "by_time_cum"){
    var test_data = [];
    var colors = ["#1f77b4", "#ff7f0e"];
    for (var i = 0; i < data.length; i++){
      test_data.push({area: true, color: colors[i], key: "range" + i, values: data[i]});
    }
    return test_data;
  } else {
    var test_data = [];
    for (var i = 0; i < data.length; i++){
      test_data.push({key: "range" + i, values: data[i]});
    }
    return test_data;
  }
}

/* To graph data */
function add_graph(data, params){
  if (params.view == "graph"){
    /* Graph heatmap */
    if (params.ser_value == "heatmap"){
      graphHeatMap(data, params);
    } else if (params.sort == "by_prov"){
      /* Horizontal bar graphs for sorting by providers */
      graphHorizontalBar(data, params);
    } else {
      graphLineBarChart(data, params);
    }
  } else if(params.view == "table"){
    /* Data table*/
    graphTable(data, params);
  } else {
    alert("No view selected");
  }
}
