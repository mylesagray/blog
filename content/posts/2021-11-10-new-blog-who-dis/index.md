---
title: "New Blog, Who Dis?"
author: Myles Gray
date: 2022-01-18T16:00:00Z
lastmod: 2022-01-18T16:00:00Z
type: posts
description: "Myles, it's been three years, where have you been mate?"
url: /miscellaneous/new-blog-who-dis
cover:
  relative: true
  image: images/cover.webp
  alt: "Blah, Cloud - Now with more Hugo"
categories:
  - Miscellaneous
tags:
  - hugo
  - github pages
  - github actions
  - cloudflare
  - website
---

## Context

Hey... so it's been a while since there was a post here (_stares at last blog [in 2019](/kubernetes/clusterapi-for-vsphere-now-with-cns-support/)_) - for a number of reasons, and you might have noticed a few changes around here if you've followed the blog for any length of time.

Some context behind the large gap, and reasons for the changes: Working in Technical Marketing for a vendor means that a lot of the time you spend working and researching things that are essentially part of the "output" for your job, meaning that most of your time and effort is spent on building content that can be used internally and externally, and subsequently if there is a decision for "_does this belong on my personal blog, or on the work blog?_" the answer basically always favours the work forums.

With that in mind, I've come up with a bit more of a deliniation between the two and what "_Blah, Cloud_" is really used for. It's my personal site, and in the past it's largely been covering vendor stuff - that's going to change a bit.

In the past I was treating my blog how I treat my work blog, and wouldn't allow myself to post things that are more personal or non-work related, but I have a vast number of thoughts, projects and ideas that i'd like to share that don't fit into that bucket - and I figure, if you're of the same persuations as me why not stick around, maybe theres some overlap!

Instead, I see this becoming a place where I can post about things like my [race car builds](/now/#cars), home automation, [machine learning experiments](http://github.com/mylesagray/anpr-knative), any [techy](/now/#simulators)/[nerdy](/now/#robotics) endeavours I might be working on, [beer brewing](/now/#brewing), [3D printing](/now/#3d-printing) & CNC; and wider opinion based thought pieces (**cough** _engineering for failure and planned obscelesence_ **cough**).

## What's new?

### Site Design

You might have noticed that the site looks totally different from it's previous incarnation as a Wordpress site - that's for a few reasons, I wanted to make it simpler, to streamline and optimise the look (and [the network calls](https://webpagetest.org/result/220118_AiDcQF_612cd136e0d01c614f64b7bd7d0fe229/)) and the processing time as well as make it [mobile responsive and SEO friendly](https://pagespeed.web.dev/report?url=https%3A%2F%2Fblah.cloud%2Fkubernetes%2Fclusterapi-for-vsphere-now-with-cns-support%2F), and allow me to use my workflow (writing in markdown and using git) - all of those things are delivered by [Hugo](https://gohugo.io), and a [heavily customised theme](https://git.io/JPbaU) with some optimisations built in.

### Site Stack

Under the hood this baby runs on GitHub Pages and Actions, uses CloudFlare as a CDN with a CloudFlare Worker for analytics via [Plausible](https://plausible.io/blah.cloud) - and still manages to only weigh in at 66KB on a full article, and load it **uncached** in 0.4s.

_C'est tres rapide, no?!_

I've also made my analytics public so you can see just what info is gathered ([not much, and no PII](https://plausible.io/data-policy), no cookie popup, you're welcome.) check that out [here](https://plausible.io/blah.cloud/).

### Site Content

I've taken the time to write a few new pages that will be permanent fixtures here and provide a whole bunch more references and information to what i've been up to for the last while:

* [Bio](/bio) - Longer term background, trends, and contact info
* [Now](/now) - What I'm up to _right now_ in short little snippets, updated regularly
* [Works](/works) - Content I've created - videos, blogs, solutions, git repos, etc

I've also moved and refactored all of the content that was on the Wordpress site and also taken the time to make sure that _every single link, in every single blog_ is working, was redirected, or is replaced with a new reference, this was a few weeks of evenings work, but as you can see from the [metrics on 404s](https://plausible.io/blah.cloud?goal=404) - it's looking pretty good.

Not to mention, the [entire site](https://github.com/mylesagray/blog) and all its [comments](https://github.com/mylesagray/blog-comments/issues) are open source.

## The Future

So with all that in mind, a few ideas I have for things i'd like to write about over the next while, should it interest any of you:

* Migrating from Wordpress to Hugo
* Building and automating social card icons for Hugo
* Building/customising a Hugo theme for performance _and_ content
* Building an [auto-scaling numberplate recognition system](http://github.com/mylesagray/anpr-knative), from scratch
* Optimising machine learning models
* Using github as a comment system for Hugo
* Building and scaling a multi-arch home K8s cluster
* Using hardware accelerators with K8s for ML scheduling
* [Building](https://www.thingiverse.com/thing:3445283) and [training](https://www.youtube.com/watch?v=A0tPe7-R8z0) robots to walk
* Compiling custom kernels for Jetson Nanos
* Pathfinding and mazebuilding algorithms (with GANs?)
* Using RTL-SDR for plane tracking and LoRa WANs
* Hacking Ikea smart blinds to add features that should have been OOTB
* Planned obscelence is alive and well in the appliance industry
* ...and a lot more.

Here's to the next chapter of _Blah, Cloud_!
