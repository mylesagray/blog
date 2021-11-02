---
title: Removing orphaned IPs from NSX using REST API
author: Myles Gray
type: posts
date: 2017-08-19T18:40:03+00:00
url: /networks/removing-orphaned-ips-nsx-using-rest-api
aliases: [ "/networks/removing-orphaned-ips-nsx-using-rest-api/amp" ]
cover:
  relative: true
  image: images/Screenshot-2017-08-19-19.21.22.png
  hidden: true
categories:
  - Infrastructure
  - Networks
tags:
  - API
  - networking
  - nsx
  - VMware
---

I had a power outage recently that took out my entire lab in a very ungraceful manner - everything, well mostly everything, came back up without a hitch - but NSX was acting a bit weird, so I decided to redeploy the NSX Controllers.

I removed all 3 controllers and tried redeploying but ended up with the error "No IPs left in pool NSX-Controllers". If you're familiar with NSX, then you know when creating both controllers and VTEPs you're required to configure IP Pools in NSX Manager to allocate IP addresses from.

What has happened in this instance is, I removed the controllers, but for some reason, NSX Manager was not made aware of these changes and now the IPs are showing as used when in fact they're free - hence, orphaned.

I went API diving and found this could be resolved with a few calls in POSTman - if you don't fancy the [API PDF][1] in its 450-page glory, I recommend running [Platypus][2] in Docker on your workstation, or you can access a hosted version [here][3].

It provides a Swagger instance for a nice overview of the available APIs and their responses:

![Swagger API][4]

So, let's get down to it - you want to query the IPPool IDs on your instance:

```sh
GET https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/scope/globalroot-0
```

Then from the response body, we want the `objectId` associated with the `NSX-Controllers` IP Pool object:

```xml
<ipamAddressPools>
    <ipamAddressPool>
        <objectId>ipaddresspool-1</objectId>
        <objectTypeName>IpAddressPool</objectTypeName>
        <vsmUuid>421190C6-9A73-BBBC-B646-11767FC2B08D</vsmUuid>
        <nodeId>532eeed7-4e72-419b-84a2-6e9c212e1810</nodeId>
        <revision>1</revision>
        <type>
            <typeName>IpAddressPool</typeName>
        </type>
        <name>NSX-Controllers</name>
        ......
```

From this, we can query the "active" IP addresses in the pool (though you probably know these already):

```sh
GET https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/ipaddresspool-1/ipaddresses
```

And then we can delete each offending IP:

```sh
DELETE https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/ipaddresspool-1/ipaddresses/10.0.3.170
```

If successful you should now be able to re-deploy your controllers with the IP Pool as before and see the following output in POSTman for each `DELETE`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<boolean>true</boolean>
```

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: https://docs.vmware.com/en/VMware-NSX-for-vSphere/6.3/nsx_63_api.pdf?src=vmw_so_vex
 [2]: https://github.com/vmware/platypus
 [3]: http://vmwareapis.com/swagger.html
 [4]: images/Screenshot-2017-08-19-19.21.22.png
 [5]: https://twitter.com/mylesagray
