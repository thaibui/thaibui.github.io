---
layout: post
title: "Improving Java Sorting Algorithms: Part 2"
modified:
categories: posts
excerpt:
tags: [algorithms, sort, merge-sort, bigdata]
image:
feature:
date: 2017-03-05T08:56:00-04:00
---

<style>
/*
.chart rect {
      fill: steelblue;
}
*/
.chart .legend {
      fill: #38353b;
      font: 14px sans-serif;
      text-anchor: start;
      font-size: 12px;
}
.chart text {
      fill: #6b6571;
      font: 11px sans-serif;
      text-anchor: start;
}

.chart .label {
      fill: #38353b;
      font: 14px sans-serif;
      text-anchor: end;
}

.bar:hover {
      fill: rgba(0, 0, 0, 0.5);
}

.axis path,
.axis line {
      fill: none;
      stroke: #38353b;
      shape-rendering: crispEdges;
}

.x text {
      fill: #38353b;
      font: 11px sans-serif;
      text-anchor: end !important;
}

.x_label {
      fill: #6b6571 !important;
      text-anchor: end !important;
}

.d3-tip {
  line-height: 0.2;
  font: 11px sans-serif;
  padding: 5px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  border-radius: 2px;
}

/* Creates a small triangle extender for the tooltip */
.d3-tip:after {
  box-sizing: border-box;
  display: inline;
  font-size: 10px;
  width: 100%;
  line-height: 1;
  color: rgba(0, 0, 0, 0.5);
  content: "\25BC";
  position: absolute;
  text-align: center;
}

/* Style northward tooltips differently */
.d3-tip.n:after {
  margin: -1px 0 0 0;
  top: 100%;
  left: 0;
}

</style>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://labratrevenge.com/d3-tip/javascripts/d3.tip.v0.6.3.js"></script>
<script src="http://d3js.org/colorbrewer.v1.min.js"></script>
<script>

var chartWidth       = 300,
    barHeight        = 20,
    gapBetweenGroups = 10,
    spaceForLabels   = 160,
    spaceForLegend   = 150,
    spaceForXAxis    = 20;

