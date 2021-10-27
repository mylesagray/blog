---
title: Building a customised ESXi image for PXE installation
author: Myles Gray
type: posts
date: 2016-08-09T12:40:27+00:00
url: /infrastructure/building-customised-esxi-image-pxe-installation
aliases: [ "/infrastructure/building-customised-esxi-image-pxe-installation/amp" ]
cover:
  image: images/GUID-61B362E1-5350-4999-8874-264ABD687E50-high.png
categories:
  - Automation
  - Infrastructure
  - Virtualisation
tag:
  - esxi
  - imagebuilder
  - powercli
  - pxe
  - vmware
---

## Introduction

I have recently been working on a larger scale platform for my employer, it requires quick deployments of environments on VSAN with some standardised VIBs added in, initially we were doing this with a standard ESXi ISO install through iDRAC and then installing vCenter, vSphere Update Manager and pushing the VIBs to the hosts via that.

This is clearly a sub-optimal process and given our dedicated lab environment, we wanted to be able to spin up/down environments a bit more quickly - so we looked to optimising the install process and making production ready as the first step (as most people know, VSAN has some stringent HCL requirements when it comes to drivers and firmware).

PXE boot has always been traditional for larger scale deployments of kit and VMware very helpfully offer an installer customisation tool called [ImageBuilder][1], which is a PowerCLI module made to allow you to build customised images with VIBs/drivers and extensions slip-streamed into the install like you would do for large scale Windows deployments.

There are a few concepts in ImageBuilder,:

`VIBs` - which are driver/extensions for ESXi like you deploy with VUM/`esxcli` `ImageProfiles` - which are a collection of VIBs and components that make up an image `Depots` - A collection of `VIBs` and `ImageProfiles`

![ImageBuilder Overview][2]

So to get into it, you need [PowerCLI][3] installed (latest at time of writing is 6.3 Release 1) and an offline ESXi depot - you can get this from the ESXi download page:

![ESXi Offline Bundle Download][4]

I usually create a directory (`C:\Depot`) to house all the various components used in the image building process with the following folder structure:

![Image Builder Folder Structure][5]

So, put the offline depot you downloaded into the `Input` folder and drivers or VIBs to slipstream into the `VIBs` folder.

The next step has two ways, the easy way and the hard way - I initially did it the hard way before I learned of the other so let's start with that:

## The hard way (CLI)

Open up PowerCLI as Administrator and change your execution policy:

```powershell
Set-ExecutionPolicy Unrestricted
```

Next we are going to load up our `depot` into ImageBuilder:

```powershell
PowerCLI C:\Depot> Add-EsxSoftwareDepot -DepotUrl C:\Depot\Input\ESXi600-201601001.zip

Depot Url
---------
zip:C:\Depot\Input\ESXi600-201601001.zip?index.xml

PowerCLI C:\Depot>
```

We can run the below to view what packages are part of the depot and then pull back the existing image profiles:

```powershell
Get-EsxSoftwarePackage
Get-EsxImageProfile

Name                           Vendor          Last Modified   Acceptance Level
----                           ------          -------------   ----------------
ESXi-6.0.0-20160104001-stan... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160104001-no-t... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160101001s-sta... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160101001s-no-... VMware, Inc.    28/12/2015 2... PartnerSupported
```

If we run `Get-EsxImageProfile | fl` we can see the full readout of the Image Profiles:

```powershell
Name            : ESXi-6.0.0-20160104001-standard
Vendor          : VMware, Inc.
Author          :
Description     : For more information, see http://kb.vmware.com/kb/2135120.
CreationTime    : 28/12/2015 20:28:21
ModifiedTime    : 28/12/2015 20:28:21
ReadOnly        : False
VibList         : {ima-qla4xxx 2.02.18-1vmw.600.0.0.2494585, sata-sata-sil 2.3-4vmw.600.0.0.2494585, lpfc 10.2.309.8-2vmw.600.0.0.2494585, lsi-mr3 6.605.08.00-7vmw.600.1.17.3029758...}
AcceptanceLevel : PartnerSupported
Guid            : 8989d78eada111e594f10200ff6bd19a
Rules           :
StatelessReady  : True
```

For reference, there are 4 profiles in this depot the difference between two is fairly obvious - VMware tools in one, not in the other - however the difference between the `ESXi-6.0.0-20160104001` and `ESXi-6.0.0-20160104001s` designations is not so obvious, `s` as it turns out is a security patch release only you can check [patch releases vs builds here][6].

To view all packages in a particular image profile run:

```powershell
(Get-EsxImageProfile -Name "Image Name Here").VibList
```

So let's clone a profile to build out our customised image profile - I want the latest release standard build (with tools) so we're going to use `ESXi-6.0.0-20160104001-standard`:

```powershell
New-EsxImageProfile -CloneProfile ESXi-6.0.0-20160104001-standard -Name "ESXi-6.0.0-U1b-3380124-STC-Dell-Customised" -Vendor Your_Vendor_Name
```

And if we run `Get-EsxImageProfile` again we will see our new profile:

```powershell
Name                           Vendor          Last Modified   Acceptance Level
----                           ------          -------------   ----------------
ESXi-6.0.0-20160101001s-sta... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-U1b-3380124-STC-... Novosco         28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160104001-no-t... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160104001-stan... VMware, Inc.    28/12/2015 2... PartnerSupported
ESXi-6.0.0-20160101001s-no-... VMware, Inc.    28/12/2015 2... PartnerSupported
```

Now let's import each of the offline VIB packages into the depot (I find the best pace to get the up to date Dell VIBs [is here][7]):

