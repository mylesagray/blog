---
title: openSUSE Install Graphics Problems?
author: Myles Gray
type: posts
date: 2013-10-02T21:15:12+00:00
url: /software/opensuse-nomodeset/
categories:
  - Linux
tags:
  - nomodeset
  - openSUSE
---

I had problems recently on a Dell R720XD giving problems when trying to install openSUSE, regardless of the mode I set it up in I would get strange vertical coloured lines on the monitor. It's a graphics driver problem clearly - the solution, on the openSUSE boot screen, move to Installation and in the `boot options` section type in:

    nomodeset
    

![OpenSuse nomodeset][1] 

Then go ahead and continue your install as normal - seems the 3D driver causes problems (with this box at least). Took me about an hour to figure this one out, I worked through all the graphics options including Text Mode - none worked except the above.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/opensuse_01.png
 [2]: https://twitter.com/mylesagray