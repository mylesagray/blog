---
title: Utilising Kerberos/AD auth in Ubuntu 14.04 with realmd
author: Myles Gray
type: posts
date: 2014-12-08T01:00:41+00:00
lastmod: 2021-10-25T10:54:00+00:00
description: "How to use realmd to federate SSO authentication to Microsoft Active Directory"
url: /infrastructure/utilising-kerberosad-auth-ubuntu-14-04-realmd
aliases: [ "/infrastructure/utilising-kerberosad-auth-ubuntu-14-04-realmd/amp" ]
cover:
  relative: true
  image: images/Screen-Shot-2014-12-07-at-16.35.40.png
  alt: "SSSD to AD federation"
categories:
  - Infrastructure
  - Linux
tags:
  - active directory
  - authentication
  - linux
  - ubuntu
---

It has, over the years always been quite a quandary to get SSO auth working from `*nix -> MS AD` without a huge amount of fiddling and tinkering, but there is a new auth framework in town by the name of [`realmd`][1]. While tinkering with [The Foreman][2] recently it had dawned on me it would be cool to have it set up such that, after the VM had been automatically provisioned it would allow me to SSH into it using my AD credentials.

This has the double benefit of providing SSO for users through SASL/GSSAPI and auto registering the linux box in Windows DNS if that is what you use as your DNS server backend.

Obviously before you can script something like this with [Puppet][3]/[Foreman][2] it is a good idea to do a test install on a blank Ubuntu 14.04.1 box so you know what exactly needs configured, so I spun up a VM using my newly created [PXE boot environment][4] to start playing around with.

`realmd` encompasses a number of existing technologies into a rather [easy to install and configure][5] package to get SSO/LDAP integration to work, primarily it uses a package developed by RedHat called [`SSSD`][6] that takes care of LDAP and Kerberos communications for you.

[RedHat docs][7] on SSSD/Kerberos/LDAP setup, pros/cons (Section 6.3).

![SSSD Architecture][8]

The reason I chose this implementation is clearly outlined in the RedHat doc above:

> * Kerberos SSO capable
> * Supports SASL/GSSAPI binds for LDAP queries (optional)
> * Enforces encrypted authentication only
> * Client side caching of user information
> * Off-line caching of previously authenticated user credentials
> * Reduces number of client queries to server
> * Graceful ID collision management

`realmd` is really a wrapper for `SSSD` and to quote the site:

> realmd configures sssd or winbind to do the actual network authentication and user account lookups.

To the configuration then, first we have to install `realmd` and `sssd`:

```sh
sudo aptitude install realmd sssd samba-common samba-common-bin samba-libs sssd-tools krb5-user adcli packagekit -y
```

Enter your full domain name in all caps when prompted for `Default Kerberos version 5 realm`, e.g. `EXAMPLE.DOMAIN.COM`

Gain a kerberos ticket from AD:

```sh
kinit -V myles.gray
```

Add the short and long domain names to the `/etc/hosts` file (order is important) and save:

```sh
#edit the localhost entry to include the box's short and long names like below
127.0.0.1     test1.domain.example.com test1 localhost
```

**_N.B. If you don't do the above you will see an error in the following output similar to the below:_**

```sh
DNS update failed: NT_STATUS_INVALID_PARAMETER
Using short domain name -- {your domain name here}
Joined 'TEST1' to dns domain 'domain.example.com'
No DNS domain configured for test1. Unable to perform DNS Update.
```

If you do come across this problem leave the domain and then edit the `/etc/hosts` file. You can leave the domain with the following command:

```sh
realm --verbose leave -U myles.gray domain.example.com
```

Now we can run our `realm join` command to join us to AD:

```sh
realm --verbose join -U myles.gray domain.example.com
```

You will be prompted for your admin user's password, enter this and you should receive an output like below:

```sh
root@test1:~# realm --verbose join -U myles.gray domain.example.com
 * Resolving: _ldap._tcp.domain.example.com
 * Performing LDAP DSE lookup on: 10.0.1.123
 * Performing LDAP DSE lookup on: 10.0.1.124
 * Successfully discovered: domain.example.com
Password for myles.gray: 
 * Unconditionally checking packages
 * Resolving required packages
 * Installing necessary packages: sssd-tools, libpam-sss, libnss-sss, sssd, samba-common-bin
 * LANG=C LOGNAME=root /usr/bin/net -s /var/cache/realmd/realmd-smb-conf.X2OPQX -U myles.gray ads join domain.example.com
Enter myles.gray's password:
Using short domain name -- DOMAIN
Joined 'TEST1' to dns domain 'domain.example.com'
 * LANG=C LOGNAME=root /usr/bin/net -s /var/cache/realmd/realmd-smb-conf.X2OPQX -U myles.gray ads keytab create
Enter myles.gray's password:
 * /usr/sbin/update-rc.d sssd enable
update-rc.d: /etc/init.d/sssd: file does not exist
 * /usr/sbin/service sssd restart
stop: Unknown instance: 
sssd start/running, process 9085
 * Successfully enrolled machine in realm 
```

