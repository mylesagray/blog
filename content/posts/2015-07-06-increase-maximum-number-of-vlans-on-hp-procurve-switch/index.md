---
title: "Increase maximum number of VLANs on HP ProCurve switch"
author: Myles Gray
date: 2015-07-06T16:52:00+01:00
type: posts
url: /command-line-fu/increase-maximum-number-of-vlans-on-hp-procurve-switch
categories:
  - Infrastructure
ShowPostRelatedContent: false
disableShare: true
comments: false
hideMeta: true
ShowToc: false
---
Ran into a maximum `VLAN` problem (8 `VLAN`s) on my lab `HP ProCurve 2824` switches.

This command can be run to increase the max number of `VLAN`s allowed on the switch (in `config` mode):

```sh
max-vlans 256
write memory
reload
```
