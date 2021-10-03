---
title: Installing MegaRAID Storage Manager on openSUSE
author: Myles Gray
type: posts
date: 2013-10-02T17:04:47+00:00
url: /hardware/installing-megaraid-storage-manager-opensuse/
categories:
  - Hardware
  - Infrastructure
tags:
  - openSUSE
---

## Introduction

Centrally managing your storage is nice - especially when you've just built your own SANs (or such). I created a synchronous replicating SAN cluster using LSI MegaRAID 9270-8i cards in 2x Dell R720XD chassis built on openSUSE 12.3 (more on that in another article soon).

We are migrating from 2x Dell MD3000i to these beasts built on a pure-cli OS. _Some people like GUIs and that's okay_ - so for day-to-day admin, email reporting on problems and basic configuration and tasks LSI offer **(free)** [MegaRAID Storage Manager][1]. It works much in the same way as [Dell's MD Storage Manager][2] that we currently use for the MD3000i but (obviously) without the ability to create iSCSI LUNs etc as they are managed by the OS, not the RAID card.

So, to get rolling we need to log into openSUSE, and `sudo bash` your way in there.

## Installing

We need to create a `temp` directory, download LSI MSM for Linux (x64) into it, extract it and install:

```bash
mkdir temp
cd temp/
wget "http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/13.08.04.01_Linux(64)_MSM.tar.gz"
tar zxvf 13.08.04.01_Linux(64)_MSM.tar.gz
cd disk/
```

We need to install `net-snmp` as a prerequisite:

```bash
zypper install net-snmp
```

Then go ahead and install MSM server agent (the component that reports back to the management client):

```bash
./install.csh -d
```

See below for complete trigger reference:

```bash
./install.csh -h
Usage : install.sh [-option]
The options are :
              a
                The Complete Installation of MegaRAID Storage Manager (MSM) 
              c
                The Client components only program of MSM
              s
                The StandAlone component of MSM
              l
                The Local component of MSM
              d
                The Server component of MSM
              au
                The upgrade only option for Complete MSM
              cu
                The upgrade only option for Client only MSM
              su
                The upgrade only option for Standalone MSM
              lu
                The upgrade only option for Local MSM
              du
                The upgrade only option for Server MSM
```

If all is well you'll see this:

```bash
./install.csh -d

....
Checking for any Old Version
No Old Version Found
Continuing with installation
Preparing...                          ################################# [100%]
Installing....
Updating / installing...
    1:Lib_Utils2-1.00-05               ################################# [100%]
Installing  MegaRAID_Storage_Manager-13.08.04-01
Preparing...                          ################################# [100%]
Installing....
Updating / installing...
    1:MegaRAID_Storage_Manager-13.08.04################################# [100%]
/
/
/
Starting Framework: 
Installing sas_ir_snmp-13.08-0401
Preparing...                          ################################# [100%]
Updating / installing...
    1:sas_ir_snmp-13.08-0401           ################################# [100%]
Starting snmpd
redirecting to systemctl  restart snmpd
Registering Service lsi_mrdsnmpd
lsi_mrdsnmpd              0:off  1:off  2:on   3:on   4:on   5:on   6:off
redirecting to systemctl  stop lsi_mrdsnmpd
Starting LSI SNMP Agent
redirecting to systemctl  start lsi_mrdsnmpd
```

Let's install the MSM Management GUI on our [Windows][3]/[Linux]x64[1] box, just run through the installer, this time you just need `client` installed.

## Managing Storage

Open up MegaRAID Storage Manager and click `Configure Host`, change the radio button to be `Display all systems in the network of local server` and press `Save Settings`. It will then scan your local network for hosts:

![Adding hosts][4]

Click the host and log in with your `root` account:

![Managing storage][5]

All the metrics, visuals and nice fancy views you could ever desire, along with the ability to manage and rebuild arrays, configure volume groups and all the stuff [listed here][6]. Enjoy!

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: https://docs.broadcom.com/docs/17.05.02.01_MSM_Linux-x64.zip
 [2]: https://www.dell.com/support/home/en-uk/drivers/DriversDetails?driverId=6H9V3
 [3]: https://docs.broadcom.com/docs/17.05.02.01_MSM_Windows.zip
 [4]: images/Screen-Shot-2013-10-02-at-17.47.19.png
 [5]: images/Screen-Shot-2013-10-02-at-17.54.46.png
 [6]: https://docs.broadcom.com/doc/12353341
 [7]: https://twitter.com/mylesagray