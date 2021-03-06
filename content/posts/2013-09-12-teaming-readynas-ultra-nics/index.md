---
title: Teaming ReadyNAS Ultra NICs
author: Myles Gray
type: posts
date: 2013-09-12T21:53:46+00:00
url: /hardware/teaming-readynas-ultra-nics
aliases: [ "/hardware/teaming-readynas-ultra-nics/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2013-09-12-at-22.39.webp
  alt: "ReadyNAS Ultra NIC bonding configuration"
categories:
  - Hardware
  - Networks
tags:
  - bonding
  - jumbo frame
  - nic
  - readynas
  - teaming
---

## Introduction

Netgear for some reason believe that ReadyNAS models that aren't the "Pro" line don't require network teaming across both their ethernet ports, so you have 2 network ports on your NAS, you've got your jumbo frames on and you want to configure load balancing/failover via the 2 interfaces.

Of course the ReadyNAS is based on Debian linux, you could SSH into the box and use `/etc/network/interfaces` to configure a networking bond using: `mode=balance-rr` or using aggregated link spec `802.3ad` if you have a switch that supports it: `mode=802.3ad`.

However, Netgear also think it is a good idea to "bork" your install on reboot if you mess with your networking in such a way even though it's a standard Linux package and kernel. 

## Enabling NIC Teaming

As such the best way I have found to achieve what we are after on the non-pro models is to simply [use an addon][1].

It is meant to be for the Pioneer models but works fine on my Ultra-6, wish i'd have found this sooner and not spent so much time trying to do it natively!

Configuring is simple, download go to your NAS's `admin page -> add-ons -> add new`, upload & verify the addon:

![Teaming for Pioneer - Upload and Verify][2]

Goto `add-ons -> installed` and enable Teaming for Pioneer, Choose your teaming method, I am running mine in round-robin at the moment with jumbo frames enabled:

![Enable Add-On and select method][3]

## Verification

Check it all worked in your `Network -> Interfaces` section - It should display Ethernet 1+2 at the top and the link as 2Gbit:

![2Gb redundant connections][4]

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: http://www.readynas.com/contributed/super-poussin/PRO-Team_2.1.bin
 [2]: images/Screen-Shot-2014-02-20-at-00.00.16.png
 [3]: images/Screen-Shot-2013-09-12-at-22.39.17.png
 [4]: images/Screen-Shot-2013-09-12-at-22.39.png
 [5]: https://twitter.com/mylesagray