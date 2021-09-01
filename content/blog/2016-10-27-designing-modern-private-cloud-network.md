---
title: Designing a modern multi-tenant DC network
author: Myles Gray
type: post
date: 2016-10-27T12:00:36+00:00
url: /architecture/designing-modern-private-cloud-network/
cover:
  image: /uploads/2016/10/DC-Network-BGP-AS-Leaf-Spine.png
wp-to-buffer-pro:
  - 'a:8:{s:14:"featured_image";s:0:"";s:8:"override";s:1:"0";s:7:"default";a:2:{s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:27:"Updated Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d5b716368246123c6ae8";a:4:{s:7:"enabled";s:1:"1";s:8:"override";s:1:"1";s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:32:"New Post: {title} {url} #vExpert";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d71510133aa22a5e5d6a";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d761163682ce153c6ae4";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d77316368280153c6ae4";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57fa3b89b069516f3f8b456d";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:9:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}}'
categories:
  - Architecture
  - Featured
  - Infrastructure
  - Networks
tags:
  - datacenter
  - l2 over l3
  - networking
  - vxlan
series:
  - Multi-tenant IaaS Networking

---
Over the last 12 months my posting has been dialled back, this isn't for lack of wanting or ideas, mainly a lack of time and mental bandwidth. Reason being, I have been designing and implementing a new cloud platform (namely &#8220;STC&#8221;<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_1');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_1');" ><sup id="footnote_plugin_tooltip_1939_88_1" class="footnote_plugin_tooltip_text">1</sup></a><span id="footnote_plugin_tooltip_text_1939_88_1" class="footnote_tooltip"><a href="https://www.novosco.com/cloud-solutions/single-tenant-cloud"><span class="footnote_url_wrap">https://www.novosco.com/cloud-solutions/single-tenant-cloud</span></a></span></span>) for my employer, Novosco - as with any new service or product this requires an element of discretion - but now is the time to let slip some of the detail on what makes the service tick!

Boilerplate caveat: any views or opinions expressed in this post or on this blog in general are my own and not that of my employer.

<!--more-->

# Requirement

Back when this project kicked off the brief was &#8220;make something scale-out, with dedicated kit per tenant in which they can manage their own virtualisation environment as if it were on-prem, BYO Licensing, BYO Backup, BYO Disaster Recovery&#8221;.

_We like the idea of Bring Your Own X for this product_

<p align="center">
  <img src="http://i.imgur.com/ny7qxSN.jpg" />
</p>

So, scale out, but dedicated hardware per tenant and we have to be able to spin these up at will, without much lead time and allow them to manage everything on their environment.

# Initial Thoughts

The obvious solution for this kind of request is to go the whole &#8220;SDDC&#8221; road; SDS, SDN, the works, but then commercially it becomes ridiculous, plus SDN tech like NSX doesn't allow for vmkernel traffic to be encapsulated, not that this is a blocker but, it doesn't help - so maybe we can meet halfway?

If we have a SDS stack; ScaleIO, SpringPath, VSAN, &#8230;Maxta - just some hyperconverged node style SDS solution with a more traditional networking stack - could it be commercially viable and yet still meet the requirements we set out with?

Problems are obviously going to rear their heads when you have a dedicated compute environment that allows the ability to install BYO-anything on said environment, the focus very quickly becomes the shared components - in this case, networking.

I will go into the physical topology in another article as well as the decisions and math that led to it, just know that it is a 10/40GbE Spine and Leaf design with redundant ToR switching that is shared between customer environments.

# Engineering

Generally when people want to separate customers that use the same networking kit; VLANs are the first port of call - but as a wise man once told me:

> Friends don't let friends build large L2 networks

This is easy to say, but **_why_**?

## The L2 Problem

A few reasons, large L2 is certainly do-able, and a great many SPs do maintain and manage large L2 networks, so what's the problem?

### Loops

Looping and L2 networking are inseparable, there is always a pub argument to be had. Where multiple links to the same devices cause continuous looping of BUM (Broadcast, Unknown Unicast, Multicast) traffic.

There are of course remedies to this, MC-LAG, Bonding, Spanning Tree in any flavour will kill off the problems with looping on a multi-link switch to switch level - these of course come with their own limitations; link utilisation and load balancing being primary of which, with link aggregation of all flavours being more band-aid type solutions than &#8220;solving the L2 problem&#8221; - after all, you still need spanning tree even if you bond all your links to stop topological loops, and you still only have 4096 VLANs.

