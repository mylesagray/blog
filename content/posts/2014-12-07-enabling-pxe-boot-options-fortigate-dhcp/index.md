---
title: Enabling PXE boot options on Fortigate DHCP
author: Myles Gray
type: posts
date: 2014-12-07T14:04:09+00:00
lastmod: 2021-10-08T11:54:00+00:00
description: "DHCP allows pushing configuration parameters to client devices, we will look at how to enable PXE boot options on FortiGate DHCP servers."
url: /infrastructure/enabling-pxe-boot-options-fortigate-dhcp/
cover:
  image: images/Screen-Shot-2014-12-07-at-12.22.31.png
  alt: "FortiGate DHCP Options"
categories:
  - Infrastructure
  - Networks
tags:
  - foreman
  - orchestration
  - puppet
  - pxe
  - vmware
---

I have been recently setting up [The Foreman][1] as a [Puppet][2] management front end to allow me to quickly provision Linux based VMs on my VMware cluster - more on that setup in another article.

I had to create a PXE boot environment for The Foreman to fully automate the provisioning of the VMs, I run a [Fortigate 100D][3] in my lab from which DHCP is served, as you may or may not know, the PXE boot options [are served from DHCP][4].

Fortigate use the `next-server` command to tell the client where to find the `next bootstrap server`, or, the server that hosts the TFTP instance.

There is a DHCP option in the IANA list we are particularly interested in is:

```sh
Tag   Name            Data Length   Meaning                  Reference
67    Bootfile-Name   N             Boot File Name           [RFC2132]
```

We must set this [option][5] to tell the PXE client what filename it is looking for on the TFTP server.

Fortigate have a strange way of doing this particular config, at least in the latest version (5.2.2) which I am running.

I like to configure from the CLI but couldn't help but noticing in the GUI that there was a new section added to the DHCP config:

![Fortigate DHCP Options][6]

It seems to allow some commonly-set DHCP options to be selected and specified with ASCII rather than hex:

![PXE boot file name][7]

Anyway, we can do all this through the CLI as well, firstly navigate to the DHCP server instance in question:

```sh
show system dhcp server 2
```

My output looks like this:

```sh
config system dhcp server
    edit 2
        set dns-service default
        set ntp-service default
        set default-gateway 10.0.0.1
        set netmask 255.255.254.0
        set interface "LAN"
            config ip-range
                edit 1
                    set start-ip 10.0.0.2
                    set end-ip 10.0.1.199
                next
            end
        set timezone-option default
    next
end
```

To this we need to add the `next-server` and `filename` directives to set the DHCP options for TFTP server and boot file name.

```sh
config system dhcp server
    edit 2
        set next-server 10.0.2.15
        set filename "pxelinux.0"
    next
exit
```

This should now point your DHCP client (Intel E1000 on ESXi) to the TFTP server `10.0.2.15` which is for this example my Foreman server and tell it to pull the `pxelinux.0` file to begin the boot and install from network.

Why not follow [@mylesagray on Twitter][8] for more like this!

 [1]: http://theforeman.org
 [2]: http://puppetlabs.com/
 [3]: http://www.fortinet.com/sites/default/files/productdatasheets/FortiGate-100D.pdf
 [4]: http://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml#options
 [5]: https://www.ietf.org/rfc/rfc2132.txt
 [6]: images/Screen-Shot-2014-12-07-at-12.22.31.png
 [7]: images/Screen-Shot-2014-12-07-at-12.21.48.png
 [8]: https://twitter.com/mylesagray
