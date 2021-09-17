---
title: Using VMWare’s OVFTool to convert VMX to OVA
author: Myles Gray
type: posts
date: 2014-02-10T01:06:06+00:00
url: /virtualisation/using-vmwares-ovftool-convert-vmx-ova/
resources:
- name: "featured-image"
  src: images/Screen-Shot-2014-02-10-at-01.05.42.png
categories:
  - Virtualisation
tags:
  - ova
  - ovftool
  - vmware
---

It's sometimes necessary (say you've been working on a VM on your local workstation in either VMWare Fusion, or VMWare Workstation) to move the VM you've been playing with to an ESXi instance to either move into development or to have it properly backed up etc.

The easiest way I find to do this is create a `.ova` file from the VM i've been working on.

First install the VMWare OVATool found here on whatever flavour your OS is (sign in required): https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL350&productId=352

Once it's running, navigate to the install folder (i'm using OSX, if you use Windows I assume it's installed in the system path and you can execute it directly from any directory) and the syntax is as follows:

    ./ovftool [original .vmx location and filename] [new .ova location and filename]
    

So in my case I was working on the wonderful [YubiX authentication virtual appliance][1]:

    ./ovftool ~/Documents/vms/yubix.vmx ~/Documents/vms/yubix.ova
    

The output will be somewhat similar to the below:

    graym$ ./ovftool ~/Documents/vms/yubix.vmx ~/Documents/vms/yubix.ova
    Opening VMX source: /Users/graym/Documents/vms/yubix.vmx
    Opening OVA target: /Users/graym/Documents/vms/yubix.ova
    Writing OVA package: /Users/graym/Documents/vms/yubix.ova
    Transfer Completed                    
    Completed successfully
    

Then I just used the deploy OVF Template wizard in vSphere Web Client.

![VMWare Deploy OVF Template][2] 

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: http://opensource.yubico.com/yubix-vm/
 [2]: images/Screen-Shot-2014-02-10-at-01.05.42.png
 [3]: https://twitter.com/mylesagray