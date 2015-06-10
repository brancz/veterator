$(function() {
    $('#language-selector').change(function() {
        $('.code-snippet').hide();
        var selection = $(this).val();
        $('.code-snippet-'+selection).show();
    });

    var removeUser = function(e) {
        var col = $(e.target).parent().parent();
        var row = col.parent();
        var listItem = row.parent();
        listItem.hide();
        var index = row.find('.current_index').val();
        $('<input type="hidden" name="sensor[sensor_accesses_attributes]['+index+'][_destroy]" value="1" />').insertBefore(col);
    };

    $('button.remove-user').click(removeUser);

    $('#user-search').autocomplete({
        source: function (request, response) {
            $.getJSON("/users/search.json?term=" + request.term, function (data) {
                response($.map(data.search, function (value) {
                    return {
                        label: value.email,
                        id: value.id
                    };
                }));
            });
        },
        select: function (e, selection) {
            var newIndex = parseInt($('.user').last().find('.current_index').val()) + 1;
            var accessLevelSelect = $('.access-level-select').first().clone();
            accessLevelSelect.attr('name', 'sensor[sensor_accesses_attributes][' + newIndex + '][access_level]');
            $('<li class="user">' +
            '<div class="row">' +
            '<input type="hidden" class="current_index" value="' + newIndex + '" />' +
            '<input type="hidden" name="sensor[sensor_accesses_attributes][' + newIndex + '][user_id]" value="' + selection.item.id + '" />' +
            '<div class="col-sm-6">' + selection.item.label + '</div>' +
            '<div class="col-sm-4 text-right"><select class="access-level-select form-control" name="sensor[sensor_accesses_attributes][' + newIndex + '][access_level]">' + accessLevelSelect.html() + '</select></div>' +
            '<div class="col-sm-2 text-right"><button type="button" class="remove-user close"><span>&times;</span></button></div>' +
            '</div>' +
            '</li>').insertBefore('#user-search-list-item');
            $('button.remove-user').click(removeUser);
            return false;
        },
        focus: function() {
            $('#user-search').val('');
            return false;
        },
        open: function() {
            $("ul.ui-menu").width($(this).innerWidth());
        }
    });
});

function Chart(sensor_id, selector, interpolationType, interactive) {
    var self = this;

    this.sensor_id = sensor_id;
    this.selector = selector;
    this.interpolationType = interpolationType;
    this.interactive = interactive;

    this.margin = 60;
    this.width = parseInt(d3.select(selector).style("width")) - this.margin*2;
    this.height = ((parseInt(d3.select(selector).style("width"))/16)*9) - this.margin*2;

    this.xScale = d3.time.scale()
        .range([0, this.width])
        .nice();
    this.yScale = d3.scale.linear()
        .range([this.height, 0])
        .nice();

    this.xAxis = d3.svg.axis()
        .scale(this.xScale)
        .orient("bottom");
    this.yAxis = d3.svg.axis()
        .scale(this.yScale)
        .orient("left");

    this.line = d3.svg.line()
        .x(function(d) { return self.xScale(d.created_at); })
        .y(function(d) { return self.yScale(d.value); });
    this.line.interpolate(this.interpolationType || 'linear');

    this.graph = d3.select(this.selector)
        .attr("width", this.width + this.margin*2)
        .attr("height", this.height + this.margin + 20)
        .append("g")
        .attr("transform", "translate(" + this.margin + "," + 20 + ")");

    this.hoverLine = this.graph
        .append('svg:line')
        .attr('class', 'hover-line')
        .attr('x1', 10).attr('x2', 10)
        .attr('y1', 0).attr('y2', self.height);

    this.hoverLine.classed('hide', true);

    d3.select(window).on('resize', function() { self.resize(); }); 

    if(this.interactive) {
        $(this.selector).mouseleave(function(event) {
            self.handleMouseOutGraph(event);
        });
        $(this.selector).mousemove(function(event) {
            self.handleMouseOverGraph(event);
        });
    }
}

Chart.prototype.valueForPosition = function(mouseX) {
    var xValue = this.xScale.invert(mouseX);
    var bisectDate = d3.bisector(function(d) { return d.created_at; }).left;
    var index = bisectDate(this.data, xValue);
    var distanceA = xValue - this.data[index-1].created_at;
    var distanceB = this.data[index].created_at - xValue;
    return distanceA < distanceB ? this.data[index-1] : this.data[index];
};

Chart.prototype.handleMouseOutGraph = function() {
    // hide the hover-line
    this.hoverLine.classed("hide", true);

    // reset timestamp and value
    $('#created_at').text('');
    $('#value').text('');
    
    // user is no longer interacting
    userCurrentlyInteracting = false;
    currentUserPositionX = -1;
};

