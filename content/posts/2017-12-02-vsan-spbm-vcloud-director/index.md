---
title: vSAN SPBM and vCloud Director
author: Myles Gray
type: posts
date: 2017-12-02T13:31:36+00:00
url: /cloud/vsan-spbm-vcloud-director
aliases: [ "/cloud/vsan-spbm-vcloud-director/amp" ]
cover:
  image: images/Screenshot-2017-12-02-13.16.24.png
categories:
  - Infrastructure
  - Storage
  - Virtualisation
tag:
  - spbm
  - vcloud director
  - vmware
  - vsan
---

I had a question last week from [Bozo Popovic][1] during our EMEA field SE training session on vSAN operations relating to SPBM support for service providers that use vCloud Director in their environments.

{{< twitter 936169713637449728 >}}

I am stating this for clarity - since the vCD 9.0 release we have supported native SPBM compatibility for vCloud Director. SPBM policies can be adopted into vCD and assigned to PVDCs and to tenants via Org VDCs.

Within vCenter you create your SPBM policies as normal, you can see in my lab I have two vSAN policies: `vSAN Default Storage Policy` and `vSAN High Throughput`.

![vSAN SPBM Policies][2]

Moving to vCloud Director then, navigate to `Manage & Monitor -> vSphere Resources -> Storage Policies` and you will see your SPBM policies available listed here.

![SPBM Policies in vCD][3]

This is an obvious departure from the previous architecture of vCD datastores where tags were assigned to datastores and objects were placed directly on to them, as vSAN is a single datastore vCD required the awareness that objects on the same datastore could have different storage policies.

To assign resources to a PVDC in order to allow tenants access to the resource you need to navigate to `Manage & Monitor -> Cloud Resources -> Provider VDCs -> {Your PVDC} -> Storage Policies`.

![Storage Policies in Provider VDCs][4]

From here you click on the green `+` icon and select the relevant SPBM policy available in vCenter to have it utilised by the Provider VDC. You can now allocate this SPBM policy to the tenant Org VDCs that are children of the Provider VDC. Again, navigate to the Org VDC and go to the `Storage Policies` tab and click the green `+` icon to move a policy into the Org VDC for consumption by the tenant.

![Adding SPBM Policies to an Org VDC][5]

At this point the tenant can configure VMs with disparate SPBM policies for individual disks/the whole VM if they wish, during their provisioning cycle, or retrospectively change policies via the VM properties window in vCloud Director.

![VM SPBM Policy selection][6]

This includes changing from a traditional tag-based datastore to a vSAN based SPBM policy, which will automatically kick off a Storage vMotion in the background for that resource.

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: https://twitter.com/bozopopovic
 [2]: images/Screenshot-2017-12-02-13.10.25.png
 [3]: images/Screenshot-2017-12-02-13.13.29.png
 [4]: images/Screenshot-2017-12-02-13.16.24.png
 [5]: images/Screenshot-2017-12-02-13.20.14.png
 [6]: images/Screenshot-2017-12-02-13.24.52.png
 [7]: https://twitter.com/mylesagray
