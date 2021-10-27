---
title: Check action progress on Dell MD3000i array
author: Myles Gray
type: posts
date: 2014-07-18T08:55:15+00:00
url: /hardware/check-action-progress-dell-md3000i-array
aliases: [ "/hardware/check-action-progress-dell-md3000i-array/amp" ]
cover:
  image: images/Screen-Shot-2014-07-18-at-09.35.16.png
  alt: "Checking an action in progress on a Dell MD array"
categories:
  - Hardware
tags:
  - dell
  - lun
  - md3000i
  - san
  - smcli
---

One of the things that the Dell MD Storage Manager is a progress indicator for rebuild operations or any actions at all really, it's fairly simple to do, but you have to use the command line tool `SMcli.exe` that comes with MD Storage Manager.

First navigate to:

```powershell
C:\Program Files (x86)\Dell\MD Storage Software\MD Storage Manager\client
```

Then execute:

```powershell
SMcli.exe {your.san.ip.address} -p {password} -c "show virtualDisk [\"name-of-vdisk\"] actionProgress;"
```

Obviously replace the curly braces with appropriate values - as well as the `"name-of-vdisk"` the square brackets are part of the syntax.

You should get an output similar to the below:

![enter image description here][1]

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/Screen-Shot-2014-07-18-at-09.49.15.png
 [2]: https://twitter.com/mylesagray
