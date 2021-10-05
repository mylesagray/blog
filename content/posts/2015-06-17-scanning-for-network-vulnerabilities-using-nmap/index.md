---
title: Scanning for network vulnerabilities using nmap
author: Myles Gray
type: posts
date: 2015-06-17T22:51:30+00:00
url: /networks/scanning-for-network-vulnerabilities-using-nmap/
aliases: /security/scanning-for-network-vulnerabilities-using-nmap/
cover:
  image: images/Screen-Shot-2015-05-26-at-10.45.41.png
categories:
  - Networks
tags:
  - nmap
  - security
  - vulnerabilities
  - windows
---

This article is a bit of a divergence for me, I recently had the need to scan an entire network for a particularly nasty Microsoft security vulnerability [MS15-034][1].

Obviously there are a few ways to check for this, the first is obvious, check what servers have IIS installed. However, this bug isn't limited to IIS, rather anything using `HTTP.sys` and, of course, a HTTP server can be spun up on any port you want so we need to check for servers that have HTTP exposed on any port from `1-65535`.

Nobody wants to manually log on to every server and check if the specific [KB patch][2] is installed though, that takes a lot of effort and time.

So is there a way we can scan for vulnerabilities in a "start and forget" sort of way?

Sure, we can use [Zenmap][3] - Zenmap is a GUI built on top of nmap, a network scanner that can gather info on open ports, OS detection, etc. It has tons of really cool features, but one thing it allows for that is of particular benefit is scripting of particular scan parameters, this makes it ideal for vulnerability scanning.

The reason I use Zenmap is that it provides a nice summarised output of nmap commands and supports all of the features nmap does. If we open up Zenmap and run the below against our subnet (obviously replace this with your subnet and mask, or indeed, single host) in question:

    nmap -v3 10.0.0.0/23
    

This will give you an output of all active hosts on the network (the -v3 trigger simply increases output verbosity during the scan, I like this to see where we are at in the scan progress-wise), nice and easy:

![Zenmap Scan-1][4] 

nmap's default "host is active" detection behaviour (on IPv4) is; send an ICMP echo request, a TCP SYN packet to port 443, a TCP ACK packet to port 80, and an ICMP timestamp request.

Sometimes, however, hosts don't respond to these requests/packets; If you think there may be hosts on your subnet that act in this manner, we can get around it by disabling host detections by passing the trigger `-Pn`.

> Disabling host discovery with `-Pn` causes Nmap to attempt the requested scanning functions against every target IP address specified

So for the below it will fully scan all top 1000 ports (default for nmap) on every IP in the `10.0.0.0/23` subnet. **N.B. This takes a LONG time**:

    nmap -v3 -Pn 10.0.0.0/23
    

Let's make our scan a little more useful and output to a nicely formatted XML document, create a folder in `C:\` called `temp` then with the `-oX [filename]` trigger edit the command:

    nmap -v3 -oX "C:\\temp\\scan.xml" 10.0.0.0/23
    

This will give you a nice XML report (saved in the C:\temp\ directory) you can open with your browser and get a report like so:

![Zenamp Scan-2][5] 

So we understand how to look for open ports (on 1000 top used TCP ports - default) and generate a nice XML report.

Let's see if we can figure out what a couple of those hosts are then.

`nmap` has a built in trigger for OS: `-A` and OS version detection: `-sV` that will use a number of pointers and try and [guess what the OS is][6] based on info available to it.

Let's run it and see what we can get (I ran it on a single host because it takes a LONG time to run these scans on a `/23` subnet):

    nmap -A -sV -v3 -oX "C:\\temp\\scan.xml" 10.0.1.253
    

