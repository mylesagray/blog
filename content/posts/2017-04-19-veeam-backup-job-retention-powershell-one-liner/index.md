---
title: "Veeam Backup job retention PowerShell one-liner"
author: Myles Gray
date: 2017-04-19T17:02:06+01:00
type: posts
url: /command-line-fu/veeam-backup-job-retention-powershell-one-liner
categories:
  - Infrastructure
ShowPostRelatedContent: false
disableShare: true
comments: false
hideMeta: true
ShowToc: false
---
Pulls back a table of Job name vs configured retention for Backup type jobs:

```powershell
Get-VBRJob | ? {$_.jobtype -eq "Backup"} | Select-Object -Property @{N="Job Name"; E={$_.name}}, @{N = "Storage Retention"; E={$_.GetOptions().BackupStorageOptions.RetainCycles}} | Format-Table -AutoSize
```
