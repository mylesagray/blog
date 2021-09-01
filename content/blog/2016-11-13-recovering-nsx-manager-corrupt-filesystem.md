---
title: Recovering NSX Manager with corrupt filesystem
author: Myles Gray
type: post
date: 2016-11-13T19:15:30+00:00
url: /virtualisation/recovering-nsx-manager-corrupt-filesystem/
cover:
  image: /uploads/2016/11/Screen-Shot-2016-11-13-at-18.54.00.png
wp-to-buffer-pro:
  - 'a:7:{s:8:"override";s:1:"0";s:7:"default";a:3:{s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:27:"Updated Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}s:24:"57f8d5b716368246123c6ae8";a:5:{s:7:"enabled";s:1:"1";s:8:"override";s:1:"1";s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:32:"New Post: {title} {url} #vExpert";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}s:24:"57f8d71510133aa22a5e5d6a";a:4:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}s:24:"57f8d761163682ce153c6ae4";a:4:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}s:24:"57f8d77316368280153c6ae4";a:4:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}s:24:"57fa3b89b069516f3f8b456d";a:4:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:7:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";}}}s:10:"conditions";a:2:{s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}}}'
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

Next, reboot into the Ubuntu ISO and choose &#8220;Try Ubuntu&#8221; when presented with the option to try or install.

Once the live environment is up - run Terminal and then type `ls -l /dev/sd*` to list all discovered partitions.

![List partitions discovered][6] 

Then you run `sudo fsck /dev/sda2` and hit `y` when prompted to fix any errors found on the filesystem. At this stage your filesystem should be &#8220;clean&#8221;, so if you run `sudo fsck /dev/sda2` again it should show up as so:

![SDA2 clean filesystem][7] 

Unmount the ISO from the VM, change the boot order back to normal and you should be good to go again:

![NSX Manager working again][8] 

Why not follow [@mylesagray on Twitter][9] for more like this!

 [1]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2069041&src=vmw_so_vex_mgray_1080
 [2]: /uploads/2016/11/Screen-Shot-2016-11-13-at-18.15.18.png
 [3]: https://twitter.com/vexpert_slack
 [4]: http://ubuntu.com/download/desktop
 [5]: /uploads/2016/11/Screen-Shot-2016-11-13-at-19.07.08.png
 [6]: /uploads/2016/11/Screen-Shot-2016-11-13-at-18.54.00.png
 [7]: /uploads/2016/11/Screen-Shot-2016-11-13-at-18.54.08.png
 [8]: /uploads/2016/11/Screen-Shot-2016-11-13-at-18.56.22.png
 [9]: https://twitter.com/mylesagray