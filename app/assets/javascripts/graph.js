function graphHeatMap(data, params){
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
  };
  var heatmap = [], map = [], pointArray = [], map_data = [];
  google.maps.visualRefresh = true;
  for (var i = 0; i < data.length; i++){
    map_data[i] = [];
    for (var j = 0; j < data[i].length; j++){
      map_data[i][j] = {location: new google.maps.LatLng(data[i][j].x, data[i][j].y), weight: data[i][j].count};
    }
  }

  /* Use the max_weight factors to change base radius
  ** Use the step_factor to change the effect of zoom on intensity **/
  function getNewRadius(zoom, max_count){
    var max_count_factor = 3;
    var step_factor = 2.5;
    return Math.max(5, Math.round((20 - Math.log(max_count))*max_count_factor + Math.exp((zoom - 8) * 0.2 + step_factor) - 40));
  }

  /* Use the first two max_weight factors to change base intensity
  ** Use the step_factor to change the effect of zoom on intensity **/
  function getNewMaxIntensity(zoom, max_weight){
    var step_factor = 2.9;
    return Math.round((max_weight * Math.log(max_weight)/Math.LN10) - Math.exp(max_weight * 0.00039) - (Math.exp((zoom - 8) * 0.15 + step_factor) - 12) * Math.pow(10, Math.floor(Math.log(max_weight)/Math.LN10-1)));
  }

  function initialize() {
    var mapOptions = {
      zoom: 13,
      center: cities[params.city1].coords
    };

    /* Set the map gradient */
    var map_grad = [
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
    ];

    for (var i = 0; i < map_data.length; i++){
      map[i] = new google.maps.Map($(params.map_name[i])[0], mapOptions);
      pointArray[i] = new google.maps.MVCArray(map_data[i]);
      heatmap[i] = new google.maps.visualization.HeatmapLayer({
        data: pointArray[i],
        dissipating: true,
        radius: getNewRadius(map[i].getZoom(), map_data[i].length),
        opacity: 0.6,
        maxIntensity: getNewMaxIntensity(map[i].getZoom(), map_data[i][0].weight),
        gradient: map_grad
      });
      heatmap[i].setMap(map[i]);
    }

    /* Event listeners to change radius and intensity as zoom changes */
    google.maps.event.addListener(map[0], 'zoom_changed', function () {
      heatmap[0].setOptions({
        radius: getNewRadius(map[0].getZoom(), map_data[0].length),
        maxIntensity: getNewMaxIntensity(map[0].getZoom(), map_data[0][0].weight)
      });
      console.log(
        "Radius 1 = " + heatmap[0].radius +
        "Int_1 = " + getNewMaxIntensity(map[0].getZoom(), map_data[0][0].weight));
    });
    google.maps.event.addListener(map[1], 'zoom_changed', function () {
      heatmap[1].setOptions({
        radius: getNewRadius(map[1].getZoom(), map_data[1].length),
        maxIntensity: getNewMaxIntensity(map[1].getZoom(), map_data[1][0].weight)
      });
      console.log(
        "Radius 2 = " + heatmap[1].radius +
        " Int_2 = " + getNewMaxIntensity(map[1].getZoom(), map_data[1][0].weight));
    });
  }

  initialize();
}

function graphHorizontalBar(data, params){
  var width = nv.utils.windowSize().width - 40,
  height = nv.utils.windowSize().height - 40;
  var chart = nv.models.multiBarHorizontalChart();

  var commasFormatter = d3.format(",0f");
  chart.showValues(true)
    .tooltips(false)
    .showControls(false)
    .valueFormat(d3.format(",0f"))
    .margin({ left: 200, right: 30});

  chart.yAxis
    .showMaxMin(true)
    .tickFormat(d3.format(",0f"));

  var yAxisLabel = "";

  switch (params.ser_type1){
    case "bookings":
    yAxisLabel = params.comp ? "Sales" : "Bookings";
    break;
    case "loots":
    yAxisLabel = params.comp ? "Sales" : "Loots";
    break;
    case "signups":
    yAxisLabel = params.comp ? "" : "Signups";
    break;
  }

  if (params.ser_value == "rev"){
    yAxisLabel = yAxisLabel + " Revenue ($1000's)";
    chart.yAxis.tickFormat(function(d){return "$" + commasFormatter(d);});
  } else if (params.ser_value == "num"){
    yAxisLabel = "Number of " +  yAxisLabel;
  } else
  alert("invalid service value");

  chart.yAxis.axisLabel(yAxisLabel);

  if (params.ser_value == "rev"){
    chart.valueFormat(function(d) {return "$" + commasFormatter(d);});
    chart.yAxis.tickFormat(function(d){return "$" + commasFormatter(d);});
  }

  d3.select(params.chart_name + ' svg')
  .datum(data)
  .transition().duration(200).call(chart);

  nv.utils.windowResize(chart.update);

  chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });

  return chart;
}

