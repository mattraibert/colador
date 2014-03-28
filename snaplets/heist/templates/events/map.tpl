<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<title>Colador</title>
<style>
  body { background-image: url('/static/sea.gif') }
  .container { 
    margin: auto;
    width: 1200px;
  }
</style>
</head>

<body>
<div class='container'>
<svg width=1200 height=800>
  <image xlink:href='/static/LAMap-grid.gif' x='0' y='0' width='1200' height='800'/>
  <events>
    <image xlink:href='/static/nature2.gif' title='${title}' x='${eventX}' y='${eventY}' width='20' height='20'/>
  </events>
</svg>
</div>
</body>

</html>