We need to also [comment out this line][9] in our `/etc/sssd/sssd.conf` file because of a [`segfault` bug known to RH][10]:

```sh
#use_fully_qualified_names = True
```

Restart `sssd` service:

```sh
service sssd restart
```

Now if we run a `realm list` we should see some info about our newly joined domain:

```sh
root@test1:~# realm list
domain.example.com
  type: kerberos
  realm-name: domain.example.com
  domain-name: domain.example.com
  configured: kerberos-member
  server-software: active-directory
  client-software: sssd
  required-package: sssd-tools
  required-package: sssd
  required-package: libnss-sss
  required-package: libpam-sss
  required-package: adcli
  required-package: samba-common-bin
  login-formats: %U
  login-policy: allow-realm-logins
```

Check the group membership of our AD user and that the AD integration is working correctly:

```sh
root@test1:~# id myles.gray
uid=952601104(myles.gray) gid=952600513(domain users) groups=952600513(domain users),952601139(virtualisation admins),952600519(enterprise admins),952601127(inet_filter_none),952603106(foreman_admins),952600512(domain admins),952600518(schema admins),952603117(linux_admins),952603116(linux_users),952601103(net-users),952601152(vpn users),952600572(denied rodc password replication group)
```

Now choose the groups we want to allow login from by denying all (default is allow all) then allowing explicit AD groups (in my case, Linux_Users):

```sh
realm deny -R domain.example.com -a
realm permit -R domain.example.com -g Linux_Users
```

Now we can add our Active Directory `Domain Admins` and `Linux_Admins` groups to the `/etc/sudoers` file to give root access for users in those security groups:

```sh
visudo
```

Add the following lines (it is important to escape spaces in group names with a `\`):

```sh
%domain\ admins ALL=(ALL:ALL) ALL
%Linux_Admins ALL=(ALL:ALL) ALL
```

One thing I like to do is have each user get their own automatically generated home directory in the format `/home/domain.example.com/myles.gray`, PAM can do this for us if we edit the `/etc/pam.d/common-session` file:

```sh
nano /etc/pam.d/common-session
```

Add this line at the **end** of the file:

```sh
session required        pam_mkhomedir.so skel=/etc/skel/ umask=0022
```

User directories will be automatically created in the format `/home/domain.example.com/myles.gray` upon login.

You should now be able to SSH into the guest with your AD credentials and `sudo bash` if you are a member of `Linux_Admins` or `Domain Admins` AD groups:

```sh
Myless-MacBook-Pro:~ myles.gray$ ssh myles.gray@10.0.2.18
myles.gray@10.0.2.18's password: 
Creating directory '/home/home.kharms.co.uk/myles.gray'.
Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-40-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

Last login: Mon Dec  8 00:31:25 2014 from 10.0.3.2
myles.gray@test1:~$
```

Run a `pwd` to make sure our home directory was created and we were placed there:

```sh
myles.gray@test1:~$ pwd
/home/home.kharms.co.uk/myles.gray
```

Check out if we can `sudo bash` as a member of one of the two AD groups we configured as `sudoers`:

```sh
myles.gray@test1:~$ sudo bash
[sudo] password for myles.gray: 
root@test1:~# 
```

You now have full AD auth for users and groups in your linux environment. I will likely revisit this or make another post about SSO/password-less ssh login using Kerberos in the near future. For the moment, good luck!

Sources:

* <http://stephenfritz.blogspot.it/2014/04/linux-microsoft-active-directory_28.html>
* <http://funwithlinux.net/2014/04/join-ubuntu-14-04-to-active-directory-domain-using-realmd/>
* <http://serverfault.com/questions/436037/sudoers-file-allow-sudo-on-specific-file-for-active-directory-group>
* <http://derflounder.wordpress.com/2012/12/14/adding-ad-domain-groups-to-etcsudoers/>
* <http://www.chriscowley.me.uk/blog/2014/06/17/new-linux-active-directory-integration/>

Why not follow [@mylesagray on Twitter][11] for more like this!

 [1]: http://www.freedesktop.org/software/realmd/
 [2]: http://theforeman.org
 [3]: http://puppetlabs.com
 [4]: /infrastructure/enabling-pxe-boot-options-fortigate-dhcp/
 [5]: https://wiki.ubuntu.com/Enterprise/Authentication#Suggestions
 [6]: http://rhelblog.redhat.com/2014/01/20/who-goes-there/
 [7]: http://www.redhat.com/en/files/resources/en-rhel-intergrating-rhel-6-active-directory.pdf
 [8]: images/Screen-Shot-2014-12-07-at-16.35.40.png
 [9]: http://serverfault.com/questions/598476/how-to-use-realmd-in-ubuntu-14-04-lts-to-join-an-active-directory-domain
 [10]: https://bugzilla.redhat.com/show_bug.cgi?id=824616
 [11]: https://twitter.com/mylesagray
