---
title: Using AD signed certificates with vCenter Server Appliance 6
author: Myles Gray
type: posts
date: 2015-07-19T19:48:56+00:00
lastmod: 2021-10-25T12:29:00+00:00
description: "How to create AD trusted certificates for vSphere"
url: /virtualisation/using-ad-signed-certificates-with-vcenter-server-appliance-6
aliases: ["/virtualisation/using-ad-signed-certificates-with-vcenter-server-appliance-6", "/virtualisation/using-ad-signed-certificates-with-vcenter-server-appliance-6/amp", "/security/using-ad-signed-certificates-with-vcenter-server-appliance-6", "/security/using-ad-signed-certificates-with-vcenter-server-appliance-6/amp"]
cover:
  relative: true
  image: images/Screen-Shot-2015-07-19-at-20.44.44.png
  alt: "vSphere with a valid corp AD cert"
categories:
  - Virtualisation
  - Infrastructure
tags:
  - active directory
  - certificate manager
  - certificates
  - vcenter
---

Creating signed certs for vCenter has _never_ been easy, with the new release of 6.0 though this has changed somewhat, there is a built in certificate manager that allows you to import a `CA` (say `Microsoft AD`) cert and key to have `VMCA` sign it's own certs with and make them trusted.

First thing, we need to set up an `AD` cert template for vSphere 6.0, that's in [my article here][1].

Next, log in to your vCenter Server Appliance as root and enter:

```sh
shell.set --enabled True
shell
```

This will get us access to the `VCSA` underlying OS CLI

Create a directory to store our `csr` and `key`:

```sh
mkdir /root/SSLCerts
```

Next we will need to launch the certificate manager, execute:

```sh
/usr/lib/vmware-vmca/bin/certificate-manager
```

You will see a display like so:

```sh
 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
|                                                                     |
|      *** Welcome to the vSphere 6.0 Certificate Manager  ***        |
|                                                                     |
|                   -- Select Operation --                            |
|                                                                     |
|      1. Replace Machine SSL certificate with Custom Certificate     |
|                                                                     |
|      2. Replace VMCA Root certificate with Custom Signing           |
|         Certificate and replace all Certificates                    |
|                                                                     |
|      3. Replace Machine SSL certificate with VMCA Certificate       |
|                                                                     |
|      4. Regenerate a new VMCA Root Certificate and                  |
|         replace all certificates                                    |
|                                                                     |
|      5. Replace Solution user certificates with                     |
|         Custom Certificate                                          |
|                                                                     |
|      6. Replace Solution user certificates with VMCA certificates   |
|                                                                     |
|      7. Revert last performed operation by re-publishing old        |
|         certificates                                                |
|                                                                     |
|      8. Reset all Certificates                                      |
|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
```

We are going to use `option 1` to replace the `machine_ssl` cert an `AD` signed one.

You will now be prompted for your `SSO user` password (usually `administrator@vsphere.local` unless you've changed it during setup like me), so enter it.

No you're going to be asked:

```sh
1. Generate Certificate Signing Request(s) and Key(s) for Machine SSL certificate
2. Import custom certificate(s) and key(s) to replace existing Machine SSL certificate
```

Option [1 or 2]: 1

We want to choose `option 1` to generate the `csr` for signing by `AD`.

Choose an output directory (`/root/SSLCerts` created earlier).

```sh
Please provide a directory location to write the CSR(s) and PrivateKey(s) to: 
Output directory path: /root/SSLCerts
2015-07-19T18:48:25.878Z   Running command: ['/usr/lib/vmware-vmca/bin/certool', '--genkey', '--privkey', '/root/SSLCerts/machine_ssl.key', '--pubkey', '/tmp/pubkey.pub']
2015-07-19T18:48:26.144Z   Done running command
2015-07-19T18:48:26.145Z   Running command: ['/usr/lib/vmware-vmca/bin/certool', '--gencsrfromcert', '--privkey', '/root/SSLCerts/machine_ssl.key', '--cert', '/tmp/vecs_crt.crt', '--csrfile', '/root/SSLCerts/machine_ssl.csr']
2015-07-19T18:48:26.245Z   Done running command

CSR generated at: /root/SSLCerts/machine_ssl.csr
```

As you can see the `.csr` was generated at: `/root/SSLCerts/machine_ssl.csr` so we will `cat` the output file (open another `ssh` session to the `vc`) to get the `csr`:

```sh
cd /root/SSLCerts/
cat machine_ssl.csr
```

Output will be in standard `csr` format:

```sh
vc1:~/SSLCerts # cat machine_ssl.csr 
-----BEGIN CERTIFICATE REQUEST-----
{CSR HERE}
-----END CERTIFICATE REQUEST-----
```

Load up `AD CertSvc` (usually at: `https://{DCnameorIP}/CertSrv/en-US/`) and follow this procedure:

* Request Certificate
* Advanced Certificate Request
* Certificate Template: vSphere 6.0
* Paste the `csr` in and click `submit`.

![CSR Request][2]

Next, download the certificate as `Base 64 encoded` (**not the chain!**).

Open the cert with notepad/sublime text or such and paste the content into a new file on the `vcsa`:

```sh
vi /root/SSLCerts/machine_ssl.cer
```

Put `vi` into `insert` mode:

```sh
i
```

Paste in the contents of the `cer` file, then hit `Esc`, write and quit the file:

```sh
:wq
```

Download the `CA root` certificate in `Base 64` also and add it to another file, as above, called `ca.cer`.

You should now have 4 files in `/root/SSLCerts/`:

* ca.cer
* machine_ssl.cer
* machine_ssl.csr
* machine_ssl.key

Back in the first `ssh` session where `certificate manager` is running enter `option 1` and enter the requested signed cert file paths:

```sh
     1. Continue to importing Custom certificate(s) and key(s) for Machine SSL certificate

     2. Exit certificate-manager 

Option [1 or 2]: 1

Please provide valid custom certificate for Machine SSL.
File : /root/SSLCerts/machine_ssl.cer

Please provide valid custom key for Machine SSL.
File : /root/SSLCerts/machine_ssl.key

Please provide the signing certificate of the Machine SSL certificate
File : /root/SSLCerts/ca.cer

You are going to replace Machine SSL cert using custom cert
Continue operation : Option[Y/N] ? : y
Status : 100% Completed [All tasks completed successfully] 
```

And we're done!

![Valid cert on vCenter 6.0 Web Client][3]

**References:**

* [VMware KB 2111571][4]
* [VMware blog on custom certs][5]
* [VMware KB 2097936][6]

Why not follow [@mylesagray on Twitter][7] for more like this!

 [1]: /security/creating-a-vsphere-6-certificate-template-in-active-directory/
 [2]: images/Screen-Shot-2015-07-19-at-19.52.47.png
 [3]: images/Screen-Shot-2015-07-19-at-20.44.44.png
 [4]: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2111571
 [5]: http://blogs.vmware.com/vsphere/2015/07/custom-certificate-on-the-outside-vmware-ca-vmca-on-the-inside-replacing-vcenter-6-0s-ssl-certificate.html
 [6]: http://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=2097936
 [7]: https://twitter.com/mylesagray
