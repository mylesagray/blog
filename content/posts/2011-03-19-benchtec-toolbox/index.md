---
title: BenchTec Toolbox
author: Myles Gray
type: posts
date: 2011-03-19T04:49:32+00:00
lastmod: 2021-09-02T13:02:00+00:00
url: /software/benchtec-toolbox/
description: "A brief overview of the BenchTech Toolbox, a tool for stripping out the Windows XP OS for benchmarking performance."
resources:
- name: "featured-image"
  src: images/ToolboxBig-1.png
categories:
  - Software Development
tags:
  - overclocking
---
A system optimizer primarily for stripped overclocking the Windows XP operating system, built in Visual Studio 2010 for Benchtec UK by Adrian (ARandomOWl) and I.

<!--more-->

[Download Benchtec Toolbox V1.5.1][1]

[Softpedia][2] Verified!

## Updates

### V1.5.1

* Added - Checkbox to change ALL other processes to low priority
* Added - Ability to set custom CDT file size
* Changed - Link on BTUK Logo
* To-Do - Add HWBot submission API (to submit results from desktop)
* To-Do - Add ability to change LOD for GTX4xx Series & V2xx.xx Drivers

### V1.5

* Fix - On Wazza the dialogues when Stabilization period was selected were in a strange order, now working okay
* Added - PCM05 - Transparency disable/enable tweak (System Tweaks section)
* Added - Screenshot - Save to dialogue to allow you to have them taken to a specific location

A system optimizer primarily for stripped overclocking operating systems.

## Features

### System Tweaks Dialogue

* Pagefile control – Allows users to set and view pagefile info as well as control the initial and max sizes of the file as well as the drive it is hosted on, If no pagefile exists or it is set by the system then it will alert you to this.
* Maxmem – Allows users to set maxmem in XP, Vista and Windows7 – If left at 0 MaxMem limit will be removed, anything above 0 and MaxMem will be applied with that value – XP MaxMem assumes that the benching OS is the first partition in the boot.ini file.
* Disable Unecessary Services – Does what is says on the tin.
* Enable Large System Cache – Checkbox indicates the current setting of this variable, If left blank LSC will be left/turned off, if it is checked it will be left/turned on.
* Disable Paging Executive – Checkbox indicates the current setting of this variable, If left blank PE will be left/turned off, if it is checked it will be left/turned on – (Thanks to Jabski for this tweak).
* Win32 Priority Separation – Checkbox indicates the current setting of this variable, If left blank Win32PS will be set a value of 2 (default), if it is checked it will be given a value of 26 – (Thanks to Jabski for this tweak)
* Other Handy System Tweaks – The app will auto detect your OS and apply tweaks from 2x tweaks for Vista/7 to 4x tweaks for XP – (Thanks to Jabski for this tweak).
* OPB Cleaner – Very handy “Junk” cleaner for all OS’s – safe to use on 24/7 OS

### Disable Cores

* If the number in the box = 0 then no cores are disabled and your settings are default.
* Type in a number to limit the CPU cores seen by the OS Then press the “Limit Cores To” Button to apply the change and restart on.prompt To return to default type in 0 and press the “Limit Cores To” button.

### WPrime

* Start WPrime Set number of threads Open WPrime Tuner Start Calculation.
* Once specified number of threads have been started press “Start WPrime Tweak” WPrime will now run at realtime priority.

### PiFast

* Start HexusPiFast.bat – With pause added at the start Check Processor Affinity if you want to have the thread run on one specific core.
* Input number of the core that you want pifast to run on.
* Press Enter on the PiFast CMD Window Press “Start PiFast Tweak” PiFast41.exe will now run in realtime priority with selected affinity.

### SuperPi

* Start SuperPi Check Processor Affinity if you want to have the thread run on one specific core.
* Input number of the core that you want SuperPi to run on.
* Choose Wazza method and its respetive variables of your choosing Press “Start SuperPi Tweak” SuperPi will now run in realtime priority with selected affinity.

### Screenshots

* Insert Filename (If you want to).
* Choose Format (.jpg or .png).
* Click “Take Screenshot” Screenshot saved in application’s directory.
* Application Shutdown: If box is checked then the app will shutdown as soon as tweak is applied If box is unchecked the app will post a message box when tweak is complete and will not shutdown.

### System Tweaks

* Edit all the values you want to change (or leave the ones that you want to be left unchanged).
* Press the “Apply System Tweaks” Button Restart on prompt (if necessary).

### OPB Cleaner

* Press “Run OPB Cleaner” Button Wait 2-3 mins up to 10 if you have a dirty drive

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: files/BenchTec_Toolbox.exe
 [2]: http://www.softpedia.com/progClean/BenchTec-Toolbox-Clean-165228.html
 [3]: https://twitter.com/mylesagray