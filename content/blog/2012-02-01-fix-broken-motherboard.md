---
title: Fixing/Flashing a broken motherboard w/ SPIPGM2 and Serial
author: Myles Gray
type: post
date: 2012-02-01T21:09:18+00:00
excerpt: |
  <p><span style="color: #99cc33;">You will need:</span><br/>
  <ul><li>Dead Motherboard<li>
  <li>Spare PSU</li>
  <li>Paperclip</li>
  <li>Laptop/Desktop with LPT/Serial</li>
  <li><a href="http://www.logicsupply.com/images/photos/cables/ieee1394hdrcab_big.jpg" rel="shadowbox">An old unused cable with a 2x5 header on one end </a>(usually come free with motherboards)</li>
  <li><a href="http://pharry.org/data/ubcd411.iso" target="_blank">Universal Boot CD</a><li>
  <li><a href="http://richard-burke.dyndns.org/wordpress/wp-content/uploads/2009/05/SPIPGM2.ZIP" target="_blank">SPIPGM2</a></li>
  <li><a href="http://www.megaupload.com/?d=J2EPQRH5" target="_blank">CWSDPMI7</a></li>
  <li><a href="http://www.megaupload.com/?d=1PSVKBEL" target="_blank">Cable Wiring Guide</a></li>
  <li>A BIOS ROM for your motherboard (go to your manufacturers website and download the latest)</li>
  <li>Basic DOS knowledge</li>
  </ul></p>
url: /hardware/fix-broken-motherboard/
cover:
  image: /uploads/2013/11/img6527x.jpeg
views:
  - 3334
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1751953304
rop_post_url_twitter:
  - 'https://blah.cloud/hardware/fix-broken-motherboard/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Hardware
tags:
  - bios
  - serial
  - spi

---
## Background So this was me when i first got the motherboard:

<blockquote class="postdata">
  <p>
    Got a Blitz formula today and i thought all was well plugged in the 24pin ATX and EATX power and all the lights were on (good stuff) Clicked the on button, the LCD was stuck with CPU INIT, I've tried clearing CMOS everything I don't know what the hell is wrong, currently in the process of resetting the CMOS (press CLR_CMOS button and take out the battery for 2 hours). The board is spotless, absolutely perfect, all the lights come on and even when you install the GPU wrong the little warning light comes on but it will not POST, just says CPU INIT all the time and restarts every 3/4 seconds as if there was a bad overclock and it was resetting to default.
  </p>
</blockquote>

As you can see something was obviously up with it and as it wouldn't even POST i couldn't flash the BIOS. So I looked for alternate methods and there were 2 open to me:

  * De/Re-Solder the BIOS chip with a new one
  * Work out how to flash using the SPI Port and flash from another computer (or in my case a very old laptop with an LPT port on it) So naturally I chose the latter, but the next challenge was to find out how I go about using this SPI port (which looks very similar to a USB header). 

<!--more-->

## You will need:

  * Broken Motherboard
  * Spare PSU
  * Paperclip
  * Laptop/Desktop with LPT/Serial
  * 100 Ohm Resistors (x4)
  * <a href="https://blah.cloud/wp-content/uploads/2012/02/ieee1394hdrcab_big.jpg" rel="shadowbox">An old unused cable with a 2&#215;5 header on one end </a>
  * <a href="https://blah.cloud/wp-content/uploads/2012/02/download.html" target="_blank">Universal Boot CD v4.1.1 (Version Important)</a>
  * <a href="http://richard-burke.dyndns.org/wordpress/wp-content/uploads/2009/05/SPIPGM2.ZIP" target="_blank">SPIPGM2</a>
  * <a href="https://blah.cloud/wp-content/uploads/2012/02/csdpmi7b.zip" target="_blank">CWSDPMI7</a> (Copy contents of /bin folder to the same directory as SPIPGM2)
  * <a href="https://blah.cloud/wp-content/uploads/2012/02/ReflashBIOS.doc" target="_blank">Cable Wiring Guide</a>
  * A BIOS ROM for your motherboard (download the latest)
  * Basic DOS knowledge

## Method:

First things first, you want to download the 3 files (The Boot CD .iso, SPIPGM2 (Used to flash the ROM), CWSDPMI7 (DPMI host process needed by SPIPGM)). Burn the Universal Boot to a CD, place both SPIPGM2 and CWSDPMI7's /bin files as well as the BIOS ROM in the C: directory on your laptop/desktop that you will be doing the flashing from. Butcher up the header cable (i.e. take off the outer sleeving so all you are left with is the header that will connect to the SPI Port and about 1M of wires. The guide to creating this cable is detailed

