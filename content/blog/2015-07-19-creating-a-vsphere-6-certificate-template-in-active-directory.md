---
title: Creating a vSphere 6 certificate template in Active Directory
author: Myles Gray
type: post
date: 2015-07-19T18:43:13+00:00
url: /security/creating-a-vsphere-6-certificate-template-in-active-directory/
cover:
  image: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.40.43.png
categories:
  - Security
tags:
  - active directory
  - certificates
  - certtmpl.msc
  - vcenter
  - vsphere 6

---
Signing certs for VMware has always been a pain in the ass, it's gotten a lot better in v6 but there are a few caveats, what we're going to do here is set up a certificate template in Active Directory from which we will sign our vCenter certificates.

Load up your `AD-CA` box and **run**:

    certtmpl.msc
    

Next **right click** on `Web Server` and click `Duplicate Template`:

![Duplicate Template][1] 

If you use an encryption level higher than `sha1` choose `Windows Server 2008` as the Certification Authority.

![Certification Authority][2] 

Click the `General` tab and change the name to something significant to you (mine is `vSphere 6.0`).

![Template Name][3] 

Then navigate to the `Extensions` tab and select `Application Policies` and click **Edit**, select `Server Authentication` and click **Remove** then **Ok**.

![Remove Server Authentication][4] 

Select `Key Usage` and click **Edit**. Select **Signature is proof of origin (nonrepudiation)** option and click **Ok**.

![Key Usage Options][5] 

Move to the `Subject Name` tab. Make sure **Supply in the request** option is selected. Click **Ok** on both dialogues. It should now show up in your cert templates like so:

![vSphere 6.0 Certificate Template][6] 

Load up `mmc` and add the `Certificate Authority` snap-in.

Navigate to the `Certificate Templates` folder and _right click_ choose `New -> Certificate Template to Issue` then select _vSphere 6.0_.

![Add as a certificate template][7] 

We are now ready to use the template for signing vCenter certs.

Why not follow [@mylesagray on Twitter][8] for more like this!

 [1]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.22.13.png
 [2]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.33.36.png
 [3]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.33.30.png
 [4]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.33.54.png
 [5]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.39.02.png
 [6]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.40.43.png
 [7]: /uploads/2015/07/Screen-Shot-2015-07-19-at-19.51.03.png
 [8]: https://twitter.com/mylesagray