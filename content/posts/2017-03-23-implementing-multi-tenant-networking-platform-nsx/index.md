---
title: Implementing a multi-tenant networking platform with NSX
author: Myles Gray
type: posts
date: 2017-03-23T18:38:57+00:00
lastmod: 2021-10-25T14:48:00+00:00
description: "How to implement a multi-tenant network using VMware NSX-V"
url: /networks/implementing-multi-tenant-networking-platform-nsx
aliases: [ "/networks/implementing-multi-tenant-networking-platform-nsx/amp", "/infrastructure/implementing-multi-tenant-networking-platform-nsx/", "/infrastructure/implementing-multi-tenant-networking-platform-nsx/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2017-03-21-at-21.29.14.webp
  alt: "OSPF discovered routes in routing table"
categories:
  - Infrastructure
  - Networks
  - Virtualisation
tags:
  - networking
  - nsx
  - VMware
series:
  - Multi-tenant IaaS Networking
course:
  - Multi-tenant IaaS Networking
---

So we have covered the typical challenges of a multi-tenant network and designed a solution to one of these, it's time to get down to the bones of it and do some configuration! Let's implement it in the lab, I have set up an NSX ESG `Cust_1-ESG` and an NSX DLR control VM `Cust_1-DLR` with the below IP configuration:

![DLR to ESG and customer IP networking][1]

I have also enabled OSPF as a NSSA (area 51) between the ESG and the DLR control VM and specified to redistribute `connected` routes attached to the DLR:

![DLR OSPF configuration][2]

Above you can see the `protocol address` is that of the DLR control VM interface and not the same as the `forwarding address` (kernel LIF) as we discussed earlier the need for a `/29` subnet. Below you can see the route redistribution configured on the DLR:

![DLR route redustribution][3]

On the ESG then, I have configured three interfaces:

* `Cust_1-DMZ` - an "Internal" interface to be completely firewalled from the DLR but still advertise a route
* `Cust_1-Transit` - an "Internal" transit interface/network towards the DLR
* `Cust_1-VRF` - an "Uplink" attached to a vDS Portgroup and such, a physical VLAN used as another transit interface towards the upstream routing.

![ESG Interfaces][4]

The ESG is configured with two OSPF areas, Area 51 - towards the DLR and Area 0 - towards the upstream routing as shown below:

![ESG OSPF configuration][5]

You can also see from the above I have enabled "Default Originate" which advertises a default route to its neighbour (in this case, the DLR), this means we don't need to add a static route to the DLR for default routing and keeps things cleaner.

Below you can see the route redistribution for the ESG is set to "connected" routes also, this is to ensure the DMZ network is advertised to neighbours.

![ESG route redistribution][6]

It is important to note here that as Area 51 (between the DLR and the ESG) is a NSSA type, that any routes it advertises will be re-advertised automatically into Area 0 (a "normal" area) by the ESG - this means they will be picked up by the upstream routing as well.

## Upstream Routing

The complete IP addressing and OSPF area configuration can be seen below:

![Entire IP network][7]

So now, to advertise routes into the physical network the `Cust_1-VRF` interface on the ESG is uplinked into a vDS Portgroup that is a physical transit VLAN into the customer VRF. In my case I have used `VLAN 2001` as my upstream SVI in `Cust_1`'s VRF on the router.

The following is how the customer VRF and OSPF instance were configured on my upstream router (a Cisco Nexus 3064PQ):

```sh
!Customer VLAN for OSPF and transit
vlan 2001
  name Customer_1-Transit-Default-GW

!VRF Config
vrf context customer_1
  description Customer_1 VRF

!SVI membership in VRF, OSPF config and VRRP config   
interface Vlan2001
  no shutdown
  vrf member customer_1
  ip address 192.168.200.1/30
  ip router ospf customer_1 area 0.0.0.0
  vrrpv3 1 address-family ipv4
    address 192.168.200.1 primary

!OSPF instance for the customer and push default route to ESG
router ospf customer_1
  vrf customer_1
    default-information originate always
```

Above we are configuring the VRF context for `customer_1`, creating a SVI from `VLAN 2001`, giving it an IP address of `192.168.200.1/30` (the other side of the ESG transit network), configuring an OSPF instance for that customer and then assigning it to `Area 0` in the SVI we just created.

We also configure a VRRP address for the SVI of `192.168.200.1` to allow for failover between the two routers should one fail.

The routes learned by the VRF via OSPF are automatically redistributed into my lab "faux-MPLS" as they would in a production environment via BGP and pushed throughout the core network to the physical Fortigate edge-firewalls used for gateway to the internet as it would be in a real MPLS network.

## Verification

### Demo

If you want the "ta-da networking" moment, I've made a quick video to prove the immediacy and usefulness of the exercise:

![Ta-da Networking!][8]

Some commentary on what is going on above:

* I have created a Logical Switch and added it to the `Cust_1-DLR` as an interface as you would for any subnet.
* I have disabled the interface on the DLR
* I kick off a ping from the physical edge-firewall (no echo)
* You can see the subnet doesn't show up in the routing table of the MPLS's physical edge-firewall
* I then enable the interface on the DLR and we check the routing table of the MPLS firewall
* The firewall is now aware - automatically, about the subnet addition I have just made in NSX
* Focus is moved back to the ping from the firewall to the new subnet, which is now responding

For reference here is all the components involved in this:

![Firewall location][9]

The edge-firewall lives in the red highlighted area above, on the side of the MPLS entirely owned by the service provider that we have no control over. We are then adding a logical switch inside the virtual infrastructure highlighted in blue and it is distributed right up to the network's edge - entirely automatically. Awesome.

### Manual Verification

Some manual verification/debugging can also be done to ensure that everything is working as we configured, to verify everything is working we can look at the routing table at each stage and check the routes present against what we expect. Firstly on the DLR:

![DLR routing table][10]

We can see that it is getting a default route as advertised via the ESG (with the `Default Information` setting enabled), as well as a route to the `10.10.10.0/24 - Cust_1-DMZ` network. There are two "connected" networks - as expected, the `Cust_1-Servers` network and the `Cust_1-Transit` network. We also get advertised the `192.168.200.0/30` network which is listed as OSPF inter-area as it lives inside the `Cust_1-VRF` network off the ESG inside OSPF `Area 0`. So all working as expected here.

On the ESG:

![ESG routing table][11]

The ESG is receiving its default route from the `default-information originate always` statement on the upstream router's OSPF config. There is a NSSA route for the `172.16.0.0/24 - Cust_1-Servers` which is advertised up from the DLR and there are three connected routes, for the `Cust_1-DMZ`, `Cust_1-Transit` and `Cust_1-VRF` networks as expected.

And on the upstream router:

```sh
sw3# sh ip route vrf customer_1

10.10.10.0/24, ubest/mbest: 1/0
    *via 192.168.200.2, Vlan2001, [110/0], 4d19h, ospf-customer_1, type-2
10.20.30.0/24, ubest/mbest: 1/0
    *via 192.168.200.2, Vlan2001, [110/1], 00:11:13, ospf-customer_1, type-2
172.16.0.0/24, ubest/mbest: 1/0
    *via 192.168.200.2, Vlan2001, [110/1], 4d19h, ospf-customer_1, type-2
192.168.0.0/29, ubest/mbest: 1/0
    *via 192.168.200.2, Vlan2001, [110/41], 4d19h, ospf-customer_1, inter
192.168.200.0/30, ubest/mbest: 1/0, attached
    *via 192.168.200.1, Vlan2001, [0/0], 6w5d, direct
192.168.200.1/32, ubest/mbest: 2/0, attached
    *via 192.168.200.1, Vlan2001, [0/0], 6w5d, local
    *via 192.168.200.1, Vlan2001, [0/0], 6w5d, vrrpv3
192.168.254.0/30, ubest/mbest: 1/0, attached
    *via 192.168.254.2, Vlan2002, [0/0], 08:12:21, direct
192.168.254.2/32, ubest/mbest: 1/0, attached
    *via 192.168.254.2, Vlan2002, [0/0], 08:12:21, local
```

Above we can see that we are receiving routes from the ESG for the `Cust_1-DMZ`, `Cust_1-Servers`, `Cust_1-Test` (behind the DLR) and `Cust_1-Transit` networks and that `Cust_1-VRF` is directly connected. Proving that our routes are being pushed up from the DLR on the hosts into the physical network's routing table for that customer's VRF.

That's it, we can now trivially add Logical Switches to the customer DLR or ESG and have the rest of the MPLS network know about them automatically as demoed above!

This naturally leads us on to some very interesting possibilities for failover, workload portability between datacenters and other such things that I'll be writing about and demoing soon.

Thanks for taking the time to read!

Why not follow [@mylesagray on Twitter][12] for more like this!

 [1]: images/image-1-1.png
 [2]: images/Screen-Shot-2017-03-21-at-20.11.41.png
 [3]: images/Screen-Shot-2017-03-21-at-20.14.05.png
 [4]: images/Screen-Shot-2017-03-21-at-20.27.39.png
 [5]: images/Screen-Shot-2017-03-21-at-20.29.55.png
 [6]: images/Screen-Shot-2017-03-21-at-20.32.11.png
 [7]: images/image.png
 [8]: images/Ta-Da-Networking.gif
 [9]: images/Whole-network-distribution.png
 [10]: images/Screen-Shot-2017-03-21-at-21.28.57.png
 [11]: images/Screen-Shot-2017-03-21-at-21.29.14.png
 [12]: https://twitter.com/mylesagray
