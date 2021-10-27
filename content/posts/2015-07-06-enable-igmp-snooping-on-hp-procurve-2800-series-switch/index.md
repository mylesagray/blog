---
title: "Enable IGMP/IGMP Snooping on HP ProCurve 2800 series switch"
author: Myles Gray
date: 2015-07-06T16:57:52+01:00
type: posts
url: /command-line-fu/enable-igmp-snooping-on-hp-procurve-2800-series-switch
categories:
  - Infrastructure
ShowPostRelatedContent: false
disableShare: true
comments: false
hideMeta: true
ShowToc: false
---
While working on my VMware NSX implementation I wanted to operate the solution in `Multicast mode`, to do so we need `IGMP` support and addresses on the switches.

> The Internet Group Management Protocol (IGMP) is a communications protocol used by hosts and adjacent routers on IPv4 networks to establish multicast group memberships.

Enter the following in `configure` mode on the `VLAN`s you want `IGMP` enabled on:

    vlan 8
    ip address [enter.switch.ip.here]
    ip igmp high-priority-forward

Allow some time for queirier to converge, then to verify:

    sh ip igmp

Output:

    VLAN ID : 8
    VLAN Name : NSX
    Querier Address : 10.0.8.2
    
    Active Group Addresses Reports Queries Querier Access Port
    ---------------------- ------- ------- -------------------
    224.0.1.140            2       1       Trk4

And also:

    sh ip igmp [VLAN ID] config

Output:

Lab-2824-Top(config)# sh ip igmp 8 config

    IGMP Service
    
    VLAN ID : 8
    VLAN NAME    : NSX
    IGMP Enabled [No] : Yes
    Forward with High Priority [No] : Yes
    Querier Allowed [Yes] : Yes
    
    Port Type      | IP Mcast
    ---- --------- + --------
    3              | Auto
    4              | Auto
    5              | Auto
    6              | Auto
    7              | Auto
    8              | Auto
    9              | Auto
    10             | Auto
    11             | Auto
    12             | Auto
    13             | Auto
    14             | Auto
    15             | Auto
    16             | Auto
    17             | Auto
    18             | Auto
    19             | Auto
    20             | Auto
    21             | Auto
    22             | Auto
    23             | Auto
    24             | Auto
    Trk4           | Auto

Don't forget to `wr mem` to save your changes!

Reference: <http://ftp.hp.com/pub/networking/software/AdvTraff-Oct2005-59908853-Chap04-IGMP.pdf>
