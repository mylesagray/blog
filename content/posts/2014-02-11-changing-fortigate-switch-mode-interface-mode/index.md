---
title: Changing Fortigate from Switch mode to Interface mode
author: Myles Gray
type: posts
date: 2014-02-11T11:53:56+00:00
lastmod: 
description: 
url: /infrastructure/changing-fortigate-switch-mode-interface-mode/
cover:
  image: images/Screen-Shot-2014-02-11-at-11.58.21.png
  alt: 
categories:
  - Infrastructure
tags:
  - fortigate
  - networking
---

Fortigate units (the big ones at least) come configured in what is called "switch mode" meaning it groups a number of interfaces together and makes them act as a switch, serves DHCP over these interfaces, etc.

Most companies don't like to use this - instead if we want to up our throughput for a given zone we'd create an `802.3ad aggregate` link out of 2 or more of the interfaces.

Disabling switch mode isn't as straight forward as putting the one command in, there are two factors you need to consider:

  1. Are you serving DHCP over this switch interface?
  2. Have you got any policies relating to this interface?

If the answer is "_yes_" to either of these you need to do the following or you will see one of "_Interface switch is in use_" or "_Interface internal is in use_" or "_Entry is used_" later on:

Delete the DHCP server relating to it (either in the GUI as below):

![Disable DHCP Server][1] 

Or you can do it in the CLI:

    fw-a # config sys dhcp server
    fw-a (server) # show <look at list and find the entry number relating to your interface>
    fw-a (server) # delete [entry number here]
    fw-a (server) # end
    

Next you need to delete all policies relating to the interface again, this can be done in the GUI via `Policy -> Policy -> Policy` and delete all policies associated with that interface. Again, it can be done with the CLI:

    fw-a # config firewall policy
    fw-a (policy) # show <look at list and find the entry number(s) relating to your interface>
    fw-a (policy) # delete [entry number here]
    fw-a (policy) # end
    

Once all the switch mode interface's related objects are deleted then we can change the global mode from switch to interface via CLI:

    fw-a # config sys global
    fw-a (global) # set internal-switch-mode interface
    fw-a (global) # end
    Changing switch mode will reboot the system!
    Do you want to continue? (y/n) y
    

The box will reboot and you'll have a host of new interfaces to use as you like.

**N.B: Some boxes are awkward and will require you to deleted the virtual hardware/software switch that is created it you still can't see the individual IFs run the following commands:**

    configure system virtual-switch
    delete {interface name e.g. lan, internal}
    

**If you are still having difficulty you can run the following to find any remaining related entries to the interface:**

    diagnose sys checkused sys.interface.name {interface name e.g. lan, internal}
    

This command will output any entries that relate to this object and might stop it from being removed.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/Screen-Shot-2014-02-11-at-11.36.54.png
 [2]: https://twitter.com/mylesagray