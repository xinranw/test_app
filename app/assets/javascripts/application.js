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
      ajax_data = $.extend([], data);
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

/**
 * Parse through data to convert dates into date objects and numbers into floats 
 */
 function format_data(data, params){
  /**
   * Store hash keys from data 
   */
  var keys = [];
  for (var i = 0; i < data.length; i++){
    keys[i] = [];
    for (var key in data[i][0]){
      keys[i].push(key);
    }
  }
  /** 
   * For heatmap data:
   * Store latitude (x) and longitude (y) data as floats.
   */
  if (params.ser_value == "heatmap"){
    for (var i = 0; i < data.length; i++){
      for (var j = 0; j < data[i].length; j++){
        for (var k = 0; k < keys[i].length; k++)
          data[i][j][keys[i][k]] = parseFloat(data[i][j][keys[i][k]]);
      }
    }
  } else {
    /*** Format time-based data ***/
    if (params.sort == "by_time" || params.sort == "by_time_cum"){
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j][keys[i][0]] = new Date(Date.parse(data[i][j][keys[i][0]]));
          data[i][j][keys[i][1]] = parseFloat(data[i][j][keys[i][1]]);
        }
      }
      /**
       * Fill in hours with no data 
       */
      if (params.time_format == "hour"){
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
    }
    /**  
     *  If different time periods, set the same dates so that graphs will overlap. Then match the 
     *  dates and set the Count data of the generated dates                                    
     */
    if (params.comp && params.comp_type == "diff"){
      var dur_start = data[0][0][keys[0][0]];
      var dur_end = data[0][data[0].length-1][keys[0][0]];
      var array_i = 0;
      var duration = 0;
      var dates_equal = false;
      var get_dur = function(start, end){
        if (params.time_format == "month")
          return (end.getFullYear() - start.getFullYear() - 1) * 12 + end.getMonth() + (12 - start.getMonth());
        else if (params.time_format == "day")
          return Math.floor((end - start) / ( 1000 * 60 * 60 * 24));
      };
      for (var i = 0; i < data.length; i++){
        dur_start = data[i][0][keys[0][0]];
        dur_end = data[i][data[i].length-1][keys[0][0]];
        var dur_temp = get_dur(dur_start, dur_end);
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
          temp[j][keys[i][0]] =
          (params.time_format == "month") ? new Date(start.clone().add(j).months().getTime()) :
          ((params.time_format == "day") ? new Date(start.clone().add(j).days().getTime()) : new Date());
          temp[j][keys[i][1]] = 0;
          dates_equal =
          ((params.time_format == "month") && data[i][count][keys[i][0]].getMonth() == temp[j][keys[i][0]].getMonth()) ||
          ((params.time_format == "day") && data[i][count][keys[i][0]].getMonth() == temp[j][keys[i][0]].getMonth() && data[i][count][keys[i][0]].getDate() == temp[j][keys[i][0]].getDate());
          if (data[i][count] && dates_equal){
            temp[j][keys[i][1]] = data[i][count][keys[i][1]];
            count++;
          }
        }
        data[i] = temp;
      }
    }
    /**
     * Convert times into unixtime for d3.js to graph 
     */
    if (params.sort == "by_time" || params.sort == "by_time_cum"){
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < data[i].length; j++){
          data[i][j][keys[i][0]] = data[i][j][keys[i][0]].getTime();
        }
      }
    }
    /*** For categorical data ***/
    else {
      for (var i = 0; i < data.length; i++){
        for (var j = 0; j < Math.min(params.res_num, data[i].length); j++){
          data[i][j][keys[i][0]] = data[i][j][keys[i][0]];
          data[i][j][keys[i][1]] = parseFloat(data[i][j][keys[i][1]]);
        }
      }
    }
  }
  return data;
}

/**
 * Generate names based on settings for data ranges
 */
 function gen_range_names_helper(data, params){
  var range = [];
  var param_name = "";
  for (var i = 0; i < data.length; i++){
    param_name = "ser_type" + (i+1);
    range[i] = capitalize(params[param_name]) + " in ";
    param_name = "city" + (i+1);
    range[i] += capitalize(params[param_name] || "All Cities") + " ";
    param_name = "start_date" + (i+1);
    range[i] += "(" + (params[param_name] || "2007/8/31");
      param_name = "end_date" + (i+1);
      range[i] += "-" + params[param_name] + ")";
}
return range;
}

function capitalize(word){
  return word[0].toUpperCase() + word.substring(1);
}

/**
 * Convert data into a format that can be used by the graphs 
 */
 function graph_data(data, params){
  if (params.view == "table")
    return data;

  /**
   * Stores hash keys again from data 
   */
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
  var formatted_data = [];
  if (params.ser_value == "heatmap"){
    return data;
  } else if (params.sort == "by_time_cum"){
    var formatted_data = [];
    var colors = ["#1f77b4", "#ff7f0e"];
    var range = gen_range_names_helper(data, params);
    for (var i = 0; i < data.length; i++){
      formatted_data.push({
        area: true,
        color: colors[i],
        key: range[i],
        values: data[i]
      });
    }
    return formatted_data;
  } else {
    var formatted_data = [];
    var colors = ["#1f77b4", "#ff7f0e"];
    var range = gen_range_names_helper(data, params);
    for (var i = 0; i < data.length; i++){
      formatted_data.push({
        key: range[i],
        color: colors[i],
        values: data[i]
      });
    }
    return formatted_data;
  }
}

/**
 * To graph data 
 */
 function add_graph(data, params){
  debugger;
  $("svg").empty();
  if (params.view == "graph"){
    // Graph heatmap 
    if (params.ser_value == "heatmap"){
      graphHeatMap(data, params);
    } else if (params.sort == "by_prov" || params.sort == "by_location"){
      // Horizontal bar graphs for sorting by providers 
      graphHorizontalBar(data, params);
    } else {
      graphLineBarChart(data, params);
    }
  } else if(params.view == "table"){
    // Data table
    graphTable(data, params);
  } else {
    alert("No view selected");
  }
}