function graphLineBarChart(data, params){
  var width = nv.utils.windowSize().width - 40,
  height = nv.utils.windowSize().height - 40;
  var chart = nv.models.multiBarChart();
  if (params.sort == "by_time_cum") {
    chart = nv.models.lineChart();
  } else {
    chart.multibar.hideable(true);
  }

  chart.margin({left: 100});
  if (params.sort == "by_cats" || params.sort == "by_location")
    chart.margin({ bottom: 150});

  var xAxisLabel = "";
  switch (params.sort){
    case "by_cats":
    xAxisLabel = "Service Categories";
    break;
    case "by_prov":
    xAxisLabel = "Providers";
    break;
    case "by_location":
    xAxisLabel = "Zones";
    break;
    case "by_time":
    case "by_time_cum":
    xAxisLabel = params.time_format;
    break;
    default:
    alert("params.sort fell through");
    break;
  }
  chart.xAxis
  .showMaxMin(false)
  .axisLabel(xAxisLabel)
  .rotateLabels(
    (params.sort == "by_time" || params.sort == "by_time_cum") ? 0 : -40);

  var timeFormatter = d3.time.format("%x");
  switch (params.time_format){
    case "year":
    timeFormatter = d3.time.format("%Y");
    break;
    case "month":
    timeFormatter = d3.time.format("%Y-%b");
    break;
    case "day":
    timeFormatter = d3.time.format("%Y/%m/%d");
    break;
    case "hour":
    timeFormatter = d3.time.format("%I %p");
    break;
    default:
    alert("params.sort fell through");
    break;
  }

  chart.xAxis.tickFormat(function(d){
    return timeFormatter(new Date(d));
  });

  chart.forceY([0]);

  var yAxisLabel = "";

  switch (params.ser_type1){
    case "bookings":
    yAxisLabel = params.comp ? "Sales" : "Bookings";
    break;
    case "loots":
    yAxisLabel = params.comp ? "Sales" : "Loots";
    break;
    case "signups":
    yAxisLabel = params.comp ? "" : "Signups";
    break;
  }

  var commasFormatter = d3.format(",0f");

  if (params.ser_value == "rev"){
    yAxisLabel = yAxisLabel + " Revenue ($1000's)";
    chart.yAxis.tickFormat(function(d){return "$" + commasFormatter(d);});
  } else if (params.ser_value == "num"){
    yAxisLabel = "Number of " +  yAxisLabel;
  } else
  alert("invalid service value");

  chart.yAxis.axisLabel(yAxisLabel);

  d3.select(params.chart_name + ' svg')
  .datum(data)
  .transition().duration(200).call(chart);

  nv.utils.windowResize(chart.update);

  chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });
  return chart;
}

function graphTable(data, params){
  // Adds a header row to the table and returns the set of columns.
  // Need to do union of keys from all records as some records may not contain
  // all records
  function addAllColumnHeaders(table_data){
    var columnSet = [];
    var columns = [];

    for (var key in table_data[0]) {
      if ($.inArray(key, columnSet) == -1){
        columnSet.push(key);
        columns.push(key);
      }
    }

    columns[0] = params.ser_type1.toUpperCase();
    columns[1] = (params.ser_value == 'num') ? "SOLD" : ((params.ser_value == 'rev') ? "PROFIT" : params.ser_value);
    columns[3] = (params.ser_value == 'num') ? "PROFIT" : ((params.ser_value == 'rev') ? "SOLD" : params.ser_value);

    var headerTr$ = $('<tr/>');
    for (var i = 0 ; i < columns.length; i++){
      headerTr$.append($('<th/>').html(columns[i]));
    }
    $(params.table_name).append(headerTr$);

    return columnSet;
  }
  function buildHtmlTable(table_data) {
    $(params.table_name).empty();
    var columns = addAllColumnHeaders(table_data);

    if (params.ser_value == "rev"){
      for (var i = 0; i < table_data.length; i++){
        table_data[i].y = "$" + table_data[i].y;
      }
    }

    for (var i = 0; i < table_data.length; i++) {
      var row$ = $('<tr/>');
      for (var colIndex = 0 ; colIndex < columns.length ; colIndex++) {
        var cellValue = table_data[i][columns[colIndex]];
        if (cellValue === null) { cellValue = ""; }
        row$.append($('<td/>').html(cellValue));
      }
      $(params.table_name).append(row$);
    }
  }
  // Moves data from column 'from' to 'to'
  function moveColumn (table, from, to) {
    var rows = jQuery('tr', table);
    var cols;
    rows.each(function() {
      cols = jQuery(this).children('th, td');
      cols.eq(from).detach().insertBefore(cols.eq(to));
    });
  }
  buildHtmlTable(data[0].values);
  // Rearrange table columns
  moveColumn($(params.table_name), 1, 3);
  moveColumn($(params.table_name), 3, 2);
}
