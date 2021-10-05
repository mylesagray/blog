---
title: In need of a multi-OS, bootable USB? Use an Android phone.
author: Myles Gray
type: posts
date: 2016-04-07T17:09:06+00:00
url: /hardware/need-multi-os-bootable-usb-use-android-phone/
cover:
  image: images/ZeroSpace.png
categories:
  - Hardware
tags:
  - android
  - esxi
  - iso
  - rufus
  - vmware
---

I found myself in the position recently whereby I had two hosts I bought off eBay (as one does for labs), they arrived, I had great plans&#8230; But no iDRAC Enterprise :(

While the iDRAC Ent cards were on their way to me I couldn't help but want to install ESXi on these things so they were ready to go (old Dell R610s are seriously good value now). One slight problem. No iDRAC Ent means no virtual console, or virtual media. I don't have any USB drives because I use cloud storage for that kind of thing and they had CD drives - what is this, the dark ages, does my mac look like it has room for a CD burner?

<!--more-->

So in my impatience I wanted a solution and this is what I came up with; I'm bad for keeping old tech around incase they one day may come in handy again - and my old Samsung Galaxy Nexus fit the bill perfectly - so after an hour on the charger and years of updates being installed it was ready to rock.

In case you haven't gathered by now the plan is to use the Android phone as a USB storage device to boot the servers off and install my ISO(s).

There are a few pre-requisites:

  * Android Phone
  * USB Data cable (yeah, got bitten by the "power only" USB cables)
  * [DriveDroid][1]
  * Windows install with [Rufus][2] on it

I'm not going to nerd out too much, but Rufus is absolutely flawless, I have never used a program that makes bootable USBs so easily, without all that Floppy disk ROM faff.

So, start your Android phone, install the DriveDroid app, click the `+` button and hit `Create blank image...` this will essentially create a blanked out space on the internal storage of the phone to which you can write an ISO image.

![Create blank image][3] 

Next we will give it a name and a size - this is just for your own reference, as you can see mine is called `ESXI6.0U2.iso` and i've given it a size of `768MB` which I know is larger than the ISO that will be extracted to it.

![Image Creation][4] 

You can view image creation progress in the notification center.

![DriveDroid Image Creation Progress][5] 

Next, we are going to click on the image we just created and choose `Writable USB` as the type, this will then mount the device, as a writable USB to your Mac/PC/VM.

![Mounting Image][6] 

In my case, I run Windows as a VM, so I attached the USB device to the VM and it shows up as such. Just hit `Cancel` here as Rufus will do this for us.

![Drive detection][7] 

Now we can run Rufus and it should detect the USB disk, ensure you pick the correct one then set up as below (be sure the Create a bootable disk option is using `ISO Image`), select the ISO for ESXi then hit `Start`.

![Rufus ESXi Settings][8] 

Yes, we want to wipe the device and the progress should begin.

![Rufus image write progress][9] 

Once that is done we can close Rufus, and should see our ISO installer presented as a USB to the host operating system again - now we're ready to roll.

![Burn successful][10] 

Boot the server/desktop into BIOS, ensure that USB emulation mode is `Hard Drive`, reboot into BIOS Boot Manager and choose the `USB device` as the boot drive - It should boot right into ESXi's installer.

Given how easy it was to create images and how easy it is to switch between them with DriveDroid i'm going to put a new more standard ISOs on there, Windows 10, Ubuntu and the like.

Until the next time&#8230;

Why not follow [@mylesagray on Twitter][11] for more like this!

 [1]: https://play.google.com/store/apps/details?id=com.softwarebakery.drivedroid.paid&hl=en_GB
 [2]: https://rufus.akeo.ie/
 [3]: images/CreateImage.png
 [4]: images/ImageSettings.png
 [5]: images/ZeroSpace.png
 [6]: images/HostImage.png
 [7]: images/Screen-Shot-2016-04-07-at-17.38.48.png
 [8]: images/Screen-Shot-2016-04-07-at-17.40.13.png
 [9]: images/Screen-Shot-2016-04-07-at-17.40.42.png
 [10]: images/Screen-Shot-2016-04-07-at-17.43.00.png
 [11]: https://twitter.com/mylesagray