---
title: Zero free space using SDelete to shrink Thin Provisioned VMDK
author: Myles Gray
type: posts
date: 2013-09-05T08:38:21+00:00
lastmod: 2021-09-02T14:20:00+00:00
url: /infrastructure/zero-free-space-using-sdelete-shrink-thin-provisioned-vmdk/
description: "Guide to show how to reclaim disk space by zeroing out free space on thin provisioned VMDKs using sdelete"
resources:
- name: "featured-image"
  src: images/Screen-Shot-2013-09-09-at-15.15.33.png
categories:
  - Infrastructure
tags:
  - datastore
  - esxi
  - punchzero
  - sdelete
  - shell
  - vmdk
  - vmfs
  - vmware
  - vsphere
---

## Introduction

Some things should be simple, shrinking a thin provisioned virtual disk should be one of them, it's not. _N.B. This will just reduce the VMDK's usage on the VMFS datastore NOT resize the "provisioned size" of a thin disk._

To shrink a VMDK we can use an ESX command line tool `vmkfstools`, but first you have to zero out any free space on your thin provisioned disk.

### Windows

On Windows guests we can use the [sysinternals tool SDelete][1] (replace the `[DRIVE:]` with the relevant Windows drive letter) _you must use **v1.6 or later**!_:

```powershell
sdelete.exe -z [DRIVE:]
```

This will fill any unused space on the drive specified with zero-blocks.

**Caution: This operation will expand your thin-disk to its maximum size, ensure your datastore has the capacity to do this before you run this operation.**

_**As of v1.6 `-c` and `-z` have changed meanings**, many instructions say `-c` zeros free space, this is no longer the case, it zeros the space then fills with random data in accordance with DOD spec: `DOD 5220.22-M`, the trigger to zero space with `0x00` has changed to `-z`!_

### Linux

On linux guests use:

```bash
dd if=/dev/zero of=/[PATH]/zeroes bs=4096 && rm -f /[PATH]/zeroes
```

Again, replace `[PATH]` with the relevant path to a location on the target storage device. Next we will shut down the guest OS and SSH into the ESX shell, once in the shell we need to navigate to the VMDK's datastore -> directory and we'll check the VM's actual size:

```bash
du -h [DISKNAME].vmdk
```

Punch all zeroed blocks out of the VMDK:

```bash
vmkfstools --punchzero [DISKNAME].vmdk
```

Check the size again (will now be less):

```bash
du -h [DISKNAME].vmdk
```

Of course, replace `[DISKNAME]` with your VMDK's actual name. There we have it, all that free space, now reclaimed.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: https://docs.microsoft.com/en-us/sysinternals/downloads/sdelete
 [2]: https://twitter.com/mylesagray