Chart.prototype.handleMouseOverGraph = function(event) {
    var mouseX = event.pageX - (this.margin + $(this.selector).offset().left);
    var mouseY = event.pageY - (this.margin + $(this.selector).offset().top);
    
    //debug("MouseOver graph [" + containerId + "] => x: " + mouseX + " y: " + mouseY + "  height: " + h + " event.clientY: " + event.clientY + " offsetY: " + event.offsetY + " pageY: " + event.pageY + " hoverLineYOffset: " + hoverLineYOffset)
    if(mouseX >= 0 && mouseX <= this.width && mouseY >= 0 && mouseY <= this.height) {
        // show the hover line
        this.hoverLine.classed("hide", false);

        // display value of current position
        var record = this.valueForPosition(mouseX);
        if(record) {
            // set position of hoverLine
            this.hoverLine.attr("x1", this.xScale(record.created_at)).attr("x2", this.xScale(record.created_at));

            $('#created_at').text(d3.time.format("%Y-%m-%d %H:%M:%S")(new Date(record.created_at)));
            $('#value').text(record.value);
        }
        
        // user is interacting
        userCurrentlyInteracting = true;
    } else {
        // proactively act as if we've left the area since we're out of the bounds we want
        this.handleMouseOutGraph(event);
    }
};

Chart.prototype.resize = function() {
    this.width = parseInt(d3.select(this.selector).style("width")) - this.margin*2;
    this.height = ((parseInt(d3.select(this.selector).style("width"))/16)*9) - this.margin*2;

    this.hoverLine.attr('y2', this.height);

    this.xScale.range([0, this.width]).nice(d3.time.day);
    this.yScale.range([this.height, 0]).nice();

    if (this.width < 300 && this.height < 80) {
        this.graph.select('.x.axis').style("display", "none");
        this.graph.select('.y.axis').style("display", "none");

        [
            {selector: ".first", record: firstRecord},
            {selector: ".last", record: lastRecord}
        ].forEach(function(e) {
            this.graph.select(e.selector)
                .attr("transform", "translate(" + this.xScale(e.record.created_at) + "," + this.yScale(e.record.value) + ")")
                .style("display", "initial");
        });
    } else {
        this.graph.select('.x.axis').style("display", "initial");
        this.graph.select('.y.axis').style("display", "initial");
        this.graph.select(".last")
            .style("display", "none");
        this.graph.select(".first")
            .style("display", "none");
    }

    this.yAxis.ticks(Math.max(this.height/50, 2));
    this.xAxis.ticks(Math.max(this.width/50, 2));

    this.graph
        .attr("width", this.width + this.margin*2)
        .attr("height", this.height + this.margin*2);

    this.graph.select('.x.axis')
    .attr("transform", "translate(0," + this.height + ")")
    .call(this.xAxis)
    .selectAll("text")  
        .style("text-anchor", "end")
        .attr("dx", "-.8em")
        .attr("dy", ".15em")
        .attr("transform", function() {
            return "rotate(-30)";
        });

    this.graph.select('.y.axis')
        .call(this.yAxis);

    var dataPerPixel = this.data.length/this.width;
    var dataResampled = this.data.filter(function(d, i) {
        return i % Math.ceil(dataPerPixel) === 0;
    });

    this.graph.selectAll('.line')
        .datum(dataResampled)
        .attr("d", this.line);
};

Chart.prototype.initialize = function() {
    var self = this;
    d3.json("/sensors/" + this.sensor_id + "/records.json" + location.search, function(error, json) {
        self.data = json.records;
        self.data.forEach(function(d) {
            d.created_at = Date.parse(d.created_at);
            d.value = +d.value;
        });

        self.xScale.domain(d3.extent(self.data, function(d) { return d.created_at; }));
        self.yScale.domain(d3.extent(self.data, function(d) { return d.value; }));

        self.graph.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + self.height + ")")
            .call(self.xAxis);

        self.graph.append("g")
            .attr("class", "y axis")
            .call(self.yAxis)
            .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end");

        var dataPerPixel = self.data.length/self.width;
        var dataResampled = self.data.filter(function(d, i) {
            return i % Math.ceil(dataPerPixel) === 0;
        });

        self.graph.append("path")
            .datum(dataResampled)
            .attr("class", "line")
            .attr("d", self.line);

        var firstRecord = self.data[self.data.length-1], 
            lastRecord = self.data[0];

        var first = self.graph.append("g")
            .attr("class", "first")
            .style("display", "none");

        first.append("text")
            .attr("x", -8)
            .attr("y", 4)
            .attr("text-anchor", "end")
            .text(firstRecord.value);
        first.append("circle")
            .attr("r", 4);

        var last = self.graph.append("g")
            .attr("class", "last")
            .style("display", "none");

        last.append("text")
            .attr("x", 8)
            .attr("y", 4)
            .text(lastRecord.value);
        last.append("circle")
            .attr("r", 4);

        self.resize();
    });
};
