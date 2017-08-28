---
layout: post
title: Arch Linux Infrastructure - NAS - Part 7 - Bareos Install
---

Installing Bareos on RockStor (CentOS 7)

# Bareos #

Add official bareos repo.

```
yum install wget
```

```
wget -O /etc/yum.repos.d/bareos.repo http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo
```

Install the required packages.

```
yum install bareos bareos-database-mysql bareos-webui bareos-storage-tape mariadb-server
```

Start mariadb & start at boot.

```
systemctl enable mariadb
systemctl start mariadb
```

Run the mysql_secure_install script.

```
mysql_secure_installation
```

next create a file :

```
nano ~/.my.cnf
```

```
[client]
host=localhost
user=root
password=PASSWORD
```

Install Bareos using MySQL scripts.

```
/usr/lib/bareos/scripts/create_bareos_database
/usr/lib/bareos/scripts/make_bareos_tables
/usr/lib/bareos/scripts/grant_bareos_privileges
```

```
[root@server ~]# /usr/lib/bareos/scripts/create_bareos_database
Creating mysql database
Creating of bareos database succeeded.
[root@server ~]# /usr/lib/bareos/scripts/make_bareos_tables
Making mysql tables
Creation of Bareos MySQL tables succeeded.
[root@server ~]# /usr/lib/bareos/scripts/grant_bareos_privileges
Granting mysql tables
Privileges for user bareos granted ON database bareos.
```

Start the services.

```
systemctl start bareos-dir
systemctl start bareos-sd
systemctl start bareos-fd
systemctl start httpd
```

The bareos-webui should now be running

```
http://ip/bareos-webui/
```

The configuration for it can be found in /etc/httpd/conf.d/bareos-webui.conf

In some cases you may have to add it to selinux security (I didn't).

```
setsebool -P httpd_can_network_connect on
```

The web interface.

Web login of bareos.

 
Create a login. Start the bareos-console.

```
bconsole
```

Add user.

```
configure add console name=admin password=password123 profile=webui-admin
```

**Note:** *This didn't work for me tossed up a forbidden error, will have to look into this later for now add your webui password here.*

```
Could not add directive "password": character '@' (include) is forbidden.
```

```
mv /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
```

Change your password.

```
nano /etc/bareos/bareos-dir.d/console/admin.conf

#
# Restricted console used by bareos-webui
#
Console {
  Name = admin
  Password = "admin"
  Profile = "webui-admin"
}
```

Restart bareos services and httpd.

```
systemctl restart bareos-dir
systemctl restart bareos-sd
systemctl restart bareos-fd
systemctl restart httpd
```

Should be able to login with that username and password now.


