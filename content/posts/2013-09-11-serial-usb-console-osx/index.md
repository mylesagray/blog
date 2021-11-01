---
title: Serial and USB Console on Mac OSX
author: Myles Gray
type: posts
date: 2013-09-11T21:51:25+00:00
url: /hardware/serial-usb-console-osx
aliases: [ "/hardware/serial-usb-console-osx/amp" ]
description: "How to use a console over a USB serial interface on MacOS"
cover:
  relative: true
  image: images/2960-S.png
  alt: "Cisco 2960 serial port"
categories:
  - Hardware
tags:
  - cisco
  - console
  - osx
  - rs232
  - serial
---

Obviously nowadays when admining we mostly have laptops - laptops don't tend to come with serial I/O ports anymore, so you buy a Serial -> USB adapter, [say this one][1] or any one with a legit (there are fakes) FDTI FT232RL chipset.

Download and install the relevant drivers but where do we go from here?

Specifically on mac, find your device's `tty` name:

```bash
cd /dev
ls -ltr *usb*
```

I added a handy little alias to my

`.bash_profile` so i don't have to remember the screen's tty connection name (obviously replace the `tty.usbserial-XXXXXXXX` with your converter's tty):

```bash
alias serial='screen /dev/tty.usbserial-XXXXXXXX'
```

So you can use this to connect instead:

```bash
serial [baudrate]
```

You can of course use the same method to connect to Cisco switches and routers that have USB consoles:

![Cisco USB Console][2]

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: https://www.startech.com/en-gb/cards-adapters/icusb2321f
 [2]: images/2960-S.png
 [3]: https://twitter.com/mylesagray