Output looks similar to the below:

    Starting Nmap 6.47 ( http://nmap.org ) at 2015-05-25 16:47 GMT Daylight Time
    NSE: Loaded 118 scripts for scanning.
    NSE: Script Pre-scanning.
    NSE: Starting runlevel 1 (of 2) scan.
    NSE: Starting runlevel 2 (of 2) scan.
    Initiating ARP Ping Scan at 16:47
    Scanning 10.0.1.253 [1 port]
    Completed ARP Ping Scan at 16:47, 0.03s elapsed (1 total hosts)
    Initiating Parallel DNS resolution of 1 host. at 16:47
    Completed Parallel DNS resolution of 1 host. at 16:47, 0.00s elapsed
    DNS resolution of 1 IPs took 0.09s. Mode: Async [#: 3, OK: 1, NX: 0, DR: 0, SF: 0, TR: 1, CN: 0]
    Initiating SYN Stealth Scan at 16:47
    Scanning dc02.home.kharms.co.uk (10.0.1.253) [1000 ports]
    Discovered open port 135/tcp on 10.0.1.253
    Discovered open port 3389/tcp on 10.0.1.253
    Discovered open port 53/tcp on 10.0.1.253
    Discovered open port 139/tcp on 10.0.1.253
    Discovered open port 445/tcp on 10.0.1.253
    Discovered open port 111/tcp on 10.0.1.253
    Discovered open port 593/tcp on 10.0.1.253
    Discovered open port 88/tcp on 10.0.1.253
    Discovered open port 3269/tcp on 10.0.1.253
    Discovered open port 49154/tcp on 10.0.1.253
    Discovered open port 49153/tcp on 10.0.1.253
    Discovered open port 464/tcp on 10.0.1.253
    Discovered open port 49156/tcp on 10.0.1.253
    Discovered open port 636/tcp on 10.0.1.253
    Discovered open port 3268/tcp on 10.0.1.253
    Discovered open port 389/tcp on 10.0.1.253
    Discovered open port 49158/tcp on 10.0.1.253
    Discovered open port 49157/tcp on 10.0.1.253
    Completed SYN Stealth Scan at 16:47, 4.70s elapsed (1000 total ports)
    Initiating Service scan at 16:47
    Scanning 18 services on dc02.home.kharms.co.uk (10.0.1.253)
    Completed Service scan at 16:49, 116.16s elapsed (18 services on 1 host)
    Initiating OS detection (try #1) against dc02.home.kharms.co.uk (10.0.1.253)
    NSE: Script scanning 10.0.1.253.
    NSE: Starting runlevel 1 (of 2) scan.
    Initiating NSE at 16:49
    NSE Timing: About 80.77% done; ETC: 16:49 (0:00:07 remaining)
    Completed NSE at 16:49, 41.75s elapsed
    NSE: Starting runlevel 2 (of 2) scan.
    Nmap scan report for dc02.home.kharms.co.uk (10.0.1.253)
    Host is up (0.00s latency).
    Scanned at 2015-05-25 16:47:08 GMT Daylight Time for 164s
    Not shown: 982 filtered ports
    PORT      STATE SERVICE       VERSION
    53/tcp    open  domain        Microsoft DNS
    88/tcp    open  kerberos-sec  Windows 2003 Kerberos (server time: 2015-05-25 15:47:18Z)
    111/tcp   open  rpcbind?
    | rpcinfo: 
    |   program version   port/proto  service
    |   100000  2,3,4        111/tcp  rpcbind
    |   100000  2,3,4        111/udp  rpcbind
    |   100004  2            787/udp  ypserv
    |   100004  2            789/tcp  ypserv
    |   100009  1            788/udp  yppasswdd
    |_  1073741824 1            790/udp  fmproduct
    135/tcp   open  msrpc?
    139/tcp   open  netbios-ssn
    389/tcp   open  ldap
    445/tcp   open  netbios-ssn
    464/tcp   open  kpasswd5?
    593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
    636/tcp   open  ssl/ldap
    | ssl-cert: Subject: commonName=dc02.home.kharms.co.uk
    | Issuer: commonName=Kharms CA/domainComponent=home
    | Public Key type: rsa
    | Public Key bits: 2048
    | Not valid before: 2015-01-25T15:35:12+00:00
    | Not valid after:  2016-01-25T15:35:12+00:00
    | -----BEGIN CERTIFICATE-----
    | [REDACTED]
    |_-----END CERTIFICATE-----
    |_ssl-date: 2015-05-25T15:49:11+00:00; 0s from local time.
    3268/tcp  open  ldap
    3269/tcp  open  ssl/ldap
    | ssl-cert: Subject: commonName=dc02.home.kharms.co.uk
    | Issuer: commonName=Kharms CA/domainComponent=home
    | Public Key type: rsa
    | Public Key bits: 2048
    | Not valid before: 2015-01-25T15:35:12+00:00
    | Not valid after:  2016-01-25T15:35:12+00:00
    | -----BEGIN CERTIFICATE-----
    | [REDACTED]
    |_-----END CERTIFICATE-----
    |_ssl-date: 2015-05-25T15:49:11+00:00; 0s from local time.
    3389/tcp  open  ms-wbt-server Microsoft Terminal Service
    49153/tcp open  msrpc         Microsoft Windows RPC
    49154/tcp open  msrpc         Microsoft Windows RPC
    49156/tcp open  msrpc         Microsoft Windows RPC
    49157/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
    49158/tcp open  msrpc         Microsoft Windows RPC
    MAC Address: 00:50:56:A4:E1:FF (VMware)
    Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
    Device type: general purpose
    Running: Microsoft Windows 2012
    OS CPE: cpe:/o:microsoft:windows_server_2012
    OS details: Microsoft Windows Server 2012
    TCP/IP fingerprint:
    OS:SCAN(V=6.47%E=4%D=5/25%OT=53%CT=%CU=%PV=Y%DS=1%DC=D%G=N%M=005056%TM=5563
    OS:44A0%P=i686-pc-windows-windows)SEQ(SP=100%GCD=1%ISR=108%TI=I%II=I%SS=S%T
    OS:S=7)OPS(O1=M5B4NW8ST11%O2=M5B4NW8ST11%O3=M5B4NW8NNT11%O4=M5B4NW8ST11%O5=
    OS:M5B4NW8ST11%O6=M5B4ST11)WIN(W1=2000%W2=2000%W3=2000%W4=2000%W5=2000%W6=2
    OS:000)ECN(R=Y%DF=Y%TG=80%W=2000%O=M5B4NW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%TG=80%S=O
    OS:%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=N)U1(R=N)IE(R=Y%DFI=N%TG=80%CD=Z)
    
    Uptime guess: 27.639 days (since Tue Apr 28 01:29:16 2015)
    Network Distance: 1 hop
    TCP Sequence Prediction: Difficulty=256 (Good luck!)
    IP ID Sequence Generation: Incremental
    Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
    
    Host script results:
    | nbstat: NetBIOS name: DC02, NetBIOS user: <unknown>, NetBIOS MAC: 00:50:56:a4:e1:ff (VMware)
    | Names:
    |   HOME<00>             Flags: <group><active>
    |   DC02<00>             Flags: <unique><active>
    |   HOME<1c>             Flags: <group><active>
    |   DC02<20>             Flags: <unique><active>
    | Statistics:
    |   00 50 56 a4 e1 ff 00 00 00 00 00 00 00 00 00 00 00
    |   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    |_  00 00 00 00 00 00 00 00 00 00 00 00 00 00
    | p2p-conficker: 
    |   Checking for Conficker.C or higher...
    |   Check 1 (port 6408/tcp): CLEAN (Timeout)
    |   Check 2 (port 33074/tcp): CLEAN (Timeout)
    |   | Check 3 (port 27466/udp): CLEAN (Timeout)
    |   | Check 4 (port 40700/udp): CLEAN (Timeout)
    |_  0/4 checks are positive: Host is CLEAN or ports are blocked
    | smb-os-discovery: 
    |   OS: Windows Server 2012 R2 Datacenter 9600 (Windows Server 2012 R2 Datacenter 6.3)
    |   OS CPE: cpe:/o:microsoft:windows_server_2012::-
    |   Computer name: dc02
    |   NetBIOS computer name: DC02
    |   Domain name: home.kharms.co.uk
    |   Forest name: home.kharms.co.uk
    |   FQDN: dc02.home.kharms.co.uk
    |_  System time: 2015-05-25T16:49:11+01:00
    | smb-security-mode: 
    |   Account that was used for smb scripts: guest
    |   User-level authentication
    |   SMB Security: Challenge/response passwords supported
    |_  Message signing required
    |_smbv2-enabled: Server supports SMBv2 protocol
    
    TRACEROUTE
    HOP RTT     ADDRESS
    1   0.00 ms dc02.home.kharms.co.uk (10.0.1.253)
    
    NSE: Script Post-scanning.
    NSE: Starting runlevel 1 (of 2) scan.
    NSE: Starting runlevel 2 (of 2) scan.
    Read data files from: C:\Program Files (x86)\Nmap
    OS and Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
    Nmap done: 1 IP address (1 host up) scanned in 166.58 seconds
               Raw packets sent: 2020 (90.718KB) | Rcvd: 225 (92.285KB)
    

I want to highlight a few lines in particular from the output:

    Running: Microsoft Windows 2012
    OS CPE: cpe:/o:microsoft:windows_server_2012
    OS details: Microsoft Windows Server 2012
    

and in the `smb-os-discovery` section:

    OS: Windows Server 2012 R2 Datacenter 9600 (Windows Server 2012 R2 Datacenter 6.3)  
    

Also, confirmed in the pretty Zenmap GUI:

![Zenmap Scan-3][7] 

So it's a Windows 2012 server, awesome, and we can see from the port scan it's got DNS, IIS, LDAP and Kerberos - so, probably a Domain Controller.

Let's dig into this host a little more and run a scan on all ports by using `-p 1-65535`, also that last scan took a little longer than I liked so, lets specify `-T4` to limit dynamic scan delay from exceeding `10 ms` for TCP ports:

    nmap -p 1-65535 -T4 -A -sV -v3 -oX "C:\\temp\\scan.xml" 10.0.1.253
    

I'm not going to output the entire script, as it's mostly the same, however here is the extra info pulled back from the full TCP range scan:

    744/tcp   open   ypserv
    5985/tcp  open   http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
    6677/tcp  closed unknown
    9389/tcp  open   unknown
    49155/tcp open   msrpc         Microsoft Windows RPC
    49159/tcp open   msrpc         Microsoft Windows RPC
    49164/tcp open   msrpc         Microsoft Windows RPC
    49215/tcp open   msrpc         Microsoft Windows RPC
    55382/tcp open   msrpc         Microsoft Windows RPC
    

The Windows RPC ports aren't new, they've just moved, [RPC ports are dynamically allocated][8]:

> allow for traffic between servers in the dynamic port range of 49152 through 65535

So the new surfaces exposed are `744`, `5985`, `6677` and `9389`.

I see that `Microsoft HTTPAPI httpd 2.0` is on port `5985`, Windows vulnerability `MS15-034` addresses a vulnerability in HTTP.sys, which this service uses.

To get into scanning ports for the MS15-034 vulnerability we will need to download a NSE script, this is a script that defines parameters to execute a POC attack to prove the exploit is viable against the defined host.

I found one that sets the required `range` in the header to `bytes=0-18446744073709551615` that will show whether the vulnerability is viable or not:

<https://github.com/cldrn/nmap/blob/master/scripts/http-vuln-cve2015-1635.nse>

The construction of an NSE is too long for this post, I will cover that in another article, but in a nutshell this script will run against all resulting ports from the scan definition that match its parameters, in this example we can see this line in the NSE file:

    portrule = shortport.http
    

This tells nmap to run this script against all ports that match the type of [shortport.http][9] in nmap's pre-defined list. We can see from [this thread][10] that it will match against the below parameters:

    http = shortport.port_or_service({80, 443, 631, 3872, 8080},
            {"http", "https", "ipp", "http-alt", "oem-agent"})
    

So we can download the script (if you copy and paste it into a new doc, make sure to save it as ANSI encoded) and move it to the `scripts` subdirectory of the `nmap` installation folder then run this to update the `script.db` file:

    nmap --script-updatedb
    

So now we have our nse installed we can run it against our host:

    nmap -p 1-65535 -T4 -A -sV -v3 -d -oX "C:\\temp\\scan.xml" --script http-vuln-cve2015-1635.nse --script-args vulns.showall 10.0.0.1/23
    

Let me break-down these commands a little, we've seen all the preceeding ones before except for `-d`.

  * `-d`: provides debugging output for scripts (so you can figure out why it isn't working)
  * `--script`: indicates the script to target in the `scripts` subdirectory
  * `--script-args vulns.showall`: tells nmap to print NSE results for both vulnerable and non-vulnerable hosts

I also like to use a script that provides a summary of the results at the bottom if i'm doing a large subnet scan, (You can view Peter Kacherginsky's article on NSE building [here][11] and follow the section on [aggregating output][12], I highly recommend it), though this is not necessary, you can simply pass it as a second script by following the first with a comma as below:

    nmap -p 1-65535 -T4 -A -sV -v3 -d -oX "C:\\temp\\scan.xml" --script http-vuln-cve2015-1635.nse,post-process.nse --script-args vulns.showall 10.0.0.1/23
    

At the end of it we should see whether our targeted host is vulnerable:

    5985/tcp  open   http          syn-ack Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
    | http-vuln-cve2015-1635: 
    |   NOT VULNERABLE:
    |   Remote Code Execution in HTTP.sys (MS15-034)
    |     State: NOT VULNERABLE
    |     IDs:  CVE:CVE-2015-1635
    |     References:
    |       https://technet.microsoft.com/en-us/library/security/ms15-034.aspx
    |_      http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-1635
    

Any questions/problems please drop a comment below!

References:

https://thesprawl.org/research/writing-nse-scripts-for-vulnerability-scanning/

<div style="tab-size: 8" id="gist10402038" class="gist">
  <div class="gist-file" translate="no">
    <div class="gist-data">
      <div class="js-gist-file-update-container js-task-list-container file-box">
        <div id="file-nmapheartbleed-md" class="file my-2">
          <div id="file-nmapheartbleed-md-readme" class="Box-body readme blob js-code-block-container p-5 p-xl-6 ">
            <article class="markdown-body entry-content container-lg" itemprop="text"> 
            
            <h2>
              <a id="user-content-requirements" class="anchor" aria-hidden="true" href="#requirements"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Requirements
            </h2>
            
            <ol>
              <li>
                <a href="http://nmap.org/download" rel="nofollow">Nmap</a>. The script requires version 6.25 or newer. <em>The latest version, 6.47, already includes the next 3 dependencies</em>, so you can skip directly to the Scanning section below. <ul>
                  <li>
                    An easy way to get the latest Nmap release is to use <a href="http://www.kali.org/" rel="nofollow">Kali Linux</a>.
                  </li>
                  <li>
                    Binary installers are available for Windows.
                  </li>
                  <li>
                    RPM installer available for Linux, or install from source.
                  </li>
                  <li>
                    .dmg installer available for Mac OS X.
                  </li>
                </ul>
              </li>
              
              <li>
                <a href="http://nmap.org/nsedoc/lib/tls.html" rel="nofollow">tls.lua</a>. The script requires this Lua library for TLS handshaking.
              </li>
              <li>
                <a href="http://nmap.org/nsedoc/scripts/ssl-heartbleed.html" rel="nofollow">ssl-heartbleed.nse</a>. This is the script itself.
              </li>
              <li>
                <a href="http://nmap.org/nsedoc/lib/stdnse.html" rel="nofollow">stdnse.lua</a>. The ssl-heartbleed script above is the development version, so it depends on some functions that are not present in released versions of Nmap.
              </li>
            </ol>
            
            <h2>
              <a id="user-content-installation-guide" class="anchor" aria-hidden="true" href="#installation-guide"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Installation Guide
            </h2>
            
            <p>
              If you have <a href="http://nmap.org/download.html" rel="nofollow">Nmap version 6.46 or 6.47</a>, you can skip this section, since you already have the <code>ssl-heartbleed</code> script and the <code>tls.lua</code> library.
            </p>
            
            <p>
              Locate your Nmap files directory. On Linux, this is usually <code>/usr/share/nmap/</code> or <code>/usr/local/share/nmap/</code>.<br /> On Windows, it's either <code>C:\Program Files\Nmap\</code> or <code>C:\Program Files (x86)\Nmap\</code>
            </p>
            
            <p>
              Download the tls.lua and stdnse.lua libraries and put them in the <code>nselib</code> directory.
            </p>
            
            <p>
              Download the ssl-heartbleed.nse script and put it in the <code>scripts</code> directory
            </p>
            
            <p>
              Optionally, run <code>nmap --script-updatedb</code> to allow the script to run according to category (not necessary for this example).
            </p>
            
            <h2>
              <a id="user-content-scanning" class="anchor" aria-hidden="true" href="#scanning"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Scanning
            </h2>
            
            <p>
              Finally, run Nmap. Here are some recommended options to use:
            </p>
            
            ```
nmap -d --script ssl-heartbleed --script-args vulns.showall -sV X.X.X.X/24
```
            
            <p>
              Options summary:
            </p>
            
            <ul>
              <li>
                <code>-d</code> turns on debugging output, helpful for seeing problems with the script.
              </li>
              <li>
                <code>--script ssl-heartbleed</code> selects the ssl-heartbleed script to run on appropriate ports.
              </li>
              <li>
                <code>--script-args vulns.showall</code> tells the script to output "NOT VULNERABLE" when it does not detect the vulnerability.
              </li>
              <li>
                <code>-sV</code> requests a service version detection scan, which will allow the script to run against unusual ports that support SSL.
              </li>
            </ul>
            
            <p>
              Other helpful options:
            </p>
            
            <ul>
              <li>
                <code>--script-trace</code> shows a packet dump of all script-related traffic, which may show memory dumps from the Heartbleed bug.
              </li>
              <li>
                <code>-p 443</code> limits the script to port 443, but use caution! Even services like SMTP, FTP, and IMAP can be vulnerable.
              </li>
              <li>
                <code>-oA heartbleed-%y%m%d</code> saves Nmap's output in 3 formats as <code>heartbleed-20140410.nmap</code>, <code>heartbleed-20140410.xml</code>, and <code>heartbleed-20140410.gnmap</code>.
              </li>
            </ul>
            
            <h2>
              <a id="user-content-bugs" class="anchor" aria-hidden="true" href="#bugs"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Bugs
            </h2>
            
            <p>
              Before reporting a bug, please be sure that you
            </p>
            
            <ol>
              <li>
                have the latest version of Nmap, OR
              </li>
              <li>
                have the most recent version of the script and the tls.lua library (links on this page are always the most recent), and
              </li>
              <li>
                have installed the script and the library according to this guide.
              </li>
            </ol>
            
            <p>
              If you find a false-negative or false-positive bug with the script, please notify <a href="dev@nmap.org">the developers mailing list</a> or #nmap on Freenode IRC. Output with <code>-d</code> and <code>--script-trace</code> is especially appreciated.
            </p></article>
          </div></p>
        </div>
      </div>
    </div>
    
    <div class="gist-meta">
      <a href="https://gist.github.com/bonsaiviking/10402038/raw/0d296d843f7b18f142795c7ddcf741373636e1d3/NmapHeartbleed.md" style="float:right">view raw</a><br /> <a href="https://gist.github.com/bonsaiviking/10402038#file-nmapheartbleed-md">NmapHeartbleed.md</a><br /> hosted with &#10084; by <a href="https://github.com">GitHub</a>
    </div></p>
  </div>
</div>

http://nmap.org/book/man-host-discovery.html

Why not follow [@mylesagray on Twitter][13] for more like this!

 [1]: https://technet.microsoft.com/en-us/library/security/ms15-034.aspx
 [2]: https://support.microsoft.com/en-us/kb/3042553
 [3]: http://nmap.org
 [4]: images/Image-1.png
 [5]: images/Image-4.png
 [6]: http://nmap.org/book/man-os-detection.html
 [7]: images/Screen-Shot-2015-05-26-at-10.45.41.png
 [8]: https://support.microsoft.com/en-us/kb/929851
 [9]: https://nmap.org/nsedoc/lib/shortport.html#http
 [10]: http://seclists.org/nmap-dev/2010/q3/304
 [11]: https://thesprawl.org/research/writing-nse-scripts-for-vulnerability-scanning
 [12]: https://thesprawl.org/research/writing-nse-scripts-for-vulnerability-scanning/#aggregating-output
 [13]: https://twitter.com/mylesagray