```powershell
Add-EsxSoftwareDepot -DepotUrl C:\Depot\VIBs\VMW-ESX-6.0.0-lsi_mr3-6.903.85.00_MR-offline_bundle-3818071.zip
Add-EsxSoftwareDepot -DepotUrl C:\Depot\VIBs\OM-SrvAdmin-Dell-Web-8.3.0-1908.VIB-ESX60i_A00.zip
Add-EsxSoftwareDepot -DepotUrl C:\Depot\VIBs\ISM-Dell-Web-2.3.0-223.VIB-ESX60i_A00.zip
```

Now check the VIBs were added to the depot (scroll to the bottom for our newly added packages):

```powershell
Get-EsxSoftwarePackage | Sort-Object CreationDate | ft
.
.
.
iSM                      2.3.0.ESXi600-0000             Dell       14/02/2016 18...
OpenManage               8.3.0.ESXi600-0000             Dell       15/02/2016 06...
lsi-mr3                  6.903.85.00-1OEM.600.0.0.27... Avago      25/04/2016 16...
```

And add the VIBs to the image profile:

```powershell
Add-EsxSoftwarePackage -ImageProfile ESXi-6.0.0-U1b-3380124-STC-Dell-Customised -SoftwarePackage iSM
Add-EsxSoftwarePackage -ImageProfile ESXi-6.0.0-U1b-3380124-STC-Dell-Customised -SoftwarePackage OpenManage
Add-EsxSoftwarePackage -ImageProfile ESXi-6.0.0-U1b-3380124-STC-Dell-Customised -SoftwarePackage lsi-mr3
```

We obviously have duplicates of the `lsi-mr3` package as it comes with the offline bundle, but it would appear when we add as above it will add the latest version in the depot (ours). Let's verify the packages were added to our profile (review the bottom of the list - should match the above packages):

```powershell
(Get-EsxImageProfile -Name "ESXi-6.0.0-U1b-3380124-STC-Dell-Customised").VibList | Sort-Object CreationDate
```

Now we can export the image profile to an offline installer (for AutoDeploy/PXE) or an ISO for standard installation with the `-ExportToISO` trigger - I'm using this for PXE so offline bundle it is:

```powershell
Export-EsxImageProfile -ImageProfile ESXi-6.0.0-U1b-3380124-STC-Dell-Customised -ExportToBundle -FilePath C:\Depot\Output\ESXi-6.0.0-U1b-3380124-STC-Dell-Customised.zip
```

And we're done - it can now be extracted and used to PXE boot the hosts. But of course, there is the easy way...

## The easy way (Scripting)

As always, someone's made it easier - go and download the ESXi-Customiser-PS script from here: <http://www.v-front.de/p/esxi-customizer-ps.html#download>

Leave the folder structure as above and `cd C:\Depot` (assuming you placed the script here), i'm also asuming you have an offline bundle downloaded to the `Input` directory and all your VIBs are downloaded and in the `VIBs` directory - now run:

```powershell
.\ESXi-Customizer-PS-v2.4.ps1 -izip C:\Depot\Input\ESXi600-201601001.zip -pkgDir C:\Depot\VIBs\ -ozip  C:\Depot\Output\
```

This takes our input offline bundle, adds all VIBs in a directory to it and outputs to the Output directory as per output below:

```powershell
Script to build a customized ESXi installation ISO or Offline bundle using the VMware PowerCLI ImageBuilder snapin
(Call with -help for instructions)

Logging to C:\Users\mgray\AppData\Local\Temp\ESXi-Customizer-PS.log ...

Running with PowerShell version 5.1 and VMware vSphere PowerCLI 6.3 Release 1 build 3737840

Adding base Offline bundle .\Input\ESXi600-201601001.zip ... [OK]

Getting Imageprofiles, please wait ... [OK]

Using Imageprofile ESXi-6.0.0-20160104001-standard ...
(dated 12/28/2015 20:28:21, AcceptanceLevel: PartnerSupported,
For more information, see http://kb.vmware.com/kb/2135120.)

Loading Offline bundles and VIB files from .\VIBs\ ...
   Loading C:\Depot\VIBs\ISM-Dell-Web-2.3.0-223.VIB-ESX60i_A00.zip ... [OK]
      Add VIB iSM 2.3.0.ESXi600-0000 [OK, added]
   Loading C:\Depot\VIBs\OM-SrvAdmin-Dell-Web-8.3.0-1908.VIB-ESX60i_A00.zip ... [OK]
      Add VIB OpenManage 8.3.0.ESXi600-0000 [OK, added]
   Loading C:\Depot\VIBs\VMW-ESX-6.0.0-lsi_mr3-6.903.85.00_MR-offline_bundle-3818071.zip ... [OK]
      Add VIB lsi-mr3 6.903.85.00-1OEM.600.0.0.2768847 [OK, replaced 6.605.08.00-7vmw.600.1.17.3029758]

Exporting the Imageprofile to 'C:\Depot\Output\\ESXi-6.0.0-20160104001-standard-customized.zip'. Please be patient ...


All done.
```

And that's it for the easy way, fully patched offline bundle ready for deploy - I know what i'm doing in future! :)

I have an article on enabling the [PXE boot options on Fortigate][8] that is largely uniform with other platforms too.

Why not follow [@mylesagray on Twitter][9] for more like this!

 [1]: https://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.vsphere.install.doc/GUID-C84C5113-3111-4A27-9096-D61EED29EF45.html
 [2]: images/GUID-61B362E1-5350-4999-8874-264ABD687E50-high.png
 [3]: https://www.vmware.com/support/developer/PowerCLI/
 [4]: images/Image-2.png
 [5]: images/Image-3.png
 [6]: https://esxi-patches.v-front.de/ESXi-6.0.0.html
 [7]: http://poweredgec.com/latest_poweredge-13g.html
 [8]: /infrastructure/enabling-pxe-boot-options-fortigate-dhcp/
 [9]: https://twitter.com/mylesagray
