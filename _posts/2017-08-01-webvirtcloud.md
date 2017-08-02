---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3.1 - WebVirtCloud
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVM.png "Infrastructure WebGUI")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 03.1 - Hypervisor WebVirtCloud You Are Here!

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# WebVirtCloud #

## Features

* User can add SSH public key to root in Instance (Tested only Ubuntu)
* User can change root password in Instance (Tested only Ubuntu)

### Warning!!!

How to update <code>gstfsd</code> daemon on hypervisor:

```bash
wget -O - https://clck.ru/9VMRH | sudo tee -a /usr/local/bin/gstfsd
sudo service supervisor restart
```

### Description

WebVirtCloud is a virtualization web interface for admins and users. It can delegate Virtual Machine's to users. A noVNC viewer presents a full graphical console to the guest domain.  KVM is currently the only hypervisor supported.

### Install WebVirtCloud Panel (Arch Linux)

```bash
sudo pacman -Sy git python-virtualenv python libxml2 libvirt zlib nginx supervisor libsasl gcc pkg-config
git clone https://github.com/retspen/webvirtcloud
cd webvirtcloud
sudo cp conf/supervisor/webvirtcloud.conf /etc/supervisor.d
sudo cp conf/nginx/webvirtcloud.conf /etc/nginx
cd ..
sudo mv webvirtcloud /srv
sudo chown -R http:http /srv/webvirtcloud
cd /srv/webvirtcloud
sudo virtualenv venv
source venv/bin/activate
pip install -r conf/requirements.txt
sudo python manage.py migrate
sudo chown -R http:http /srv/webvirtcloud
sudo rm /etc/nginx/sites-enabled/default
```

Restart services for running WebVirtCloud:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

sudo service enable supervisord
sudo service start supervisord
sudo service status supervisord
```

NOT COMPLETE YET FROM HERE DOWN!!!!!!!!!!!!!!!!!!!!!!!!!!!


Setup libvirt and KVM on server

```bash
wget -O - https://clck.ru/9V9fH | sudo sh
```

Change permission for selinux:

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/webvirtcloud(/.*)"
```

Add required user to the kvm group:
```bash
sudo usermod -G kvm -a webvirtmgr
```

Let's restart nginx and the supervisord services:
```bash
sudo systemctl restart nginx && systemctl restart supervisord
```

And finally, check everything is running:
```bash
sudo supervisorctl status

novncd                           RUNNING    pid 24186, uptime 2:59:14
webvirtcloud                     RUNNING    pid 24185, uptime 2:59:14

```

#### Apache mod_wsgi configuration
```
WSGIDaemonProcess webvirtcloud threads=2 maximum-requests=1000 display-name=webvirtcloud
WSGIScriptAlias / /srv/webvirtcloud/webvirtcloud/wsgi.py
```

#### Install final required packages for libvirtd and others on Host Server
```bash
wget -O - https://clck.ru/9V9fH | sudo sh
```

Done!!

Go to http://serverip and you should see the login screen.

### Default credentials
<pre>
login: admin
password: admin
</pre>

### How To Update
```bash
git pull
python manage.py migrate
sudo service supervisor restart
```

### License

WebVirtCloud is licensed under the [Apache Licence, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
