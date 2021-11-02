---
title: Configuring Auto Deploy Stateless Caching in vSphere 6.0
author: Myles Gray
type: posts
date: 2016-08-19T21:53:33+00:00
url: /automation/configuring-auto-deploy-stateless-caching-vsphere-6-0
aliases: [ "/automation/configuring-auto-deploy-stateless-caching-vsphere-6-0/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2016-08-19-at-22.39.12.png
categories:
  - Automation
  - Infrastructure
  - Virtualisation
tags:
  - autodeploy
  - automation
  - esxi
  - pxe
  - vSphere
---

Following on from my previous post on [configuring custom ESXi images for PXE deployment][1], it piqued my interest again in Auto Deploy, now that I have a lab large enough (enough physical failure domains) to justify auto-deploy I figured i'd give it another go. I have chosen to implement stateless caching as it will allow the hosts to boot from the last used ESXi image they had if the PxE/AutoDeploy server goes down - then when it comes back up will pull the new version, this accounts for a total infrastructure outage and still allows the hosts to be bootable.

So to start off with, i'm assuming you're using the vCenter Server Appliance and not a Windows based VC and you're on vCenter 6.0.

Let's go and start the Auto Deploy service on the vCenter Web UI, you're going to need to log in with a user with **@vsphere.local/SSO** permissions and navigate to `Administration -> System Configuration -> Services -> Auto Deploy` and click the `Actions` dropdown and `Edit Startup Type` and change to `Automatic`:

![Auto Deploy Edit Startup Type][2]

Now back into the `Action` menu and click `Start`. Now that the Auto Deploy service is started and set to start on every boot, we're ready to configure the service itself, to view the current config we need to move to `Home -> Hosts and Clusters` click your vCenter and click `Manage -> Settings -> Auto Deploy` and it should look similar to below:

![Auto Deploy configuration settings][3]

Click the link to `Download TFTP Boot File Zip` and extract - copy these files to the root of your PxE server `tftpboot` folder with FileZilla/your SFTP client of choice.

Now we need to configure our DHCP server to hand out options codes to tell clients where the TFTP server is and what the boot file is called:

* `66 - next-server` - IP address of the PxE server that you have previously spun up and copied the `TFTP Boot File Zip` contents to.
* `67 - filename` - In above picture `BIOS DHCP File Name`

I have [covered setting up DHCP options previously on a Fortigate][4] and there are plenty of guides out there for doing this on Linux/Windows so trust in your Google-fu. I'm just going to show you what my finished DHCP config looks like on a Fortigate (note `next-server` and `filename`):

```sh
config system dhcp server
    edit 2
        set dns-service default
        set ntp-service default
        set default-gateway 10.0.3.1
        set netmask 255.255.255.0
        set interface "MGMT"
            config ip-range
                edit 1
                    set start-ip 10.0.3.2
                    set end-ip 10.0.3.100
                next
            end
        set timezone-option default
        set next-server 10.0.3.189
        set filename "undionly.kpxe.vmw-hardwired"
    next
end
```

Now we should be in a position to boot the hosts and have them pick up the iPxE boot environment that we pushed to it earlier, however, at this stage it shouldn't run ESXi as we haven't created any Auto Deploy Rules or created an active Auto Deploy Rule Set.

For purposes of demonstration I've spun up some VMs in my lab with no OS to PXE boot - when you power on the hosts at this stage, you should see the below screen, if you don't you likely have a DHCP option problem or permissions problem on your `tftpboot` folder and it can't be read by `world`.

![Auto Deploy PxE Boot][5]

So once you're seeing the above we are good to build up our Auto Deploy rule set - you'll need [PowerCLI][6] installed as there is no native UI for building Auto Deploy Rules (yet...).

Open up PowerCLI, connect to the vCenter server that has the Auto Deploy service running and we will import an [offline ESXi bundle][7] to deploy our selected version of ESXi - if you want to create a customised image profile with particular VIBs pre-installed, [check my article on that here][1].

```powershell
Connect-VIServer vc01.lab.mylesgray.io
Add-ESXSoftwareDepot E:\DL\update-from-esxi6.0-6.0_update02.zip
```

Now we can get the `Name` field of the image profiles included

```powershell
Get-ESXImageProfile | fl
```

For this demo i'm going to use the latest image profile that includes VMware Tools `ESXi-6.0.0-20160302001-standard` - let's create our first Auto Deploy Rule (you can create other more specific ones based [on the patterns here][8] if you like and add them to the rule set):

```powershell
New-DeployRule -Name "InitialBootRule" -Item "ESXi-6.0.0-20160302001-standard" -AllHosts
```

This will kick off an upload of the image profile to the vCenter Server for provisioning to the hosts:

![Auto Deploy Rule Creation][9]

So all this has done is created the rule, it's not in the _active_ rule set yet, so won't apply to any booting hosts, we need to add the rule to part of the active rule set for it to apply to hosts:

```powershell
Add-DeployRule -DeployRule "InitialBootRule"
```

And we can run `Get-DeployRuleSet` to ensure the rules are part of the active set, if successful we should se it listed as so:

```powershell
PowerCLI C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI> Get-DeployRuleSet


Name        : InitialBootRule
PatternList :
ItemList    : {ESXi-6.0.0-20160301001s-standard}
```

Now as the host reboots we can see it boot the hypervisor from AutoDeploy:

![ESXi Boot from Auto Deploy][10]

So the host now boots into ESXi and joins vCenter, but is completely unconfigured and not very useful, the whole purpose of automating something like this is to for example, auto scale and IaaS cluster - especially one where the public can spin up VMs on demand.

With that in mind, let's build a host profile to get some standardised config on the go - I've set up the first host manually with some generic stuff (NTP, Power Profile, Keyboard type, etc) and have [extracted the host profile][11] (deselecting anything irrelevant) then, attached the Host Profile to the cluster Auto Deploy will be moving the hosts into - In my case, I created a cluster `TestClusterPleaseIgnore`.

![Host Profile attached to Cluster][12]

There is however one thing we need to change - Remember we said at the start we wanted the host to cache the image it pulls from Auto Deploy to disk in case of a PxE outage? Well, we do that in the host profile - the exact setting is in `Advanced Configuration Settings -> System Image Cache Configuration -> Enable stateless caching on the host`:

![Enable Stateless Caching on Host][13]

The other settings (`overwrite VMFS`, `ignore SSD` and the `first disk`) are up to you - however, just know the way I illustrated specifies the first disk with `ESXi` installed, followed by a `local` disk as the priority for storing the cached image.

Given we have got a cluster to adopt the hosts into and a host profile to provision and make the hosts useful (somewhat, [this rabbit hole goes deep][14] so spend time getting your host profile right) - we will update our Auto Deploy Rule to make it add all hosts into `TestClusterPleaseIgnore` and thus, automatically apply the Host Profile and make it production ready.

Let's remove the rule we created earlier from the active rule set (If you want to delete the rule altogether append with `-Delete`):

```powershell
Remove-DeployRule InitialBootRule
```

And create a new rule with multiple arguments in the `-Item` field to represent Image Profile and Cluster:

```powershell
New-DeployRule -Name "ProductionRule" -Item  "ESXi-6.0.0-20160302001-standard",TestClusterPleaseIgnore -AllHosts
```

This rule will boot _all hosts_ to the Image Profile we selected before, then, add them to the cluster `TestClusterPleaseIgnore` which will in turn attach the host profile to the host on bootup.

We now need to add the rule to our active rule set to deploy it:

```powershell
Add-DeployRule ProductionRule
Get-DeployRuleSet
```

And that's it, reboot the host and it should boot into ESXi, apply customisations and join the cluster.

![Applying host profile customisations][15]

In the words of [Tag Team, "Whoomp, There it is"][16].

![Host adopted into cluster][17]

If you have any suggestions for further customisations or nice scenarios you have used Auto Deploy in, I'd love to hear about them in the comments!

Why not follow [@mylesagray on Twitter][18] for more like this!

 [1]: /infrastructure/building-customised-esxi-image-pxe-installation/
 [2]: images/Image-5.png
 [3]: images/Image-6.png
 [4]: /infrastructure/enabling-pxe-boot-options-fortigate-dhcp/
 [5]: images/PxE-Boot.gif
 [6]: https://www.vmware.com/support/developer/PowerCLI/
 [7]: https://my.vmware.com/web/vmware/details?productId=491&downloadGroup=ESXI60U2
 [8]: http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.vsphere.install.doc/GUID-3521CBAC-8819-489D-A10A-93397E332C9A.html
 [9]: images/2016-08-19_21-28-01.gif
 [10]: images/Screen-Shot-2016-08-19-at-21.48.09.png
 [11]: http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.vsphere.install.doc/GUID-4D8EDD07-6C77-4845-8F0E-A0F4C9102840.html
 [12]: images/Screen-Shot-2016-08-19-at-22.14.04.png
 [13]: images/Screen-Shot-2016-08-19-at-22.31.45.png
 [14]: https://pubs.vmware.com/vsphere-60/topic/com.vmware.ICbase/PDF/vsphere-esxi-vcenter-server-60-host-profiles-guide.pdf
 [15]: images/Screen-Shot-2016-08-19-at-22.37.21.png
 [16]: https://youtu.be/Z-FPimCmbX8?t=46
 [17]: images/Screen-Shot-2016-08-19-at-22.39.12.png
 [18]: https://twitter.com/mylesagray
