// Generated by CoffeeScript 1.8.0
(function() {
  var mapE;

  mapE = {};

  window.mapE = mapE;

  mapE.categoryMapToIcon = {
    1: "mapimages/war2.gif",
    4: "mapimages/war1.gif",
    2: "mapimages/ind.gif"
  };

  mapE.iconFromObject = function(obj) {
    var imgURL;
    imgURL = mapE.categoryMapToIcon[obj.category_id];
    if (imgURL === void 0) {
      return "";
    } else {
      return imgURL;
    }
  };

  mapE.showMarkersForYear = function(year) {
    return $(".marker").each(function(i, d) {
      if ($(d).data("start_year") <= year && year <= $(d).data("end_year")) {
        return $(d).show();
      } else {
        return $(d).hide();
      }
    });
  };

  $(function() {
    $("#slider").slider({
      min: 1491,
      max: 2020,
      slide: function(event, ui) {
        $("#yearIndicator").html(ui.value);
        return mapE.showMarkersForYear(ui.value);
      }
    });
    return $.getJSON("events.json", function(data) {
      $.each(data, function(i, d) {
        var e;
        console.log(d);
        try {
          $("<div class='markerDialog'/>").attr("id", "markerDialog-" + d.id).data("id", d.id).data("start_year", d.start_year).data("end_year", d.end_year).html(d.content).appendTo($("#markerDialogs"));
          return $("<div class='marker'/>").attr("id", "marker-" + d.id).css("left", d.location.left).css("top", d.location.top).data("id", d.id).data("start_year", d.start_year).data("end_year", d.end_year).html("<img src=" + mapE.iconFromObject(d) + "/>").on("click", function(e) {
            var thisID;
            thisID = $(this).data("id");
            console.log($("#markerDialog-" + thisID));
            $(".markerDialog").hide();
            return $("#markerDialog-" + thisID).show();
          }).appendTo($("#markers"));
        } catch (_error) {
          e = _error;
          return console.log(e);
        }
      });
      mapE.showMarkersForYear(1491);
      return $("#yearIndicator").html(1491);
    });
  });

}).call(this);
