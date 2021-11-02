---
title: "{{ replace (replace .Name "-" " ") (now.Format "2006 01 02 ") "" }}"
author: Myles Gray
date: {{ .Date }}
lastmod: {{ .Date }}
type: posts
description: "Text-description"
url: /category/postname
cover:
  relative: true
  image: images/cover.png
  alt: "Some-text"
categories:
  - Infrastructure
tags:
  - tag
draft: true
---
