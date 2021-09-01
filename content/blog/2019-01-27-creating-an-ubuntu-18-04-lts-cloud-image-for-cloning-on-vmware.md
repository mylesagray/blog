---
title: Creating an Ubuntu 18.04 LTS cloud image for cloning on VMware
author: Myles Gray
type: post
date: 2019-01-27T23:15:11+00:00
url: /kubernetes/creating-an-ubuntu-18-04-lts-cloud-image-for-cloning-on-vmware/
cover:
  image: /uploads/2019/01/Screenshot-2019-01-27-22.07.55.png
wp-to-buffer-pro:
  - 'a:6:{s:14:"featured_image";s:4:"3886";s:8:"override";s:1:"0";s:7:"default";a:2:{s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:27:"Updated Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d71510133aa22a5e5d6a";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57fa3b89b069516f3f8b456d";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"58d8c52ae84fe7db7982a9b1";a:2:{s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}}'
switch_like_status:
  - 1
categories:
  - Cloud Frameworks
  - Featured
  - Infrastructure
  - Kubernetes
  - Software
  - Virtualisation
tags:
  - govc
  - govmomi
  - kubernetes
  - linux
  - powershell
  - templating
  - ubuntu
  - vmware
  - vsphere
series:
  - Kubernetes on vSphere

---
## Intro

I have been experimenting a lot over the past 18 months with containers and in particular, Kubernetes, and one of the core things I always seemed to get hung up on was part-zero - creating the VMs to actually run K8s. I wanted a CLI only way to build a VM template for the OS and then deploy that to the cluster.

It turns out that with Ubuntu 18.04 LTS (in particular the cloud image OVA) there are a few things need changed from the base install (namely `cloud-init`) in order to make them play nice with OS Guest Customisation in vCenter.

This post is a guide through making those changes.

## Prerequisites

### Tools

I am using macOS, so will be using the `brew` package manager to install and manage my tools, if you are using Linux or Windows, use the appropriate install guide for each tool, according to your OS.

For each tool I will list the `brew` install command and the link to the install instructions for other OSes.

  * brew 
      * <https://brew.sh>
  * Powershell - `brew tap caskroom/cask && brew cask install powershell` 
      * <https://github.com/PowerShell/PowerShell>
  * PowerCLI - `pwsh` then `Install-Module -Name VMware.PowerCLI -Scope CurrentUser` 
      * <https://code.vmware.com/web/dp/tool/vmware-powercli>
  * govc - `brew tap govmomi/tap/govc && brew install govmomi/tap/govc` 
      * <https://github.com/vmware/govmomi/tree/master/govc>

### Resources

We are going to need the Ubuntu 18.04 LTS Cloud image OVA from Canonical's repo downloaded to our local machine in order to extract the OVF specifications from it, the OVA can be found here:

  * <https://cloud-images.ubuntu.com/releases/18.04/release/ubuntu-18.04-server-cloudimg-amd64.ova>

## Setup

With the OVA downloaded, we need to configure a few variables for `govc` to connect to our vCenter, handily, rather than having to define them on the CLI for every command, we can just `export` them as variables to our current shell.

I created a file called `govcvars.sh` with the following content - create one for yourself filling in the relevant details:

<pre><code class="sh">$ cat govcvars.sh
export GOVC_INSECURE=1 # Don't verify SSL certs on vCenter
export GOVC_URL=10.198.17.84 # vCenter IP/FQDN
export GOVC_USERNAME=administrator@vsphere.local # vCenter username
export GOVC_PASSWORD=Admin\!23 # vCenter password
export GOVC_DATASTORE=vsanDatastore # Default datastore to deploy to
export GOVC_NETWORK="VM Network" # Default network to deploy to
export GOVC_RESOURCE_POOL='*/Resources' # Default resource pool to deploy to
</code></pre>

Next, we need to load the variables into our current shell session:

<pre><code class="sh">source govcvars.sh
</code></pre>

At this point we should be able to connect to and query our vCenter:

<pre><code class="sh">$ govc about
Name:         VMware vCenter Server
Vendor:       VMware, Inc.
Version:      6.7.0
Build:        10244857
OS type:      linux-x64
API type:     VirtualCenter
API version:  6.7.1
Product ID:   vpx
UUID:         1bd33d4e-555f-4d8b-9b77-8d155f612155
</code></pre>