function draw_chart(_class, data) {
    var groupHeight = barHeight * data.series.length;

    // Zip the series data together (first values, second values, etc.)
    var zippedData = [];
    for (var i=0; i<data.labels.length; i++) {
      for (var j=0; j<data.series.length; j++) {
        zippedData.push(data.series[j].values[i]);
      }
    }

    // Color scale
    var color = d3.scale.ordinal()
        .range(colorbrewer.Set2[4]);
    var chartHeight = barHeight * zippedData.length + 
            gapBetweenGroups * data.labels.length + 
            spaceForXAxis;

    var x = d3.scale.linear()
        .domain([0, d3.max(zippedData) * 1.1])
        .range([0, chartWidth]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .tickSize(5,0)
        .ticks(5)
        .orient("bottom");

    var y = d3.scale.linear()
        .range([chartHeight + gapBetweenGroups, 0]);

    var yAxis = d3.svg.axis()
        .scale(y)
        .tickFormat('')
        .tickSize(0)
        .orient("left");

    // Specify the chart area and dimensions
    var chart = d3.select(_class)
        .attr("width", spaceForLabels + chartWidth + spaceForLegend)
        .attr("height", chartHeight);

    // Draw tooltip
    var format_ops = d3.format(",.0f")
    var tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html(function(d) {
        return "<span style='tooltip-text'>" + format_ops(d) + "</span> ops/sec";
      })
    chart.call(tip);

    // Create bars
    var bar = chart.selectAll("g")
        .data(zippedData)
        .enter().append("g")
        .attr("transform", function(d, i) {
          return "translate(" + spaceForLabels + "," + (i * barHeight + gapBetweenGroups * (0.5 + Math.floor(i/data.series.length))) + ")";
        });

    // Create rectangles of the correct width
    bar.append("rect")
        .attr("fill", function(d,i) { return color(i % data.series.length); })
        .attr("class", "bar")
        .attr("width", x)
        .attr("height", barHeight - 1)
        // Add tooltip
        .on('mouseover', tip.show)
        .on('mouseout', tip.hide);

    // Add text label in bar
    var format_percent = d3.format(",.0%")
    bar.append("text")
        .attr("x", function(d) { return x(d) + 3; })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .text(function(d,i) { return format_percent(d/data.series[0].values[Math.floor(i/data.series.length)]); });

    // Draw labels
    bar.append("text")
        .attr("class", "label")
        .attr("x", function(d) { return - 10; })
        .attr("y", groupHeight / 2)
        .attr("dy", ".35em")
        .text(function(d,i) {
          if (i % data.series.length === 0)
            return data.labels[Math.floor(i/data.series.length)];
          else
            return ""});

    chart.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(" + spaceForLabels + ", " + 
            (-gapBetweenGroups/2-spaceForXAxis) + ")")
          .call(yAxis);

    chart.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(" + spaceForLabels + ", " + 
            (chartHeight-spaceForXAxis) + ")")
          .call(xAxis);

    // Draw legend
    var legendRectSize = 18,
        legendSpacing  = 4;

    var legend = chart.selectAll('.legend')
        .data(data.series)
        .enter()
        .append('g')
        .attr('transform', function (d, i) {
            var height = legendRectSize + legendSpacing;
            var offset = -gapBetweenGroups/2;
            var horz = spaceForLabels + chartWidth + 40 - legendRectSize;
            var vert = i * height - offset;
            return 'translate(' + horz + ',' + vert + ')';
        });

    legend.append('rect')
        .attr('width', legendRectSize)
        .attr('height', legendRectSize)
        .style('fill', function (d, i) { return color(i); })
        .style('stroke', function (d, i) { return color(i); });

    legend.append('text')
        .attr('class', 'legend')
        .attr('x', legendRectSize + legendSpacing)
        .attr('y', legendRectSize - legendSpacing)
        .text(function (d) { return d.label; });

    chart.append("text")
        .attr("class", "x_label")
        .attr("x", chartWidth + spaceForLabels)
        .attr("y", chartHeight - spaceForXAxis - 6)
        .text("sort operations per second");
}
</script>

# Parallelism != linear sort improvement

Mergesort is an easy algorithm to be parallelized. However, any parallelable tasks will need at least 
a coordinating task to split up the work and to synchronize the result. There is always a 
tradeoff between how much is gained because of parallelism and how much is lost because of coordination.

## Parallel mergesort vs. Java Tim's sort vs. Naive mergesort

My mergesort parallelism
[attempt](https://github.com/thaibui/algorithms-core/blob/forkjoinmerge_sort/sort/src/main/java/org/bui/algorithms/sort/ForkJoinMergesort.java)
was about 27-46% faster than a single-threaded Java Timsort. It is about the same in sorting stock
values which I do not know why. It could be that the stock values are almost sorted such that there is
little to do and the parallelism improvement is minimal.

<svg class="chart chart01"></svg>
<script>
draw_chart(".chart01", {
    labels: [
        '1000 movie titles', '2000 stock values', '10000 random integers'
    ],
    series: [
    {
      label: 'Java Timsort',
      values: [12501.816283, 11601.747724, 1505.355129]
    },
    {
      label: 'Mergesort',
      values: [12113.082190, 9064.588318, 1331.298021]
    },
    {
      label: 'Parallel Timsort',
      values: [15815.545862, 11773.716560, 2202.290482]
    }
    ]
}); 
</script>

In the next post, I will examine the performance of the current Java 7 parallel sort algorithm and
the newer Java 8 parallel sort [algorithm](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#parallelSort-byte:A-). I expect
mine to be slower since I don't have enough time and expertise to tune the algorithm on a variety of
dataset and machine configurations. However, even if the current algorithm is slower, I still can
parallel the sort task across machines to beat Java 8 version.

So stay tune and until next time.
