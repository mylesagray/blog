---
title: 'How to: Run emoncms on NginX and PHP5-FPM'
author: Myles Gray
type: post
date: 2012-11-12T19:43:46+00:00
url: /ardunio-hacking/how-to-run-emoncms-on-nginx-and-php5-fpm/
cover:
  image: /uploads/2013/11/Screen-Shot-2013-09-09-at-15.20.58.png
bfa_virtual_template:
  - hierarchy
dsq_thread_id:
  - 1752041863
rop_post_url_twitter:
  - 'https://blah.cloud/ardunio-hacking/how-to-run-emoncms-on-nginx-and-php5-fpm/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost'
categories:
  - Arduino/Hacking
  - Infrastructure
tags:
  - Arduino
  - emoncms
  - NginX
  - PHP5-FPM

---
For those of you that don't know, [emoncms][1] is a small cms that will accept inputs via GET requests for things like power meters, temp probes for measuring household power usage, PV panel, windmill etc power production levels. <!--more-->

**[DEMO][2]** \**** To achieve this you need to use git to download the newest version of emoncms (the new more modularised version):

<pre class="prettyprint"><code>$ git clone git://github.com/emoncms/emoncms.git</code></pre>

Next step is to set up a mysql db:

<pre class="prettyprint"><code>$ mysql -u root -p
mysql&gt; CREATE DATABASE emoncms;
mysql&gt; exit</code></pre>

Next we are going to write and nginx config for emoncms I have hosted mine on https w/ SPDY however for simplicity this config is for http:

<pre class="prettyprint"><code>server {
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
}</code></pre>

I'd like to highlight this line:

<pre class="prettyprint"><code>rewrite ^/(.*)$ /index.php?q=$1 last;</code></pre>

This is extremely important to make emoncms work, it rewrites the pretty URLs to reference them to the index file. Without this you will get &#8220;Invalid Username/Password&#8221; when you try to log in or register. cd to your emoncms folder and move the default settings file to make it active, then open it:

<pre class="prettyprint"><code>$ cd /var/www/emoncms/
$ mv default.settings.php settings.php
$ nano settings.php</code></pre>

Then change your DB settings like so:

<pre class="prettyprint"><code>/*

Database connection settings

*/

$username = "youruser";
$password = "yourpassword";
$server   = "localhost";
$database = "emoncms";</code></pre>

Now restart NginX:

<pre class="prettyprint"><code>$ service nginx restart</code></pre>

If all is well you will be able to navigate to your URL, enter a username and password

_then_ click Register, a bit counter-intuitive but there we are.

![enter image description here][3] 

Why not follow [@mylesagray on Twitter][4] for more like this!

 [1]: /uploads/2012/11/emoncms
 [2]: https://emon.mylesgray.com
 [3]: /uploads/2013/11/Screen-Shot-2013-09-09-at-15.20.58.png
 [4]: https://twitter.com/mylesagray