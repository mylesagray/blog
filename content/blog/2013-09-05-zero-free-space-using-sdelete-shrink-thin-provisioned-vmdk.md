---
title: Zero free space using SDelete to shrink Thin Provisioned VMDK
author: Myles Gray
type: post
date: 2013-09-05T08:38:21+00:00
url: /infrastructure/zero-free-space-using-sdelete-shrink-thin-provisioned-vmdk/
cover:
  image: /uploads/2013/11/Screen-Shot-2013-09-09-at-15.15.33.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1752023658
rop_post_url_twitter:
  - 'https://blah.cloud/infrastructure/zero-free-space-using-sdelete-shrink-thin-provisioned-vmdk/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Infrastructure
tags:
  - datastore
  - esxi
  - punchzero
  - sdelete
  - shell
  - vmdk
  - vmfs
  - vmware
  - vsphere

---
Some things should be simple, shrinking a thin provisioned virtual disk should be one of them, it's not. <span style="color: #ff0000;">N.B. This will just reduce the VMDK's usage on the VMFS datastore NOT resize the &#8220;provisioned size&#8221; of a thin disk.</span> To shrink a VMDK we can use an ESX command line tool &#8220;vmkfstools&#8221;, but first you have to zero out any free space on your thin provisioned disk.<!--more--> On Windows guests we can use the

[sysinternals tool SDelete][1] (replace the `[DRIVE:]` with the relevant Windows drive letter) <span style="color: #ff0000;">you must use <strong>v1.6 or later</strong>!</span>:

<pre class="prettyprint"><code>sdelete.exe -z [DRIVE:]</code></pre>

This will fill any unused space on the drive specified with zero-blocks.

<span style="color: #ff0000;">Caution: This operation will expand your thin-disk to its maximum size, ensure your datastore has the capacity to do this before you run this operation. </span> <span style="color: #ff0000;"><span style="color: #000000;"><strong>As of v1.6 <code>-c</code> and <code>-z</code> have changed meanings, many instructions say <code>-c</code> zeros free space, this is no longer the case, it zeros the space then fills with random data in accordance with DOD spec: DOD 5220.22-M, the trigger to zero space with <code>0x00</code> has changed to <code>-z</code>!</strong></span> </span> On linux guests use:

<pre class="prettyprint"><code>dd if=/dev/zero of=/[PATH]/zeroes bs=4096 && rm -f /[PATH]/zeroes</code></pre>

Again, replace

`[PATH]` with the relevant path to a location on the target storage device. Next we will shut down the guest OS and SSH into the ESX shell, once in the shell we need to navigate to the VMDK's datastore -> directory and we'll check the VM's actual size:

<pre class="prettyprint"><code>du -h [DISKNAME].vmdk</code></pre>

Punch all zeroed blocks out of the VMDK:

<pre class="prettyprint"><code>vmkfstools --punchzero [DISKNAME].vmdk</code></pre>

Check the size again (will now be less):

<pre class="prettyprint"><code>du -h [DISKNAME].vmdk</code></pre>

Of course, replace

`[DISKNAME]` with your VMDK's actual name. There we have it, all that free space, now reclaimed.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /uploads/2013/09/bb897443.aspx
 [2]: https://twitter.com/mylesagray