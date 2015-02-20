mapE = {}
window.mapE = mapE


mapE.categoryMapToIcon =
  1: "mapimages/war2.gif"
  4: "mapimages/war1.gif"
  2: "mapimages/ind.gif"

mapE.iconFromObject = (obj) ->
  imgURL = mapE.categoryMapToIcon[obj.category_id]
  if(imgURL == undefined)
    return ""
  else
    return imgURL

mapE.showMarkersForYear = (year) ->
  $(".marker").each (i, d) ->
    if $(d).data("start_year") <= year and year <= $(d).data("end_year")
      $(d).show()
    else
      $(d).hide()


$ ->

  $( "#slider" ).slider
    min: 1491
    max: 2020
    slide: (event, ui) ->
      $("#yearIndicator").html(ui.value)
      mapE.showMarkersForYear(ui.value)

  $.getJSON "events.json", (data) ->

    $.each data, (i, d) ->

      try
        $("<div class='markerDialog'/>")
          .attr("id", "markerDialog-" + d.id)
          .data("id", d.id)
          .data("start_year", d.start_year)
          .data("end_year", d.end_year)
          .html(d.content)
          .appendTo($("#markerDialogs"))
        tempmark = "hi"
        $("<div class='marker'/>")
          .attr("id", "marker-" + d.id)
          .css("left", d.location.left)
          .css("top", d.location.top)
          .data("id", d.id)
          .data("start_year", d.start_year)
          .data("end_year", d.end_year)
          .html("<img src=" + mapE.iconFromObject(d) + "/>")
          .on "click", (e) ->
            thisID = $(this).data("id")
            console.log $("#markerDialog-" + thisID)
            $(".markerDialog").hide();
            $("#markerDialog-" + thisID).show()
          .appendTo($("#markers"))
      catch e
        console.log e

    mapE.showMarkersForYear(1491)
    $("#yearIndicator").html(1491)



