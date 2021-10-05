---
title: vCloud Director console proxy and UI on a single interface
author: Myles Gray
type: posts
date: 2017-08-20T17:09:08+00:00
url: /cloud/vcloud-director-console-proxy-ui-single-ip/
cover:
  image: images/Screenshot-2017-08-20-17.54.09.png
categories:
  - Infrastructure
  - Virtualisation
tags:
  - load-balancing
  - vcloud director
  - vmware
---

I was recently rebuilding part of my lab infrastructure, and as part of it, I wanted to migrate my vCD cells from two IPs each to a single IP (as this feature was added in [vCD 8.10][1]) for both the web UI and the console proxy.

It simplifies provisioning, potential routing problems, and load-balancer configuration by having a single IP but separate ports for each service. Adding both services to a single IP is not new, Tomas Fjota [wrote about it here][2], however, there was some detail missing from his article to allow it to work behind a load-balancer.

So, first up I am going to assume you already have both your vCD cells up and operational as from the install guide. Now we are going to quiesce the cells and shut them down:

    cd /opt/vmware/vcloud-director/bin/
    ./cell-management-tool -u administrator cell --quiesce true
    ./cell-management-tool -u administrator cell --shutdown
    

Now we need to edit the `global.properties` file:

    nano /opt/vmware/vcloud-director/etc/global.properties
    

In here we will change the existing lines:

    vcloud.cell.ip.primary = 10.0.3.229
    consoleproxy.host.https = 10.0.3.231
    

To the same IP as each other:

    vcloud.cell.ip.primary = 10.0.3.229
    consoleproxy.host.https = 10.0.3.229
    

And add the following to the bottom of the file (insert your external load-balanced address for the last property):

    consoleproxy.port.https = 8443
    vcloud.http.port.standard = 80
    vcloud.http.port.ssl = 443
    consoleproxy.external.address = vcd-prx.mylesgray.io:8443
    

You might be wondering about the `consoleproxy.external.address` property, you can set the console address in the vCD UI - so why add it here, right? Because if you try to add it in the UI, you get this error:

![vCD Console Proxy address error][3] 

However, if we add it in our `global.properties` file, then restart the cells we can avoid the UI based checks, the cell will start up and bind the console proxy to this port.

Startup the cells again:

    service vmware-vcd start
    

You should see two ports bound to the same address if you run netstat:

    [root@vcd01 ~]# netstat -tlpn | grep java | grep 443
    tcp        0      0 ::ffff:10.0.3.229:8443      :::*                        LISTEN      16190/java
    tcp        0      0 ::ffff:10.0.3.229:443       :::*                        LISTEN      16190/java
    

If you check in the UI, it will now list the console proxy address as what we put in `global.properties`, even though the UI would not let us do this:

![vCD Console proxy address][4] 

Now, if you log in as a tenant and launch a console, then right click anywhere and hit "Inspect" you should see the console calls to the WebSocket on TCP/8443 as we configured:

![vCD netstat output][5] 

A final note on load-balancer configuration across cells - I run a Kemp LB and have two separate virtual services running, one for each port. Both services were required to be in L7 SSL-offload/termination mode and were configured to re-encrypt traffic to the backend cells for console proxy sessions to establish successfully:

![Kemp VS config][6] 

Also noteworthy, HTTP headers cannot be used for session persistence on the console proxy virtual service as these are raw TCP streams, not HTTPS/HTTP. Attempting to use HTTP headers for session persistence or traffic redirection will cause the TCP socket establishment to fail.

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: http://pubs.vmware.com/Release_Notes/en/vcd/8-10/rel_notes_vcloud_director_8-10.html?src=vmw_so_vex
 [2]: https://fojta.wordpress.com/2016/05/27/vcloud-director-share-console-proxy-ip-with-uiapi-ip-address/
 [3]: images/Screenshot-2017-08-20-17.08.11-740x56.png
 [4]: images/Screenshot-2017-08-20-17.34.37-740x64.png
 [5]: images/Screenshot-2017-08-20-17.36.19-740x39.png
 [6]: images/Screenshot-2017-08-20-17.54.09-740x412.png
 [7]: https://twitter.com/mylesagray