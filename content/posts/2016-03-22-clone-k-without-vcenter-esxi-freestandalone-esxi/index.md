---
title: Clone VMDK without vCenter (ESXi Free/Standalone ESXi)
author: Myles Gray
type: posts
date: 2016-03-22T09:27:59+00:00
lastmod: 2021-10-25T13:11:00+00:00
description: "How to clone a VMDK without a vCenter"
url: /infrastructure/clone-vmdk-without-vcenter-esxi-freestandalone-esxi
aliases: [ "/infrastructure/clone-vmdk-without-vcenter-esxi-freestandalone-esxi/amp" ]
cover:
  relative: true
  image: images/Image-4.png
  alt: "Cloning a VMDK via CLI"
categories:
  - Infrastructure
---

It's sometimes necessary to clone VMs when you don't have a vCenter, either because you plain don't have one in a small customer environment or you are doing a deploy and don't have vCenter deployed yet - you've created a template VM for Windows or such and want to roll out some DCs and management VMs before your vCenter deploy such that you have DNS etc.

Luckily there is a way to do this through the ESXi host directly, the method I use that I find effective is:

Copy the `.vmx` file over and rename it, also rename all entries inside it from the previous VM to the name of the new VM. Copy the `vmdk` over with `vmkfstools` as such:

```sh
vmkfstools -i /vmfs/volumes/dc1-r2-mgmt1-das/Windows2012R2-Template/Windows2012R2-Template.vmdk /vmfs/volumes/dc1-r2-mgmt1-das/dc1-mgmt-mgmt01/dc1-mgmt-mgmt01.vmdk -d zeroedthick
```

This will copy over the `.vmdk`, both the flat file and the metadata file - as we have already changed all the references in our `.vmx` we can now add the VM to inventory through the datastore browser (right click on `.vmzx` -> Add to Inventory), power on the VM - to see this prompt:

![Moved or Copied VM?][1]

We, of course, copied the VM, so click OK - this will adjust some settings in the vmx such that there are no duplicate properties such as MAC address across VMs.

The VM will now power on as a clone of the previous.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/Image-5.png
 [2]: https://twitter.com/mylesagray