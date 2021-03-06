---
title: Safely check/remove orphaned VMDK files from ESXi
author: Myles Gray
type: posts
date: 2015-02-21T13:53:57+00:00
lastmod: 2021-10-25T11:24:00+00:00
description: "How to check if VMDKs are actively being used by a VM, and how to safely remove them."
url: /infrastructure/safely-checkremove-orphaned-vmdk-files-from-esxi
aliases: [ "/infrastructure/safely-checkremove-orphaned-vmdk-files-from-esxi/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2015-02-21-at-13.52.41.webp
  alt: "VM Snapshot UI"
categories:
  - Infrastructure
  - Virtualisation
tags:
  - esxi
  - orphaned
  - vmdk
  - vmfs
  - vmkfstools
  - VMware
  - vSphere
---

I have come across a number of environments where mystery "snapshot" files exist - they are not seen in snapshot manager, running a consolidation them doesn't help, creating a snapshot (with memory, or guest OS quiescing) then running "Delete All" doesn't resolve it, but some applications still think a snapshot is there.

To take care of these is quite a manual process after you have followed all the VMware KB advice:

* [VMware KB 2017072][1]
* [VMware KB 1023657][2]
* [VMware KB 1002310][3]

So we've done all the above, don't fancy doing a V2V to sort this as it shouldn't really be a problem in the first place.

First step is to find all snapshots and delta disks on the datastores:

```sh
# find /vmfs/volumes/ -name *-delta*;find /vmfs/volumes/ -name *-0000*
/vmfs/volumes/[id]/[VM]/VM-000002-delta.vmdk
/vmfs/volumes/[id]/[VM]/VM-000002.vmdk
/vmfs/volumes/[id]/[VM]/VM_1-000002-ctk.vmdk
/vmfs/volumes/[id]/[VM]/VM_1-000002-delta.vmdk
/vmfs/volumes/[id]/[VM]/VM_1-000002.vmdk
```

As you can see above there are 5 snapshot/tracking/vmdk files that are orphaned and we need to investigate.

The first step is to snapshot the VM above and then run delete all to see if VMware can clear them all down - re-run the check above, if they still exist it is quite possible they are orphaned.

To investigate further we can find out what vmdks are mounted by the vmx for that particular VM:

```sh
# cat /vmfs/volumes/[id]/[VM]/VM.vmx | grep vmdk
scsi0:0.fileName = "VM.vmdk"
scsi0:1.fileName = "VM_1.vmdk"
```

So this gives us all the vmdks mounted by the VM - we can then `cat` these files to check what underlying files on the datastore they reference (I have done one of the two disks as an example):

```sh
# cat VM_1.vmdk
# Disk DescriptorFile
version=3
encoding="UTF-8"
CID=IDHERE
parentCID=ffffffff
isNativeSnapshot="no"
createType="vmfs"

# Extent description
RW 220200960 VMFS "VM_1-flat.vmdk"

# Change Tracking File
changeTrackPath="VM_1-ctk.vmdk"
```

We are interested in the two sections from above "Extent description" and "Change Tracking File", from the above we can see the reference VMDKs files are:

```sh
VM_1-flat.vmdk
VM_1-ctk.vmdk
```

In the interests of completeness a `cat` of the other VMDK (`VM.vmdk`) showed the following were referenced:

```sh
VM-flat.vmdk
VM-ctk.vmdk
```

Check if the vmdk files are locked by any hosts, `-delta`, `-ctk` and `-flat` files should be locked when in active I/O use, descriptor files (just the `.vmdk` "meta" files) are not so you need to check all the files individually:

```sh
# vmkfstools -D VM-000002-delta.vmdk
Lock [type 10c00001 offset 39821312 v 23225, hb offset 3702784
gen 7489, mode 0, owner 00000000-00000000-0000-000000000000 mtime 2048078
num 0 gblnum 0 gblgen 0 gblbrk 0]
Addr <4, 66, 20>, gen 27, links 1, type reg, flags 0, uid 0, gid 0, mode 600
len 606, nb 0 tbz 0, cow 0, newSinceEpoch 0, zla 4305, bs 65536
```

If it was locked by an ESXi host the MAC of the host would be shown in the `owner` readout above - all zeros indicates no R/W lock. From the VMware docs:

> If the command `vmkfstools -D VM-000002-delta.vmdk` does not return a valid MAC address in the top field (returns all zeros ). Review the field below it, the `RO Owner` line below it to see which MAC address owns the read only/multi writer lock on the file.
>
> In some cases it is possible that it is a Service Console-based lock, an NFS lock or a lock generated by another system or product that can use or read VMFS file systems. The file is locked by a VMkernel child or cartel world and the offending host running the process/world must be rebooted to clear it.
>
> Once you have identified the host or backup tool (machine that owns the MAC) locking the file, power it off or stop the responsible service, then restart the management agents on the host running the virtual machine to release the lock.

So no references to our 5 mystery files - check the last time they were used by running:

```sh
# ls -ltr /vmfs/volumes/[id]/[VM]/ | grep vmdk
-rw-------    1 root     root      16863232 Nov  13 15:01 VM-000002-delta.vmdk
-rw-------    1 root     root           344 Nov  13 15:01 VM-000002.vmdk
-rw-------    1 root     root       6554112 Nov  13 15:01 VM_1-000002-ctk.vmdk
-rw-------    1 root     root      16986112 Nov  13 15:01 VM_1-000002-delta.vmdk
-rw-------    1 root     root           419 Nov  13 15:01 VM_1-000002.vmdk
-rw-------    1 root     root       2621952 Feb  5 22:01 VM-ctk.vmdk
-rw-------    1 root     root           612 Feb  5 22:01 VM_1.vmdk
-rw-------    1 root     root           606 Feb  5 22:01 VM.vmdk
-rw-------    1 root     root       6881792 Feb  5 22:01 VM_1-ctk.vmdk
-rw-------    1 root     root     42949672960 Feb  6 15:20 VM-flat.vmdk
-rw-------    1 root     root     112742891520 Feb  6 15:20 VM_1-flat.vmdk
```

As we can see above our orphaned files were last accessed almost 3 months previous.

Then make sure they are not locked by a process, `touch` them and see that the timestamp updates:

```sh
# touch /vmfs/volumes/[id]/[VM]/*-00000* | ls -ltr | grep vmdk
-rw-------    1 root     root           612 Feb  5 22:01 VM_1.vmdk
-rw-------    1 root     root           606 Feb  5 22:01 VM.vmdk
-rw-------    1 root     root       6881792 Feb  5 22:01 VM_1-ctk.vmdk
-rw-------    1 root     root       2621952 Feb  5 22:01 VM-ctk.vmdk
-rw-------    1 root     root     42949672960 Feb  6 15:29 VM-flat.vmdk
-rw-------    1 root     root           419 Feb  6 15:29 VM_1-000002.vmdk
-rw-------    1 root     root      16986112 Feb  6 15:29 VM_1-000002-delta.vmdk
-rw-------    1 root     root       6554112 Feb  6 15:29 VM_1-000002-ctk.vmdk
-rw-------    1 root     root     112742891520 Feb  6 15:29 VM_1-flat.vmdk
-rw-------    1 root     root           344 Feb  6 15:29 VM-000002.vmdk
-rw-------    1 root     root      16863232 Feb  6 15:29 VM-000002-delta.vmdk
```

Being able to `touch` the file, run `vmkfstools -D` finding no locks, find no references in vmdk descriptor files generally means it isn't in active use and is safe to move/remove, create a new create a new directory and move the suspect files to it and check for problems with the VM:

```sh
# mkdir oldfiles
# mv *-00000* oldfiles/.
```

If all looks well and you are happy the VM is operating normally delete the directory:

```sh
# rm -r oldfiles/
```

References:

* [VMware KB 10051][4]
* [VMware blog on vmkfstools][5]

Why not follow [@mylesagray on Twitter][6] for more like this!

 [1]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2017072
 [2]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1023657
 [3]: http://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1002310
 [4]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=10051
 [5]: http://blogs.vmware.com/vsphere/2012/08/some-useful-vmkfstools-hidden-options.html
 [6]: https://twitter.com/mylesagray