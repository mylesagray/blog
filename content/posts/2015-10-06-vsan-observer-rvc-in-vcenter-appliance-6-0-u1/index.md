---
title: VSAN Observer RVC in vCenter Appliance 6.0 U1
author: Myles Gray
type: posts
date: 2015-10-06T09:18:45+00:00
lastmod: 2021-10-25T13:06:00+00:00
description: "Using vSAN observer inside vCenter 6.0"
url: /virtualisation/vsan-observer-rvc-in-vcenter-appliance-6-0-u1/
aliases: /security/vsan-observer-rvc-in-vcenter-appliance-6-0-u1/
cover:
  image: images/Image-5.png
  alt: "vSAN Observer disks page"
  hidden: true
categories:
  - Virtualisation
  - Infrastructure
  - Storage
tags:
  - esxi
  - esxi 6.0
  - vmware
  - vsan
  - vsan observer
  - vsphere
---

I have been working with VSAN in the lab recently and had the need to get some deeper stats on the inner operations.

I had upgraded the lab to ESXi 6.0 U1 and vCenter 6.0 U1 and for the life of me couldn't get the RVC console in the VCSA to work per the [VMware KB][1].

In particular it just wouldn't log in with this line, even with the correct password:

```sh
rvc username@localhost
```

and this didn't work either:

```sh
rvc administrator@localhost
```

Then I had a sort of epiphany, what if I append the SSO domain to the start and target it at the localhost?

```sh
rvc administrator@vsphere.local@localhost
```

Sure, it looks janky, but it worked!

![VSAN Observer vSphere 6.0 U1][2] 

It appears to need the SSO domain (whatever yours is - could obviously be different from the `vsphere.local` default) appended to the username then target the rvc at localhost.

Hope this helps, had me stumped for a bit for sure!

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2064240
 [2]: images/Image-5.png
 [3]: https://twitter.com/mylesagray