---
layout: post
title: "Building Apache Ambari RPM with views"
modified:
categories: posts
excerpt:
tags: [devops, bigdata, ambari]
image:
feature:
date: 2018-03-16T15:34:03-06:00
---

I needed to build a custom Apache Ambari version for Cloudbreak 2.4.0.

## Get around an annoying error

If you encountered this error when installing the Ambari RPM.

{% highlight bash %}
Extracting system views...
ERROR: Unexpected OSError: [Errno 2] No such file or directory: '/var/lib/ambari-server/resources/views'
For more info run ambari-server with -v or --verbose option
{% endhighlight %}

Then you haven't specified the views parameter when you built the Ambari project. For example, this will
build the RPM with the views correctly.

{% highlight bash %}
mvn -fae \
  -DskipTests -Dcheckstyle.skip -Drat.skip -Dfindbugs.skip \
  -Del.log=WARN -Dpython.ver="python >= 2.6" -Preplaceurl \
  clean install package rpm:rpm -Dviews
{% endhighlight %}
