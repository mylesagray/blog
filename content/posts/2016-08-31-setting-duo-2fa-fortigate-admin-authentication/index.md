---
title: Setting up Duo 2FA for Fortigate admin authentication
author: Myles Gray
type: posts
date: 2016-08-31T23:08:42+00:00
url: /infrastructure/setting-duo-2fa-fortigate-admin-authentication/
aliases: /security/setting-duo-2fa-fortigate-admin-authentication/
resources:
- name: "featured-image"
  src: images/DuoAuthProxy.png
categories:
  - Infrastructure
  - Networks
tags:
  - duo
  - fortigate
  - ldap
  - security
---

I protect any account I have with two factor auth, at least the ones that support it (this site for example has 2FA for admin logon), it's not that inconvenient (especially not with Authy/Duo) and greatly increases security of your critical accounts.

Let's start with the endgame:

![Duo Logon][1] 

However, I haven't protected my publicly accessible firewall with 2FA - mainly because there is no real built in method for using industry standard apps with it. (Who wants a hardware token or a paid for token nowadays? no thanks).

I have been using [Duo][2] recently for a lot of my 2FA accounts, mainly because I really like their "push" 2FA service, no need to type in any timed code, just tap approve on your phone/watch/whatever. They have an insane number of [application integrations][3] possible natively. However, there are a lot of services that don't offer native integration, Fortigate as a case-in-point are a vendor that only allow their own tokens to be used - however you can have your VPN and firewall admin users auth against LDAP/RADIUS.

Helpfully, Duo have an [auth proxy][4] that will sit between the firewall and our actual auth source, check the credential against the primary auth source, then send a push to your mobile device before sending the auth approved message back to the firewall - essentially giving you two factor for any device that can use LDAP/RADIUS as a backend auth mechanism, like below:

![Duo Auth Proxy][5] 

The beautiful part is it is completely application agnostic, the only requirement from the app is the ability to query a RADIUS or LDAP server.

You'll need to [sign up][6] and add your mobile verification method. We'll start by creating an application, navigate to the `Protect an Application` page, the number of apps is pretty overwhelming, but we are looking for `RADIUS` and then hit `Protect this Application`:

![Authy RADIUS Proxy][7] 

Give it a meaningful name as multiple can be used across multiple sites - I've named mine `MGIO-Lab-RADIUS-Proxy` I find it helps to prepend a site name or domain to the start to make it more obvious in future. I also like to change the username normalisation to `Simple` as it will accept any of the given formats, which is fine by me.

![Authy RADIUS Proxy Setup][8] 

Take note of the three credentials at the top; `Integration Key`, `Secret Key` and `API Hostname`.

Next we need to download the proxy, I typically install one on DC1 and another on DC2 with their primary auth methods pointed at themselves, with the other as a backup. This protects against app failure, VM failure and host failure (DRS anti-affinity rule).

As for any 2FA system, have backup keys as well as an unused admin user with a very long and complex password.

I'm using AD, so my auth proxy is going to live on Windows for handiness, you can of course run them on linux of you wish as well - either way you can [get them here][9].

Install on your chosen machine (very Next -> Next -> Finish type deal) and now for the actual setup. Navigate to and open this file with _wordpad_ as administrator (notepad messes with spacing and encoding):

    C:\Program Files (x86)\Duo Security Authentication Proxy\conf\authproxy.cfg
    

I've created a new domain user as a Duo service account called `_svc.duo` and also have encrypted the plaintext password with the Authy password encryptor located here (you will need to generate a new hash for each proxy as they are machine specific):

    C:\Program Files (x86)\Duo Security Authentication Proxy\bin\authproxy_passwd.exe
    

We also need to adjust the config from `service_account_password` to `service_account_password_protected` to let Duo know it's encrypted, my config looks like this with all the info plugged in:

    [ad_client]
    host=dc1.lab.mylesgray.io
    host_2=dc2.lab.mylesgray.io 
    service_account_username=_svc.duo  
    service_account_password_protected=<encrypted string>  
    search_dn=dc=lab,dc=mylesgray,dc=io
    security_group_dn=CN=Firewall_Admins,OU=Security Groups,OU=Groups,OU=Lab,DC=lab,DC=mylesgray,DC=io
    