You can get into some pretty ugly config when you spin up a STP instance per VLAN (a-la MST/PVST) or you have a single instance and just lose half your bandwidth (or more).

But&#8230; What if the looping device only has a single link and doesn't participate in spanning tree?

That's right, you can have a loop on an STP enabled network from a device with only a single NIC. VMware's vSwitching (both standard and distributed) are cases of such, or at least with VMs configured incorrectly they can be.

Read this KB<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_2');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_2');" ><sup id="footnote_plugin_tooltip_1939_88_2" class="footnote_plugin_tooltip_text">2</sup></a><span id="footnote_plugin_tooltip_text_1939_88_2" class="footnote_tooltip"><a href="https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2017193&src=vmw_so_vex_mgray_1080"><span class="footnote_url_wrap">https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2017193&src=vmw_so_vex_mgray_1080</span></a></span></span> - it is the harbinger of doom when it comes to L2 scenarios you never want to encounter.

Engineering around a situation like this is extremely difficult - it largely becomes T&Cs and user education. That is not to say it cannot be mitigated at least to a degree. Ivan at IPSpace<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_3');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_3');" ><sup id="footnote_plugin_tooltip_1939_88_3" class="footnote_plugin_tooltip_text">3</sup></a><span id="footnote_plugin_tooltip_text_1939_88_3" class="footnote_tooltip"><a href="http://blog.ipspace.net/2012/09/dear-vmware-bpdu-filter-bpdu-guard.html"><span class="footnote_url_wrap">http://blog.ipspace.net/2012/09/dear-vmware-bpdu-filter-bpdu-guard.html</span></a></span></span> makes some very good arguments with reference to VMware's BPDU position and vSwitch implementation that will further help you understand the problem should you not see it so far (he has diagrams!).

I would also highly recommends his webinars on DC networking topologies<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_4');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_4');" ><sup id="footnote_plugin_tooltip_1939_88_4" class="footnote_plugin_tooltip_text">4</sup></a><span id="footnote_plugin_tooltip_text_1939_88_4" class="footnote_tooltip"><a href="http://www.ipspace.net/Data_Center_Fabrics"><span class="footnote_url_wrap">http://www.ipspace.net/Data_Center_Fabrics</span></a></span></span> and Brad Hedlund's articles<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_5');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_5');" ><sup id="footnote_plugin_tooltip_1939_88_5" class="footnote_plugin_tooltip_text">5</sup></a><span id="footnote_plugin_tooltip_text_1939_88_5" class="footnote_tooltip"><a href="http://bradhedlund.com/2012/01/25/construct-a-leaf-spine-design-with-40g-or-10g-an-observation-in-scaling-the-fabric/"><span class="footnote_url_wrap">http://bradhedlund.com/2012/01/25/construct-a-leaf-spine-design-with-40g-or-10g-an-observation-in-scaling-the-fabric/</span></a></span></span> on this topic if you're interested in the engineering behind them.

Forged transmits, port security, BDPU filter and BPDU guard can all be used to mitigate these _to a degree_ for your specific scenario but won't stop the loops - the KB does a good job in dealing with these cases, as a service provider it is hard to determine if any of these cases are true unless you have visibility over the workloads operating on the environment, we do, thankfully - however, if you don't there are behaviours and conditions you can view as &#8220;acceptable risks&#8221; should someone not follow the ToS.

  * What is the maximum speed/pps my link can loop at (the link to the host's speed)?
  * What traffic volume can my spine uplinks/switch take?
  * Is it acceptable that if the customer violates Terms of Use that their environment is &#8220;DoS'd&#8221; by BPDU Guard on the switches?
  * Is it acceptable to request in the user manual if a customer wants to deploy an SSL-VPN appliance on the service they should contact the SP first for guidance?

In some cases it may be acceptable to the SP that when a customer violates the ToS their environment stability is at risk **as long as it does not affect other customers using the shared components**. Your position is entirely up to you but a combination of the above usually makes a good compromise.

### Link Utilisation

Second to looping, there is link utilisation, which actually is where a lot of the solutions to looping actually lie. It also happens to be where most vendors have their secret-sauce flavour of link aggregation (Dell - VLT, Brocade - VCS, Cisco - FabricPath), there is of course an open standard for this, TRILL operates at layer 2/3<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_6');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_6');" ><sup id="footnote_plugin_tooltip_1939_88_6" class="footnote_plugin_tooltip_text">6</sup></a><span id="footnote_plugin_tooltip_text_1939_88_6" class="footnote_tooltip"><a href="http://www.cisco.com/c/en/us/about/press/internet-protocol-journal/back-issues/table-contents-53/143-trill.html"><span class="footnote_url_wrap">http://www.cisco.com/c/en/us/about/press/internet-protocol-journal/back-issues/table-contents-53/143-trill.html</span></a></span></span> using a modified link-state routing protocol (IS-IS), but as of yet there is limited vendor support.

