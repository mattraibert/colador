<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<title>Colador</title>
<script src="/static/js/d3.v3.min.js"></script>
<style>
  body { background-image: url('/static/sea.gif') }
  .container { 
    margin: auto;
    width: 1250px;
  }

  .hidden { display: none;}
</style>
<script>
  var events = [
    {id: 1, title: "Great things", img: '/static/nature2.gif', x: 10, y: 10, startYear: 1491, endYear: 1491},
    {id: 2, title: "Aligator eats", img: '/static/nature2.gif', x: 20, y: 20, startYear: 1491, endYear: 1491},
    {id: 3, title: "Hippo charges", img: '/static/nature2.gif', x: 30, y: 30, startYear: 1491, endYear: 1493},
    {id: 4, title: "Mole burrows", img: '/static/nature2.gif', x: 40, y: 40, startYear: 1492, endYear: 1492},
    {id: 5, title: "Snake coils", img: '/static/nature2.gif', x: 50, y: 50, startYear: 1492, endYear: 1492},
    {id: 6, title: "Asparagus spears", img: '/static/nature2.gif', x: 60, y: 60, startYear: 1493, endYear: 1493}
  ];
</script>
</head>
<body>
<div class='container'>
  <svg width=1250 height=900>
    <image xlink:href='/static/LAMap-grid.gif' x='0' y='0' width='1200' height='800' transform='translate(20,0)' />
    <image xlink:href='/static/centralamerica-inset.gif' x='0' y='500' width='401' height='323'/>
  </svg>
</div>
<link href="/static/css/slider.css" media="all" rel="stylesheet" type="text/css" />
<script>
  d3.select("svg").selectAll("image.event").data(events).enter()
  .append("a")
  .attr("xlink:href", function(d) {return "/events/" + d.id;})
  .append("image")
  .attr("class", "event")
  .attr("xlink:href", function(d) {return d.img;})
  .attr("width",20).attr("height",20)
  .attr("x", function(d) {return d.id * 25;})
  .attr("y", function(d) {return d.id * 25;});

  var showEvents = function(year) {
    function should_hide(d) {
      return !(d.startYear <= year && d.endYear >= year);
    }

    d3.selectAll("image.event").classed("hidden", should_hide);
  };

  var sliderConf = {left: 262, width: 800, top: 66, height: 30, minYear: 1491, maxYear: 2020, callback: showEvents};
</script>
<script src="/static/js/slider.js"></script>
</body>
</html>
