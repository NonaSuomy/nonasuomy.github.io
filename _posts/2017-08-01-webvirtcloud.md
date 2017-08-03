---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3.1 - WebVirtCloud
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVM.png "Infrastructure WebGUI")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

Part 03.1 - Hypervisor WebVirtCloud You Are Here!

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# WebVirtCloud #

## Features ##

* User can add SSH public key to root in Instance (Tested only Ubuntu)
* User can change root password in Instance (Tested only Ubuntu)

### How To Update ###

How to update <code>gstfsd</code> daemon on hypervisor:

```bash
wget -O - https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/daemon/gstfsd | sudo tee -a /usr/local/bin/gstfsd
sudo systemctl restart supervisord
```

### Description ###

WebVirtCloud is a virtualization web interface for admins and users. It can delegate Virtual Machine's to users. A noVNC viewer presents a full graphical console to the guest domain.  KVM is currently the only hypervisor supported.

### Install WebVirtCloud Panel (Arch Linux) ###

```bash
sudo pacman -Sy base-devel git python-virtualenv python libxml2 libvirt zlib nginx supervisor libsasl gcc pkg-config
git clone https://github.com/retspen/webvirtcloud
cd webvirtcloud
sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/sites-available
sudo cp conf/supervisor/webvirtcloud.conf /etc/supervisor.d
sudo cp conf/nginx/webvirtcloud.conf /etc/nginx/sites-enabled/
cd ..
sudo mv webvirtcloud /srv
cd /srv/webvirtcloud
sudo virtualenv venv --python=python2.7
source venv/bin/activate
sudo pip install -r conf/requirements.txt 
sudo python manage.py migrate
sudo chown -R http:http /srv/webvirtcloud
```

**Note:** *sudo pip install -r conf/requiements.txt will fail on python-libvirt maybe try to install a different version...*

Enable & start services for running WebVirtCloud:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

sudo service enable supervisord
sudo service start supervisord
sudo service status supervisord
```

Configure the supervisor.

Add the following after the [include] line (after *files = ... * actually):

```
sudo nano /etc/supervisor.d/webvirtcloud.conf
```

```
[program:webvirtcloud]
command=/srv/webvirtcloud/venv/bin/gunicorn webvirtcloud.wsgi:application -c /srv/webvirtcloud/gunicorn.conf.py
directory=/srv/webvirtcloud
user=nginx
autostart=true
autorestart=true
redirect_stderr=true

[program:novncd]
command=/srv/webvirtcloud/venv/bin/python /srv/webvirtcloud/console/novncd
directory=/srv/webvirtcloud
user=nginx
autostart=true
autorestart=true
redirect_stderr=true
```

```
sudo nano /etc/supervisor.d/gstfsd.conf
```

```
[program:gstfsd]
command=/usr/bin/python2 /usr/local/bin/gstfsd
directory=/usr/local/bin
user=root
autostart=true
autorestart=true
redirect_stderr=true
```

Edit the nginx.conf file

You will need to edit the main nginx.conf file as the one that comes from the rpm's will not work. Comment the following lines and add the sites-enabled at the end of the http section:

```
sudo nano /etc/nginx/nginx.conf
```

```
#user html;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

#    server {
#        listen       80;
#        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

#        location / {
#            root   /usr/share/nginx/html;
#            index  index.html index.htm;
#        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
#        error_page   500 502 503 504  /50x.html;
#        location = /50x.html {
#            root   /usr/share/nginx/html;
#        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
#    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
include /etc/nginx/sites-enabled/*.conf;
}
```

Also make sure file in /etc/nginx/sites-enabled/webvirtcloud.conf has the proper paths:

```
server {
    listen 80;

    server_name localhost;
    access_log /var/log/nginx/webvirtcloud-access_log; 

    location /static/ {
        root /srv/webvirtcloud;
        expires max;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Forwarded-Proto $remote_addr;
        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_send_timeout 600;
        client_max_body_size 1024M;
    }
}
```

```
yaourt libguestfs
```

```
sudo wget https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/supervisor/gstfsd.conf -P /etc/supervisord.d/
```

Add required user to the kvm group:

```bash
sudo useradd -M -G kvm -r webvirtmgr
```

Let's restart nginx and the supervisord services:

```bash
sudo systemctl restart nginx && systemctl restart supervisord
```

And finally, check everything is running:

```bash
sudo supervisorctl status

gstfsd                           RUNNING    pid 24187, uptime 2:59:14
novncd                           RUNNING    pid 24186, uptime 2:59:14
webvirtcloud                     RUNNING    pid 24185, uptime 2:59:14

```

Done!!

Go to http://serverip and you should see the login screen.

### Default credentials ###

<pre>
login: admin
password: admin
</pre>

### How To Update ###

```bash
cd /srv/webvirtcloud
git pull
python manage.py migrate
sudo service supervisor restart
```

### License ###

WebVirtCloud is licensed under the [Apache Licence, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).


NOT COMPLETE YET FROM HERE DOWN!!!!!!!!!!!!!!!!!!!!!!!!!!!

Not really sure just yet of what to do with these items below as they fail in Arch.

Change permission for selinux:

```
yaourt selinux ??
```

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/webvirtcloud(/.*)"
```

#### Apache mod_wsgi configuration ####

```
sudo pacman -Sy mod_wsgi2  ??
```

```
WSGIDaemonProcess webvirtcloud threads=2 maximum-requests=1000 display-name=webvirtcloud
WSGIScriptAlias / /srv/webvirtcloud/webvirtcloud/wsgi.py
```

#### Install final required packages for libvirtd and others on Host Server ####

```
sudo pacman -Sy libvirtd qemu virt-manager
```

```bash
wget -O - https://raw.githubusercontent.com/retspen/webvirtcloud/master/dev/libvirt-bootstrap.sh | sudo sh
```
