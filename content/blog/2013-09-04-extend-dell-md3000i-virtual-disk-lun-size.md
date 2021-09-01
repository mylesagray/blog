---
title: Extend Dell MD3000i Virtual Disk LUN Size
author: Myles Gray
type: post
date: 2013-09-04T12:54:14+00:00
url: /hardware/extend-dell-md3000i-virtual-disk-lun-size/
cover:
  image: /uploads/2013/11/Screen-Shot-2013-09-09-at-15.08.56.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1752023973
rop_post_url_twitter:
  - 'https://blah.cloud/hardware/extend-dell-md3000i-virtual-disk-lun-size/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Hardware
  - Infrastructure
tags:
  - datastore
  - dell
  - esxi
  - lun
  - md3000i
  - san
  - vcenter
  - vmdk
  - vmfs-5
  - vsphere

---
I have had the need recently to expand a LUN on a Dell MD3000i SAN to above 2TB that is presented to VMWare ESX 5.1 hosts. There are a few caveats here:<!--more-->

  * The VMWare datastore for 2TB+ LUNs _must_ be VMFS-5 as it is now GPT based, not MBR. - This can be updated on the fly without shutting down VMs **(Configuration -> Storage, Click the Datastore -> &#8220;Upgrade to VMFS-5&#8221;)**

<img class="size-full wp-image-639 aligncenter" alt="Convert to VMFS-5" src="https://blah.cloud/wp-content/uploads/2013/11/Screen-Shot-2013-09-05-at-13.44.15.png" /> * Expanding the virtual disks on MD3000i's can only be done in CLI. First, add your new physical disks to the box and add them to the appropriate RAID volume group. Next, you will be presented your space as &#8220;Free Capacity&#8221; - copy down the size of this in GB.

<img class="aligncenter size-full wp-image-589" alt="MD3000i Storage Manager" src="https://blah.cloud/wp-content/uploads/2013/11/Screen-Shot-2013-09-04-at-13.53.36.png" /> [Convert GB to Bytes here][1] On the computer running MD Storage Manager open cmd and navigate to:

    C:Program FilesDellMD Storage ManagerClient
    

The command you need to run is:

    SMCli.exe [your.san.ip.address] -c "set VirtualDisk ["[VDNAME]"] addCapacity=XXXXXXXXXX;" -p [password]
    

Of course, replace the &#91;your.san.ip.address], [password], [VDNAME&#93; (of the disk you wish to expand) and XXXXXXXXX capacity (in Bytes) to those appropriate to you. You'll see the following output if the command runs successfully:

    Performing syntax check...
    
    Syntax check complete.
    
    Executing script...
    
    Script execution complete.
    
    SMcli completed successfully.
    

You can then watch your initialisation progress with (follow same replacements as above):

    SMCli.exe [your.san.ip.address] -c "show VirtualDisk ["[VDNAME]"] actionprogress;" -p [password]
    

_Sorry to all my linux friends - Dell don't let you SSH into the box - you'll have to use a VM :(_ You can then go back to VSphere Client and choose your datastore - **Right click, Properties -> Increase  -> Choose the LUN** you just expanded, expand VMFS to maximum size available, Finish, your datastore is now expanded.<img class="aligncenter size-full wp-image-644" alt="Increase VMFS File" src="https://blah.cloud/wp-content/uploads/2013/11/Screen-Shot-2013-09-05-at-13.46.02.png" /> All the above can be done on a live system - though due to the I/O from the volume initialization and inherent risks make sure you have backups and that you do this after hours ;)

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /uploads/2013/09/byteconverter.htm
 [2]: https://twitter.com/mylesagray