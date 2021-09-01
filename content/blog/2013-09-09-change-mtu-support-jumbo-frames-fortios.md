---
title: Change MTU to support Jumbo Frames in FortiOS
author: Myles Gray
type: post
date: 2013-09-09T23:05:49+00:00
url: /hardware/change-mtu-support-jumbo-frames-fortios/
cover:
  image: /uploads/2013/11/Screen-Shot-2013-09-10-at-00.02.05.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1752023177
rop_post_url_twitter:
  - 'https://blah.cloud/hardware/change-mtu-support-jumbo-frames-fortios/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Hardware
  - Infrastructure
tags:
  - fortigate
  - jumbo frame
  - mtu

---
This info is quite hard to come across and Fortigate don't have it in their GUI from FortiOS v5.0+, SSH into your Fortigate's CLI and enter the following (it can be done on both software aggregated and standard interfaces):

    config system interface
    edit [interfacename]
        set mtu-override enable
        set mtu 9208
    end
    end
    

Confirm your MTU size change has worked on the given interface by plugging directly into it (test MTU in accordance to [my guide here][1]).

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /hardware/test-jumbo-frames-working/ "How to test if 9000 MTU/Jumbo Frames are working"
 [2]: https://twitter.com/mylesagray