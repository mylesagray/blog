---
title: Updating VMWare Horizon Workspace vApp
author: Myles Gray
type: post
date: 2014-06-03T19:08:27+00:00
url: /infrastructure/updating-vmware-horizon-workspace-vapp/
cover:
  image: /uploads/2014/06/Screen-Shot-2014-06-03-at-20.10.05.png
categories:
  - Infrastructure
  - Software
  - Virtualisation
tags:
  - horizon-workspace
  - vapp
  - vdi
  - vmware

---
It's fairly straight forward to update your Horizon Workspace vApp to the latest (**this is an out-of-hours update due to downtime**):

<!--more-->

  1. Back up your vApp
  2. Ensure **all** VAs have connectivity to `vapp-updates.vmware.com` on port `80`
  3. Log into your `configurator-va` CLI with the root password you set up initially
  4. Run the following command to check for update: 
        /usr/local/horizon/lib/menu/updatemgr.hzn check
        

  5. It should come back after checking all other appliances in the vApp with something like this: 
        vdi-configurator:~ # /usr/local/horizon/lib/menu/updatemgr.hzn check
        
        Checking for updates, this can take up to 5 minutes.
        ..
        checking connector-va 192.168.xxx.xxx
        checking data-va 192.168.xxx.xxx
        checking gateway-va 192.168.xxx.xxx
        checking service-va 192.168.xxx.xxx
        
        Current version: 1.8.1.1810
        Update version available: none
        Individual VM versions:
            configurator-va:      1.8.1.1810  
            connector-va:         1.8.0.1800 (Needs update) 
            data-va:              1.8.0.1800 (Needs update) 
            gateway-va:           1.8.0.1800 (Needs update) 
            service-va:           1.8.0.1800 (Needs update) 
        Some VMs are out of date.
        Run update to bring them up to the current version.
        

  6. Run the following to update your VAs: 
        /usr/local/horizon/lib/menu/updatemgr.hzn update
        

  7. It will run through and update all VAs: 
        Checking for updates, this can take up to 5 minutes.
        ..
        checking connector-va 192.168.xxx.xxx
        checking data-va 192.168.xxx.xxx
        checking gateway-va 192.168.xxx.xxx
        checking service-va 192.168.xxx.xxx
        
        Updating out of date VMs to version: 1.8.1.1810
        Running preupdate -c
        Running preupdate -c connector-va CONNECTOR vdi-connector.xxxxx.xx 192.168.xxx.xxx
        Update connector-va to 1.8.1.1810
        
        Running postupdate -c connector-va CONNECTOR vdi-connector.xxxxx.xx 192.168.xxx.xxx
        postupdate.hzn rebuilding connector-va manifest file
        ssh -oBatchMode=yes -o StrictHostKeyChecking=no -i /home/configurator/.ssh/id_rsa -q configurator@192.168.xxx.xxx sudo /usr/local/horizon/scripts/updfix.hzn /home/configurator/manifest-installed.save /opt/vmware/var/lib/vami/update/data/info/manifest-installed.xml 1.8.1.1810 1752346
        version=1.8.1.1810 fullversion=1.8.1.1810 Build 1752346
        Running preupdate -c data-va DATA vdi-data.xxxxx.xx 192.168.xxx.xxx
        Update data-va to 1.8.1.1810
        
        [continues until all VAs updated...]
        
    
    This takes some time, so just keep an eye on the ssh output and wait for this and you'll be ready to go:
    
        Running postupdate -c
        updateMobilemoduleIfEnabled
        

  8. Check your `https://[configurator-va-address]/cfg/system` to make sure all the software versions match the updated version you saw earlier in the CLI when you checked for updates.</p> 

That's all there is to it, the update does take some time but is a straightforward procedure as long as you check the pre-requisites thoroughly.

Why not follow [@mylesagray on Twitter][1] for more like this!

 [1]: https://twitter.com/mylesagray