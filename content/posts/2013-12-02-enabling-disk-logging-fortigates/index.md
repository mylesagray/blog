---
title: Enabling disk logging on a FortiGate
author: Myles Gray
type: posts
date: 2013-12-02T15:34:29+00:00
lastmod: 2021-10-04T17:41:29+00:00
description: "How to enable disk logging on FortiGate firewalls"
url: /hardware/enabling-disk-logging-fortigates
aliases: [ "/hardware/enabling-disk-logging-fortigates/amp" ]
cover:
  image: images/Screen-Shot-2013-12-02-at-15.35.21.png
  alt: "FortiGate disk logging comparison"
categories:
  - Hardware
  - Infrastructure
  - Networks
tag:
  - fortigate
  - logging
  - syslogd
---

Fortigate's logging typically isn't the best - but it's bad when you have no logs at all, which seems to be the default. To enable logging on fortigate models with an internal SSD/HDD use the following command:

```sh
config log disk setting
set status enable
```

You can now collect and view your logs in the `Log & Report` section.

**N.B. As of FortiOS 5.2 this has been disabled on all SMB class (100D and below) units. You will need to use memory logging or export to syslog.**

Why not follow [@mylesagray on Twitter][1] for more like this!

 [1]: https://twitter.com/mylesagray