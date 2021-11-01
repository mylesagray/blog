---
title: My home datacenter.
author: Myles Gray
type: posts
date: 2016-09-13T23:04:11+00:00
lastmod: 2021-10-25T13:45:00+00:00
url: /hardware/my-home-datacenter
aliases: [ "/hardware/my-home-datacenter/amp" ]
cover:
  relative: true
  image: images/Homelab-Front.jpg
  alt: "Homelab stack"
  hidden: true
categories:
  - Hardware
  - Infrastructure
---

I have been meaning to write this for a very long time, finally inspired by seeing Russell Pope's absolutely insane lab in the [vExpert Slack][1] and [Mark Brookfield][2]'s homelab [post][3] it started when my lab was a single Dell R710 with 96GB RAM and 2x X5670 procs. The home lab has stopped being a lab and become a datacenter in that time and it's about time I put it down on paper.

So, like most people, I collect hardware and gubbins over time - about 2/3 years in now and I have what has been described as _[better than most people's production infrastructures.][4]_ It may looks like hardware lust, but it is (mostly) requirement driven. I want a lab in which I can accurately simulate an environment like I would have in my day-to-day work ([a MSP, Novosco][5]) so, dedicated management cluster, compute cluster, hardware to support a multi-tenant environment, enough resource to run all our various automation and services pieces.

In essence, this thing is **big**.

## Current Lab

So I guess we'll start with a LucidChart topograph of the whole deal:

![Homelab V1][6]

As you can see from the above, yes, my management cluster is bigger than my compute cluster, but i'm emulating an MSP here, I don't need a ton of compute workloads to replicate the tool chain.

There is a cacophony of software running in here; vSphere, vCloud Director, Zerto, VMware VIO, vROPS, Runecast, Veeam, PernixData FVP (R.I.P.), NSX and soon to be VSAN. All layed out with a true multi-tenant service model (even the house it's hosted in accesses the VMs over an IPSec tunnel to an NSX edge as a tenant would).

With the topo fresh in your mind, here is the actual physical loadout of the boxes and the rest of the hardware:

3x Dell R710:

```sh
96 / 72 / 72GB RAM
2x X5670 / 2x X5570 / 2x X5570
4x Internal 250GB SATA drives RAID 10
1x 250GB Samsung 850 EVO in each (PernixData FVP FTW!)
Quad Gig NICs
iDRAC 6 Ent
H700 RAID Card
2x Intel X520-DA1
```

2x Dell R610:

```sh
48GB RAM
2x E5630
4x Internal 150GB 10K SAS RAID 1
Quad Gig NICs
iDRAC 6 Ent
PERC 6i RAID
2x Intel X520-DA1
```

Synology DS2015xs

```sh
2x Intel 240GB 520 Series (RAID1 SSD R/W Cache)
6x HGST Ultrastar 7K4000
2x 1GbE
2x 10GbE
```

ReadyNAS Ultra 6

```sh
6x HGST Ultrastar 7K6000
2x 1GbE
```

* 2x Fortigate 100D firewalls in A/P HA
* Cisco 2811 Router for PPPoE termination to allow for the HA clustered firewalls
* 2x HP ProCurve 2824 switches (complete balls)
* Cisco SG300-10 (splits the interfaces between HA cluster members)
* Eaton 5PX 2200 UPS (with not enough runtime - watch this space)

_The Money Shot_

![The Money Shot][7]

As you saw above, i'm running some archaeology grade HP Procurves as my ToR switching - they're bog standard, noisy, old, L2 switches and need to die. :)

And how does all this look in vCenter?

![Homelab vCenter Screenshot][8]

The sad part being, most of it belongs in the management cluster:

![Homelab Management Cluster][9]

I'm sure I'll write another article/multiple on the set up, what way things are configured from an interop point of view and how it is run operationally - but this is about the hardware. That said, I should note that I do run the lab with DPM enabled so on the off chance it falls below N+1 it powers off the unnecessary hosts, which is helpful given the current usage at 240v for _half_ the kit looks like this:

![Observium UPS Graph][10]

## The Future

So what does the future hold for this home DC?

Well, no thanks to [Erik Bussink][11]'s latest [blog post][12] it refreshed my hunger for 10GbE switches in the lab, I had previously been eyeing up some Cisco 5548P, Mellanox SN series and even older Arista and Force10 switches - But the Nexus 3K Erik found seemed perfect.

So I picked up a [Nexus 3K 3064PQ][13] from a very helpful US Cisco reseller along with 2x 400W PSUs, some cables and N3K-LAN1k9 Layer 3 Enterprise networking services licenses along with a massive haul of Intel X520-DA1s I found [a killer deal on][14] to fully build out 10GbE in prep for VSAN and any other SDS goodness.

On the topic of futures, this thing chucks out a **lot** of heat, sound and every other sensory irritant known to man. So obviously, it is currently hosted in what was originally a room for a filing cabinet and some circuit breakers in the house with almost no ventilation or sound deadening.

It'll be moving into a dedicated room in a detached garage with air conditioning and given all my bitching about power, a [_slight upgrade to the UPS_][15] - plus some 4-core fiber cross connects to the house.

After that, who knows (I have some pie in the sky ideas), but hopefully whatever it is, it helps me learn and doesn't just benefit the power company (NIE, hook me up with 3-phase, kthxbai).

Why not follow [@mylesagray on Twitter][16] for more like this!

 [1]: https://twitter.com/vexpert_slack
 [2]: https://twitter.com/virtualhobbit
 [3]: https://virtualhobbit.com/2016/04/13/upping-my-homelab-game/
 [4]: https://www.reddit.com/r/homelab/comments/4ibw6s/time_to_buy_some_rails/d2wx15i
 [5]: https://www.novosco.com/cloud-solutions
 [6]: images/Homelabv1.png
 [7]: images/Homelab-Front.jpg
 [8]: images/Screen-Shot-2016-09-13-at-23.12.07.png
 [9]: images/Screen-Shot-2016-09-13-at-23.14.16.png
 [10]: images/Screen-Shot-2016-09-14-at-00.00.26.png
 [11]: https://twitter.com/ErikBussink
 [12]: http://bussink.ch/?p=1810
 [13]: http://www.cisco.com/c/en/us/support/switches/nexus-3064-switch/model.html
 [14]: http://www.ebay.co.uk/itm/381700918035
 [15]: http://www.apc.com/shop/uk/en/products/APC-Symmetra-LX-16kVA-Scalable-to-16kVA-N-1-Tower-220-230-240V-or-380-400-415V/P-SYA16K16I
 [16]: https://twitter.com/mylesagray
