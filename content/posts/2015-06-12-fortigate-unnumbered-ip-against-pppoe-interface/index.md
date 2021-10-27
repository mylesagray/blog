---
title: Fortigate Unnumbered IP against PPPoE Interface
author: Myles Gray
type: posts
date: 2015-06-12T18:26:18+00:00
lastmod: 2021-10-25T11:34:00+00:00
description: "How to use a statically assigned IP as the main WAN interface IP on a FortiGate firewall"
url: /networks/fortigate-unnumbered-ip-against-pppoe-interface
aliases: [ "/networks/fortigate-unnumbered-ip-against-pppoe-interface/amp" ]
cover:
  image: images/Screen-Shot-2015-06-12-at-19.27.55.png
  alt: "Fortigate WAN interface using IP unnumbering"
categories:
  - Networks
tags:
  - firewall
  - fortigate
  - static ip
  - unnumbered ip
---

I ran into some very strange behaviour on a BT Business Fiber connection with PPPoE and static IPs assigned by the ISP on a Fortigate firewall.

A site-to-site IPSec VPN was required, however the tunnel kept terminating as BT assign a dynamic address with the PPPoE connection, then the static IPs are typically ingested through the use of Virtual-IPs on the fortigate unit, however IPSec requires the use of the router WAN address and it needs to be static.

Setting the `unnumbered IP` on the Fortigate to one of the assigned static IP addresses from the ISP should have presented the firewall on this address to the outside world, but not so.

I stumbled upon a CLI parameter that was used to remedy non-standard PPPoE implementations in Japan on an article linked below and gave it a go:

```sh
set pppoe-unnumbered-negotiate disable
```

This will reset the WAN connection when saved, however in place of the dynamically assigned IP you should now be able to access the firewall remotely with the ISP static IP you just assigned.

References:

* <http://qiita.com/Glassphere/items/7f737153f8f291e089ca>

Why not follow [@mylesagray on Twitter][1] for more like this!

 [1]: https://twitter.com/mylesagray