---
layout: post
title: "A code a day keeps the doctor away"
modified:
categories: posts
excerpt:
tags: [daily, coding, challenge]
image:
feature:
date: 2016-10-17T21:39:55-04:00
---

# Day 2 Challenge

Write a program in HTML5 & Javascript to draw a pulsing circle (like a beating heart).

## The code 

You can see the end result [here](https://cdn.rawgit.com/thaibui/617914cfe10552ff5a048114a446373e/raw/8a928444d7bb2b261a6b2f1f1c5bb5298d3de7e3/pulsing_circle.html)

{% highlight html linenos %}
<html>
    <head>
    </head>
    <body>
        <canvas id="canvas" width="600px" height="600px"></canvas>
        <script>
            var c = document.getElementById("canvas");
            var deltas = [];
            for(var i = 1; i <= 10; i++) {
                deltas[i-1] = i;
            }
            for(var i = 10, j = 10; i > 0; i--, j++) {
                deltas[j] = i;
            }
            var index = 0;
            var radius = 40;
            setInterval(draw, 100);

            function draw() {
                var ctx = c.getContext("2d");
                ctx.beginPath();
                ctx.clearRect(0,0,600,600);
                var k = i++ % deltas.length;
                ctx.arc(95,50,40+deltas[k],0,2*Math.PI);
                ctx.stroke();
            }
        </script>
    </body>
</html>
{% endhighlight %}
