---
title: Fortigate High Availability – Active/Active – Part 2 – Implementation
author: Myles Gray
type: posts
date: 2014-02-16T12:42:06+00:00
lastmod: 2021-10-06T15:13:52+00:00
description: "How to configure two Fortigate Firewalls to run in Active/Active High Availability mode"
url: /infrastructure/fortigate-high-availability-activeactive-part-2-implementation/
cover:
  image: images/Screen-Shot-2014-02-16-at-12.35.16.png
  alt: "Fortigate Firewalls in HA mode"
categories:
  - Infrastructure
tags:
  - fortigate
  - high-availability
  - networking
---

[In Part 1][1] we got the prerequisites sorted out for the HA (removed all PPPoE or DHCP address assignment from the FG boxes and VLANed a switch to split the inputs between both boxes).

Part 2 is considerably easier, the cabling had been done for the VLANs now we had to designate 2x ports as our cluster comms ports, I chose `port1` and `port2` on each box, each given a weight of `50`:

![Fortigate HA Port Assignment][2]

Next we plug configure the cluster and weighting of each box in the cluster, we wanted to run ours in Active/Active - with session pickup and reserve a port for managing the units individually on port3 as you can see from the above settings.

The process of them bringing up the cluster goes like so:

* Backup your master config (the one you want to run on the firewalls)
* Set the master unit to have a higher priority - I set ours to `255` and the other to `0`
* Shut down both units
* Plug in `port1` on `fw-a` into `port1` on `fw-b` and the same with `port2`
* Power on the master unit and allow it to boot fully
* Power on the slave unit and allow it to boot
* Log into the web interface of the firewall and check to see if the cluster is up as below

![Fortigate HA Front Page][3]

You can view stats on the cluster by going to `System -> Config -> HA` and clicking `View HA Statistics` here you can view session distribution etc.

![Fortigate HA Monitoring][4]

And that's it, your firewalls are now running Active/Active HA, load sharing, redundancy, the whole lot!

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: /infrastructure/fortigate-ha-activeactive-part-1-preparation/
 [2]: images/Screen-Shot-2014-02-16-at-12.18.47.png
 [3]: images/Screen-Shot-2014-02-16-at-12.35.48.png
 [4]: images/Screen-Shot-2014-02-16-at-12.35.16.png
 [5]: https://twitter.com/mylesagray
