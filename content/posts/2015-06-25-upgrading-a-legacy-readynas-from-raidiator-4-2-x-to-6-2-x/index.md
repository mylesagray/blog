---
title: Upgrading a legacy ReadyNAS from RAIDiator 4.2.x to 6.x
author: Myles Gray
type: posts
date: 2015-06-25T10:35:26+00:00
lastmod: 2021-10-25T12:15:00+00:00
description: "How to upgrade a legacy x86 based ReadyNAS to OS 6.x"
url: /miscellaneous/upgrading-a-legacy-readynas-from-raidiator-4-2-x-to-6-2-x
aliases: ["/miscellaneous/upgrading-a-legacy-readynas-from-raidiator-4-2-x-to-6-2-x", "/miscellaneous/upgrading-a-legacy-readynas-from-raidiator-4-2-x-to-6-2-x/amp", "/just-for-fun/upgrading-a-legacy-readynas-from-raidiator-4-2-x-to-6-2-x", "/just-for-fun/upgrading-a-legacy-readynas-from-raidiator-4-2-x-to-6-2-x/amp"]
cover:
  image: images/Image-11.png
  alt: "ReadyNAS legacy running OS 6.x"
categories:
  - Hardware
tag:
  - netgear
  - RAIDiator
  - readynas
---

My old ReadyNAS was in need of an update and figured i'd look back into upgrading to OS 6.2.x again, this used to be quite an involved manual process requiring you to access the [VGA header on the motherboard][1].

As it turns out Netgear have realised people would get round this anyway and have provided an (unsupported) upgrade path.

This will allow us to use a number of features not available on our current firmware (for me I have a ReadyNAS Ultra 6):

* AD Authentication
* NFS v4
* Native link bonding (without 3rd party plugin)
* SSH access (without 3rd party plugin)
* New plugin catalogue
* A shiny new GUI :)

**N.B: This operation will factory reset your NAS including all shares, take a backup first!**

So, first things first, download `R4toR6_Prep_Addon.bin` and `R4toR6_6.9.5.bin` from the [here](https://community.netgear.com/t5/ReadyNAS-Storage-Apps-Current/ReadyNAS-OS-6-9-3-Run-on-existing-x86-4-2-notsupported/m-p/905258).

Log into your ReadyNAS admin interface and navigate to `Add-ons -> Add New`, Select the `R4toR6_Prep_Addon.bin` extension we downloaded earlier and click `Upload and verify image...`:

![ReadyNAS Add-On Installation Screen][2]

If the installation prep file was successfully uploaded and verified you will see the below:

![ReadyNAS RAIDiator 4.2.x to 6.2.x upgrade][3]

Click `Install` to commit to the OS.

Next up we need to upload the OS `R4toR6_6.9.5.bin` itself via `System > Update > Local`:

![ReadyNAS Firmware Upgrade to 6.2.x][4]

After the firmware has been uploaded and verified click `Perform System Update` and reboot when prompted:

![YOLO][5]

Now we pray to the computing deities and hope that the completely unsupported software upgrade we did on our NAS has not fudged the entire box.

As the box gets reset to factory defaults it will now have a DHCP address - connect to this new address, login with `admin` and `password` and set it back up with bonding, AD auth, set up some shares and private Time Machine, etc:

![Netgear OS 6.2.x][6]

I installed `Pydio` on mine, it's an awesome cloud file sync platform that you forward through your firewall (enable IPS on your firewall now if you have it!).

So there it is, nice and easy, updated to the latest RAIDiator.

Worth holding your breath during the upgrade for? I think so.

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: https://web.archive.org/web/20190102203234/https://warwick.ac.uk/fac/sci/csc/people/computingstaff/jaroslaw_zachwieja/readynaspro-jailfix
 [2]: images/Screen-Shot-2015-06-24-at-20.33.35.png
 [3]: images/Screen-Shot-2015-06-24-at-20.35.23.png
 [4]: images/Screen-Shot-2015-06-24-at-20.52.51.png
 [5]: images/Screen-Shot-2015-06-24-at-20.57.59.png
 [6]: images/Image-11.png
 [7]: https://twitter.com/mylesagray
