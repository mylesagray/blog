---
title: Fix for CBT bug in VMWare Products
author: Myles Gray
type: posts
date: 2014-12-02T18:00:13+00:00
url: /infrastructure/fix-cbt-bug-vmware-products/
cover:
  image: images/Image-11.png
categories:
  - Infrastructure
  - Virtualisation
  - Storage
tags:
  - CBT
  - vmdk
  - vmware
---

VMWare, as of writing, has a nasty bug that means your backups that run utilising CBT (hint: if you have basically any enterprise backup product worth its salt, it's got CBT enabled) it loses track of the changed blocks when the VMDK reaches any `Power 2` value of 128GB (128, 256, 512, 1024, etc.) which may make your backup unrecoverable.

The VMWare bug is in KB:

> [kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2090639][1]

The remedy for this is to disable and re-enable (reset) CBT on the affected machines, this can be done with the machine powered off or with it turned on by running PowerCLI commands and a snapshot, we will be doing the latter, [no one likes downtime][2]:

![XKCD Sysadmin](https://imgs.xkcd.com/comics/devotion_to_duty.png)

Download and install [VMWare PowerCLI][3] then run the following command:

```powershell
Connect-VIServer -Server {VC-Address}
```

Enter Username and Password when prompted. Should display output like below:

```powershell
Name            Port  User
----            ----  ----
vcsa.domain.com 443   username
```

The following will run and collect the VMs matching the conditions VMDK>=128GB and CBT enabled into the array `$vms`:

```powershell
[System.Collections.ArrayList]$vms = Get-VM| ?{$_.ExtensionData.Config.Hardware.Device.CapacityInKB -ge 128000000} | ?{$_.ExtensionData.Config.ChangeTrackingEnabled -eq $true}
```

To view the list of VMs run the following:

```powershell
echo $vms
```

You should get a nice list of VMs that match the conditions and likely need CBT reset:

```powershell
Name                 PowerState Num CPUs MemoryGB
----                 ---------- -------- --------
Machine1.domain... PoweredOn  4        8.000
Machine2.domain... PoweredOn  4        8.000
Machine3.domain... PoweredOn  2        6.000
```

To reset CBT on these machines while they are live you need to create a VM spec that disables CBT and apply it to the affected machines:

```powershell
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec; $spec.ChangeTrackingEnabled = $false;
```

To disable CBT on all VMs affected we then have to apply the `$spec` to each VM in the `$vms` array:

```powershell
foreach($vm in $vms){$vm.ExtensionData.ReconfigVM($spec);$snap=$vm | New-Snapshot -Name 'Disable CBT';$snap | Remove-Snapshot -confirm:$false;}
```

This will apply the `$spec` to each VM affected, take a snapshot then remove it to commit the CBT param to turn off.

![PowerCLI CBT Command][4]

To check if your command ran successfully run:

```powershell
get-vm | ?{$_.ExtensionData.Config.ChangeTrackingEnabled -eq $false}
```

This outputs a list of VMs with CBT disabled - you should see your full list of VMs from above here. If you are using a backup product that forces CBT to on, like Veeam, then you can leave it here, Veeam will re-enable CBT and run a full backup next time (because we have lost our CBT history).

However, if you run a product that doesn't do this you will need to let your backup run once then run the following command to enable CBT in the spec again and apply to the VMs:

```powershell
[System.Collections.ArrayList]$vms = Get-VM| ?{$_.ExtensionData.Config.Hardware.Device.CapacityInKB -ge 128000000} | ?{$_.ExtensionData.Config.ChangeTrackingEnabled -eq $false}
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec; $spec.ChangeTrackingEnabled = $true;
foreach($vm in $vms){$vm.ExtensionData.ReconfigVM($spec);$snap=$vm | New-Snapshot -Name 'Disable CBT';$snap | Remove-Snapshot -confirm:$false;}
```

This is subtly different than the first set of commands; of note are:

```powershell
.ChangeTrackingEnabled -eq $false
```

To only pull VMs with CBT disabled into the $vms array.

```powershell
$spec.ChangeTrackingEnabled = $true;
```

To enable CBT on machines rather than disable.

**This will resolve the problem until your machine crosses another `Power 2` border of 128GB when this will need run again.**

This bug is currently under research with VMWare and I am keeping an eye on the KB for updates on a hotfix available. Source for PowerShell code that has been adapted from: <http://www.veeam.com/kb1940>

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2090639&src=vmw_so_vex_mgray_1080
 [2]: http://xkcd.com/705/
 [3]: https://my.vmware.com/web/vmware/details?downloadGroup=PCLI58R1&productId=352&src=vmw_so_vex_mgray_1080
 [4]: images/Image-11.png
 [5]: https://twitter.com/mylesagray
