---
title: '[Ref] Configure vRealize Orchestrator 6.0.3 with vCenter 6.0 U1'
author: Myles Gray
type: posts
date: 2015-10-29T18:04:54+00:00
url: /infrastructure/ref-configure-vrealize-orchestrator-6-0-3-with-vcenter-6-0-u1/
cover:
  image: images/Screen-Shot-2015-10-29-at-18.00.22.png
categories:
  - Automation
  - Infrastructure
tags:
  - automation
  - vcsa
  - vrealize orchestrator
  - vsphere 6
---

Spent longer than necessary messing with vRealize Orchestrator and trying to get it to display the plugin in vCenter server appliance 6.0 U1, you can review my trials and tribulations here:

[https://communities.vmware.com/thread/523397?src=vmw\_so\_vex\_mgray\_1080][1]

> I have been trying to deploy vRealize Orchestrator 6.0.3 with my VCSA 6.0 U1 instance (supported according to compatibility matrix), the symptoms are almost exactly the same as this post:
> 
> [Re: Installing vRO v6.01 but not showing in web client][2]
> 
> Can run workflows, auth using the client, everything, just no plugin in web client.
> 
> `com.vmware.vco` isn't showing at all in the MOB browser however.
> 
> I have tried cat-ing the virgo.log file on the VCSA but nothing relating to vco-plugin comes up when I tell vro to register the extension with vcenter.
> 
> All that shows in the web client is the getting started page, nothing else - i have tried restarting the web client service and the appliance, also rebooting the vro appliance - nothing works.

As you can see, even OOTB config is broken for this release.

I stumbled across this article:

<http://orchestration.io/2015/09/28/deploying-vrealize-orchestrator-6-0-3/>

And, of course, I was stumbling at the simplest of hurdles, when registering the appliance extension with vCenter and executing the workflow you are prompted for "External address to advertise this Orchestrator" - I was just putting in my `FQDN`, apparently, this is not how we do.

Instead of `vro1.lab.mylesgray.io` I needed to put in `https://vro1.lab.mylesgray.io:8281`.

Re-registered and BAM, working right off the bat!

![vRealize Orchestrator 6.0.3 vCenter 6.0 U1][3] 

Thanks to [Chris Greene (@orchestrationio)][4] for documenting this better than VMware.

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: https://communities.vmware.com/thread/523397?src=vmw_so_vex_mgray_1080
 [2]: https://communities.vmware.com/message/2489425#2489425?src=vmw_so_vex_mgray_1080
 [3]: images/Screen-Shot-2015-10-29-at-18.00.22.png
 [4]: https://twitter.com/orchestrationio
 [5]: https://twitter.com/mylesagray