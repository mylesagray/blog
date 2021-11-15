---
title: vSphere 6.5 Host Resources Deep Dive
author: Myles Gray
type: posts
date: 2017-06-21T12:21:56+00:00
url: /hardware/vsphere-6-5-host-resources-deep-dive
aliases: [ "/hardware/vsphere-6-5-host-resources-deep-dive/amp" ]
cover:
  relative: true
  image: images/Host-Resource-Deep-Dive-cover.webp
  hidden: true
categories:
  - Hardware
  - Infrastructure
  - Networks
  - Storage
tags:
  - book
  - design
  - hardware
  - vSphere
---

Over the last 6-9 months, I have been reviewing the vast majority of a new book just released to print by [Frank Denneman][1] and [Niels Hagoort][2] - The [vSphere 6.5 Host Resources Deep Dive][3].

![vSphere 6.5 Host Resource Deep Dive][4]

This book is, without a doubt, the most in-depth look at host design I have ever read, we are not talking about standard best practices here, though those are in there too. More, low-level understanding of _why_ best practices exist and even challenging some existing perceptions and paradigms about why technologies should be used and more importantly, how they should be utilised.

The blurb from the book does speak for itself, and I have to tell you - I learned a **lot** reading this book - about how CPUs work, QPI speeds, high/low core count procs, non-local memory access, right down to on-die cache snooping protocols. How storage protocols, drivers and busses work as well as the vmkernel level tuning of all four components of host resourcing.

> This book explains the concepts and mechanisms behind the physical resource components and the VMkernel resource schedulers, which enables you to:
>
> * Optimize your workload for current and future Non-Uniform MemoryAccess (NUMA) systems.
> * Discover how vSphere Balanced Power Management takes advantage of the CPU Turbo Boost functionality, and why High Performance does not.
> * How the 3-DIMMs per Channel configuration results in a 10-20% performance drop.
> * How TLB works and why it is bad to disable large pages in virtualized environments.
> * Why 3D XPoint is perfect for the vSAN caching tier.
> * What queues are and where they live inside the end-to-end storage data paths.
> * Tune VMkernel components to optimize performance for VXLAN network traffic and NFV environments.
> * Why Intel's Data Plane Development Kit significantly boosts packet processing performance.

This book is a bit of a monster. It comes in at almost 600 pages and it is going to take you a while to absorb all of its content - but it does convey the information clearly in a logical manner that can be easily understood, and that's what you want from highly technical content like this. The diagrams are excellent and easy to follow - the guys have outdone themselves here, and complex concepts or topics are broken down into easy to manage sections.

So get out there and buy it, I cannot recommend it enough, buy some for your team - whatever, just go forth, and _learn_!

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: https://twitter.com/frankdenneman
 [2]: https://twitter.com/NHagoort
 [3]: https://www.amazon.co.uk/dp/1540873064/ref=cm_sw_r_tw_asp_CbUGN.65HJTN9
 [4]: images/Host-Resource-Deep-Dive-cover.png
 [5]: https://twitter.com/mylesagray
