---
title: "Manually delete custom TCP/IP stack in ESXi"
author: Myles Gray
date: 2015-07-17T17:00:05+01:00
type: posts
description: "Text-description"
url: /command-line-fu/manually-delete-custom-tcpip-stack-in-esxi
categories:
  - Infrastructure
ShowPostRelatedContent: false
disableShare: true
comments: false
hideMeta: true
ShowToc: false
---
Sometimes when third party plugins or solutions work with vCenter and ESXi (Like NSX) they will create a custom `TCP/IP stack` for them to use.

If for whatever reason (say, unclean uninstall) you need to remove the `TCP/IP stack` you can't do it from the vCenter GUI, log into each host directly and execute:

```sh
esxcli network ip netstack delete -N="stack_name"
```

E.g. if you are uninstalling `NSX` and get a stuck `vxlan` stack:

```sh
esxcli network ip netstack remove -N="vxlan"
```
