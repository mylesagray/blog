---
title: Replicating SAN on openSUSE with VAAI
author: Myles Gray
type: posts
date: 2016-08-27T12:59:18+00:00
url: /hardware/replicating-san-opensuse-vaai/
cover:
  image: images/OpenSUSE_Logo.svg_.png
categories:
  - Hardware
  - Infrastructure
  - Storage
  - Virtualisation
  - Linux
tags:
  - drbd
  - iscsi
  - linux
  - openSUSE
  - OSS
  - VAAI
  - lio-target
---

## Preamble

This article was written a few years back, but never published - it was some work I was doing in my lab to try and get to grips around the work involved in creating a SAN with synchronous replication built in from scratch.

It in no way should be used for production, but rather as a learning exercise - as previously stated the instructions are a few years old and version specific, so openSUSE may well now support some of the modules I had to compile and create repos for manually, also DRBD9 has been released and should obviously be used in place of DRBD8 as I have below.

The purpose of posting this information is just as a knowledge dump and some configs may come in handy to others out there. I learned a lot about the open source community during this project, how helpful, but also at times how toxic the politics can be. I could have written about those, as all the information is out in the open, but have chosen not to write about the experiences therein and rather, let the incredible work these people are doing speak for themselves.

The section about Corosync/Pacemaker is missing from the below, I will create some VMs with the config below and try to finish off that section in the near future - but know that these HA daemons were used to orchestrate quorum and failure domains in the event of bad things happening (automatically take down iSCSI targets etc).

* * *

## Intro / Specification

I will leave the hardware spec and definition for another article, this one is just about getting the software sorted out.

I had the need to create 2x SANs that had to have the following features:

* synchronous replication
* asynchronous replication (offsite-replication to another paired array - possibly)
* iSCSI support
* RAID10 - Large array (36TB per SAN)
* 10GbE
* 10-20k IOPS per host

## Research

With this in mind I had a few "nice" features I wanted the SANs to support myself, through software, namely:

* SPC-3/4 `XCOPY`, `Persistent Reservations` commands (SCSI Locking, Cluster Aware for Primary/Primary cluster)
* [VAAI support][1]
* SSD cache in front of HDDs (LSI cards with CacheCade)

A word on the above:

* `VAAI` is nothing more than standard (`t10`) SCSI commands implemented into VMWare's ESX iSCSI initiator, there is nothing VMWare or VMFS specific about these commands so _any_ hypervisor could add support for `VAAI` compliant storage by adding this functionality to their iSCSI initiator. _The amazing thing about this change however is that data processing is now offloaded to the SAN's hardware_. Meaning your ESX instance now no longer has to process the data - this is particularly handy for cloning, replication, templating - instead of a VM clone taking hours it can take minutes. The exact commands are:

> * Atomic Test & Set (ATS), which is used during creation and locking of files on the VMFS volume (**`SCSI COMPARE AND WRITE`**)
> * Clone Blocks/Full Copy/XCOPY, which is used to copy or migrate data within the same physical array (**`SCSI EXTENDED COPY`**)
> * Zero Blocks/Write Same, which is used to zero-out disk regions (**`SCSI WRITE SAME`**)
> * Block Delete in ESXi 5.x and later hosts, which allows for space to be reclaimed using the SCSI UNMAP feature. For more information on Block Delete (**`SCSI UNMAP`**)

* Operating Systems are easy to choose between - especially for clustering, you either use RHEL or its derivatives (Fedora/CentOS) or SLES and thus conversely - openSUSE. _Why not use Ubuntu?_ I hear you ask, Ubuntu is not what I call "Enterprise OS" material - clustering has been broken from 10.10 right through to the current release 13.04 - too focused on Desktop UX and not enough on core functionality it would appear.

**Replication:** DRBD is going to be the replication framework of choice - this is because it offers great support, is proven to be stable in production environments and as of DRBD9 will support scale-out clustering and multi-primary). I chose this over GlusterFS et al. because of stability problems using iSCSI on GlusterFS with VMWare - this has apparently been fixed in v3.3/3.4 but I have not tested and rather not be the one to find out.

