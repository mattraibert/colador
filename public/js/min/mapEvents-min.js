colador,$(function(){function t(t,e){return Math.floor(Math.random()*(e-t+1)+t)}d3.json("./events.json",function(e,n){d3.select("svg").selectAll("image.event").data(n).enter().append("a").attr("xlink:href",function(t){return"/events/"+t.id}).append("image").attr("class","event").attr("xlink:href",function(t){return t.img}).attr("width",20).attr("height",20).attr("x",function(e){return t(200,600)}).attr("y",function(e){return t(200,500)}),slider.call(brush.event)});var e=function(t){function e(e){return!(e.startYear<=t&&e.endYear>=t)}d3.selectAll("image.event").classed("hidden",e)},n={left:262,width:800,top:66,height:30,minYear:1491,maxYear:2020,callback:e}});