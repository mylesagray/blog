---
title: Setting Up Multi-NIC vMotion in vSphere 5.5
author: Myles Gray
type: posts
date: 2014-06-07T15:11:45+00:00
url: /hardware/setting-multi-nic-vmotion-vsphere-5-5
aliases: [ "/hardware/setting-multi-nic-vmotion-vsphere-5-5/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2014-06-07-at-16.14.14.webp
categories:
  - Hardware
  - Infrastructure
  - Networks
tags:
  - esxi
  - iscsi
  - san
  - vmotion
  - VMware
  - vSphere
---

Multi-NIC vMotion is a no-brainer [configuration for performance][1]:

* Faster maintenance mode operations
* Better DRS load balance operations
* Overall reduction in lead time of a manual vMotion process.

It was [introduced in vSphere 5.0][2] and has improved in v5.5 - so let's get into how to configure it (we'll be using the vSphere Web Client because that's what VMWare wants us to do nowadays...).

> I don't have an Enterprise Plus license so no Distributed Switches for me - however, if you do have Distributed Switching licenses you should be able to extrapolate from my Standard Switching how to config yours

First, log in and navigate to your first host `Manage -> Networking -> VMKernel Adapters` (I already have an existing vMotion vmk adapter - we will reuse this to create our first vMotion NIC):

![VMKernel adapter][3]

Create the new VMkernel Network Adapter:

![Create VMkernel Adapter][4]

Add your vMotion VLAN, label and check the vMotion box:

![vMotion setup][5]

Enter your IP settings and finish the operation.

**Don't forget** - if you are using jumbo frames to edit the VMkernel adapter just created and set the `MTU` to `9000`.

![MTU 9000][6]

I like to also go back into the vSwitches section and rename the first vmk port group to `vMotion-1` for posterity.

You can of course repeat this procedure across as many NICs as VMWare supports for your pNIC, with 1Gb and 10Gb you can utilise up to 16 and 4 NICs respectively.

**Note:** if you use a 1Gb NIC in your vMotion config along with your 10Gb NICs you'll be limited to vMotion properties of the 1Gb NIC - 4 concurrent vMotion operations. 10Gb NICs limit the number of concurrent vMotion transfers to 8. **Adding more NICs does NOT allow more concurrent vMotions instead, it increases throughput so the vMotion operations are faster**

Next we need to set up the failover order for each of our VMkernel adapaters - each needs one active and one standby NIC:

![VMnic failover order][7]

As you can see currently our vMotion port groups are using both adapters each, we need to fix this:

![vMotion port groups][8]

Edit the first vMotion adapter's Teaming and failover section to "Override" and prioritise your NICs as you wish:

![vMotion-1 NIC order][9]

And do the same for the second, but obviously, swapping the NICs order for active/standby:

![vMotion-2 NIC order][10]

Your vMotion port groups should now point at alternating pNICs:

![pNIC configuration][11]

You've successfully configured Multi-NIC vMotion, pretty easy, just be careful of MTU for jumbo frames and your failover order is correct for each of the port groups on each host.

This guide couldn't have been completed without the great articles by [Frank][12] and [Duncan][13]. I also recommend [Duncan's book on VMWare clusters][14] for those just cutting their teeth on the topic.

Why not follow [@mylesagray on Twitter][15] for more like this!

 [1]: http://frankdenneman.nl/2014/01/07/vcdx-defend-clinic-choosing-multi-nic-vmotion-lbt/
 [2]: http://www.yellow-bricks.com/2011/07/20/vsphere-50-vmotion-enhancements/
 [3]: images/Screen-Shot-2014-06-07-at-14.58.25.png
 [4]: images/Screen-Shot-2014-06-07-at-15.13.27.png
 [5]: images/Screen-Shot-2014-06-07-at-15.14.02.png
 [6]: images/Screen-Shot-2014-06-07-at-15.24.41.png
 [7]: images/Screen-Shot-2014-06-07-at-15.51.33.png
 [8]: images/Screen-Shot-2014-06-07-at-15.53.40.png
 [9]: images/Screen-Shot-2014-06-07-at-15.59.22.png
 [10]: images/Screen-Shot-2014-06-07-at-15.58.07.png
 [11]: images/Screen-Shot-2014-06-07-at-16.03.09.png
 [12]: http://frankdenneman.nl/2012/09/07/vsphere-5-1-vmotion-deepdive/
 [13]: http://www.yellow-bricks.com/vmware-high-availability-deepdiv/
 [14]: http://www.amazon.com/VMware-vSphere-5-1-Clustering-Deepdive-ebook/dp/B0092PX72C/
 [15]: https://twitter.com/mylesagray