These all solve a Layer 2 problem, but with the caveat of proprietary tech, increased expense and eventually redundancy when an open standard takes over.

So, with that in mind, why use a large L2 &#8220;fabric&#8221; for your datacenter network - especially given it is a band-aide making Ethernet do things it was never meant to?

### Limitations on Scale

We all know there is a VLAN limit of 4096, to most this might not seem like much of a limit and generally it isn't - but when you are dealing with multi-tenancy and separation on a per-tenant level where they may have an allocation of 30-50 VLANs each, that has to do transit links, LANs, DMZs, storage, interconnects - it doesn't add up to much when building out a scalable datacenter.

### Operational Risk

A result of all the above, particularly loops is the risk involved from an operational standpoint - in a large scale L2 network there is always risk involved, Murphy's law and all that. You just need a switch that is not participating in STP, or indeed one with the wrong bridge ID to case a world of pain - granted you can say that about almost any switching environment, but L2 problems tend to be quite catastrophic.

## Solving the L2 problem with L3

You know what solves all of the above? Layer 3 - no loops (let's ignore routing loops for now), fully utilised links from point to point when using a routed core with OSPF/BGP and ECMP selection with 5-tuple hashing for traffic distribution.

However, L2 adjacency is handy sometimes; like when you have a single tenant's compute cluster split across racks (remember, L3 routed Spine/Leaf). We start off with a DC looking like this, but we get an order for 3 new nodes - normally we would have to waste the space left in `Rack 1` to provide L2 adjacency when there is a L3 boundary between racks:

![DC Networking Single Rack][1] 

If this is the case the L2 networks need to be accessible in both racks, if you vMotion a VM from one to another or DRS does it, it still needs to be contactable by all other VMs in that broadcast domain.

So is there a way to get all the benefits as a service provider from a big L3 routed core network, with the ability to fully utilise all our links and have no loops - but still provide L2 adjacency and segregation to tenants across racks?

### L2 over L3

![DC Networking Overlay][2] 

Sure, let's provide L2 over L3, there is a lot of tech out there to skin this particularly unlucky cat, most in use by telcos providing services like VPLS (typically using pseudo-wire tech AToM, GRE, L2TPv3) but sticking with a purely datacenter context the common options are VXLAN and EVPN.

Overlays allow us to do some very cool stuff, take the instance above where we have an L3 boundary between racks, but we have a customer that wants to come on with 3 nodes, to do this across racks, we need to provide L2 adjacency to the customer LAN networks to allow the VMs to move around easily - if we encapsulate the L2 traffic and route it across the L3 core we can decapsulate the packet on the destination ToR switch and the L2 traffic will continue as if it were in the same rack as below.

![DC Network two racks][3] 

This of course can scale across multiple racks, as it is point to multi-point technology, allowing for us to stretch a given L2 network across a &#8220;limitless&#8221; number of racks, so we can mix and match customer nodes anywhere within the datacenter:

![DC Network multiple racks][4] 

#### #TechnologyShowdown

So we want a L2 P2MP tech, to start off with eVPN - pioneered by Juniper, uses MP-BGP for control plane traffic as well as MAC and IP locality/distribution for an overlay technology (typically MPLS, PBB, VXLAN) - there are also multiple IETF RFC drafts for this standard, however the limited vendor support (Cisco and Juniper at the time) as well as lack of DC-rack class switches that these features are available on killed this tech off for the requirement.

VXLAN is an L2 encapsulation technology that will route packets over a standard L3 core network using UDP (with a larger MTU to allow for encap - typically 1600 bytes). VXLAN, has an official IETF RFC<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_7');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_7');" ><sup id="footnote_plugin_tooltip_1939_88_7" class="footnote_plugin_tooltip_text">7</sup></a><span id="footnote_plugin_tooltip_text_1939_88_7" class="footnote_tooltip"><a href="https://tools.ietf.org/html/rfc7348"><span class="footnote_url_wrap">https://tools.ietf.org/html/rfc7348</span></a></span></span> and has been implemented by multiple vendors (VMware, Arista, Cisco, Cumulus on switches with T2/T2+ chipsets, with many more coming like Mellanox and Dell) and very much seems to be the dominant choice for DC networking and such, was the logical choice.

