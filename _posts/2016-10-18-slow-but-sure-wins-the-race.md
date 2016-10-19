---
layout: post
title: "Slow but sure wins the race"
modified:
categories: posts
excerpt:
tags: [daily, coding, challenge]
image:
feature:
date: 2016-10-18T21:00:00-04:00
---

# Day 3 Challenge

Write a program in Go to create a file, write something in it then read the content back.

## The code 

You can see the coding replay [here](https://codepad.remoteinterview.io/playback/GLHUVWPMMA)

{% highlight go linenos %}
package main
import "fmt"
import "os"

func main(){
    file, error := os.Create("/tmp/todo.list")
    
    if error != nil {
        fmt.Println("Error while creating a file. ", error)
    } else {
        _, writeErr := file.WriteString("Day 3 challenge.")

        if writeErr != nil {
            fmt.Println("Error while writing a file. ", writeErr)
        } 
        
        file.Close()
    }
    
    readonlyFile, _ := os.Open("/tmp/todo.list")
    buffer := make([]byte, 100)
    count, _ := readonlyFile.Read(buffer)
    s := string(buffer[:count])
    fmt.Println("Content is: ", s)
    readonlyFile.Close();
}
{% endhighlight %}
