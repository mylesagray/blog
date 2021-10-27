---
title: 'vSphere HA Configuration fails: Operation Timed Out'
author: Myles Gray
type: posts
date: 2015-07-22T12:17:47+00:00
lastmod: 2021-10-25T12:35:00+00:00
description: "How to troubleshoot vSphere Ha failing to configure"
url: /infrastructure/vsphere-ha-configuration-fails-operation-timed-out
aliases: [ "/infrastructure/vsphere-ha-configuration-fails-operation-timed-out/amp" ]
cover:
  image: images/Image-2.png
  alt: "vSphere HA in a healthy state"
categories:
  - Infrastructure
  - Networks
  - Virtualisation
tag:
  - esxi
  - ha
  - jumbo frame
  - ssl
  - vcenter
  - vmware
---

I recently rebuilt my lab and added 2x new ESXi hosts, I re-used my old single host in the process which I upgraded from ESXi 5.5 to 6.0 and patched to the same level as the new hosts.

Everything was working as expected until it came for the time to enable HA.

My old host claimed the master roll and thus the other boxes had to connect to it as slaves, however, these failed with "HA Agent Unreachable" and "Operation Timed Out" errors.

After some host reboots, ping, nslookup and other standard connectivity tests with still no progress I started blaming the ESXi 5.5 -> 6.0 upgrade this was, as it turns out, unfounded.

Looking at the `/var/log/fdm.log` on the `master` host the following lines could be seen:

```sh
SSL Async Handshake Timeout : Read timeout after approximately 25000ms. Closing stream <SSL(<io_obj p:0x1f33f794, h:31, <TCP 'ip:8182'>, <TCP 'ip:47416'>>)>
```

Further along we could see that it knows the other hosts are alive:

```sh
[ClusterDatastore::UpdateSlaveHeartbeats] (NFS) host-50 @ host-50 is ALIVE
```

And further along again:

```sh
[AcceptorImpl::FinishSSLAccept] Error N7Vmacore16TimeoutExceptionE(Operation timed out) creating ssl stream or doing handshake
```

On the `slave` candidates this could be seen:

```sh
[ClusterManagerImpl::AddBadIP] IP 1{master.ip.address.here} marked bad for reason Unreachable IP
```

After yet more troubleshooting and messing about with SSL cert regeneration I [stumbled upon this][1]:

> This issue occurs when Jumbo Frames is enabled on the host Management Network (VMkernel port used for host management) and a network misconfiguration prevent hosts communicating using jumbo frames. It is supported to use jumbo frames on the Management Network as long as the MTU values and physical network are set correctly.

Checked the `vmk0` `MTU` on my `master` host - sure enough, I had configured this as `9000` [back in the day][2] and completely forgotten about it, bumped it back down to `1500`, HA agents came up right away:

![HA Agent Vmware master][3]

Hopefully this saves you some time and you don't have to go through what I did trying to solve this.

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2011974
 [2]: /?s=jumbo%20frames
 [3]: images/Image-2.png
 [4]: https://twitter.com/mylesagray
