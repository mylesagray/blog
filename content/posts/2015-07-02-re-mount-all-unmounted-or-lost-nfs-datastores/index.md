---
title: 'Re-mount all unmounted or "lost" NFS Datastores'
author: Myles Gray
date: 2015-07-02T16:55:28+01:00
type: posts
url: /command-line-fu/re-mount-all-unmounted-or-lost-nfs-datastores
categories:
  - Infrastructure
ShowPostRelatedContent: false
disableShare: true
comments: false
hideMeta: true
ShowToc: false
---
Particularly useful if you have used DNS for your NFS datastore mounts and have rebooted the host with the only DNS server on it:

```sh
esxcfg-nas -r
```
