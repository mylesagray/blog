---
title: 'How to: Run emoncms on NginX and PHP5-FPM'
author: Myles Gray
type: posts
date: 2012-11-12T19:43:46+00:00
url: /miscellaneous/how-to-run-emoncms-on-nginx-and-php5-fpm
aliases: ["/miscellaneous/how-to-run-emoncms-on-nginx-and-php5-fpm", "/miscellaneous/how-to-run-emoncms-on-nginx-and-php5-fpm/amp", "/ardunio-hacking/how-to-run-emoncms-on-nginx-and-php5-fpm", "/ardunio-hacking/how-to-run-emoncms-on-nginx-and-php5-fpm/amp"]
description: "How to setup emoncms to run behind and NginX proxy with php5-fpm"
cover:
  image: images/Screen-Shot-2013-09-09-at-15.20.58.png
  alt: "Screenshot of emoncms"
categories:
  - Miscellaneous
tags:
  - Arduino
  - emoncms
  - NginX
  - PHP5-FPM
---

For those of you that don't know, [emoncms][1] is a small cms that will accept inputs via GET requests for things like power meters, temp probes for measuring household power usage, PV panel, windmill etc power production levels.

To achieve this you need to use git to download the newest version of emoncms (the new more modularised version):

```bash
git clone git://github.com/emoncms/emoncms.git
```

Next step is to set up a mysql db:

```sql
$ mysql -u root -p
mysql> CREATE DATABASE emoncms;
mysql> exit
```

Next we are going to write and nginx config for emoncms I have hosted mine on https w/ SPDY however for simplicity this config is for http:

```nginx
server {
        listen 80;
        server_name sub.domain.name;

        location / {
                root /path/to/your/emoncms;
                index index.php;
                rewrite ^/(.*)$ /index.php?q=$1 last;
        }

        location ~* ^.+.(jpg|jpeg|gif|css|png|js|ico|xml)$ {
                expires           30d;
                root /path/to/your/emoncms;
        }

        location ~ .php$ {
                fastcgi_split_path_info ^(.+.php)(.*)$;
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME  /path/to/your/emoncms$fastcgi_script_name;
                include fastcgi_params;
                fastcgi_intercept_errors        on;
        }
}
```

I'd like to highlight this line:

```json
rewrite ^/(.*)$ /index.php?q=$1 last;
```

This is extremely important to make emoncms work, it rewrites the pretty URLs to reference them to the index file. Without this you will get "Invalid Username/Password" when you try to log in or register. cd to your emoncms folder and move the default settings file to make it active, then open it:

```bash
cd /var/www/emoncms/
mv default.settings.php settings.php
nano settings.php
```

Then change your DB settings like so:

```php
/*

Database connection settings

*/

$username = "youruser";
$password = "yourpassword";
$server   = "localhost";
$database = "emoncms";
```

Now restart NginX:

```bash
service nginx restart
```

If all is well you will be able to navigate to your URL, enter a username and password _then_ click Register, a bit counter-intuitive but there we are.

![Emoncms Graph][2]

Why not follow [@mylesagray on Twitter][3] for more like this!

 [1]: https://emoncms.org
 [2]: images/Screen-Shot-2013-09-09-at-15.20.58.png
 [3]: https://twitter.com/mylesagray