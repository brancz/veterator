# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@parseDate = d3.time.format.iso.parse

@plot = (uri, selector) ->
  rwidth = $('#graph').width()
  rheight = rwidth / 2

  brushed = ->
    x.domain (if brush.empty() then x2.domain() else brush.extent())
    focus.select("path").attr "d", area
    focus.select(".x.axis").call xAxis
  margin =
    top: Math.max(rheight / 50, 10)
    right: 10
    bottom: Math.max(rheight / 5, 55)
    left: 40

  margin2 =
    top: Math.max(rheight / 1.16, 20)
    right: 10
    bottom: Math.max(rheight / 25, 20)
    left: 40

  width = rwidth - margin.left - margin.right
  height = rheight - margin.top - margin.bottom
  height2 = rheight - margin2.top - margin2.bottom
  x = d3.time.scale().range([0, width])
  x2 = d3.time.scale().range([0, width])
  y = d3.scale.linear().range([height, 0])
  y2 = d3.scale.linear().range([height2, 0])
  xAxis = d3.svg.axis().scale(x).orient("bottom")
  xAxis2 = d3.svg.axis().scale(x2).orient("bottom")
  yAxis = d3.svg.axis().scale(y).orient("left")
  brush = d3.svg.brush().x(x2).on("brush", brushed)
  area = d3.svg.area().interpolate("monotone").x((d) ->
    x d.created_at
  ).y0(height).y1((d) ->
    y d.value
  )
  area2 = d3.svg.area().interpolate("monotone").x((d) ->
    x2 d.created_at
  ).y0(height2).y1((d) ->
    y2 d.value
  )
  svg = d3.select(selector).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom)
  svg.append("defs").append("clipPath").attr("id", "clip").append("rect").attr("width", width).attr "height", height
  focus = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
  context = svg.append("g").attr("transform", "translate(" + margin2.left + "," + margin2.top + ")")
  d3.json uri, (error, data) ->
    data.forEach (d) ->
      d.created_at = parseDate(d.created_at)
      d.value = +d.value

    x.domain d3.extent(data.map((d) ->
      d.created_at
    ))
    y.domain [0, d3.max(data.map((d) ->
      d.value
    ))]
    x2.domain x.domain()
    y2.domain y.domain()
    focus.append("path").datum(data).attr("clip-path", "url(#clip)").attr "d", area
    focus.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
    focus.append("g").attr("class", "y axis").call yAxis
    context.append("path").datum(data).attr "d", area2
    context.append("g").attr("class", "x axis").attr("transform", "translate(0," + height2 + ")").call xAxis2
    context.append("g").attr("class", "x brush").call(brush).selectAll("rect").attr("y", -6).attr "height", height2 + 7

@plot_graphs = ->
	$('.sensor').each ->
		element = $(this)
		element_selector = element.attr('id')
		number = element.attr('id').split('_')[1]
		chart_element = $("#chart-preview-#{number}")
		uri = "/sensors/#{number}/records.json"
		margin = [15,15,20,30]
		width = 391
		height = chart_element.height() - margin[0] - margin[2]

		d3.json uri, (error, data) ->

			if data.length > 0

				data.forEach (d) ->
					d.created_at = parseDate(d.created_at)
					d.value = +d.value

				chart_element.empty()

				x_min = d3.min data, (d) -> 
					d.created_at
				
				x_max = d3.max data, (d) ->
					d.created_at

				y_min = d3.min data, (d) ->
					d.value

				y_max = d3.max data, (d) ->
					d.value

				x = d3.time.scale().domain([x_min, x_max]).range([0, width])
				x.tickFormat(d3.time.format("%s"));

				y = d3.scale.linear().domain([y_min, y_max]).range([height, 0])
				
				area = d3.svg.area().interpolate("monotone").x((d) ->
					x d.created_at
				).y0(height).y1((d) ->
					y d.value
				)

				graph = d3.select("##{chart_element.attr('id')}").append("svg:svg").attr("width", chart_element.width()).attr("height", chart_element.height()).attr("preserveAspectRatio", "xMidYMid").append("svd:g").attr("transform", "translate(" + margin[3] + "," + margin[0] + ")")

				xAxis = d3.svg.axis().scale(x);
				graph.append("svg:g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis)

				yAxisLeft = d3.svg.axis().scale(y).ticks(2).tickSize(-width).orient("left");
				graph.append("svg:g").attr("class", "y axis").call(yAxisLeft)

				graph.append("svg:path").attr("d", area(data)).attr("class", "data")

			else

				chart_element.append "<h3 class='text-center margin-top-20'>No data available for</br>the last 24 hours</h3>"
