---
title: Deploying Dell OpenManage on ESXi and vCenter 6
author: Myles Gray
type: posts
date: 2015-07-26T02:53:44+00:00
lastmod: 2021-10-25T12:37:00+00:00
description: "How to deploy and integrate Dell OMIVV with vCenter 6"
url: /hardware/deploying-dell-openmanage-on-esxi-and-vcenter-6
aliases: [ "/hardware/deploying-dell-openmanage-on-esxi-and-vcenter-6/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2015-07-26-at-03.52.55.png
  alt: "Dell OMIVV information in vSphere"
categories:
  - Hardware
  - Infrastructure
  - Virtualisation
tags:
  - dell
  - esxi
  - omivv
  - openmanage
  - update manger
  - vcenter
  - VMware
  - vSphere 6
  - vUM
---

If you've been reading my other posts of late, you will have gathered I've been building a new lab. I say "new", the last one was a single R710 with a ReadyNas Ultra 6 attached. So essentially, this is my first REAL lab.

It's mostly based on Dell hardware; it's cheap on eBay, I like their management tools and in the past i've only really had good experiences with them, granted it's no Cisco UCS, HP Bladesystem or Dell M1000e - I think with the addition of OpenManage, and in particular `OMIVV` it makes it _almost_ as manageable as those environments when you get the foundations laid down nice and solid.

It makes sense to try and integrate hardware infrastructure with the virtualisation infrastructure as much as possible, "single pane of glass" management is very much the thing at the moment, mainly because it makes life easier. I can see, in my normal operating environment, if there are hardware problems, have it trigger vMotion events, send up vCenter alarms, update firmware, all sorts of cool stuff - who _doesn't_ want this?

Luckily for me (totally based purchasing decisions around this) Dell have an offering called OpenManage, it's been in their line up for a **very** long time, but it's gone and gotten all modern and has a vCenter plugin and ESXi VIB installers for info gathering and reporting to the plugin.

OpenManage for vSphere is three discrete piece of software:

* A [VIB][1] to be deployed to each ESXi host (you have [vUM][2] [installed][3], right?)
* An [OpenManage Integration for VMware vCenter '.ova'][4] (provides vCenter plugin)
* The [OpenManage Web Server][5] (provides a windows-based web GUI for ESXi VIB agents)

So, to get the ball rolling, let's install the Windows component on a management machine that has access to the host management `VMkernel` ports, download the [OM Managed Node installer][5] from above and extract on your management box, navigate to extraction and run `setup.exe`, we want to see that the box we're installing it on supports the Web Server role:

![Web Server Role Installation][6]

Installation is a very Next, Next, Finish type thing, just blast through it then try navigating to `https://localhost:1311/`:

![Managed Node Login][7]

We obviously can't log in yet as we haven't installed the `VIB`s on the ESXi hosts, so let's get on that (if you don't have `vUM` installed, either set it up, or just [follow this VMware KB][8] on how to manually install ESXi `VIB`s, download the OpenManage `VIB` from above and apply the same procedure).

I'm going to assume you've already got your vCenter set up and plugged `VMware Update Manager` into it - so lets navigate to the C# client, select our cluster or hosts then go to:

`Update Manager` tab -> `Admin View` -> `Configuration` tab -> `Download Settings` menu item.

Now we should see the default VMware repositories in here, let's click `Add Download Source` and input this URL:

```sh
https://vmwaredepot.dell.com/index.xml
```

Add a description of your choosing and click `Validate URL` you should see the below:

![Dell VMware VIB Depot][9]

Click `Ok`, then `Apply` and finally `Download Now` to kick off VIB catalogue download.

If you go to the `Patch Repository` tab in `vUM` and add `6.0` to the filter box you should now see a few packages loaded from the Dell VIB Depot:

![Dell VIB Extensions][10]

Alright cool, so that all looks good, now, as I said before, I run Dell R710s in my lab, which come with iDRAC6 boards, so I can't use the fancy new `Dell iSM` to replicate log events into the OS or do automatic reboots etc, but the `OpenManage 8.1.0 VIB` will give me the functionality that I need regardless.

So let's create a Dell `Baseline`, navigate to `Baselines and Groups` and click `Create` on `Baseline`, name it `Dell OpenManage`, choose `Baseline Type` as `Host Extension`, On the next screen you want to choose the Dell `VIB`s that apply to you, I only need `OpenManage 8.1.0 for ESXi600` so I selected that and added to my `Baseline`, if you can run `iSM` then add that `VIB` in here too, finish off the creation of the `Baseline` then move back to `Compliance View`.

Click `Attach` and tick the `Dell OpenManage` `Extension Baseline` we just created and click `Scan`, check `Patches and Extensions` then click `Scan`.

Your hosts should now all show `Non-Compliant` in the `Extensions` field - this is fine, click `Remediate` choose the `Extension Baselines` option and check the `Dell OpenManage` option from before.

![Dell OpenManage VIB Baseline][11]

Choose the hosts you want to deploy it on check the `VIB`s to deploy and run through the options around remediation, choose what is best for your environment, it's always good to hit `Generate Report` to see any blockers before you run the remediation, go ahead and remediate. If you have DRS enabled you're Recent Tasks should look similar to this:

![VMware Update Manager DRS Migration][12]

Once they're remediated all hosts should show `compliant` against the `Dell OpenManage` baseline. We will now be able to connect to the hosts through the OpenManage Web Server we set up on `https://localhost:1311` before, just put in the host `vmk` management address, username and password:

![Dell OMSA Web Interface][13]

