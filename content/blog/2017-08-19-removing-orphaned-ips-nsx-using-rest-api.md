---
title: Removing orphaned IPs from NSX using REST API
author: Myles Gray
type: post
date: 2017-08-19T18:40:03+00:00
url: /networks/removing-orphaned-ips-nsx-using-rest-api/
cover:
  image: /uploads/2017/08/Screenshot-2017-08-19-19.21.22.png
wp-to-buffer-pro:
  - 'a:8:{s:14:"featured_image";s:4:"3007";s:8:"override";s:1:"0";s:7:"default";a:2:{s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:23:"New Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:27:"Updated Post: {title} {url}";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d5b716368246123c6ae8";a:4:{s:7:"enabled";s:1:"1";s:8:"override";s:1:"1";s:7:"publish";a:2:{s:7:"enabled";s:1:"1";s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"1";s:11:"sub_profile";i:0;s:7:"message";s:32:"New Post: {title} {url} #vExpert";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d71510133aa22a5e5d6a";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d761163682ce153c6ae4";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57f8d77316368280153c6ae4";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";s:1:"0";s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}s:24:"57fa3b89b069516f3f8b456d";a:3:{s:7:"enabled";s:1:"1";s:7:"publish";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}s:6:"update";a:1:{s:6:"status";a:1:{i:0;a:11:{s:5:"image";i:0;s:11:"sub_profile";i:0;s:7:"message";s:0:"";s:8:"schedule";s:12:"queue_bottom";s:4:"days";s:1:"0";s:5:"hours";s:1:"0";s:7:"minutes";s:1:"0";s:26:"schedule_custom_field_name";s:0:"";s:30:"schedule_custom_field_relation";s:5:"after";s:10:"conditions";a:3:{s:8:"category";s:0:"";s:8:"post_tag";s:0:"";s:6:"course";s:0:"";}s:5:"terms";a:3:{s:8:"category";a:1:{i:0;s:0:"";}s:8:"post_tag";a:1:{i:0;s:0:"";}s:6:"course";a:1:{i:0;s:0:"";}}}}}}}'
categories:
  - Infrastructure
  - Networks
tags:
  - API
  - networking
  - nsx
  - vmware

---
I had a power outage recently that took out my entire lab in a very ungraceful manner - everything, well mostly everything, came back up without a hitch - but NSX was acting a bit weird, so I decided to redeploy the NSX Controllers.

I removed all 3 controllers and tried redeploying but ended up with the error &#8220;No IPs left in pool NSX-Controllers&#8221;. If you're familiar with NSX, then you know when creating both controllers and VTEPs you're required to configure IP Pools in NSX Manager to allocate IP addresses from.

What has happened in this instance is, I removed the controllers, but for some reason, NSX Manager was not made aware of these changes and now the IPs are showing as used when in fact they're free - hence, orphaned.

I went API diving and found this could be resolved with a few calls in POSTman - if you don't fancy the [API PDF][1] in its 450-page glory, I recommend running [Platypus][2] in Docker on your workstation, or you can access a hosted version [here][3].

It provides a Swagger instance for a nice overview of the available APIs and their responses:

![Swagger API][4] 

So, let's get down to it - you want to query the IPPool IDs on your instance:

    GET https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/scope/globalroot-0
    

Then from the response body, we want the `objectId` associated with the `NSX-Controllers` IP Pool object:

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
    

From this, we can query the &#8220;active&#8221; IP addresses in the pool (though you probably know these already):

    GET https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/ipaddresspool-1/ipaddresses
    

And then we can delete each offending IP:

    DELETE https://{{nsxmanagerIP}}/api/2.0/services/ipam/pools/ipaddresspool-1/ipaddresses/10.0.3.170
    

If successful you should now be able to re-deploy your controllers with the IP Pool as before and see the following output in POSTman for each `DELETE`:

    <?xml version="1.0" encoding="UTF-8"?>
    <boolean>true</boolean>
    

Why not follow [@mylesagray on Twitter][5] for more like this!

 [1]: https://docs.vmware.com/en/VMware-NSX-for-vSphere/6.3/nsx_63_api.pdf?src=vmw_so_vex
 [2]: https://github.com/vmware/platypus
 [3]: http://vmwareapis.com/swagger.html
 [4]: /uploads/2017/08/Screenshot-2017-08-19-19.21.22-740x498.png
 [5]: https://twitter.com/mylesagray