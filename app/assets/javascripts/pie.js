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

function lineGraph(data){
  console.log(data)

  var dateParse = d3.timeParse("%Y-%m-%d")
  var margin = {top: 0, right: 10, bottom: 50, left: 50},
    canvas_width = 350,
    canvas_height = 200,
    plot_width = canvas_width - margin.left - margin.right,
    plot_height = canvas_height - margin.top - margin.bottom;

  var xScale = d3.scaleTime().range([0, plot_width]);
  var yScale = d3.scaleLinear().range([plot_height, 0]);

  var line = d3.line()
      .x(function(d,i) { return xScale(d.date); })
      .y(function(d,i) { return yScale(d.revenue); })
      .curve(d3.curveCardinal);

  var svg = d3.select("svg#revenue")
      .attr("width", canvas_width)
      .attr("height", canvas_height)
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");
    data.forEach(function(d){
      d.date = dateParse(d.date);
      d.revenue = +d.revenue
    })
    xScale.domain(d3.extent(data, function(d) { return d.date; }));
    yScale.domain([0, d3.max(data, function(d) { return d.revenue; })]);

    svg.append("path")
        .data([data])
        .attr("class", "line")
        .attr("d", line);

    svg.append("g")
        .attr("transform", "translate(0," + plot_height + ")")
        .call(d3.axisBottom(xScale))
        .selectAll("text")
          .style("text-anchor", "end")
          .attr("dx", "-.8em")
          .attr("dy", ".15em")
          .attr("transform", "rotate(-35)")

    svg.append("g")
       .call(d3.axisLeft(yScale).ticks(5));
};

function parseData(data){
  drawPie("percent-sold", data['percent-sold']);
  drawPie("top-cities", data['top-cities']);
  drawPie("top-states", data['top-states']);
  lineGraph(data['revenue'])
}

function getDashboardData(){
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

function getMerchantData(){
              $.ajax({
                type: 'GET',
                contentType: 'application/json; charset=utf-8',
                url: '/admin/merchants',
                dataType: 'json',
                success: function(data){
                  drawPie("total-sales", data);
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
              .innerRadius(30)
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
        d.innerRadius = 30;
        d.outerRadius = radius;
        return "translate(" + arc.centroid(d) + ")";
      })
      .attr("text-anchor", "middle")
      .text(function(d, i) { return data[i].label; });
};