Note from the above, `host_2` is my second DC in case the first isn't available - as stated before the same config will exist on the second proxy, just with `host` and `host_2` swapped. `security_group_dn` is the security group I want to filter users on to allow users admin access to the Fortigate. Save the file, you will be prompted if you want to remove formatting (this is fine) go ahead and save.

Now we need to set up the RADIUS proxy so we can actually query it from the Fortigate, we need to add another section to the `authproxy.cfg` file and fill in the details from the console we recorded earlier:

    [radius_server_auto]
    client=ad_client
    ikey=<your identity key here>  
    skey=<your secret key here>
    api_host=<your API hostname here>
    radius_ip_1=<your firewall IP>
    radius_secret_1=<add a password for RADIUS client auth here>
    failmode=secure
    

The `failmode=secure` in the above section can be added if you'd like to make Duo reject all logins if backend auth fails - if you have an out of band admin account this should be an okay option to use. The field `radius_secret_1` is just a password to allow the device `radius_1` to query the new RADIUS proxy, just make sure you match this to the firewall config later on.

Now we are ready to start the Duo service:

    net start DuoAuthProxy
    

If for whatever reason it fails to startup, go diving for logs in Event Viewer they are usually helpful and Google-able. Now your proxy is listening so it's time to configure the Fortigate. I'm using FortiOS 5.4.1 in my lab so your UI will likely look a little different, but it can be found in the `User & Device` section - we are going to configure a RADIUS Server with the below settings (note the active/backup radius servers):

![Fortigate RADIUS Server][10] 

I have created a group in AD `Firewall_Admins` as above to allow users access based on group membership - it's a pain adding and removing users manually from firewalls so for me centralised RBAC = win.

We will now create a user group on the Fortigate and associate it with the Duo RADIUS proxy - Navigate to `User & Device -> User Groups -> Create New` - Name the group, `Type` should be `Firewall` and we will add a remote group - your RADIUS Proxy should show in the list under `Remote Server` and no group is needed as we have already filtered within the proxy - so `Any` is fine here.

![Fortigate RADIUS User Group][11] 

Let's add the `Firewall_Admins` group to the Fortigate administrator users, this is found in `Global (if using VDOMs) -> System -> Administrators -> Create New`, give it a name and change the `Type` to `Match all users in a remote server group` (or choose `Wildcard` on FortiOS 5.2). Choose the `Firewall_Admins` group we created earlier - set the `Administrator Profile` to `super_admin`.

![Fortigate Admin Auth][12] 

That's should be it, given all has gone well - logout of the firewall and log back in with one of the users in the `Firewall_Admins` group in AD - the login screen will wait for you to confirm on your phone then continue once you have pressed accept.

It's a good idea to extend the login timeout on the fortigates to give you time to get your phone/process the logon, SSH into the firewalls and put this in to the console:

    #config global //if you're using VDOMs
    #config system global
    #set remoteauthtimeout 60
    #end
    #end //if you're using VDOMs
    

This Foritgate article helped out a lot in the end when I found myself spinning my wheels over providing admin auth to a group rather than individual users: <http://kb.fortinet.com/kb/documentLink.do?externalID=FD36127>

Why not follow [@mylesagray on Twitter][13] for more like this!

 [1]: images/IMG_0026.gif
 [2]: https://duo.com/
 [3]: https://duo.com/solutions/features/supported-applications
 [4]: https://duo.com/docs/authproxy-overview
 [5]: images/DuoAuthProxy.png
 [6]: https://signup.duo.com/
 [7]: images/DuoRADIUSProxySelection.png
 [8]: images/DuoRADIUSProxy.png
 [9]: https://duo.com/docs/ldap
 [10]: images/Fortigate-Radius-Config.png
 [11]: images/Screen-Shot-2016-08-31-at-23.42.58.png
 [12]: images/Screen-Shot-2016-08-31-at-23.45.31.png
 [13]: https://twitter.com/mylesagray