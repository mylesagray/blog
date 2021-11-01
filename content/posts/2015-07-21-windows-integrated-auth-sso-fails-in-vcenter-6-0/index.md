---
title: Windows Integrated Auth (SSO) fails in vCenter 6.0
author: Myles Gray
type: posts
date: 2015-07-21T22:26:04+00:00
lastmod: 2021-10-25T12:33:00+00:00
description: "How to troubleshoot AD SSO integration failing in vSphere"
url: /virtualisation/windows-integrated-auth-sso-fails-in-vcenter-6-0
aliases: ["/virtualisation/windows-integrated-auth-sso-fails-in-vcenter-6-0", "/virtualisation/windows-integrated-auth-sso-fails-in-vcenter-6-0/amp", "/software/windows-integrated-auth-sso-fails-in-vcenter-6-0", "/software/windows-integrated-auth-sso-fails-in-vcenter-6-0/amp"]
cover:
  relative: true
  image: images/Screen-Shot-2015-07-21-at-23.22.50.png
  alt: "Windows SSO integration with vSphere"
categories:
  - Virtualisation
  - Infrastructure
tags:
  - authentication
  - sso
  - vcenter
  - vmware
---

If you've just spun up a new vCenter 6.0 appliance, have joined it to the domain and added a new identity source but have found that your integrated windows auth (the handy checkbox you use for SSO) isn't working with this error:

```sh
A General System error occurred: Cannot get user info
```

Then it's because the `nsswitch.conf` file is missing the `lsass` parameter, to remedy this:

`SSH` as `root` to your vCenter server appliance.

Enable the local shell:

```sh
shell.set --enabled True
shell
```

Open the `nsswitch.conf` file:

```sh
vi /etc/nsswitch.conf
```

Find the line that specifies:

```sh
passwd: compat ato
```

And append `lsass` so it looks like this:

```sh
passwd: compat ato lsass
```

Write & exit the file then restart the `vpxa` service.

```sh
/etc/init.d/vmware-vpxd restart
```

You will now be able able to log into vCenter using SSO in both the web client and legacy client:

![Windows integrated authentication vCenter 6.0][1]

Why not follow [@mylesagray on Twitter][2] for more like this!

 [1]: images/Screen-Shot-2015-07-21-at-23.22.50.png
 [2]: https://twitter.com/mylesagray
