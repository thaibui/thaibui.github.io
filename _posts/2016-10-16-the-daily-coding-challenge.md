---
layout: post
title: "The Daily Coding Challenge"
modified:
categories: posts
excerpt:
tags: [daily, coding, challenge]
image:
feature:
date: 2016-10-16T01:30:02-07:00
---

# Rules

The rules are simple: you should try to code something everyday and publish it
on your blog. The challenge should be very simple so that you can finish it 
daily. Today will be my first day.

## 1st Challenge 

Write a program in Scala to sort a list of integers in decending orders.

## The code 

I used this nifty online code editor for writing the challenge. You can use it to 
run and test the code below. It also provides a playback of my coding progress as well. 

[https://codepad.remoteinterview.io/GLHUVWPMMA](https://codepad.remoteinterview.io/GLHUVWPMMA){:target="_blank"} 

{% highlight scala linenos %}
object FirstChallenge {
    def main(args: Array[String]) = {
        val a = Array(1, 2, 3, 4)
        for(i <- 0 until a.length - 1){
            var max = a(i)
            var maxPos = i
            for(j <- i+1 until a.length) {
                if(a(j) > max) {
                    max = a(j)
                    maxPos = j
                }
            }
            
            max = a(i)
            a(i) = a(maxPos);
            a(maxPos) = max;
        }
        
        for(i <- 0 until a.length) {
            println(a(i))
        }
    }
}
{% endhighlight %}

The code is not efficient but it is good enough for completing this challenge.
