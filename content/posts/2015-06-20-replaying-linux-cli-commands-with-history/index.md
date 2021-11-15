---
title: Replaying Linux CLI commands with history
author: Myles Gray
type: posts
date: 2015-06-20T08:00:18+00:00
lastmod: 2021-10-25T12:11:00+00:00
description: "Hot to use the linux history command"
url: /linux/replaying-linux-cli-commands-with-history
aliases: ["/linux/replaying-linux-cli-commands-with-history", "/linux/replaying-linux-cli-commands-with-history/amp", "/software/replaying-linux-cli-commands-with-history", "/software/replaying-linux-cli-commands-with-history/amp"]
cover:
  relative: true
  image: images/Image-3.webp
  alt: "Linux history output"
categories:
  - Linux
tags:
  - cli
  - linux
  - cli history
---

Very handy little snippet I discovered today, mostly here for my own reference in future.

It's handy to be able to re-play/re-submit commands that you've typed into the CLI before on your Linux box, to do this you can use the `history` command.

Let's take a look at my webserver hosting the site, just as an example:

```sh
root@web:~# history
  781  nano /etc/cron.hourly/.placeholder sess_
  782  crontab
  783  crontab -e
  784  nano /etc/cron.d/php5
  785  sudo bash
  786  exit
  787  sudo bash
  788  service php5-fpm restart
  789  service nginx restart
  790  service varnish restart
```

If I want to look for particular entries I can just `grep` the output:

```sh
root@web:~# history | grep "cat"
 1005  cat /etc/nginx/sites-enabled/default
 1006  cat /etc/nginx/sites-enabled/www.mylesgray.com
 1027  cat mini/README.txt
 1137  cat var/report/1084963200249
```

Then if you pay attention to the left hand column, there is a history number, to re-enter a command we simple put a bang (`!`) in front of the number in the CLI:

```sh
root@web:~# !1006
cat /etc/nginx/sites-enabled/www.mylesgray.com
## https://blah.cloud -> https://blah.cloud
server {
.
.
.
etc
```

If you want to execute the very last command you typed:

```sh
root@web:~# !!
```

If you want to execute a command issued `n` commands previous:

```sh
root@web:~# !-n
```

If you want to execute the last command starting with `word`:

```sh
root@web:~# !word
```

If you want to execute the last command containing `word`:

```sh
root@web:~# !?word
```

If you want to view the parameters passed to the last command:

```sh
root@web:~# !*
```

If you want to view the parameters passed to command `n` commands previous:

```sh
root@web:~# !-n*
```

As you can see, plenty of options, these are by no means exhausted, you can combine them to create any kind of filter in-between.

Bonus extra tip - if you forgot to add `sudo` to a command that requires it (because we all do) this will repeat the last command, with `sudo` prefixed to it:

```sh
root@web:~# sudo !!
```

Why not follow [@mylesagray on Twitter][1] for more like this!

 [1]: https://twitter.com/mylesagray