From here we can do things we can't in iDRAC - Manage storage rebuilds/disk replacements, view hardware and firmware revisions and if you've done what I have in the past and forgotten to put a `VLAN ID` into the iDRAC you can recover from a complete iDRAC disconnection by changing the settings in here - think of it as an _out of band for your out of band_.

Okay, so we're almost there, we can see some benefits already, however the vCenter plugin is where this solution really shines, so download the `.ova` from above, run the `Dell_OpenManage_Installation.exe` (just a zip extraction) and [deploy it][14] on your vCenter, once deployed and powered on it will run an initial setup procedure itself, this can take some time so be patient.

![Dell OMIVV Initial Startup][15]

When it's finally started up, you need to login as `admin` and will be asked for a password, then you'll see the following screen:

![Dell OMIVV Admin Interface][16]

You'll need to set up an IP to log into the appliance's web interface, from here we will also change change its' hostname and time config. Once you've done that, reboot the appliance.

Log on to the appliance's hostname/IP from your browser and we will set up vCenter Registration (this is the point at which the plugin will be installed), navigate to: `vCenter Registration` -> `Register a New vCenter`, fill in the details with those of your local vCenter and hit `Register`, if it's all gone well you'll see the below:

![OMIVV vCenter Registration Complete][17]

If you log in to the Web Client now, you'll see `A communication error has occurred` in the Dell Host Infromation sections, this is because we haven't configured auth for the vCenter plugin to the iDRACs.

Let's log into the vCenter Web Client and configure authentication for the host's iDRACs in the vCenter plugin. Navigate to `Home` -> `Administration` -> `OpenManage Integration`:

![OpenManage Integration][18]

Then click on `Start Initial Configuration Wizard`, it's fairly self explanatory, set up a Connection Profile for your hosts and test it against them (this needs to succeed before any useful info will be displayed), it will also ask you to create inventory and warranty scan schedules, I just use the defaults here.

I have my OMIVV to post virtualisation-related critical and warning events into vCenter and have enabled Enable Alarms for Dell Hosts to trigger automatic DRS migrations of VMs on critical host events.

![OMIVV Connection Profile][19]

Once you hit Finish the wizard will run the warranty and inventory checks:

![Dell OMIVV Inventory Job Running][20]

You will then see the inventory has run on the boxes you specified in the `Job Queue` section of OMIVV `Home` -> `Administration` -> `OpenManage Integration` -> `Monitor` -> `Job Queue`:

![OMIVV Job Queue][21]

Now if we navigate back to the `Hosts and Clusters` view and go to a host you should see something like the below:

![OpenManage Integration vCenter Tab][22]

My favourite utility here is the firmware updater option, from here you can view firmware and _update_ it directly from vCenter - this is pretty cool, what I tend to do is `Firmware Update` have it stage all firmware patches to the host and have it automatically install them on next restart - this is a _very_ cool feature. Of course, again, if you use DRS, just set it up to remediate immediately:

![Dell OMIVV Firmware Update][23]

Then review the recent tasks pane to view firmware updates:

![Update in progress OMIVV][24]

Luckily for you (not so for me), while writing this a DIMM died in one of my hosts, so we can see the vCenter alarms working as expected:

![Dell OMIVV vCenter Alarms][25]

And there we are, your vCenter is fully integrated with your physical host infrastructure and out-of-band management to give you full visibility.

Hope this helped, any questions, ask below, or indeed any suggestions too!

Why not follow [@mylesagray on Twitter][26] for more like this!

 [1]: http://www.dell.com/support/home/uk/en/ukdhs1/Drivers/DriversDetails?driverId=FN2KW
 [2]: http://www.vmwareandme.com/2015/02/How-to-Install-vSphere-Update-Manager-6.0-on-Windows-Server-2012-Windows-Server-2012-R2-step-by-step.html#.Va_OP5OrREc
 [3]: http://regimentalrogue.com/papers/egg.htm
 [4]: http://www.dell.com/support/home/uk/en/ukdhs1/Drivers/DriversDetails?driverId=8V0JG
 [5]: http://www.dell.com/support/home/uk/en/ukdhs1/Drivers/DriversDetails?driverId=20V28
 [6]: images/Screen-Shot-2015-07-22-at-18.42.12.png
 [7]: images/Screen-Shot-2015-07-22-at-18.51.19.png
 [8]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2008939
 [9]: images/Image-1.png
 [10]: images/Image-21.png
 [11]: images/Image-3.png
 [12]: images/Image-4.png
 [13]: images/Image-5.png
 [14]: http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.vsphere.vm_admin.doc/GUID-AFEDC48B-C96F-4088-9C1F-4F0A30E965DE.html?resultof=%2522%2564%2565%2570%256c%256f%2579%2522%2520%2522%2564%2565%2570%256c%256f%2569%2522%2520%2522%256f%2576%2566%2522%2520
 [15]: images/Image-6.png
 [16]: images/Image-8.png
 [17]: images/Image-10.png
 [18]: images/Screen-Shot-2015-07-26-at-01.40.01.png
 [19]: images/Screen-Shot-2015-07-26-at-01.47.19.png
 [20]: images/Screen-Shot-2015-07-26-at-03.08.31.png
 [21]: images/Screen-Shot-2015-07-26-at-03.10.54.png
 [22]: images/Screen-Shot-2015-07-26-at-03.12.04.png
 [23]: images/Screen-Shot-2015-07-26-at-03.14.14.png
 [24]: images/Screen-Shot-2015-07-23-at-22.16.54.png
 [25]: images/Screen-Shot-2015-07-23-at-22.56.25.png
 [26]: https://twitter.com/mylesagray
