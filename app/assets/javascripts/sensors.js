$(function() {
    $('#language-selector').change(function(e) {
        $('.code-snippet').hide();
        var selection = $(this).val();
        $('.code-snippet-'+selection).show();
    });

    var removeUser = function(e) {
        $(e.target).parent().parent().parent().parent().remove();
    }

    $('button.remove-user').click(removeUser);

    $('#user-search').autocomplete({
        source: function (request, response) {
            $.getJSON("/users/search.json?term=" + request.term, function (data) {
                response($.map(data.search, function (value, key) {
                    return {
                        label: value.email,
                        id: value.id
                    };
                }));
            });
        },
        select: function (e, selection) {
            $('<li class="user">' +
            '<div class="row">' +
            '<input type="hidden" name="sensor[user_ids][]" value="' + selection.item.id + '" />' +
            '<div class="col-sm-9">' + selection.item.label + '</div>' +
            '<div class="col-sm-3 text-right"><button type="button" class="remove-user close"><span>&times;</span></button></div>' +
            '</div>' +
            '</li>').insertBefore('#user-search-list-item');
            $('button.remove-user').click(removeUser);
            return false;
        },
        focus: function() {
            $('#user-search').val('');
            return false;
        }
    });
});

function createLineChartFor(sensor_id, selector, interactive, interpolationType) {
    var margin = 60,
        width = parseInt(d3.select(selector).style("width")) - margin*2,
        height = ((parseInt(d3.select(selector).style("width"))/16)*9) - margin*2;

    var xScale = d3.time.scale()
        .range([0, width])
        .nice();

    var yScale = d3.scale.linear()
        .range([height, 0])
        .nice();

    var xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(yScale)
        .orient("left");

    var line = d3.svg.line()
        .x(function(d) { return xScale(d.created_at); })
        .y(function(d) { return yScale(d.value); });

    line.interpolate(interpolationType || 'linear');

    var graph = d3.select(selector)
        .attr("width", width + margin*2)
        .attr("height", height + margin + 20)
        .append("g")
        .attr("transform", "translate(" + margin + "," + 20 + ")");

    d3.json("/sensors/" + sensor_id + "/records.json" + location.search, function(error, json) {
        data = json.records;
        data.forEach(function(d) {
            d.created_at = Date.parse(d.created_at);
            d.value = +d.value;
        });

        xScale.domain(d3.extent(data, function(d) { return d.created_at; }));
        yScale.domain(d3.extent(data, function(d) { return d.value; }));

        graph.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis);

        graph.append("g")
            .attr("class", "y axis")
            .call(yAxis)
            .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end");

        dataPerPixel = data.length/width;
        dataResampled = data.filter(function(d, i) {
            return i % Math.ceil(dataPerPixel) == 0;
        });

        graph.append("path")
            .datum(dataResampled)
            .attr("class", "line")
            .attr("d", line);

        var firstRecord = data[data.length-1], 
            lastRecord = data[0];

        var first = graph.append("g")
            .attr("class", "first")
            .style("display", "none");

        first.append("text")
            .attr("x", -8)
            .attr("y", 4)
            .attr("text-anchor", "end")
            .text(firstRecord.value);
        first.append("circle")
            .attr("r", 4);

        var last = graph.append("g")
            .attr("class", "last")
            .style("display", "none");

        last.append("text")
            .attr("x", 8)
            .attr("y", 4)
            .text(lastRecord.value);
        last.append("circle")
            .attr("r", 4);

        var hoverLine = graph
            .append('svg:line')
            .attr('class', 'hover-line')
            .attr('x1', 10).attr('x2', 10)
            .attr('y1', 0).attr('y2', height);

        hoverLine.classed('hide', true);

        function resize() {
            width = parseInt(d3.select(selector).style("width")) - margin*2;
            height = ((parseInt(d3.select(selector).style("width"))/16)*9) - margin*2;

            hoverLine.attr('y2', height);

            xScale.range([0, width]).nice(d3.time.day);
            yScale.range([height, 0]).nice();

            if (width < 300 && height < 80) {
                graph.select('.x.axis').style("display", "none");
                graph.select('.y.axis').style("display", "none");

                graph.select(".first")
                    .attr("transform", "translate(" + xScale(firstRecord.created_at) + "," + yScale(firstRecord.value) + ")")
                    .style("display", "initial");

                graph.select(".last")
                    .attr("transform", "translate(" + xScale(lastRecord.created_at) + "," + yScale(lastRecord.value) + ")")
                    .style("display", "initial");
            } else {
                graph.select('.x.axis').style("display", "initial");
                graph.select('.y.axis').style("display", "initial");
                graph.select(".last")
                    .style("display", "none");
                graph.select(".first")
                    .style("display", "none");
            }

            yAxis.ticks(Math.max(height/50, 2));
            xAxis.ticks(Math.max(width/50, 2));

            graph
                .attr("width", width + margin*2)
                .attr("height", height + margin*2)

                graph.select('.x.axis')
                .attr("transform", "translate(0," + height + ")")
                .call(xAxis)
                .selectAll("text")  
                    .style("text-anchor", "end")
                    .attr("dx", "-.8em")
                    .attr("dy", ".15em")
                    .attr("transform", function(d) {
                        return "rotate(-30)" 
                    });

            graph.select('.y.axis')
                .call(yAxis);

            dataPerPixel = data.length/width;
            dataResampled = data.filter(function(d, i) {
                return i % Math.ceil(dataPerPixel) == 0;
            });

            graph.selectAll('.line')
                .datum(dataResampled)
                .attr("d", line);
        }

        function handleMouseOutGraph(event) {
            // hide the hover-line
            hoverLine.classed("hide", true);

            // reset timestamp and value
            $('#created_at').text('');
            $('#value').text('');
            
            // user is no longer interacting
            userCurrentlyInteracting = false;
            currentUserPositionX = -1;
        }

        function valueForPosition(mouseX) {
            var xValue = xScale.invert(mouseX);
            var bisectDate = d3.bisector(function(d) { return d.created_at; }).left;
            return data[bisectDate(data, xValue)];
        }

        function handleMouseOverGraph(event) {
            var mouseX = event.pageX - (margin + $(selector).offset().left);
            var mouseY = event.pageY - (margin + $(selector).offset().top);
            
            //debug("MouseOver graph [" + containerId + "] => x: " + mouseX + " y: " + mouseY + "  height: " + h + " event.clientY: " + event.clientY + " offsetY: " + event.offsetY + " pageY: " + event.pageY + " hoverLineYOffset: " + hoverLineYOffset)
            if(mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height) {
                // show the hover line
                hoverLine.classed("hide", false);

                // display value of current position
                record = valueForPosition(mouseX);
                if(record) {
                    // set position of hoverLine
                    hoverLine.attr("x1", xScale(record.created_at)).attr("x2", xScale(record.created_at));

                    $('#created_at').text(d3.time.format("%Y-%m-%d %H:%M:%S")(new Date(record.created_at)));
                    $('#value').text(record.value);
                }
                
                // user is interacting
                userCurrentlyInteracting = true;
            } else {
                // proactively act as if we've left the area since we're out of the bounds we want
                handleMouseOutGraph(event);
            }
        }

        d3.select(window).on('resize', resize); 

        if(interactive) {
            $(selector).mouseleave(function(event) {
                handleMouseOutGraph(event);
            });
            $(selector).mousemove(function(event) {
                handleMouseOverGraph(event);
            });
        }

        resize();
    });
}
