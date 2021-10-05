---
title: Migrating vSAN vmkernel ports to a new subnet
author: Myles Gray
type: posts
date: 2017-11-03T14:01:47+00:00
url: /infrastructure/migrating-vsan-vmkernel-ports-new-subnet/
cover:
  image: images/Screenshot-2017-11-02-12.39.08.png
categories:
  - Infrastructure
  - Networks
  - Storage
  - Virtualisation
tags:
  - esxi
  - vmware
  - vsan
  - vsphere
---

After deploying a vSAN cluster, the need sometimes arises to make changes to its network configuration, such as migrating the vmkernel network of the cluster to a new subnet. This requirement may appear for example when changing the network in which the vSAN cluster is running, or even, in a more complex scenario such as when a standalone vSAN needs to be converted to a stretched cluster.

In these sorts of situations, complications may be encountered if the subnet in use for the vSAN vmkernel ports cannot be routed to the network as a whole, as it is in use elsewhere in the organization, and is currently isolated in an L2 segment. In this situation, the only option is to migrate hosts into a different subnet to achieve to a stretched cluster architecture. This requirement comes to the surface as it is necessary for the vSAN vmkernel ports to have routable access to the witness VM on a separate site, as such, L2 isolated segments are not appropriate.

In this post, we will examine some of the networking implications that may arise if you need to make changes to an existing cluster, such as when converting a standalone vSAN cluster into a stretched cluster configuration, or when migrating a vSAN to a new subnet.

There have been a few questions around how one would migrate from an isolated subnet to another subnet without requiring application downtime; the answer is quite simple. VMware supports running two vSAN vmkernel ports simultaneously on a vSAN cluster, as long as the subnets are disparate - It is essential, however, to distinguish between a configuration with multiple discrete vSAN vmkernel ports on separate subnets and multiple vSAN vmkernel ports on the same subnet, the latter of which is not supported.

It is advisable before you carry out the changes that isolation addresses for the stretched cluster's HA mechanism are put in place. Read more on using vSAN with vSphere HA [here][1].

If you are utilizing a VDS for network connectivity, it is recommended that you first add a new vmkernel port into the VDS for the new subnet that is routable throughout your infrastructure and tag it for the vSAN service. If you are using a VSS instead, you can add each new vmkernel interface manually. It is a good idea to verify connectivity from host-to-host using vmkping over the newly created vSAN vmkernel port before enacting any changes.

It is possible to verify the vmkernel ports that a host is using for vSAN by entering the command line on the hosts and running:

    esxcli vsan network list
    

The test setup in this example is as follows:

    10.0.1.0/24 - Old unroutable vSAN network
    10.198.16.0/20 - New routable vSAN network
    vmk1 - Old vSAN vmkernel port
    vmk8 - New vSAN vmkernel port
    

Below you can see the new interface we will be migrating all hosts to (`h1`-`h6`) is `vmk8` and in the `10.198.16.0/20` subnet and the old interface `vmk1` with associated subnet `10.0.1.0/24`.

![vSAN new vmkernel interface][2] 

In the example below, `vmk8` is the newly created vmkernel port on host `h1` and `10.198.16.241` is the new vmkernel interface tagged with vSAN traffic on host `h2`.

    [root@h1:~] vmkping -I vmk8 10.198.16.241
    PING 10.198.16.241 (10.198.16.241): 56 data bytes
    64 bytes from 10.198.16.241: icmp_seq=0 ttl=64 time=0.106 ms
    64 bytes from 10.198.16.241: icmp_seq=1 ttl=64 time=0.099 ms
    

You can check connectivity from each host to every other host if you wish to verify connectivity on this new vmkernel interface throughout the cluster.

Now that the networking infrastructure is in place, we can proceed to begin the migration of hosts into a stretched cluster configuration and alter the required network settings.

Put the first host in the cluster into maintenance mode (in our case, host `h1`) selecting “Ensure data accessibility” or “Full data evacuation” as you see fit. In this example, I am using “Ensure data accessibility” as the hosts will be returning quickly after the changes are made.

![Enter vSAN host into maintenance mode][3] 

Once the host has successfully entered maintenance mode - navigate to `Configure -> Networking -> VMkernel Adapters` in the vSphere Web Client, select the old vmkernel interface (in our case, as listed above, this is vmk1) and delete it, confirm the deletion when prompted.

![Delete vSAN vmkernel port][4] 

Select the host again and exit maintenance mode, at this point if you wish you can verify vSAN Object Health in the Health UI by navigating to the cluster, then `Monitor -> vSAN -> Health` and run a `Retest`.

All objects should be in the “Healthy” state at this point, note; you may see some alerts in the Health UI. In particular, relating to vSAN unicast checks from the migrated host(s) to the pending hosts’ old vSAN vmkernel ports, this alert is expected as that subnet is not routable - vSAN traffic will still flow via the new vmkernel ports created earlier.

![vSAN object health][5] 

With that process defined for one host, you can now “walk” all other hosts in the cluster into the new subnet, by repeating the above steps for every host. The steps can be summarized as so:

  1. Put host into maintenance mode
  2. Specify your preferred data evacuation mode
  3. Allow host to enter maintenance mode fully
  4. Remove original vSAN vmkernel port
  5. Take host out of maintenance mode

Once all hosts in the cluster have been migrated in this fashion, recheck the vSAN Health UI and run a Retest, this time all checks should come back “Healthy” as we have removed all the old vmkernel ports from the hosts.

Why not follow [@mylesagray on Twitter][6] for more like this!

 [1]: https://docs.vmware.com/en/VMware-vSphere/6.0/com.vmware.vsphere.virtualsan.doc/GUID-D68890D8-841A-4BD1-ACA1-DA3D25B6A37A.html?src=vmw_so_vex
 [2]: images/Screenshot-2017-11-02-12.39.08.png
 [3]: images/Screenshot-2017-11-02-12.00.59.png
 [4]: images/Screenshot-2017-11-02-12.39.39.png
 [5]: images/Screenshot-2017-11-02-12.41.23.png
 [6]: https://twitter.com/mylesagray