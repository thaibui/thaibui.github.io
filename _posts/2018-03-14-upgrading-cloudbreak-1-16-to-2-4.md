---
layout: post
title: "Upgrading Hortonworks Cloudbreak from 1.16 to 2.4.0"
modified:
categories: posts
excerpt:
tags: [devops, bigdata]
image:
feature:
date: 2017-03-14T17:53:00-06:00
---

I needed to upgrade Hortonworks Cloudbreak at work from 1.16 to 2.4.0 and here's how.

## Prep work

If you are running Cloudbreak in your own VM, the task will be very simple:

{% highlight bash %}
# ssh into your Cloudbreak box, in your cloudbreak installation dir, run
cbd upgrade
cbd migrate
cbd regenerate
cbd restart
{% endhighlight %}

Oh, yeah, that's it?

Not really.

## A bit more work

If you have a custom Ambari version in your `etc/application.yml`
you'll need to update it as well.

So change this

{% highlight yaml %}
cb:
  ambari:
    repo:
      version: 2.5.1.0-159
      baseurl: http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.1.0
      gpgkey: http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
{% endhighlight %}

To this

{% highlight yaml %}
cb:
  ambari:
    version: 2.6.1.5-3
    repo:
      centos7:
        baseurl: http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.1.5
        gpgkey: http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.1.5/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
{% endhighlight %}

 Or else you'll get an error when Cloudbreak is trying to load a the default
 Ambari repo configuration.


{% highlight bash %}
cloudbreak_1   | ***************************
cloudbreak_1   | APPLICATION FAILED TO START
cloudbreak_1   | ***************************
cloudbreak_1   |
cloudbreak_1   | Description:
cloudbreak_1   |
cloudbreak_1   | Binding to target com.sequenceiq.cloudbreak.service.DefaultAmbariRepoService@52418721 failed:
cloudbreak_1   |
cloudbreak_1   |     Property: cb.ambari.repo[version]
cloudbreak_1   |     Value: 2.6.1.5-3
cloudbreak_1   |     Reason: Failed to convert property value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[version]'; nested exception is java.lang.IllegalStateException: Cannot convert value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[version]': no matching editors or conversion strategy found
cloudbreak_1   |
cloudbreak_1   |     Property: cb.ambari.repo[baseurl]
cloudbreak_1   |     Value: http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.1.5
cloudbreak_1   |     Reason: Failed to convert property value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[baseurl]'; nested exception is java.lang.IllegalStateException: Cannot convert value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[baseurl]': no matching editors or conversion strategy found
cloudbreak_1   |
cloudbreak_1   |     Property: cb.ambari.repo[gpgkey]
cloudbreak_1   |     Value: http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.1.5/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
cloudbreak_1   |     Reason: Failed to convert property value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[gpgkey]'; nested exception is java.lang.IllegalStateException: Cannot convert value of type 'java.lang.String' to required type 'java.util.Map' for property 'repo[gpgkey]': no matching editors or conversion strategy found
cloudbreak_1   |
cloudbreak_1   |
cloudbreak_1   | Action:
cloudbreak_1   |
cloudbreak_1   | Update your application's configuration
{% endhighlight %}
