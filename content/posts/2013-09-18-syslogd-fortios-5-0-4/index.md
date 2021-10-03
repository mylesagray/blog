---
title: Syslogd on FortiOS 5.0.4
author: Myles Gray
type: posts
date: 2013-09-18T19:49:28+00:00
url: /hardware/syslogd-fortios-5-0-4/
description: "How to enable syslog on FortiOS v5.0"
resources:
- name: "featured-image"
  src: images/Screen-Shot-2013-09-18-at-20.51.16.png
categories:
  - Hardware
  - Infrastructure
tags:
  - fortigate
  - splunk
  - syslogd
---

Again, Fortigate's documentation falls down at the simplest of things, this time, syslogging - To get your Fortigate to log to a syslogger (like Kiwi/Splunk) you'll need to go in via the CLI as they have removed this option from the GUI as of FortiOS v5.0.

Log in via shell and enter the following:

```sh
config log syslogd setting
    set status enable
    set server [ip.or.dns-name.here]
end
```

I have seen where people say you need to explicitly:

`set port 514` or `set facility local7` but these are defaults and implied.

You can set up multiple syslog server locations by simply changing the first line to `config log [syslog2|syslog3] setting` and filling in the details for the other syslog servers.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/Screen-Shot-2013-09-18-at-20.51.16.png
 [2]: https://twitter.com/mylesagray