<a href="https://blah.cloud/wp-content/uploads/2012/02/ReflashBIOS.doc" target="_blank">here</a>, note it is VERY important to use the 3V line from the spare PSU (to hot-wire the spare PSU use the paperclip and make a connection between the green wire and ANY black wire) and NOT 2xAA batteries as 2x AA's will not work (believe me I've tried), also ignore the bootable USB as were using a CD. Once you have created the flashing cable then it is time to plug it into the Serial Port on your chosen flashing computer (Make sure it's mode is set to LPT port as detailed in the pdf, check and recheck these!) The ports should be as so:

<table style="text-align: center; margin: 0 auto;">
  <tr>
    <td>
      LPT Port
    </td>
    
    <td>
      |
    </td>
    
    <td>
      SPI Port
    </td>
  </tr>
  
  <tr>
    <td>
      7
    </td>
    
    <td>
      ->
    </td>
    
    <td>
      3
    </td>
  </tr>
  
  <tr>
    <td>
      8
    </td>
    
    <td>
      ->
    </td>
    
    <td>
      4
    </td>
  </tr>
  
  <tr>
    <td>
      9
    </td>
    
    <td>
      ->
    </td>
    
    <td>
      6
    </td>
  </tr>
  
  <tr>
    <td>
      10
    </td>
    
    <td>
      ->
    </td>
    
    <td>
      5
    </td>
  </tr>
  
  <tr>
    <td>
      18
    </td>
    
    <td>
      ->
    </td>
    
    <td>
      2
    </td>
  </tr>
  
  <tr>
    <td colspan="3">
      (Resistors need to be on lines 7, 8, 9 and 10)
    </td>
  </tr>
</table>

 

<table style="margin: 0 auto;">
  <tr>
    <td style="text-align: center; width: 20em;">
      DB25 (LPT Port Pinout)
    </td>
    
    <td style="text-align: center; width: 15em;">
      SPI Port Pinout
    </td>
  </tr>
  
  <tr>
    <td style="text-align: center; width: 20em;">
      <img loading="lazy" class="alignnone size-full wp-image-476" title="DB-25 Female Connector" alt="DB-25 Female Connector" src="https://blah.cloud/wp-content/uploads/2012/02/db25fem.jpg" width="171" height="65" />
    </td>
    
    <td style="text-align: center; width: 15em;">
      <img loading="lazy" class="alignnone size-full wp-image-477" title="SPI Pinout" alt="SPI Pinout" src="https://blah.cloud/wp-content/uploads/2012/02/images.jpg" width="49" height="67" />
    </td>
  </tr>
</table>

  Once you have everything hooked up and triple checked (don't forget to hook up port 1 to +3V and 2 (that is also connected to 18 on the LPT) to 0V) Then it's time to shut down your laptop/desktop that you wish to flash from and change the BIOS to boot from CD, restart again and boot into the CD.

**(BEFORE BOOTING MAKE SURE PARALLEL PORT IS SET TO LPT/378h IN BIOS!)** Once in the CD select a program called _NTFS4DOS (In File System>NTFS Tools>Avira NTFS4DOS_) This will give you access to your C: drive where you saved the CWSDPMI7 and SPIPGM2 and your BIOS's ROM earlier. Once there the next thing to do is execute this from the DOS cmd line:

<pre class="prettyprint"><code>SPIPGM2 /d DUMP.ROM</code></pre>

This dumps the ROM to a file in C: called DUMP.ROM To analyze your dumped ROM upload DUMP.ROM to here:

<a href="https://blah.cloud/wp-content/uploads/2012/02/hexdump.htm" target="_blank">http://www.fileformat.info/tool/hexdump.htm</a> Select to 10000 characters Compare this to the first 10000 characters of the downloaded ROM (upload this via the same method) Next you have to flash the ROM do this by executing these commands in DOS:

<pre class="prettyprint"><code>CWSDPMI
SPIPGM2 /i
SPIPGM2 /u
SPIPGM2 /e
SPIPGM2 /s BIOSNAME.rom</code></pre>

And your done! Maybe one last ROM dump to make sure all has gone to plan and boot your broken mobo up! Credit to:

<http://www.fccps.cz/download/adv/frr/spi/msi_spi.html> <http://rayer.ic.cz/elektro/spipgm.htm> [http://mondotech.blogspot.com/2009/05/asus-p5b-deluxe-bios-recovery-spi-flash.html][1] Any problems/error codes leave a comment and I'll do all i can to help! Just covering my ass: By carrying out these actions your are individually and solely responsible for anything that may/may not happen to your motherboard/other devices.

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: /uploads/2012/02/asus-p5b-deluxe-bios-recovery-spi-flash.html
 [2]: https://twitter.com/mylesagray