$ ->

	$( "#slider" ).slider
		min: 1400
		max: 1900
		slide: (event, ui) ->
			$(".marker").each (i, d) ->
				if $(d).data("start_year") <= ui.value and ui.value < $(d).data("end_year")
					$(d).show()
				else
					$(d).hide()

	$.getJSON "events.json", (data) ->
		_.each data, (d) ->
			console.log d
			$("<div class='marker'/>")
				.css("left", d.location.left)
				.css("top", d.location.top)
				.data("start_year", d.start_year)
				.data("end_year", d.end_year)
				.html(d.title)
				.appendTo($("#markers"))
	

