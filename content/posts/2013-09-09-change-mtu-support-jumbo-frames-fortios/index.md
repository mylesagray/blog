---
title: Change MTU to support Jumbo Frames in FortiOS
author: Myles Gray
type: posts
date: 2013-09-09T23:05:49+00:00
lastmod: 2021-09-02T14:27:00+00:00
url: /networks/change-mtu-support-jumbo-frames-fortios
aliases: ["/networks/change-mtu-support-jumbo-frames-fortios", "/networks/change-mtu-support-jumbo-frames-fortios/amp", "/hardware/change-mtu-support-jumbo-frames-fortios", "/hardware/change-mtu-support-jumbo-frames-fortios/amp"]
description: "Quick overview showing how to enable Jumbo Frames on FortiOS devices"
cover:
  relative: true
  image: images/Screen-Shot-2013-09-10-at-00.02.05.webp
  alt: "FortiOS Jumbo Frames configuration"
categories:
  - Hardware
  - Infrastructure
  - Networks
tags:
  - fortigate
  - jumbo frame
  - mtu
---

This info is quite hard to come across and Fortigate don't have it in their GUI from FortiOS v5.0+, SSH into your Fortigate's CLI and enter the following (it can be done on both software aggregated and standard interfaces):

```text
config system interface
edit [interfacename]
    set mtu-override enable
    set mtu 9208
end
end
```

Confirm your MTU size change has worked on the given interface by plugging directly into it (test MTU in accordance to [my guide here][1]).

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /hardware/test-jumbo-frames-working/ "How to test if 9000 MTU/Jumbo Frames are working"
 [2]: https://twitter.com/mylesagray