## Building the image

### Extract the OVF spec from the OVA

Use `govc` to pull the OVF spec from the Ubuntu OVA we just downloaded, for customisation (this will output the spec to a file in your current directory called `ubuntu.json`):

<pre><code class="sh">govc import.spec ~/Downloads/ubuntu-18.04-server-cloudimg-amd64.ova | python -m json.tool &gt; ubuntu.json
</code></pre>

### Customise the OVF spec

I changed `hostname`, `public-keys`, `Password`, `Network` and `Name`. It is necessary to set `public-keys` as Ubuntu cloud images (which the OVAs are) only allow SSH key auth from first-boot - no password-only auth.

You can get your SSH public key by running `cat ~/.ssh/id_rsa.pub` - note if you run this command and you don't get an output - you probably need to generate an SSH key with `ssh-keygen`.

<pre><code class="sh">$ cat ubuntu.json
{
    "DiskProvisioning": "thin",
    "IPAllocationPolicy": "dhcpPolicy",
    "IPProtocol": "IPv4",
    "PropertyMapping": [
        {
            "Key": "instance-id",
            "Value": "id-ovf"
        },
        {
            "Key": "hostname",
            "Value": "Ubuntu1804Template"
        },
        {
            "Key": "seedfrom",
            "Value": ""
        },
        {
            "Key": "public-keys",
            "Value": "ssh-rsa [[[[[YOUR PUBLIC KEY]]]] mylesg@vmware.com"
        },
        {
            "Key": "user-data",
            "Value": ""
        },
        {
            "Key": "password",
            "Value": "VMware1!"
        }
    ],
    "NetworkMapping": [
        {
            "Name": "VM Network",
            "Network": "VM Network"
        }
    ],
    "MarkAsTemplate": false,
    "PowerOn": false,
    "InjectOvfEnv": false,
    "WaitForIP": false,
    "Name": "Ubuntu1804Template"
}
</code></pre>

### Deploy the OVA

