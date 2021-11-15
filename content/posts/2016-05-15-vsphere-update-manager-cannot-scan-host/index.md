---
title: vSphere Update Manager – Cannot Scan Host
author: Myles Gray
type: posts
date: 2016-05-15T14:29:38+00:00
url: /virtualisation/vsphere-update-manager-cannot-scan-host
aliases: [ "/virtualisation/vsphere-update-manager-cannot-scan-host/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2016-05-15-at-15.26.34.webp
categories:
  - Infrastructure
  - Virtualisation
tags:
  - esxi
  - VMware
  - vSphere
  - VUM
---

I have been testing out [Runecast Analyzer][1] in my lab recently - it's pretty badass, you can set it up to scan your virtual infrastructure at a vCenter level and will scan your vC, VMs and hosts looking for KBs that may apply, security compliance and best practises.

![Runecast Analyzer][2]

As you can see my lab isn't exactly a model config when it comes to any of these things:

![Runecast Analyzer Best Practises][3]

It's really very cool, syslogging is also built in, if you add it as a syslog target to your hosts (RCA can do this automatically too) it will monitor the syslogs incoming and search the KB database for any matching problems - I actually found that some of my iSCSI paths weren't coming up after failover due to this!

So, this is all well and good, but why am I talking about Runecast? It is the thing that prompted my to look at the vSphere 6.0 U2 bug that relates to VMXNET3 adapters in [this KB][4] - I had vSphere Update Manager installed so decided to update as it is trivial.

Made sure VUM was using the latest patches with a "Download Now" and hit the vCenter root object, navigated to `Manage -> Update Manager` and scanned all objects against the attached baselines, all seemed to be going well then it bombed out at the end with `Could not scan host` and a little more digging (scanned an individual host) yielded `Error code: 99`.

So diving through the VUM logs on the Windows guest the agent was installed on at:

```powershell
C:\Users\All Users\VMware\VMware Update Manager\Logs
```

The log file we are concerned with is the latest available that matches the filename `vmware-vum-server-log4cpp.log` roughly, open it up in notepad++ or another text editor and run another scan in vCenter. We should be able to see a line similar to the one here:

```powershell
[2016-05-15 00:47:01:772 'SingleHostScanTask.SingleHostScanTask{14}' 4292 ERROR]  [singleHostScanTask, 399] SingleHostScan caught exception: 99 with code: 129
```

A few lines later we can see this:

```powershell
[2016-05-15 00:47:02:035 'HostUpdateDepotManager' 4016 ERROR]  [hostErrorHandler, 73] esxupdate error, version: 1.50, operation: Scan, host: mgmt01.lab.mylesgray.io, entityName: host-661
error code: 99, desc: Cannot merge VIBs Dell_bootbank_OpenManage_8.3.0.ESXi600-0000, Dell_bootbank_OpenManage_8.3.0.ESXi600-0000 with unequal payloads attributes: ([OpenManage: 7807.439 KB], [OpenManage: 7809.081 KB])
```

This is telling us exactly the reason why the scan cannot complete:

```powershell
Cannot merge VIBs Dell_bootbank_OpenManage_8.3.0.ESXi600-0000, Dell_bootbank_OpenManage_8.3.0.ESXi600-0000 with unequal payloads attributes
```

There is a [VMware KB for this behaviour here][5], it is also referenced on [Dell's forums][6] with no resolution.

So, to quickly fix the problem I reinitialised the VUM database by shutting down the VUM service on the Windows box, opening an elevated command prompt, navigating to the VUM installation folder and running the following command, [per this KB][7]:

```powershell
vciInstallUtils.exe -O dbcreate -C . -L .
```

I'm sure some of you are wondering, why not just remove the VUM Baseline I created for the Dell iSM and OMSA VIBs and re-scan?

I had of course tried this, but the patches still exist in the VUM repo, I had not found any concrete method for removing a patch from the VUM repo DB, so a nuke of the DB it was.

After that operation completed, I associated critical and non-critical patch baselines to the vCenter root object and re-scanned and success!

However, this did solve the initial goal (update `esx-base` on all hosts to account for the VMXNET3 adapter bug), but now we have a problem in that, I have the `Dell OMSA 8.3.0` VIB installed on all hosts already and would like to continue distributing this with VUM.

It would appear from the before threads I found that the VIB installed on the hosts and the VIB with the same patch ID pulled from the Dell VUM depot (<http://vmwaredepot.dell.com/index.xml>) were different as shown in the VUM logs on the agent Windows VM:

```powershell
unequal payloads attributes: ([OpenManage: 7807.439 KB], [OpenManage: 7809.081 KB])
```

The easiest solution I could think of to make the VIB compliant with the Dell VUM Depot was to just remove the VIB from each host manually with `esxcli`:

```sh
#find out what the VIB name is
[root@esxi01:~] esxcli software vib list | grep Dell
OpenManage                     8.3.0.ESXi600-0000                    Dell        PartnerSupported  2016-04-10
```

Now that we have the VIB name (`OpenManage`) we can remove it from the host:

```sh
#enter host into maint mode and allow DRS to vMotion VMs
[root@esxi01:~] esxcli system maintenanceMode set --enable true
#remove Dell OMSA 8.3.0 VIB
[root@esxi01:~] esxcli software vib remove --vibname=OpenManage
Removal Result
Message: The update completed successfully, but the system needs to be rebooted for the changes to be effective.
Reboot Required: true
VIBs Installed:
VIBs Removed: Dell_bootbank_OpenManage_8.3.0.ESXi600-0000
VIBs Skipped:
#reboot the host
[root@esxi01:~]reboot
```

When the host comes back up exit maint mode:

```sh
[root@esxi01:~] esxcli system maintenanceMode set --enable false
```

Add the Dell VUM Depot back into the VUM config, run "Download Now" to grab the patches:

![Dell VUM Depot][8]

Add to baseline:

![Dell VUM baseline][9]

Attach to the host we just removed the VIB from to test and run a rescan on it:

![VUM rescan][10]

Now that VUM is successfully rescanning the host we can again stage and remediate the host(s):

![Stage and remediate host with VUM][11]

Host comes back up and ran another re-scan there we have it:

![VUM rescan after reboot][12]

Hopefully this will help some poor souls out there who wasted time on this too!

Why not follow [@mylesagray on Twitter][13] for more like this!

 [1]: https://www.runecast.biz/
 [2]: images/Screen-Shot-2016-05-15-at-13.29.52.png
 [3]: images/Screen-Shot-2016-05-15-at-13.33.21.png
 [4]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2144968
 [5]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2107133
 [6]: http://en.community.dell.com/support-forums/servers/f/177/t/19697499
 [7]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2043170
 [8]: images/Screen-Shot-2016-05-15-at-14.54.23.png
 [9]: images/Screen-Shot-2016-05-15-at-14.58.27.png
 [10]: images/Screen-Shot-2016-05-15-at-15.00.16.png
 [11]: images/Screen-Shot-2016-05-15-at-15.01.37.png
 [12]: images/Screen-Shot-2016-05-15-at-15.26.34.png
 [13]: https://twitter.com/mylesagray
