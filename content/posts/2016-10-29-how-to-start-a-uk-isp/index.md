---
title: 'How To: Start a UK Internet Service Provider'
author: Myles Gray
type: posts
date: -001-11-30T00:00:00+00:00
draft: true
url: /?p=2619
categories:
  - Networks
  - Miscellaneous
tags:
  - business
  - isp
  - networking
---

Up until I joined [Novosco][1] I had basically no interest in networking, thought of it as someone else problem, LAN, WAN, DC, didn't matter as long as it worked.

That changed when I got the chance to architect [STC][2], which is Novosco's new hosted platform for dedicated customer clouds - as you will read in an upcoming article, my involvement in the network design and architecture was deep, real deep - I learned more about networking in those 6-9 months than I had in my entire life.

But it did something else, it piqued my interest in networking - being purely storage/virtualisation focused before it's not something I ever saw happening, but here I am with my first VCIX (in the Networking track of all things) and writing an article about starting an internet service provider.

## Rationale

There are a multitude of reasons as to why to do this. I kind of want to start up an ISP so I can actually be a real part of the internet - with a /22 under my belt and an AS number, there's very little you can't do - at least from my primitive starting out point of view at `23:00 - 30/09/16`.

The other is somewhat more self-serving I kind of want to have symmetric upload and download to where my lab lives (which is a residence, not a datacenter - though it is often [thought of as one][3]) - no provider really does this for anyone other than a business, or unless you fork over a _ton_ of cash and even then, you don't get the full spectrum of services available due to standardisation by almost every provider on some core offerings, which makes good financial sense.

Now i'm not saying doing it my way is cheaper, but at the end of the day, price is only part of the reason one would become an ISP. Network resiliency certainly isn't one (what happens when the [DC hosting my edge router][4] and [transit goes down][5]? - That's now _my_ problem).

So if it's not for those reasons, what is it for..? _Because I want to_.

I love to learn stuff about how the internet works, how the underlying physical infrastructure and services that make someone's home connection "just connect to the internet". There are a few other motivations, that will likely be made clear here in the future - but mainly, I want more bandwidth, symmetrical bandwidth and I want to learn.

So - first up, this guide is specific to the UK, at least the first part as it's where I live and it's where the providers I will use are based.

## The Legal Bits

In the UK, almost all physical infrastructure is run by OpenReach - a spinoff from BT. Some is operated by private companies (Virgin have their own cables in the ground for example).

To deal with [OpenReach][6] you need a [DUNS number][7] which is a uniquely identifying number provided for free to any registered company. Oh, by the way then, you also need a company - so set one up with the help from [gov.uk][8] and online service for [Companies House][9] - register a company and then applying for your DUNS number - it's actually a pretty painless process.

Be aware, registering as a company has some obligations that need to be fulfilled yearly and on time or you will face penalties (Corporation Tax, etc) - it may be worth having an accountant deal with all that stuff.

Why not follow [@mylesagray on Twitter][10] for more like this!

 [1]: https://www.novosco.com
 [2]: https://www.novosco.com/cloud-solutions/single-tenant-cloud
 [3]: /hardware/my-home-datacenter/
 [4]: http://www.theregister.co.uk/2016/07/20/telecity_power_outage_bt_offline/
 [5]: http://www.theregister.co.uk/2016/07/21/bt_customers_broadband_outage/
 [6]: https://www.openreach.co.uk/orpg/home/loadBecomeNonPortalCustomerForm.do
 [7]: https://europe.dnb.com/find-my-duns/
 [8]: http://register%20company%20online%20uk
 [9]: https://ewf.companieshouse.gov.uk/runpage?page=welcome
 [10]: https://twitter.com/mylesagray