---
title: Deploying and Installing your first Juju Charm on Vagrant
author: Myles Gray
type: posts
date: 2014-12-14T22:02:07+00:00
lastmod: 2021-10-25T11:13:00+00:00
url: /infrastructure/deploying-installing-first-juju-charm-vagrant
aliases: [ "/infrastructure/deploying-installing-first-juju-charm-vagrant/amp" ]
description: "How to use Juju Charms to deploy applications on to Vagrant"
cover:
  relative: true
  image: images/Screen-Shot-2014-12-14-at-20.06.56.png
  alt: "Juju charms deployed for ELK stack"
  hidden: true
categories:
  - Infrastructure
  - Virtualisation
tags:
  - cloud
  - juju
  - ubuntu
  - vagrant
---

I've been playing with cloud platforms quite a lot recently, and in particular [Juju][1]'s way of operations caught my particular attention.

![Juju Interface][2]

It has a [very impressive feature set][3] and makes deploying and linking "canned" apps very simple, whether you are using public, private or hybrid cloud instances.

I wanted to set Juju up with minimal fuss to give it a quick spin, obviously deploying OpenStack etc is a little more involved for a simple POC than I would have liked and using AWS/Azure/HP Cloud/MAAS was just way overkill.

Luckily, there is a very nice dev environment manager for OSX and Windows by the name of [Vagrant][4], it can run on [VirtualBox][5] (the "normal" installation method) or VMware Workstation/Fusion if you pay a $79 license, as it's a POC i'm cool with using VirtualBox.

Vagrant lets you spin up *nix "boxes" with services etc preconfigured with simple commands like:

```sh
vagrant up hashicorp/precise32
```

The above will spin you up a Ubuntu 12.04 LTS "Precise" x86 instance, pretty cool.

So, to get the ball rolling, for this deployment we have 2x pieces of software to install:

* [Vagrant][6]
* [VirtualBox][5]

Run through the installer for each on your respective OS (very straight forward so I won't document).

I like to create a new directory for Vagrant under my Documents folder:

```sh
cd Documents/
mkdir Vagrant
cd Vagrant/ 
```

To gain access to the machines created by Juju later (in a separate subnet accessible by the Juju VM) we should install `sshuttle` which is a VPN over SSH program, i'm on OSX so I use the package manager [brew.sh][7] to install it:

```sh
brew install sshuttle
```

On Windows you need to [install the node.js][8] binary for Windows then run:

```sh
npm install sshuttle
```

Ubuntu has a pre-built dev/test environment for Juju as a cloud image:

```sh
vagrant box add JujuBox http://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-amd64-juju-vagrant-disk1.box
```

This will download and install an Ubuntu cloud image as a vagrant instance with juju pre-installed. Now we need to init this instance:

```sh
vagrant init JujuBox
vagrant up
```

![Vagrant Init][9]

Once it is spun up you can access the Juju GUI via: <http://127.0.0.1:6080/>, deploy charms etc - Just to test I deployed the "WordPress" charm:

![Wordpress Juju Charm][10]

The box created will use an address in the `10.0.3.0/24` range as this is the range LXC uses to assign DHCP addresses. So I will use sshuttle to create a VPN over SSH to this network (password for machine is `vagrant`):

```sh
sshuttle -r vagrant@localhost:2222 10.0.3.0/24
```

Now I can browse to my newly created WordPress instance through its ip specified by Juju:

![Juju WordPress Deployed][11]

Why not follow [@mylesagray on Twitter][12] for more like this!

 [1]: https://juju.ubuntu.com/
 [2]: images/Screen-Shot-2014-12-14-at-20.06.56.png
 [3]: https://juju.ubuntu.com/features/
 [4]: https://www.vagrantup.com/
 [5]: https://www.virtualbox.org/wiki/Downloads
 [6]: https://www.vagrantup.com/downloads.html
 [7]: http://brew.sh
 [8]: http://nodejs.org/download/
 [9]: images/Screen-Shot-2014-12-14-at-20.52.58.png
 [10]: images/Screen-Shot-2014-12-14-at-21.00.58.png
 [11]: images/Screen-Shot-2014-12-14-at-21.58.51.png
 [12]: https://twitter.com/mylesagray