**iSCSI:** I wanted an iSCSI framework that would support `VAAI` and `SCP-3/4` commands - there is only _one_ at the moment that does this and it is (controversially) Linux's kernel build in SCSI framework - LIO - after fighting off SCST for the retired IET module.

**Cluster Management:** Heartbeat is dead, so the natural stack of choice for cluster management is Pacemaker/Corosync - all of DRBD's guides are written for this and is basically a standard.

## Software

So a break-down of the software to be used then:

* openSUSE12.3 (upgraded to linux-3.12 kernel)
* Lio-target w/ targetcli (native linux kernel SCSI module)
* DRBD 8.4.3 (DRBD9 as a rolling upgrade when released)
* Pacemaker/Corosync

First we install our base openSUSE 12.3 install - as default this comes with the `linux-3.7.10` kernel to use the `VAAI` features of `LIO Target` we need to have the `linux-3.12` kernel installed, so we need to pull this from the openSUSE kernel HEAD repository, get `sudo` then enter the following:

```sh
zypper ar http://download.opensuse.org/repositories/Kernel:/HEAD/standard/ Kernel-Head
zypper refresh #Yes you want to always trust this repo when adding
zypper in --from Kernel-Head kernel-desktop #Yeah, openSUSE uses the desktop kernel
reboot
```

Upon reboot your output should read similar to this:

```sh
# uname -r
3.14.0-rc3-4.g1d0217b-desktop
```

Let's install DRBD, openSUSE's drbd trails behind what is currently in the linux kernel somewhat (v8.4.3) - the userland as of openSUSE 12.3 is v8.3.11 so I created a package to upgrade the userland to v8.4.3:

```sh
zypper ar http://download.opensuse.org/repositories/home:MylesGray/openSUSE_12.3/home:MylesGray.repo
zypper refresh #Yes - trust source
zypper in --from home_MylesGray drbd
```

That's nicely installed DRBD for you avoiding all those exceedingly annoying userland and kernel recompiling problems you'd otherwise have :)

Next up, install `targetcli` (again another package not in the openSUSE repo - i've added it to my build.opensuse.org repo):

```sh
zypper ar http://download.opensuse.org/repositories/home:/MylesGray:/targetcli/openSUSE_12.3/home:MylesGray:targetcli.repo
zypper refresh #Yes - trust source
```

Next we have to remove the OS versions of these libs - the lio-utils one seems broken as standard, as such we need to run:

```sh
zypper in --from home_MylesGray targetcli #select option 1 if prompted - Solution 1: deinstallation of patterns-openSUSE-minimal_base-conflicts
```

So that's `targetcli` and DRBD installed, lets configure drbd:

```sh
nano /etc/drbd.conf
```

Paste in the following:

```json
global {
        usage-count no;
}

common {
        protocol C;

        net {
                cram-hmac-alg sha1;
                shared-secret "abc123456789";
        }

        syncer {
                rate 750M;
        }
}

resource data0 {
        device /dev/drbd0;
        disk /dev/sda5;
        meta-disk internal;

        on atlas {
                address 10.0.5.2:7789;
        }
        on zeus {
                address 10.0.5.3:7789;
        }
}
```

Start up DRBD:

```sh
service drbd start
```

Bring resources up and make one node primary:

```sh
drbdadm primary --force all
drbdadm -- --overwrite-data-of-peer primary all
drbdadm up all
drbd-overview
```

Let's create our `lio-target` config:

```sh
targetcli
/>/backstores/iblock create data0 /dev/drbd0
/>/iscsi create
/>/iscsi/iqn..../tpg1/luns create /backstores/iblock/data0
/>/iscsi/iqn..../tpg1/portals create 10.0.5.2
/>saveconfig
/>exit
```

We should now be able to access our target from our ESXi hosts.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1021976
 [2]: https://twitter.com/mylesagray
