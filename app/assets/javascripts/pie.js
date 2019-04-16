var test_data = [{"label":"one", "value":20},
      {"label":"two", "value":55},
      {"label":"three", "value":10}];

var line_test_data = [{"date":new Date(2018,3), "revenue":26},
                      {"date":new Date(2018,4), "revenue":24},
                      {"date":new Date(2018,5), "revenue":22},
                      {"date":new Date(2018,6), "revenue":20},
                      {"date":new Date(2018,7), "revenue":20},
                      {"date":new Date(2018,8), "revenue":16},
                      {"date":new Date(2018,9), "revenue":14},
                      {"date":new Date(2018,10), "revenue":12},
                      {"date":new Date(2018,11), "revenue":10},
                      {"date":new Date(2019,0), "revenue":8},
                      {"date":new Date(2019,1), "revenue":6},
                      {"date":new Date(2019,2), "revenue":4},
                      {"date":new Date(2019,3), "revenue":2}]

$(function(){
  lineGraph(line_test_data);
});

function lineGraph(data){
  console.log(data)
  var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

  var parseTime = d3.timeParse("%d-%b-%y");
  console.log(parseTime("01-Apr-18"))
  console.log(data[0].date)
  console.log(data[0].date==parseTime("01-Apr-18"))
  // set the ranges
  var xScale = d3.scaleTime().range([0, width]);
  var yScale = d3.scaleLinear().range([height, 0]);

  // define the line
  var valueline = d3.line()
      .x(function(d,i) { return xScale(d.date); })
      .y(function(d,i) { return yScale(d.revenue); })
      .curve(d3.curveCardinal);

  // append the svg obgect to the body of the page
  // appends a 'group' element to 'svg'
  // moves the 'group' element to the top left margin
  var svg = d3.select("svg#revenue")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");


    // // format the data
    // data.forEach(function(d) {
    //     d.date = parseTime(d.date);
    //     d.revenue = +d.revenue;
    // });

    // Scale the range of the data
    xScale.domain(d3.extent(data, function(d) { return d.date; }));
    yScale.domain([0, d3.max(data, function(d) { return d.revenue; })]);

    // Add the valueline path.
    svg.append("path")
        .data([data])
        .attr("class", "line")
        .attr("d", valueline);

    // Add the X Axis
    svg.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(xScale));

    // Add the Y Axis
    svg.append("g")
        .call(d3.axisLeft(yScale));


};

function parseData(data){
  drawPie("percent-sold", data)
}

function getData(){
               $.ajax({
                 type: 'GET',
                 contentType: 'application/json; charset=utf-8',
                 url: '/dashboard',
                 dataType: 'json',
                 success: function(data){
                   parseData(data);
                 },
                 failure: function(result){
                   error();
                 }
               });
             };

function drawPie(id, data){
  var width = 200,
    height = 200,
    radius = 100,
    color = d3.scaleOrdinal(d3["schemeCategory10"]);

  var vis = d3.select("svg#"+ id)
      .data(data)
          .attr("width", width)
          .attr("height", height)
          .attr('id', 'percent-sold')
      .append("g")
          .attr("transform", "translate(" + radius + "," + radius + ")")

  var pie = d3.pie().value(function(d){return d.value});

  var arc = d3.arc()
              .innerRadius(50)
              .outerRadius(radius);

  var arcs = vis.selectAll("arc")
                .data(pie(data))
                .enter()
                .append("g")
                .attr("class", "arc")

  arcs.append("path")
      .attr("fill", function(d, i) {
        return color(i);
      })
      .attr("d", arc);

  arcs.append("text")
      .attr("transform", function(d) {
        d.innerRadius = 50;
        d.outerRadius = radius;
        return "translate(" + arc.centroid(d) + ")";
      })
      .attr("text-anchor", "middle")
      .text(function(d, i) { return data[i].label; });
};
