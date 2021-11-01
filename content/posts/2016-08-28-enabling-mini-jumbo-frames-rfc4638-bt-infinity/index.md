---
title: Enabling Mini Jumbo Frames (RFC4638) on OpenReach FTTC
author: Myles Gray
type: posts
date: 2016-08-28T16:29:59+00:00
lastmod: 2021-10-25T13:41:00+00:00
description: "How to enable 1500 MTU on OpenReach internet connections"
url: /networks/enabling-mini-jumbo-frames-rfc4638-bt-infinity
aliases: [ "/networks/enabling-mini-jumbo-frames-rfc4638-bt-infinity/amp" ]
cover:
  relative: true
  image: images/2016-08-28_17-17-18.gif
  alt: "Pinging google at 1500 MTU"
categories:
  - Networks
tags:
  - bt
  - cisco
  - mtu
  - networking
  - wan
---

I swapped out my single Fortigate 100D at home a while back for a cluster of two in active/passive, as part of this migration, that [I have written][1] [about before][2] I needed to terminate any DHCP or PPPoE interfaces on a different piece of kit than the clustered firewalls.

I have had this in the lab for a while on a Cisco 2811 router set up pretty much exactly like I had [in the previous article][3].

However, it came to my attention that OpenReach support [RFC4638 (Mini Jumbo Frames)][4] on their WAN, so I felt compelled to remove a few lines of config from my router to clean it up and gain whatever marginal benefit an extra 8 bytes of frame size will get me.

The current config looked like this (the parts that matter anyway):

```sh
interface FastEthernet0/0
 description FG_side
 ip address my.public.ip.address 255.255.255.248
 duplex auto
 speed 100
!
interface FastEthernet0/1
 description WAN_side
 no ip address
 duplex auto
 speed auto
 pppoe enable group global
 pppoe-client dial-pool-number 1
!
interface Dialer1
 ip unnumbered FastEthernet0/0
 ip mtu 1492
 encapsulation ppp
 ip tcp adjust-mss 1452
 dialer pool 1
 dialer idle-timeout 0
 dialer-group 1
 ppp authentication chap pap callin
 ppp chap hostname USERNAME HERE
 ppp chap password 7 PASSWORD
 ppp pap sent-username USERNAMEHERE password 7 PASSWORD
 no cdp enable
!
```

The RFC allows for you to send a standard 1500 byte ethernet frame over the WAN - so we need to increase the MTU on the WAN side interface and tell ppp to negotiate a MRU size of `1500` as it is larger than the `1492` standard:

```sh
interface fa 0/1
 mtu 1508
 pppoe-client ppp-max-payload 1500
```

And we can also now remove `ip tcp adjust-mss` and `ip mtu` from the dialler as no frames will need their size change when going over wan:

```sh
interface Dial 1
 no ip mtu 1492
 no ip tcp adjust-mss 1452
```

You can see from the ping below running during my change that we are now able to ping google.com at a `1472` (accoung for 28 byte overhead) MTU.

![Mini Jumbo Frames Ping][5]

[Props to this thread][6], without it I wouldn't have known OpenReach implemented this feature.

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: /infrastructure/fortigate-ha-activeactive-part-1-preparation/
 [2]: /infrastructure/fortigate-high-availability-activeactive-part-2-implementation/
 [3]: images/Cisco_1841_Config.txt
 [4]: https://tools.ietf.org/html/rfc4638
 [5]: images/2016-08-28_17-17-18.gif
 [6]: https://community.bt.com/t5/BT-Infinity-Speed-Connection/Infinity-on-Cisco-Router/td-p/149185/page/2
 [7]: https://twitter.com/mylesagray