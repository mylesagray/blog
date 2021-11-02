---
title: LSI3108 based controllers now VSAN 6.2 Certified
author: Myles Gray
type: posts
date: 2016-04-29T09:22:23+00:00
url: /hardware/lsi3108-based-controllers-now-vsan-6-2-certified
aliases: [ "/hardware/lsi3108-based-controllers-now-vsan-6-2-certified/amp" ]
categories:
  - Hardware
  - Storage
tags:
  - LSI
  - storage
  - VMware
  - vsan
---

After a long an arduous certification and regression testing process following many problems with LSI 3108 based controllers that I have been using for VSAN they are finally VSAN 6.2 certified.

Having seen and opened multiple tickets about strange controller behaviors (hot add controller do VMware have released a FW/HW and Software combo that, according to a highly regarded VMware internal storage resource:

> Its certainly the most tested combination of a firmware/driver/controller ever at this point [...] My understanding is the reason this took so long is they didn’t just fix the big issue, but also minor ones too, and any minor regressions

I have been following a few VMware KBs with a keen eye in particular, it's worth giving these a read over so you are aware of all the intricacies involved:

_Certification of Dell PERC H730 and FD332-PERC Controllers with VSAN 6.x (2144614)_ [https://kb.vmware.com/selfservice/microsites/search.do?language=en\_US&cmd=displayKC&externalId=2144614][1]

_Required VSAN and ESXi configuration for controllers based on the LSI 3108 chipset (2144936)_ [https://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT\_KB\_1\_1&externalId=2144936][2]

And the HCL for the particular controller I am using (the Dell H730 mini): [http://www.vmware.com/resources/compatibility/detail.php?deviceCategory=vsanio&productid=34859][3]

![VSAN HCL][4]

It should be noted as well as upgrading the firmware and driver on the controller and VSAN hosts, the `diskIoTimeout` and `diskIoRetryFactor` advanced parameters should also still be implemented when rolling out with this controller from [this KB][2].

So, go forth and install, reap the benefits of VSAN 6.2 [of which there are many][5]!

Why not follow [@mylesagray on Twitter][6] for more like this!

 [1]: https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2144614
 [2]: https://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=2144936
 [3]: http://www.vmware.com/resources/compatibility/detail.php?deviceCategory=vsanio&productid=34859
 [4]: images/Image-1-1.png
 [5]: http://cormachogan.com/2016/02/10/vsan-6-2-an-overview-of-the-new-virtual-san-6-2-features/
 [6]: https://twitter.com/mylesagray