---
title: How to test if 9000 MTU/Jumbo Frames are working
author: Myles Gray
type: posts
date: 2013-09-09T11:45:56+00:00
lastmod: 2021-09-02T14:30:00+00:00
url: /networks/test-jumbo-frames-working/
aliases: /hardware/test-jumbo-frames-working/
description: "An overview on how to test if jumbo frames/MTU 9000 is working on mac, Linux, and Windows"
cover:
  image: images/Ipv4_packet_header.jpg
  alt: "IPv4 packet header"
categories:
  - Networks
  - Hardware
  - Infrastructure
tags:
  - jumbo frame
  - linux
  - mtu
  - networking
  - osx
  - windows
---

## Introduction

Fairly straight forward this time, you've configured your `MTU/jumbo frames` to be `9000` on your client and destination devices (say a laptop/desktop/server/san/nas) and on **ALL** your switching devices in between - you've done that right? ;)

## Testing

So the next step is, we want to test if our new `9000 byte MTU` is actually working and we can reap the benefits of a larger packet size (whether it's on iSCSI, LAN, whatever) being of course a higher latency but also higher throughput. This depends on the OS you are running.

### MacOS

On Mac OSX (that I run) it's:

```bash
ping -D -s 8184 [destinationIP]
```

### Linux

On Linux it's:

```bash
ping -M do -s 8972 [destinationIP]
```

### Windows

On Windows it's:

```powerhsell
ping -f -l 9000 [destinationIP]
```

## Additional Context

The reason for the `8972` on *nix devices is that the ICMP/ping implementation doesn't encapsulate the `28` byte ICMP (8) + IP (20) (ping + standard internet protocol packet) header - thus we must take the `9000` and subtract `28 = 8972`.

On Mac's even though they are *nix kernels, the ping implementation only supports packets `8192` in size so we must remove the ICMP (`8 byte`) header as the ping implementation has already included the `20 byte` IP header, `8192 - 8 = 8184`.

(Apple macs DO support packets up to 9000 bytes, just the ICMP implementation they sport doesn't...)

_EDIT 31/10/13:_ According to [BernieC in a comment here][1] OSX does support 9000+ byte packets if you run the following command to increase its maximum datagram size:

```bash
sudo sysctl -w net.inet.raw.maxdgram=16384
```

It is also important to understand where I got my values from this is an IP packet's layout, you can see the IP info is 20 bytes:

![IP Packet][2]

## Troubleshooting

If you've forgotten to enable `jumbo frames/9k MTU` on your client device you're sending the ping from you'll see:

```bash
PING xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx): 8184 data bytes
ping: sendto: Message too long
```

If you have enabled jumbo frames on your client but not the destination (or a switch in between) you'll see:

```bash
PING xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx): 8184 data bytes
Request timeout for icmp_seq 0
```

If you've done everything right and you're set up ready to go you'll get this:

```bash
PING xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx): 8184 data bytes
8192 bytes from xxx.xxx.xxx.xxx: icmp_seq=0 ttl=128 time=0.714 ms
```

Now rejoice in your lovely jumbo-framey goodness and a good 20-30% in sustained data throughput.

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: /hardware/test-jumbo-frames-working/#comments
 [2]: images/Ipv4_packet_header.jpg
 [3]: https://twitter.com/mylesagray