# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
plot = (uri, selector) ->
  brushed = ->
    x.domain (if brush.empty() then x2.domain() else brush.extent())
    focus.select("path").attr "d", area
    focus.select(".x.axis").call xAxis
  margin =
    top: 10
    right: 10
    bottom: 100
    left: 40

  margin2 =
    top: 430
    right: 10
    bottom: 20
    left: 40

  width = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom
  height2 = 500 - margin2.top - margin2.bottom
  parseDate = d3.time.format.iso.parse
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

plot uri, selector
