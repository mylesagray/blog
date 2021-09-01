---
title: Deploying OVA/OVF to remote vCenter using OVFTool
author: Myles Gray
type: post
date: 2014-11-23T16:05:24+00:00
url: /virtualisation/deploying-ovaovf-remote-vcenter-using-ovftool/
cover:
  image: /uploads/2014/11/Screen-Shot-2014-11-23-at-16.03.03.png
categories:
  - Virtualisation
tags:
  - ovftool
  - vmware

---
I had recently come across the need to deploy an OVA file remotely and didn't want to have to upload the file over VPN to the destination vCenter, the solution is to install [OVFTool][1] on a server that has local access to the vCenter and deploy it using the following syntax:

<!--more-->

    ovftool.exe --acceptAllEulas -ds="[DATASTORE NAME HERE]" --net:"NAME OF OVA NETWORK"="NAME OF PORT GROUP" --prop:[PROPNAME]=[Value] \path\to\appliance.ova vi://vcsa.domain.com/DatacenterName/host/ClusterName
    

The easiest way to get a list of objects you must reference for `--net` and `--prop` values is by running (in this example I am testing a vSphere Data Protection 5.8 0 `.ova`):

    ovftool.exe \path\to\appliance.ova
    

You will receive an output similar to the below:

    Download Size:  4.58 GB
    
    Deployment Sizes:
      Flat disks:   100.00 GB
      Sparse disks: 8.98 GB
    
    Networks:
      Name:        Isolated Network
      Description: The Isolated Network network
    
    Virtual Machines:
      Name:               vSphereDataProtection-0.0TB
      Operating System:   sles11_64guest
      Virtual Hardware:
        Families:         vmx-07
        Number of CPUs:   4
        Cores per socket: 1
        Memory:           4.00 GB
    
        Disks:
          Index:          0
          Instance ID:    11
          Capacity:       100.00 GB
          Disk Types:     SCSI-lsilogic
    
        NICs:
          Adapter Type:   VmxNet3
          Connection:     Isolated Network
    
    Properties:
      ClassId:     vami
      Key:         gateway
      InstanceId   vSphere_Data_Protection_5.8
      Category:    Networking Properties
      Label:       Default Gateway
      Type:        string
      Description: The default gateway address for this VM.
    
      ClassId:     vami
      Key:         DNS
      InstanceId   vSphere_Data_Protection_5.8
      Category:    Networking Properties
      Label:       DNS
      Type:        string
      Description: The domain name servers for this VM (comma
    
      ClassId:     vami
      Key:         ip0
      InstanceId   vSphere_Data_Protection_5.8
      Category:    Networking Properties
      Label:       Network 1 IP Address
      Type:        string
      Description: The IP address for this interface.
    
      ClassId:     vami
      Key:         netmask0
      InstanceId   vSphere_Data_Protection_5.8
      Category:    Networking Properties
      Label:       Network 1 Netmask
      Type:        string
      Description: The netmask or prefix for this interface.
    

We are interested in a few key items from the above:

    NICs:
      Adapter Type:   VmxNet3
      **Connection:     Isolated Network**
    

Our `--net` command would look like this for the above trigger:

    `--net:"Isolated Network"="{Port Group}"`
    

Where `{Port Group}` is the name of your vSwitch Port Group you wish to assign the appliance to.

From the `Properties` section in the output we can see there 4 `--prop` triggers we are interested in - our `--prop` triggers would be constructed of 3 variables from each of the `Properties` sections:

  * `ClassID`
  * `Key`
  * `InstanceID`

each `--prop` trigger is constructed like so:

    --prop:{ClassID}.{Key}.{InstanceID}={Value}
    

If we take `Default Gateway` as an example it would be constructed like so:

    --prop:vami.gateway.vSphere_Data_Protection_5.8=10.0.0.1
    

You will of course chain the `--prop` triggers one after another in the command line.

Given an example datacenter our fully constructed ovftool.exe deployment command would look like this:

    ovftool.exe --acceptAllEulas -ds="datastore1" \
    --net:"Isolated Network"="DMZ" \
    --prop:"vami.gateway.vSphere_Data_Protection_5.8"="10.0.2.1" \
    --prop:"vami.DNS.vSphere_Data_Protection_5.8"="10.0.1.254" \
    --prop:"vami.ip0.vSphere_Data_Protection_5.8"="10.0.2.150" \
    --prop:"vami.netmask0.vSphere_Data_Protection_5.8"="255.255.255.0" \
    \\nas\data\nfs\VMWare\vSphereDataProtection-5.8.ova \
    vi://vcsa.domain.com/datacentername/host/clustername
    

Enter username and password (in URL safe mode - substitute special characters like `/` or `!` for `%2F` or `%21`)

Deploy will run and show progress in CLI and vCenter

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: https://my.vmware.com/web/vmware/details?downloadGroup=OVFTOOL400&productId=353&src=vmw_so_vex_mgray_1080
 [2]: https://twitter.com/mylesagray