It's worth noting that VXLAN doesn't have a discrete control plane - rather it can use an external controller or flood + learn.

Some networking vendors will only provide VXLAN tunnels if you have an external SDN-style controller, like Big Switch Networks, Dell and Cumulus. Generally this is not a problem when you have a single tenant infrastructure, you could use NSX-MH, BSN or an array of other controllers to provide intelligence about MAC locality and physical/host based VTEP endpoints.

This is not the case in a shared multi-tenant network because different vSphere environments means multiple integration points for MAC awareness and tunnel endpoints for any SDN controller. This feature was not provided by any networking vendor at the time in a _commercially and operationally viable_ form.

So we had found another requirement, we couldn't use a centralised controller at least none in their current forms but still needed P2MP.

Cumulus was ruled out at this stage due to a VXLAN tunnel down behaviour on loss of a single ToR switch when using MLAG<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_8');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_8');" ><sup id="footnote_plugin_tooltip_1939_88_8" class="footnote_plugin_tooltip_text">8</sup></a><span id="footnote_plugin_tooltip_text_1939_88_8" class="footnote_tooltip"><a href="https://docs.cumulusnetworks.com/display/DOCS/LNV+VXLAN+Active-Active+Mode"><span class="footnote_url_wrap">https://docs.cumulusnetworks.com/display/DOCS/LNV+VXLAN+Active-Active+Mode</span></a></span></span>. This was apparently to stop traffic blackholing, being linux based, it is tricky I'm told to view status of individual links within a bond reliably.

Dell was also ruled out as while the DNOS (Force 10) switches at the time had a `feature vxlan` they didn't allow for tunnels to be created via CLI, only controller based i.e. NSX - however, we have been told by our rep that this is no longer the case in DNOS 9.11 and arbitrary tunnels are now supported.

So that really only left Cisco and Arista - at the time Cisco only supported VXLAN on the 7k and 9k series switches, which didn't lend themselves to Spine and Leaf (now of course they have the Nexus 5600) and the cost was prohibitive as well as some multicast routing performance challenges ruled out Cisco.

Thus, we arrived at Arista who allow for all of the above (they support CLI based flood + learn for MAC addresses and BUM traffic suppression) and have a good external controller story should we choose to move that direction in future - I've also been informed by our SE they now support L2 and L3 eVPN as a control plane for VXLAN.

The switches chosen were `48x 10GbE, 6x 40GbE` for the leaf nodes and `32x 40GbE` for the spine - I will get into link scaling in another article as stated above.

### Providing an L3 core

We had our chosen overlay tech and vendor, what about the L3 core?

Typically in a spine and leaf you run a dynamic routing protocol like OSPF or BGP to distribute routes for all node interfaces to each other (VTEPs, loopbacks and P2P links for the spine/leaf fabric).

In this case, it was designed such that there was an AS per rack as well as a spine AS that all rack ASes peered with. This was chosen over a single AS for all leafs and spine as you can have instances in which traffic is dropped when a particular combination of links have an outage due to the default behaviour of BGP to prevent routing loops.

This can be overcome with `allowas-in` but it is more standard and safer to simply use a different ASN for each rack.

Like most things this is best described with a diagram or two, below you can see two ASNs, one for all leafs and one for the spine - the combination of link outages below would result in the traffic being unroutable due to BGP's built-in loop prevention methods:

![BGP Network with single ASN for Leafs and Spine][5] 

However, if we operate the network with an ASN per rack and an ASN for the spine we can see that the traffic can still be routed as there is no problem with the advertisement containing the same ASN as the one it is being advertised to:

![BGP Network with ASN per Leaf and Spine][6] 

`iBGP` was used to distribute the loopback and P2P interfaces to the other node at ToR as well provide redundancy should a leaf lose both uplinks to the spine and `eBGP` was used for the spine to distribute the routes learned from rack ASes to all other peered rack ASes - This provided VTEP visibility for all racks to each other as well as multiple routes to each destination which were then used for load distribution via ECMP.

The VTEP awareness across racks allowed for the creation of VLAN to VNI mappings that could traverse the spine.

