---
title: Fortigate High Availability – Active/Active – Part 1 – Preparation
author: Myles Gray
type: posts
date: 2014-02-11T13:11:40+00:00
lastmod: 2021-10-06T14:53:52+00:00
description: "How to fill out all the pre-requisites for moving a Fortigate firewall into a HA pair"
url: /infrastructure/fortigate-ha-activeactive-part-1-preparation
aliases: [ "/infrastructure/fortigate-ha-activeactive-part-1-preparation/amp" ]
cover:
  image: images/Screen-Shot-2014-02-11-at-12.36.56.png
  alt: "Fortigate firewall PPPoE interface config for HA"
categories:
  - Infrastructure
tags:
  - fortigate
  - high-availability
  - networking
---

## Introduction

I recently set up 2x Fortigate 200B units to run in HA Active/Active mode, this posed a number of challenges:

* HA doesn't work if any interfaces use PPPoE or have an address assigned via DHCP
* How do I effectively split our network communications between both units?

## The PPPoE Problem

The main problem was that _both_ the internet connections used PPPoE for address assignment and auth - I had taken care of one of these previously as it was a simple ADSL link our Fortigate units didn't allow for so we had a [Cisco 837][1] box to terminate the PPPoE on a virtual interface and `unnumber` the static external IP to an internal interface. (Read: I used it as a proxy of sorts to get round hardware limitations).

We had done it before for an ADSL link so I follow the same methodology for our fiber link, except, with a faster Cisco box - in the form of a very simple, cheap [Cisco 1841][2]. Loaded the latest broadband firmware onto it ([c1841-broadband-mz.151-4.M7.bin][3]) and did the following:

* Assigned `f0/0` to be our internal "gateway" address (the assigned router address from BT/Zen in the static IP block)
* Assigned `f0/1` to be our external WAN facing address and act as PPPoE client (no ip address)
* Created a virtual Dialer interface `Dialer1` to act as PPPoE terminator
* Unnumbered `Dialer1`'s IP against `f0/0`
* Set `mtu` to `1492` on `Dialer1`
* Enable `ip cef`
* Set `adjust-mss` to `1452` on `f0/0` **Extremely important to match frame size to ISP**

[Download full (nulled) config here.][4]

With that out of the way I then set up our 200B to use this IP as its gateway (via static route 0.0.0.0/0.0.0.0 to go out [router address assigned to `f0/0`]).

> A static route was used as I can set priorities on these and give our fiber link a higher priority than the ADSL meaning we will always use the fiber link unless it breaks, when it fails over to ADSL.

The previously configured PPPoE WAN link was changed to be "manual mode" and assigned it the desired public IP:

![Interface Manual Mode][5]

This then left me in a position where I could configure our 200Bs to use HA as now no interface relied on DHCP or PPPoE for addressing.

## Sharing Interfaces

> How do we effectively split our network communications between both units?

This was considerably simpler than the first problem I came across - the answer is get a Gb switch - I had a [Cisco 3560-X 24P-L][6] to work with.

I split the ports into groups of 4 ports on VLANs (a separate untagged VLAN for each usable interface on the Fortigate) this gave me:

* 1x input port
* 1x output port to fw-a
* 1x output port to fw-b
* 1x extra port for maintenance access

[Download full (nulled) config here.][7]

Hence the groups of 4, if you had 3x or even 4x Firewalls in A/A HA then you would need 5 and 6 ports per VLAN respectively.

My `show vlan` output looked like this (_note I am using jumbo frames_):

```sh
Cisco-3560X-200B-HA#sh vlan

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    
2    lan                              active    Gi0/1, Gi0/2, Gi0/3, Gi0/4
3    mgmt                             active    
4    iscsi                            active    
5    phones                           active    Gi0/5, Gi0/6, Gi0/7, Gi0/8
6    wifi                             active    Gi0/9, Gi0/10, Gi0/11, Gi0/12
7    microwave-wan                    active    Gi0/13, Gi0/14, Gi0/15, Gi0/16
100  adsl                             active    Gi0/17, Gi0/18, Gi0/19, Gi0/20
101  fiber                            active    Gi0/21, Gi0/22, Gi0/23, Gi0/24
1002 fddi-default                     act/unsup 
1003 token-ring-default               act/unsup 
1004 fddinet-default                  act/unsup 
1005 trnet-default                    act/unsup 

VLAN Type  SAID       MTU   Parent RingNo BridgeNo Stp  BrdgMode Trans1 Trans2
---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------
1    enet  100001     1500  -      -      -        -    -        0      0   
2    enet  100002     9000  -      -      -        -    -        0      0   
3    enet  100003     9000  -      -      -        -    -        0      0   
4    enet  100004     9000  -      -      -        -    -        0      0   
5    enet  100005     9000  -      -      -        -    -        0      0   
6    enet  100006     9000  -      -      -        -    -        0      0   
7    enet  100007     9000  -      -      -        -    -        0      0   
100  enet  100100     9000  -      -      -        -    -        0      0   
101  enet  100101     9000  -      -      -        -    -        0      0   
1002 fddi  101002     1500  -      -      -        -    -        0      0   
1003 tr    101003     1500  -      -      -        -    -        0      0   
1004 fdnet 101004     1500  -      -      -        ieee -        0      0   
1005 trnet 101005     1500  -      -      -        ibm  -        0      0
```

All that needed to be done was plug the input ports into its respective VLAN and then take a cable to each 200B from each VLAN, effectively meaning each 200B could communicate with each input, easy.

[In part 2][8] we will talk about setting up the Fortigate units themselves for HA and the proper procedure to employ for this.

Why not follow [@mylesagray on Twitter][9] for more like this!

 [1]: http://www.cisco.com/c/en/us/products/collateral/routers/837-adsl-broadband-router/product_data_sheet09186a008010e5c5.html
 [2]: http://www.cisco.com/en/US/prod/collateral/routers/ps5853/product_data_sheet0900aecd8016a59b.html
 [3]: http://software.cisco.com/download/release.html?mdfid=279119622&flowid=7351&softwareid=280805680&release=15.1.4M7&relind=AVAILABLE&rellifecycle=MD&reltype=latest
 [4]: files/Cisco_1841_Config.txt
 [5]: images/Screen-Shot-2014-02-11-at-12.36.56.png
 [6]: http://www.cisco.com/c/en/us/products/switches/catalyst-3560-x-series-switches/index.html
 [7]: files/Cisco_3560X_Config.txt
 [8]: /infrastructure/fortigate-high-availability-activeactive-part-2-implementation/
 [9]: https://twitter.com/mylesagray
