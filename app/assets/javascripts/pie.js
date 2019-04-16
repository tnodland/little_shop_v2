var test_data = [{"label":"one", "value":20},
      {"label":"two", "value":55},
      {"label":"three", "value":10}];

$(function(){
  getData();
});

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