Deploy the OVA with the customised OVF spec (you can pass the OVA URL to the below command instead of the file on your system, but it will first download to your local computer, then upload to the vCenter, it doesn't hand off the download operation so is no faster).

<pre><code class="sh">govc import.ova -options=ubuntu.json ~/Downloads/ubuntu-18.04-server-cloudimg-amd64.ova
</code></pre>

Change the VM size to 4 vCPUs, 4GB RAM, 60GB disk and set the `disk.enableUUID=1` flag (needed for disk identification from the vSphere Cloud Provider in Kubernetes)

<pre><code class="sh">govc vm.change -vm Ubuntu1804Template -c 4 -m 4096 -e="disk.enableUUID=1"
govc vm.disk.change -vm Ubuntu1804Template -disk.label "Hard disk 1" -size 60G
</code></pre>

Power on the VM

<pre><code class="sh">govc vm.power -on=true Ubuntu1804Template
</code></pre>

### Customise the VM for templating

Get the VM's IP address in order to SSH to it:

<pre><code class="sh">$ watch -n 10 govc vm.info Ubuntu1804Template
Name:           Ubuntu1804Template
  Path:         /vSAN-DC/vm/Discovered virtual machine/Ubuntu1804Template
  UUID:         42392966-8d21-ceda-5f23-28584c18703b
  Guest name:   Ubuntu Linux (64-bit)
  Memory:       1024MB
  CPU:          2 vCPU(s)
  Power state:  poweredOn
  Boot time:    2019-01-25 18:28:21.978093 +0000 UTC
  IP address:   10.198.17.85
  Host:         10.198.17.31
</code></pre>

SSH to the new guest VM (should auth automatically as you put in your SSH key above in the OVF spec) - you will be prompted to change your password:

<pre><code class="sh">ssh ubuntu@10.198.17.85
</code></pre>

SSH to the box again to re-auth and update apt

<pre><code class="sh">ssh ubuntu@10.198.17.85
sudo apt update
sudo apt install open-vm-tools -y
sudo apt upgrade -y
sudo apt autoremove -y
</code></pre>

We are going to disable `cloud-init` and instead rely on VMware Guest Customisation specs:

<pre><code class="sh"># cleans out all of the cloud-init cache, disable and remove cloud-init customisations
sudo cloud-init clean --logs
sudo touch /etc/cloud/cloud-init.disabled
sudo rm -rf /etc/netplan/50-cloud-init.yaml
sudo apt purge cloud-init -y
sudo apt autoremove -y
</code></pre>

We have to disable a few startup params and adjust the open-vm-tools startup order to allow customisation to work:

<pre><code class="sh"># Don't clear /tmp
sudo sed -i 's/D \/tmp 1777 root root -/#D \/tmp 1777 root root -/g' /usr/lib/tmpfiles.d/tmp.conf

# Remove cloud-init and rely on dbus for open-vm-tools
sudo sed -i 's/Before=cloud-init-local.service/After=dbus.service/g' /lib/systemd/system/open-vm-tools.service
</code></pre>

Cleanup the VM for templating

<pre><code class="sh"># cleanup current ssh keys so templated VMs get fresh key
sudo rm -f /etc/ssh/ssh_host_*

# add check for ssh keys on reboot...regenerate if neccessary
sudo tee /etc/rc.local &gt;/dev/null &lt;&lt;EOL
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#

# By default this script does nothing.
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# make the script executable
sudo chmod +x /etc/rc.local

# cleanup apt
sudo apt clean

# reset the machine-id (DHCP leases in 18.04 are generated based on this... not MAC...)
echo "" | sudo tee /etc/machine-id &gt;/dev/null

# disable swap for K8s
sudo swapoff --all
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# cleanup shell history and shutdown for templating
history -c
history -w
sudo shutdown -h now
</code></pre>

### Mark the VM as a template

Mark the VM as a template to so you can clone from it in vSphere:

<pre><code class="sh">govc vm.markastemplate Ubuntu1804Template
</code></pre>

## Define a VM Guest Customisation spec

VM Guest Customisation specs can't be created from `govc` right now [see here][1] for details - I have submitted some documentation for this features, so hopefully in future we won't need PowerShell or PowerCLI at all.

Start up PowerShell and create a guest customisation spec

<pre><code class="sh">pwsh
</code></pre>

<pre><code class="powershell">&gt; Connect-VIServer 10.198.17.160 -User administrator@vsphere.local -Password Admin!23
&gt; New-OSCustomizationSpec -Name Ubuntu -OSType Linux -DnsServer 10.198.16.1,10.198.16.2 -DnsSuffix satm.eng.vmware.com -Domain satm.eng.vmware.com -NamingScheme vm

Name                                         Description Type          OSType  LastUpdate           Server
----                                         ----------- ----          ------  ----------           ------
Ubuntu                                                   Persistent    Linux   27/01/2019 21:43:40  10.198.17.160

&gt; exit
</code></pre>

## Deploy some clones

Clone the Kubernetes VMs from this template using the `Ubuntu` customisation spec we just defined in order to customise the VM name, domain, DNS, etc.

<pre><code class="sh">govc vm.clone -vm Ubuntu1804Template -customization=Ubuntu  k8s-master
govc vm.clone -vm Ubuntu1804Template -customization=Ubuntu  k8s-worker1
govc vm.clone -vm Ubuntu1804Template -customization=Ubuntu  k8s-worker2
govc vm.clone -vm Ubuntu1804Template -customization=Ubuntu  k8s-worker3
</code></pre>

In a new terminal, watch for the VM IP addresses (refreshes every 30 seconds):

<pre><code class="sh">watch -n 30 "govc find / -type m -name 'k8s*' | xargs govc vm.info | grep 'Name:\|IP'"
</code></pre>

## End

That's it - you now have a base Ubuntu 18.04 LTS Cloud template to clone from - and as a bonus we've deployed four VMs from it for use in a Kubernetes cluster as part of the [next chapter][2]!

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: https://github.com/vmware/govmomi/issues/984
 [2]: /kubernetes/setting-up-k8s-and-the-vsphere-cloud-provider-using-kubeadm/
 [3]: https://twitter.com/mylesagray