It's a given that to improve link utilisation you want a decent hashing algorithm for distribution of traffic, ECMP on Trident2 chipset based switches is by default 5-tuple (`src + dest IP`, `protocol`, `src + dest port`) - you will however need to enable explicitly multi-path BGP with:

    maximum-paths [paths] ecmp [max ecmp paths per route to store in table]
    

### Routing

So now we have an L3 core, we have L2 adjacency across racks - what about routing?

There is an interesting constraint with the Trident2 chipset - you can't route between VLANs that exist on a VNI segment<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_9');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_9');" ><sup id="footnote_plugin_tooltip_1939_88_9" class="footnote_plugin_tooltip_text">9</sup></a><span id="footnote_plugin_tooltip_text_1939_88_9" class="footnote_tooltip"><a href="http://blog.ipspace.net/2014/06/trident-2-chipset-and-nexus-9500.html"><span class="footnote_url_wrap">http://blog.ipspace.net/2014/06/trident-2-chipset-and-nexus-9500.html</span></a> </span></span> because it would require recirculation back into the chipset after decapsulation (how Arista achieves this with the T2) or a separate chipset specifically to route between VNI segments (Cisco Nexus).

This was actually quite easy to solve - VLANs are stretched up to a pair of routers that come off the edge-leaf and provide all inter-VLAN routing and N/S traffic. Almost all of our customer traffic is E/W within the same VLAN and the traffic that was inter-VLAN is typically between DMZ/LAN and done on-host by a virtual firewall - anything else would traverse the links to the edge-leaf rack.

![Datacenter Networking N/S Routing][7] 

If a customer wished to use NSX however then routing could be done on the DLR within the hosts and save on traffic hairpinning as well as provide the value-added services from NSX.

This can also be achieved through the use of anycast gateway with VRFs on Arista switching where routing decisions are made at a ToR level, keeping the traffic within the rack so inter-VLAN routing does not have to traverse the spine or go to a centralised routing point as above. This has some obvious benefits, there are operational overheads involved here as well and at the time was not available from our chosen vendor that met all other requirements so we settled for the centralised routing option.

There is an excellent article on routing between VXLAN segments with MLAG and anycast gateway by Arista's technical team here<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_10');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_10');" ><sup id="footnote_plugin_tooltip_1939_88_10" class="footnote_plugin_tooltip_text">10</sup></a><span id="footnote_plugin_tooltip_text_1939_88_10" class="footnote_tooltip"><a href="https://eos.arista.com/vxlan-routing-with-mlag/"><span class="footnote_url_wrap">https://eos.arista.com/vxlan-routing-with-mlag/</span></a></span></span>. I will include one diagram from the article however:

![Arista vVTEP and Anycast Gateway][8] 

This shows the SVIs at the top of rack with the same IP, providing local routing decisions (as well as remote routing, done on the source ToR switch then sent over VXLAN) and vVTEPs for ARP suppression as well as broadcasts in large topologies. The article above is incredible and I highly recommend you read it if you want a good, in depth look at the exact packet flow in an environment like this.

# Wrapping Up

So, after all that - you can see there is a lot to learn when it comes to DC networking, especially ones at scale with L3 involved, but that is not to say they are hard to maintain or operate.

Keep an eye out for articles in the near future on the maths behind why the particular switches were chosen and eventually ESXi networking config for VSAN over the encapsulated physical network.

Big thanks to Novosco<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_11');" onkeypress="footnote_moveToReference_1939_88('footnote_plugin_reference_1939_88_11');" ><sup id="footnote_plugin_tooltip_1939_88_11" class="footnote_plugin_tooltip_text">11</sup></a><span id="footnote_plugin_tooltip_text_1939_88_11" class="footnote_tooltip"><a href="http://twitter.com/novosco"><span class="footnote_url_wrap">http://twitter.com/novosco</span></a></span></span> for allowing me to publish this article in as much detail as I have and for giving me the opportunity to architect such a solution, I couldn't have done it without the help and input of the rest of the Hosted Platforms team as well as the broader Novosco team!

Why not follow [@mylesagray on Twitter][9] for more like this!

