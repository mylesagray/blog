---
title: Flashing over OEM-R BIOS/Firmware on Dell hardware
author: Myles Gray
type: posts
date: 2015-07-01T22:50:01+00:00
lastmod: 2021-10-25T12:19:00+00:00
description: "How to convert an Avamar (or any other OEM) node back to standard Dell firmware"
url: /hardware/flashing-over-oem-r-biosfirmware-on-dell-hardware
aliases: [ "/hardware/flashing-over-oem-r-biosfirmware-on-dell-hardware/amp" ]
cover:
  image: images/Screen-Shot-2015-07-02-at-22.18.21.png
  alt: "Dell BIOS flashing"
categories:
  - Hardware
tags:
  - avamar
  - dell
  - emc
  - firmware
  - forcetype
  - oemr
---

I have recently been rebuilding my home lab from scratch (a series of posts on that coming soon), so naturally my first port of call for server hardware was eBay, what self-respecting techie would pay full price for anything...

I found an incredible deal on some used Dell R710 servers, so I bought two to bring my collection of these beasts up to 3 so I can run VSAN, NSX, vCloud Director and some other [SDDC][1] tastiness ([VMware VIO][2] anyone?).

So picked up this great deal and my servers arrived promptly, noticing they came in EMC boxes made me very intrigued, haven't I seen boxes _just like_ this one at work (we run a sizable Avamar grid), open the boxes, lo-and-behold i'm greeted with this familiar sticker:

![Avamar ADS Gen3 3.3TB Storage Server][3]

So they were familiar!

Anyway, no big deal, we all know EMC Gen3 Avamar nodes are just [re-branded Dell R710s][4], after all just look at the BOM for one of my nodes' service tags:

<http://www.dell.com/support/home/uk/en/ukbsdt1/product-support/servicetag/38CHT4J/configuration>

Plenty of EMC only line items, still though, same motherboard, iDRAC, etc.

So, powering it up, clearly had not been updated in some time (BIOS version 6.0.8, iDRAC6 1.10, Lifecycle Controller 1.2), so I did what any good sysadmin would and download the [Dell CentOS Firmware LiveDVD][5] ([detail][6]), stuck it on a USB and proceeded to pimp it out with all the latest firmwares.

Updates stated they were successful, so I thought "yay!", rebooted the host and hit `F10` to log into `Lifecycle Controller/Universal Server Configurator`.

_Server hangs for 30 minutes_

Clearly, [that's not gone well][7].

This is repeatable, also the BIOS on boot now just says:

```sh
BIOS Version
```

With no version number displayed as-would be normal. (Another hint something was amiss - zero Dell branding **anywhere**, even on iDRAC and UEFI - see below)

![Dell iDRAC No Branding][8]

After a spot of Google archaeology I [found][9] [some][10] [threads][11] indicating that this may be because when 3rd Party Integrators use Dell items they are offered OEMR versions of the firmwares (OEM-Ready) we can find those [for the R710 here][12].

However, they are lagging behind and also handicap the functionality and integration somewhat, in that, they don't play nice with stock firmware images for other components (hence my LCS/USC weirdness).

I don't want to have to flash a special OEMR BIOS every time I do an upgrade, I want to use the standard Dell repos with my OMSA integration for vCenter and/or Dell Repository Manager.

So how can we force a "standard" Dell firmware on to the hardware (which is, of course, identical to its EMC/Google/whatever integrated counterpart)?

This is actually pretty easy, we need to create a DOS Boot USB using [Rufus][13];

Setting the file system to `FAT32` and the bootable OS type to `MS-DOS`, then load our stock [Dell `Non-Packaged` BIOS firmware `.exe`][14] on to it.

Boot into our newly made USB and run the update package with the `/forcetype` argument:

```sh
R710-060400C.exe /forcetype
```

![Dell BIOS flash utility][15]

Let the upgrade complete, reboot and BAM, stock Dell goodness again.

Pressed `F10` LSC/USC loads right up with all the usual Dell branding and we can update our firmwares from here on out with peace of mind, knowing that we don't have to wait on special OEMR firmware updates.

![Dell Branding Back][16]

Why not follow [@mylesagray on Twitter][17] for more like this!

 [1]: https://en.wikipedia.org/wiki/Software-defined_data_center
 [2]: https://www.vmware.com/uk/products/openstack
 [3]: images/IMG_0776_1024.jpg
 [4]: http://www.dell.com/learn/us/en/555/oem/oem-class-hardware-page
 [5]: http://linux.dell.com/files/openmanage-contributions/
 [6]: http://en.community.dell.com/techcenter/b/techcenter/archive/2011/08/17/centos-based-livedvd-to-update-firmware-on-dell-servers
 [7]: https://www.youtube.com/watch?v=QQh56geU0X8
 [8]: images/Screen-Shot-2015-07-02-at-21.47.54.png
 [9]: http://mickitblog.blogspot.co.uk/2011/09/dell-bios-switches.html
 [10]: http://www.itwalkthru.com/2013/03/how-to-flash-google-search-appliance-to.html
 [11]: http://en.community.dell.com/support-forums/servers/f/956/t/19605760
 [12]: http://downloads.dell.com/published/pages/oth-r710.html
 [13]: https://rufus.akeo.ie/
 [14]: https://poweredgec.dell.com/latest_poweredge-11g.html#R710%20BIOS
 [15]: images/Screen-Shot-2015-07-02-at-22.18.21.png
 [16]: images/Screen-Shot-2015-07-02-at-22.21.56.png
 [17]: https://twitter.com/mylesagray
