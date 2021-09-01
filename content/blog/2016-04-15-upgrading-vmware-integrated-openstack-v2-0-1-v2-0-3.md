---
title: Upgrading VMware Integrated Openstack from v2.0.1 to v2.0.3
author: Myles Gray
type: post
date: 2016-04-15T20:14:52+00:00
url: /cloud/upgrading-vmware-integrated-openstack-v2-0-1-v2-0-3/
cover:
  image: /uploads/2016/04/Screen-Shot-2016-04-15-at-21.12.46.png
rop_post_url_twitter:
  - 'https://blah.cloud/cloud/upgrading-vmware-integrated-openstack-v2-0-1-v2-0-3/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Cloud Frameworks
tags:
  - openstack
  - vmware

---
I've been playing around with VMware Integrated Openstack recently and wanted to see what the upgrade experience for bugfixes and point releases is like, happy to say - it's quite easy.

Firstly, download the `.deb` package from my.vmware.com and upload it to the VIO management appliance - I used FileZilla for this, the username is `viouser` and password is what you set during OVF deploy.

I just uploaded mine to the `viouser` home folder `/home/viouser/`

![Filezilla upload of VIO patches][1] 

Next, SSH into the VIO management appliance and import the patch:

    viopatch add -l vio-patch-203_2.0.3.3720171_all.deb
    

Then to show the patch is listed:

    viouser@vio1:~$ viopatch list
    Name           Version        Type    Installed
    -------------  -------------  ------  -----------
    vio-patch-203  2.0.3.3720171  infra   No
    

Now, we're going to install the patch:

    sudo viopatch install --patch vio-patch-203 --version 2.0.3.3720171
    

This process took around 15 minutes in my case, the API endpoint will be down for the duration so any replies will be with `Error 503`.

I opened another SSH session during the install and ran `top` to monitor progress, you will see the CPU utilisation cycle through Java and Ansible as it deploys to the cluster itself.

![TOP usage][2] 

And that's it, if you see the following you're good to go:

    viouser@vio1:~$ sudo viopatch install --patch vio-patch-203 --version 2.0.3.3720171
    [sudo] password for viouser:
    Installing patch vio-patch-203 version 2.0.3.3720171
    done
    Installation complete for patch vio-patch-203 version 2.0.3.3720171
    

Log out of the Web Client and back in and verify that you're now operating at 2.0.3:

![OpenStack Operating Version][3] 

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: /uploads/2016/04/Screen-Shot-2016-04-15-at-20.25.01.png
 [2]: /uploads/2016/04/Screen-Shot-2016-04-15-at-20.48.39.png
 [3]: /uploads/2016/04/Screen-Shot-2016-04-15-at-21.12.46.png
 [4]: https://twitter.com/mylesagray