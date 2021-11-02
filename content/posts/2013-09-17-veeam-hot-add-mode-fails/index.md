---
title: Veeam Hot-Add Mode Fails – Mismatching VMFS block size
author: Myles Gray
type: posts
date: 2013-09-17T11:51:21+00:00
url: /infrastructure/veeam-hot-add-mode-fails
aliases: [ "/infrastructure/veeam-hot-add-mode-fails/amp" ]
description: "Solution for VMDK hot-add mode failing when using Veeam Backup"
cover:
  relative: true
  image: images/Screen-Shot-2013-09-17-at-12.51.54.png
  alt: "VMFS block size"
categories:
  - Infrastructure
  - Virtualisation
tags:
  - CBT
  - hot-add
  - RDM
  - Veeam
  - vmfs
  - vSphere
  - backup
---

Recently had a problem were Veeam was giving bother on `one VM` that had a dedicated datastore, not allowing `hot-add virtual appliance mode` to work.

I originally thought it was a problem with CBT (changed block tracking) so I disabled that, with no luck, as it transpires there were a few (all datastore formatting related) problems:

* The `Veeam proxy`'s datastore was formatted in `VFMS-3` with a 2MB `block size` and upgraded to `VMFS-5` (retaining its 2MB `block size` of course - otherwise a reformat would be needed).
* The `source machine`'s datastore was formatted in `VMFS-3` with an 8MB `block size` and later upgraded to `VMFS-5` (retaining its 8MB `block size`).
* The target datastore was formatted in `VMFS-5` natively with a unified 1MB `block size`.

So when the `proxy` tries to `hot-add` the disk the `VMFS block size` on the `source machine`'s datastore is larger than the `proxy`'s datastore `block size` and the `hot-add` fails.

![VMFS v5][1]

One solution was to put it in network mode but this can be slow and it's not a nice way of doing things, so I wanted to run it in VA mode.

What I ended up doing was shutting down the `source machine`, migrating it to a `VMFS-5` datastore, reformatting it's `original datastore` to native `VMFS-5` (native `VMFS-5` volumes are all created with a unified 1MB `block size`) and migrating the `source VM` back to its `original location`.

The `hot-add` then worked as expected. In an ideal world one would [reformat all their datastores to `VMFS-5`][2] with the standard 1MB `block size` and this is what I am working towards.

"_What about the VMDK file size limit tied to `block size`?_" I hear you say - well, as of [`VMFS-5` the 1MB `block size` now supports 2TB .vmdk files][3]:

The limits that apply to VMFS-5 datastores are:

> The maximum virtual disk (VMDK) size is 2 TB minus 512 B. The maximum  
> virtual-mode RDM size is 2 TB minus 512 B. Physical-mode RDMs are  
> supported up to 64 TB.

As of VSphere 5.5 this will change to 64TB - though why you would want a .vmdk this size beats me - i'd have the disk split and clustered, if it was a Windows box e.g. SBS, Exchange or SQL - though, if you need this disk size you're likely already using `RDM` for those.

Any input on this however is welcome.

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: images/Screen-Shot-2013-09-17-at-12.51.54.png
 [2]: http://vinfrastructure.it/en/2011/12/upgrading-vs-fresh-install-vmfs5/
 [3]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1003565
 [4]: https://twitter.com/mylesagray