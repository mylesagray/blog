---
title: Deploying Cisco VIRL on VMware Workstation – Caveats
author: Myles Gray
type: posts
date: 2014-12-03T18:00:45+00:00
url: /networks/deploying-cisco-virl-vmware-workstation-caveats
aliases: ["/networks/deploying-cisco-virl-vmware-workstation-caveats", "/networks/deploying-cisco-virl-vmware-workstation-caveats/amp", "/software/deploying-cisco-virl-vmware-workstation-caveats", "/software/deploying-cisco-virl-vmware-workstation-caveats/amp"]
cover:
  relative: true
  image: images/2014-11-18-07.00.15-pm-1024x598.webp
categories:
  - Networks
  - Virtualisation
tags:
  - cisco
  - lab
  - VIRL
  - VMware
---

I recently tried to deploy Cisco VIRL on VMWare Workstation 10 - [the install instructions][1] are for v8 - there are a few differences I noted.

* It doesn't account for the `host-only` network installed by default so increment all vmnets by `1`

![VMNet configuration VMware Workstation 10][2]

* The labelling for VT-x/EPT has changed, it now lives under **Settings -> Hardware -> Processors -> Virtualisation engine -> Preferred mode:**
* You need to explicitly select `Intel VT-x/EPT or AMD-V/RVI` mode

![Expose VT-x/EPT to VM in Workstation][3]

After this entering the `sudo kvm-ok` command in the VIRL CLI still output `KVM acceleration can NOT be used`.

I needed to edit the `.vmx` file directly and add/change these lines:

```ini
monitor.virtual_mmu = "hardware"
monitor.virtual_exec = "hardware"
vhv.enable = "TRUE"
monitor_control.restrict_backdoor = "true"
```

After that booting into VIRL and running `sudo kvm-ok` output `KVM acceleration can be used`.

Once this was overcome configuration went quite smoothly and was fairly simple to setup, be sure to [follow the tutorials][4] once you are ready to go.

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: http://virl-dev-innovate.cisco.com/workstation.ext.html
 [2]: images/Image-2.png
 [3]: images/Image-12.png
 [4]: http://virl-dev-innovate.cisco.com/virl.tutorial.html
 [5]: https://twitter.com/mylesagray
