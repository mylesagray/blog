---
title: Recovering NSX Manager with corrupt filesystem
author: Myles Gray
type: posts
date: 2016-11-13T19:15:30+00:00
url: /virtualisation/recovering-nsx-manager-corrupt-filesystem/
cover:
  image: images/Screen-Shot-2016-11-13-at-18.54.00.png
categories:
  - Infrastructure
  - Networks
  - Virtualisation
tags:
  - fsck
  - linux
  - nsx
  - vmware
---

I had a bit of a storage outage in my lab due to a funky behaviour on the Synology that I use as primary storage for _all_ my VMs:

<blockquote class="twitter-tweet" data-width="500">
  <p lang="en" dir="ltr">
    Today I Learned: Adding IP address to interfaces on Synology causes reboots :/ Lab now in not such great shape. 80 VMs with APD. <a href="https://twitter.com/hashtag/vExpert?src=hash">#vExpert</a>
  </p>
  
  <p>
    &mdash; Myles Gray (@mylesagray) <a href="https://twitter.com/mylesagray/status/797829960044072962">November 13, 2016</a>
  </p>
</blockquote>



Most stuff came back up or could at least be trivially fixed (like VCSA, PSCs, etc) you can [edit the GRUB boot string][1] and force into `/bin/bash` then run `fsck` from there.

One VM that doesn't allow the GRUB string to be edited or both to be paused in any way is the NSX manager, that was a problem given I was presented with this upon boot:

![NSX Manager No Boot][2] 

    /dev/sda2: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
    

This is not a good situation, a corrupt FS and no way to force into a shell.

A quick cry for advice on the [vExpert Slack][3] and it was decided booting into a live CD and trying to mount and repair the filesystems from there was the way to go.

So I downloaded the [Ubuntu Desktop installer][4] ISO (the server installer does not have fsck present) - transferred the ISO to my NFS datastore and mounted to the NSX Manager VM. If you're going to do this, make sure you force BIOS boot mode on the VM and put boot from CD-ROM at the top of the list.

![Force into BIOS mode on boot][5] 

Next, reboot into the Ubuntu ISO and choose "Try Ubuntu" when presented with the option to try or install.

Once the live environment is up - run Terminal and then type `ls -l /dev/sd*` to list all discovered partitions.

![List partitions discovered][6] 

Then you run `sudo fsck /dev/sda2` and hit `y` when prompted to fix any errors found on the filesystem. At this stage your filesystem should be "clean", so if you run `sudo fsck /dev/sda2` again it should show up as so:

![SDA2 clean filesystem][7] 

Unmount the ISO from the VM, change the boot order back to normal and you should be good to go again:

![NSX Manager working again][8] 

Why not follow [@mylesagray on Twitter][9] for more like this!

 [1]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2069041&src=vmw_so_vex_mgray_1080
 [2]: images/Screen-Shot-2016-11-13-at-18.15.18.png
 [3]: https://twitter.com/vexpert_slack
 [4]: http://ubuntu.com/download/desktop
 [5]: images/Screen-Shot-2016-11-13-at-19.07.08.png
 [6]: images/Screen-Shot-2016-11-13-at-18.54.00.png
 [7]: images/Screen-Shot-2016-11-13-at-18.54.08.png
 [8]: images/Screen-Shot-2016-11-13-at-18.56.22.png
 [9]: https://twitter.com/mylesagray