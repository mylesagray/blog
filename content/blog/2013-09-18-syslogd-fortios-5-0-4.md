---
title: Syslogd on FortiOS 5.0.4
author: Myles Gray
type: post
date: 2013-09-18T19:49:28+00:00
url: /hardware/syslogd-fortios-5-0-4/
cover:
  image: /uploads/2013/11/Screen-Shot-2013-09-18-at-20.51.16.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1775066961
rop_post_url_twitter:
  - 'https://blah.cloud/hardware/syslogd-fortios-5-0-4/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Hardware
  - Infrastructure
tags:
  - fortigate
  - splunk
  - syslogd

---
Again, Fortigate's documentation falls down at the simplest of things, this time, syslogging - To get your Fortigate to log to a syslogger (like Kiwi/Splunk) you'll need to go in via the CLI as they have removed this option from the GUI as of FortiOS v5.0.

![Splunk Fortigate Syslogd][1] 

Log in via shell and enter the following:

    config log syslogd setting
        set status enable
        set server [ip.or.dns-name.here]
    end
    

I have seen where people say you need to explicitly:

`set port 514` or `set facility local7` but these are defaults and implied.

You can set up multiple syslog server locations by simply changing the first line to `config log [syslog2|syslog3] setting` and filling in the details for the other syslog servers.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /uploads/2013/11/Screen-Shot-2013-09-18-at-20.51.16.png
 [2]: https://twitter.com/mylesagray