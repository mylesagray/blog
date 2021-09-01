---
title: Serial and USB Console on Mac OSX
author: Myles Gray
type: post
date: 2013-09-11T21:51:25+00:00
url: /hardware/serial-usb-console-osx/
cover:
  image: /uploads/2013/11/2960-S.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1751948285
rop_post_url_twitter:
  - 'https://blah.cloud/hardware/serial-usb-console-osx/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Hardware
  - Software
tags:
  - cisco
  - console
  - osx
  - rs232
  - serial

---
Obviously nowadays when admining we mostly have laptops - laptops don't tend to come with serial I/O ports anymore, so you buy a Serial -> USB adapter, [say this one][1] or any one with a legit (there are fakes) FDTI FT232RL chipset. Download and install [the relevant drivers][2] but where do we go from here? Specifically on mac, find your device's `tty` name:

<pre class="prettyprint"><code>cd /dev
ls -ltr *usb*</code></pre>

I added a handy little alias to my

`.bash_profile` so i don't have to remember the screen's tty connection name (obviously replace the `tty.usbserial-XXXXXXXX` with your converter's tty):

<pre class="prettyprint"><code>alias serial='screen /dev/tty.usbserial-XXXXXXXX'</code></pre>

So you can use this to connect instead:

<pre class="prettyprint"><code>serial [baudrate]</code></pre>

You can of course use the same method to connect to Cisco switches and routers that have USB consoles:

<img loading="lazy" class="alignnone size-full wp-image-723" alt="Cisco USB Console" src="https://blah.cloud/wp-content/uploads/2013/11/2960-S.png" width="921" height="269" /> 

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: /uploads/2013/09/1-Port-USB-Serial-RS232-Adapter-Cable~ICUSB2321F
 [2]: /uploads/2013/09/FTDI.zip
 [3]: https://twitter.com/mylesagray