<div class="speaker-mute footnotes_reference_container">
  <div class="footnote_container_prepare">
    <p>
      <span role="button" tabindex="0" class="footnote_reference_container_label pointer" onclick="footnote_expand_collapse_reference_container_1939_88();">References</span><span role="button" tabindex="0" class="footnote_reference_container_collapse_button" style="display: none;" onclick="footnote_expand_collapse_reference_container_1939_88();">[<a id="footnote_reference_container_collapse_button_1939_88">+</a>]</span>
    </p>
  </div>
  
  <div id="footnote_references_container_1939_88" style="">
    <table class="footnotes_table footnote-reference-container">
      <caption class="accessibility">References</caption> <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_1');">
          <a id="footnote_plugin_reference_1939_88_1" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>1</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://www.novosco.com/cloud-solutions/single-tenant-cloud"><span class="footnote_url_wrap">https://www.novosco.com/cloud-solutions/single-tenant-cloud</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_2');">
          <a id="footnote_plugin_reference_1939_88_2" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>2</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2017193&src=vmw_so_vex_mgray_1080"><span class="footnote_url_wrap">https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2017193&src=vmw_so_vex_mgray_1080</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_3');">
          <a id="footnote_plugin_reference_1939_88_3" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>3</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://blog.ipspace.net/2012/09/dear-vmware-bpdu-filter-bpdu-guard.html"><span class="footnote_url_wrap">http://blog.ipspace.net/2012/09/dear-vmware-bpdu-filter-bpdu-guard.html</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_4');">
          <a id="footnote_plugin_reference_1939_88_4" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>4</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://www.ipspace.net/Data_Center_Fabrics"><span class="footnote_url_wrap">http://www.ipspace.net/Data_Center_Fabrics</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_5');">
          <a id="footnote_plugin_reference_1939_88_5" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>5</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://bradhedlund.com/2012/01/25/construct-a-leaf-spine-design-with-40g-or-10g-an-observation-in-scaling-the-fabric/"><span class="footnote_url_wrap">http://bradhedlund.com/2012/01/25/construct-a-leaf-spine-design-with-40g-or-10g-an-observation-in-scaling-the-fabric/</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_6');">
          <a id="footnote_plugin_reference_1939_88_6" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>6</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://www.cisco.com/c/en/us/about/press/internet-protocol-journal/back-issues/table-contents-53/143-trill.html"><span class="footnote_url_wrap">http://www.cisco.com/c/en/us/about/press/internet-protocol-journal/back-issues/table-contents-53/143-trill.html</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_7');">
          <a id="footnote_plugin_reference_1939_88_7" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>7</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://tools.ietf.org/html/rfc7348"><span class="footnote_url_wrap">https://tools.ietf.org/html/rfc7348</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_8');">
          <a id="footnote_plugin_reference_1939_88_8" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>8</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://docs.cumulusnetworks.com/display/DOCS/LNV+VXLAN+Active-Active+Mode"><span class="footnote_url_wrap">https://docs.cumulusnetworks.com/display/DOCS/LNV+VXLAN+Active-Active+Mode</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_9');">
          <a id="footnote_plugin_reference_1939_88_9" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>9</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://blog.ipspace.net/2014/06/trident-2-chipset-and-nexus-9500.html"><span class="footnote_url_wrap">http://blog.ipspace.net/2014/06/trident-2-chipset-and-nexus-9500.html</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_10');">
          <a id="footnote_plugin_reference_1939_88_10" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>10</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://eos.arista.com/vxlan-routing-with-mlag/"><span class="footnote_url_wrap">https://eos.arista.com/vxlan-routing-with-mlag/</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_1939_88('footnote_plugin_tooltip_1939_88_11');">
          <a id="footnote_plugin_reference_1939_88_11" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>11</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://twitter.com/novosco"><span class="footnote_url_wrap">http://twitter.com/novosco</span></a>
        </td>
      </tr>
    </table>
  </div>
</div>

 [1]: /uploads/2016/10/DC-Network-Scale-Out-1-Rack.png
 [2]: /uploads/2016/10/DC-Network-Overlay.png
 [3]: /uploads/2016/10/DC-Network-Scale-Out-2-Racks.png
 [4]: /uploads/2016/10/DC-Network-Scale-Out-3-Racks.png
 [5]: /uploads/2016/10/DC-Network-BGP-AS-Leaf-Spine.png
 [6]: /uploads/2016/10/DC-Network-BGP-AS-Per-Leaf.png
 [7]: /uploads/2016/10/DC-BGP-Network-NS-Routing.png
 [8]: /uploads/2016/10/AristavVTEPAnycast.png
 [9]: https://twitter.com/mylesagray