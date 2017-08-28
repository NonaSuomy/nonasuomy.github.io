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

Create a file.

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

Check for autochanger and tape drives.

```
lsscsi --generic

[0:0:0:0]    tape    IBM      ULTRIUM-TD3      88M0  /dev/st0   /dev/sg4 
[0:0:0:1]    mediumx IBM      33614LX          0029  /dev/sch0  /dev/sg6 
[3:0:1:0]    disk    ATA      WDC WD30EFRX-68E 0A82  /dev/sda   /dev/sg0 
[4:0:0:0]    disk    ATA      WDC WD30EFRX-68E 0A82  /dev/sdb   /dev/sg1 
[5:0:0:0]    disk    ATA      WDC WD30EFRX-68E 0A80  /dev/sdc   /dev/sg2 
[7:0:0:0]    disk    Lexar    USB Flash Drive  1100  /dev/sdd   /dev/sg3 
[8:0:0:0]    tape    IBM      ULTRIUM-TD3      88M0  /dev/st1   /dev/sg5
```

```
ls -rtl /dev/tape/by-id
total 0
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-35005076312020c2e -> ../../st0
lrwxrwxrwx 1 root root 10 Aug 24 20:44 scsi-35005076312020c2e-nst -> ../../nst0
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-35005076312020ac6 -> ../../st1
lrwxrwxrwx 1 root root 10 Aug 24 20:44 scsi-35005076312020ac6-nst -> ../../nst1
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-3100000e09e0b4486 -> ../../sg6
```

Make sure you installed bareos-storage-tape above or else the files in these locations wont be there.

```
/usr/lib/bareos/scripts/mtx-changer
/etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf.example
/etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example
/etc/bareos/bareos-dir.d/storage/tape.conf.example
```

Copy and Rename all tape related example files.

```
cp /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf.example /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf
cp /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example /etc/bareos/bareos-sd.d/device/tapedrive-0.conf
cp /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example /etc/bareos/bareos-sd.d/device/tapedrive-1.conf
cp /etc/bareos/bareos-dir.d/storage/Tape.conf.example /etc/bareos/bareos-dir.d/storage/Tape.conf
```

Change owner and permissions.

```
chown bareos:bareos /etc/bareos/bareos-sd.d/autochanger/*
chown bareos:bareos /etc/bareos/bareos-sd.d/device/*
chown bareos:bareos /etc/bareos/bareos-dir.d/storage/*
chmod 640 /etc/bareos/bareos-sd.d/autochanger/*
chmod 640 /etc/bareos/bareos-sd.d/device/*
chmod 640 /etc/bareos/bareos-dir.d/storage/*
```

Autochanger Setup.

```
nano /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf

#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-350011d00018a5f03-nst),
# because the short device names like /dev/sg7
# might change on reboot.
#

Autochanger {
  Name = "autochanger-0"
  # adapt this, to match your storage loader
  Changer Device = /dev/tape/by-id/scsi-35001234567890

  # an Autochanger can contain multiple drive devices
  Device = tapedrive-0
  #Device = tapedrive-1

  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
}
```

Tape drive 0 setup.

```
#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-350011d00018a5f03-nst),
# because the short device names like /dev/nst1
# might change on reboot.
#

Device {

    Name = "tapedrive-0"
    DeviceType = tape

    # default:0, only required if the autoloader have multiple drives.
    DriveIndex = 0

    # if only one drive is available, this is normally /dev/nst0.
    # However, it is advised to access it via id (/dev/tape/by-id/...).
    #ArchiveDevice = /dev/nst0
    ArchiveDevice = /dev/tape/by-id/scsi-35001234567891-nst

    # arbitrary string that descripes the the storage media.
    # Bareos uses this to determine, which device can be handle what medi$
    MediaType = LTO

    # enable "Check Labels" if tapes with ANSI/IBM labels
    # should be preserved
    #Check Labels = yes

    AutoChanger = yes                       # default: no
    AutomaticMount = yes                    # default: no
    MaximumFileSize = 10GB                  # default: 1000000000 (1GB)
}
```

Tape drive 1 setup.

```
#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-35001234567892-nst),
# because the short device names like /dev/nst1
# might change on reboot.
#

Device {

    Name = "tapedrive-1"
    DeviceType = tape

    # default:0, only required if the autoloader have multiple drives.
    DriveIndex = 1

    # if only one drive is available, this is normally /dev/nst0.
    # However, it is advised to access it via id (/dev/tape/by-id/...).
    #ArchiveDevice = /dev/nst1
    ArchiveDevice = /dev/tape/by-id/scsi-350011d00018a5f04-nst

    # arbitrary string that descripes the the storage media.
    # Bareos uses this to determine, which device can be handle what medi$
    MediaType = LTO

    # enable "Check Labels" if tapes with ANSI/IBM labels
    # should be preserved
    #Check Labels = yes

    AutoChanger = yes                       # default: no
    AutomaticMount = yes                    # default: no
    MaximumFileSize = 10GB                  # default: 1000000000 (1GB)
}
```

Get storage director password.

```
cat /etc/bareos/bareos-sd.d/director/bareos-dir.conf

Director {
  Name = bareos-dir
  Password = "Storage director password will show up here."
  Description = "Director, who is permitted to contact this storage daemon."
}
```

Setup Tape.conf

```
nano /etc/bareos/bareos-dir.d/storage/Tape.conf

Storage {
  Name = Tape
  Address  = localhost
  Password = "storage director password here"
  Device = autochanger-0
  Media Type = LTO
  Auto Changer = yes
}
```
