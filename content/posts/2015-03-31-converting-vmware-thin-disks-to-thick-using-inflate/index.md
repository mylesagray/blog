---
title: Converting VMware thin disks to thick using Inflate
author: Myles Gray
type: posts
date: 2015-03-31T14:59:31+00:00
lastmod: 2021-10-25T11:31:00+00:00
description: "How to converts a thin provisioned VMDK to a thich provisioned VMDK in vSphere"
url: /virtualisation/converting-vmware-thin-disks-to-thick-using-inflate
aliases: [ "/virtualisation/converting-vmware-thin-disks-to-thick-using-inflate/amp" ]
cover:
  relative: true
  image: images/Image-2.png
  alt: "Inflate modal in vSphere datastore browser"
  hidden: true
categories:
  - Virtualisation
tags:
  - provisioning
  - sdelete
  - vmdk
  - vmware
---

Just a quick note today, more of a reference than anything else.

I had the requirement recently to convert a load of VMs that had thin VMDKs to thick provisioned, however the client was not licensed for live Storage vMotion.

In an effort to minimise downtime I decided the best thing to do was use the "Inflate" option in the datastore for that VMDK - this requires the VM to be powered off.

![Inflate VMDK][1]

However, `Inflate` - at least when i've tested it is very slow in comparison to Storage vMotion, to keep downtime to a minimum (some inflations were in the order of 200GB+) I wanted to minimise the data that the `Inflate` process had to fill out on the end of the drive.

The solution is to use [sdelete][2] in OS to fill the target disks with data in order to force the VMDK to full size.

However, there is an interesting caveat:

```sh
sdelete.exe -z
```

Zeros free space in OS, does not affect thin VMDK size when when drive is filled due to thin disk compression/dedupe algorithms.

```sh
sdelete.exe -c
```

Fills with random bits, expands disk to full size.

A little nugget there, the purpose of running `sdelete` is to fill all the space on the drive, however, when using non-random or zeroed bits, vmware's thin disk technology dedupes the zeroed writes resulting in the wrong outcome (a disk that is NOT full size). Using the `sdelete.exe -c` trigger fills the disk with random bits and thus forces the VMDK to its full size.

The result? Inflate ran across a 5GB increase in 30 seconds rather than 7 minutes.

An extension of this is, if you want to do the above but don't want to fill the whole drive (say a SQL server log drive) you can use a [`dd` port for Windows][3], this emulates Linux's `/dev/random` and will let you specify bytesize and count, letting you set the size of random data to write to the drive.

The below will write a 3GB file filled with random bits to the D:\ drive then delete the file created:

```sh
dd.exe if=/dev/random of=D:\file.img bs=1M count=3000 --progress & del D:\file.img
```

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: images/Image-2.png
 [2]: https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx
 [3]: http://www.chrysocome.net/downloads/dd-0.6beta3.zip
 [4]: https://twitter.com/mylesagray
