---
title: Deployment Options for vCenter Server Appliance 6.0
author: Myles Gray
type: posts
date: 2015-02-03T10:09:28+00:00
lastmod: 2021-10-25T11:17:00+00:00
description: "Exploring the various deployment options for vCenter Server Appliance 6.0"
url: /virtualisation/deployment-options-vcenter-server-appliance-6-0
aliases: ["/virtualisation/deployment-options-vcenter-server-appliance-6-0", "/virtualisation/deployment-options-vcenter-server-appliance-6-0/amp", "/software/deployment-options-vcenter-server-appliance-6-0", "/software/deployment-options-vcenter-server-appliance-6-0/amp"]
draft: true
cover:
  relative: true
  image: images/Screen-Shot-2014-07-02-at-20.49.47.webp
  alt: "vCenter PSC architecture"
  hidden: true
categories:
  - Virtualisation
  - Infrastructure
tags:
  - esxi
  - vcenter
  - vcsa
  - vSphere
---

The new version of vSphere brings some major improvements to the vCenter management end of things, the main thing is that it is now a highly available solution (previously reserved for vCenter Server Heartbeat - a separate, now EOL, product VMware offered) that can run in two modes.

1) vCenter Server with embedded platform services controller

    ![vCenter Server with embedded platform services controller][1]

2) vCenter Server with external platform services controller

    ![vCenter Server with external platform services controller][2]

The former runs an platform services controller and a vCenter server on a single VM/Host, the latter runs a vCenter server in a separate node (VM/Host) from the platform services controller, which are abstracted from the vCenter server the platform services controller can then control multiple vCenter server nodes. In any case you must have at least two platform services controllers in order to provide HA, to quote VMware here:

> If you have more than one platform services controller, you can set up the controllers to replicate data with each other all the time, so that the data from each platform services controller is shared with every product. You can of course run in a hybrid config with some embedded infrastructure nodes and some external infrastructure nodes:

![mixed environment][3]

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: images/Screen-Shot-2014-07-02-at-20.26.57.png
 [2]: images/Screen-Shot-2014-07-02-at-20.27.03.png
 [3]: images/Screen-Shot-2014-07-02-at-20.49.47.png
 [4]: https://twitter.com/mylesagray
