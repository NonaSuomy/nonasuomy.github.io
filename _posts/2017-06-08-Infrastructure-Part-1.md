---
layout: post
title: Arch Linux Infrastructure Part 1 Brouter Inception
---

##Switch Hardware##

24 Port P.O.E. Switch H3C 4800G

Firmware: https://h10145.www1.hpe.com/Downloads/SoftwareReleases.aspx?ProductNumber=JD008A&lang=en&cc=us&prodSeriesId=4177359&SoftwareReleaseUId=21933&SerialNumber=&PurchaseDate=
```
Version as of writing: 
5500.EI-4800G_5.20.R2221P18-US (TAA Compliant)	28-Sep-2015	23-Oct-2015	Release notes 18.7 MB
5500.EI_5.20.R2222P05	24-Apr-2017	26-Apr-2017	Release notes 17.0 MB

BootROM: A5500EI-BTM-721-US.btm
Boot-Loader: A5500EI-CMW520-R2222P05.bin
```

You may need to grab both lastest downloads as the bootrom is only in the prior release, you can use the newest boot-loader with it though, don't have to first use the older boot-loader *.bin file.

###Factory Reset###

Forgot your login password and want to do a password recovery? Factory reset to default!

In order to restore your 3COM switch you will need the following:

```
Serial Console Cable
```

1.) Connect to the console port of the switch.

Make sure to connect using the following settings 19200, 8, 1, N

2.) Press Ctrl-B to enter the boot menu.

```
Starting......

    *************************************************************************
    *                                                                       *
    *             Switch 4800G PWR 24-Port BOOTROM, Version 721             *
    *                                                                       *
    *************************************************************************
    Copyright(c) 2004-2014 3Com Corp. and its licensors. All rights reserved.
    Creation date   : Mar 14 2014, 12:12:47
    CPU Clock Speed : 533MHz
    BUS Clock Speed : 133MHz
    Memory Size     : 256MB
    Mac Address     : 001ec1dcff80


Press Ctrl-B to enter Boot Menu... 1
```

3.) Enter 7 to skip current configuration file.

When prompted for password just hit enter.
```
password: 

  BOOT  MENU

1. Download application file to flash
2. Select application file to boot
3. Display all files in flash
4. Delete file from flash
5. Modify bootrom password
6. Enter bootrom upgrade menu
7. Skip current configuration file
8. Set bootrom password recovery
9. Set switch startup mode
0. Reboot

Enter your choice(0-9): 7

The current setting will boot with current configuration file when rebooted.
Are you sure you want to skip the current configuration file when rebooting? Yes or No(Y/N)y

Setting......done!
Hit Y to continue
```

4.) Enter 0 to reboot.

```
Enter your choice(0-9): 0

System is rebooting...
```

5.) Once booted, delete the 3comoscfg.cfg file.

You can either backup the config file first then delete, or delete it.

```
<4800G>dir flash:/
Directory of flash:/

   0(b)  -rw-  10319701  Apr 30 2008 09:44:16   someoldversion.bin
   1     -rw-      5827  Jun 13 2017 00:50:06   3comoscfg.cfg
   2(*)  -rw-  14379886  Apr 26 2000 13:09:50   a5500ei-cmw520-r2222p05.bin
   3     -rw-    484116  Apr 26 2000 12:07:55   a5500ei-btm-721-us.btm
   4     drw-         -  Apr 26 2000 12:00:38   seclog
   5     -rw-       151  Jun 13 2017 00:50:00   system.xml

31496 KB total (6885 KB free)

(*) -with main attribute   (b) -with backup attribute
(*b) -with both main and backup attribute
```

Delete configuration file

```
delete 3comoscfg.cfg 
Delete flash:/3comoscfg.cfg?[Y/N]:y
.......
%Delete file flash:/3comoscfg.cfg...Done.
```

6.) Reboot and you’re done!

```
reboot
```

Factory U/P
U:admin
P:<ENTER> key (blank)

###Firmware Updates###

####FTP Method####

1.) Get the files to the switch by using FTP.

```
<4800G> ftp 10.13.37.100
Trying ...
Press CTRL+K to abort
Connected.
220 WFTPD 2.0 service (by Texas Imperial Software) ready for new user
User(none):user
331 Give me your password, please
Password:
230 Logged in successfully
[ftp] get A5500EI-CMW520-R2222P05.bin
[ftp] get A5500EI-BTM-721-US.btm
[ftp] bye
```

2.) Upgrade Boot ROM.

```
<4800G> bootrom update file A5500EI-BTM-721-US.btm
This command will update bootrom file on the specified board(s), Continue? [Y/N]y
Now updating bootrom, please wait...
Succeeded to update bootrom of Board
```

3a.) Load the system software image and specify the file as the main file at the next reboot.

```
<4800G> boot-loader file A5500EI-CMW520-R2222P05.bin main
This command will set the boot file. Continue? [Y/N]: y
The specified file will be used as the main boot file at the next reboot!

```

3b.) You can then set the old bootloader to backup in case it fails if you didn't delete it for space.

```
<4800G> boot-loader file someoldversion.bin backup
 This command will set the boot file. Continue? [Y/N]:y
 The specified file will be used as the backup boot file at the next reboot!
```

```
<4800G> display boot-loader
The current boot app is: flash:/someoldversion.bin
The main boot app is: flash:/A5500EI-CMW520-R2222P05.bin
The backup boot app is: flash:/someoldversion.bin
```

4.) Reboot the switch with the reboot command to complete the upgrade.
```
reboot
```

####TFTP Method####

TFTP is basically the same

```
<4800G>tftp 10.13.37.100 get A5500EI-CMW520-R2222P05.bin
<4800G>tftp 10.13.37.100 get A5500EI-BTM-721-US.btm
 ...
 File will be transferred in binary mode
 Downloading file from remote TFTP server, please wait............../
<4800G>boot-loader file A5500EI-CMW520-R2222P05.bin main
 This command will set the boot file. Continue? [Y/N]:y
 The specified file will be used as the main boot file at the next reboot!
```

You can then set the old bootloader to backup in case it fails if you didn't delete it for space.
```
<4800G>boot-loader file someoldversion.bin backup
 This command will set the boot file. Continue? [Y/N]:y
 The specified file will be used as the backup boot file at the next reboot!
```
```
reboot
 Start to check configuration with next startup configuration file, please wait........DONE!
This command will reboot the device. Current configuration will be lost in nex startup if you continue. Continue? [Y/N]:
```

Running...
```
Software Version 
S4800G-CMW520-R2210-S168

Hardware Version 
REV.C

Bootrom Version 
721

Running Time: 
0 days 0 hours 1 minutes 46 seconds
```

###How to enable Web Interface###

```
<4800G>display ip http
HTTP port: 80
Basic ACL: 0
Operation status: Stopped
```

```
<4800G>system-view
System View: return to User View with Ctrl+Z.
```
```
[4800G]ip http enable
```
```
[4800G]display ip http
HTTP port: 80
Basic ACL: 0
Current connection: 0
Operation status: Running
```
```
local-user pleb
password cipher plebmast0r
authorization-attribute level 3
service-type web
save
The current configuration will be written to the device. Are you sure? [Y/N]:y
Please input the file name(*.cfg)[flash:/3comoscfg.cfg]
(To leave the existing filename unchanged, press the enter key):
Validating file. Please wait..................
The current configuration is saved to the active main board successfully.
Configuration is saved to device successfully.
return
```

```
system-view
System View: return to User View with Ctrl+Z.
```
```
interface vlan 1
ip address 10.13.37.2 255.255.255.0
ip route-static 0.0.0.0 0.0.0.0 10.13.37.1
quit
save
```

## VLAN Setup ##

```
<4800G>system-view
System View: return to User View with Ctrl+Z.

```

### Setup VLAN ###

The primary two ports on the switch we need to setup are ports 1/0/1 and 1/0/2, 1/0/1 is the WAN port untagged vlan 500 and 1/0/2 is the trunk port for the hypervisor one of the required VLANs for it is 600 for general LAN traffic. The rest of the VLANs are for virtual machines (PBX, Automation, etc) which will be connected by virtual bridges. Port 1/0/3 is our emergency test port for the WAN, Unplug trunk and plug in a test machine to see if the WAN is functioning properly.

```
[4800G]vlan 500
[4800G-vlan500]description WAN VLAN
[4800G-vlan500]port GigabitEthernet 1/0/1 GigabitEthernet 1/0/3
[4800G-vlan500]vlan 600
[4800G-vlan600]description LAN VLAN
[4800G-vlan600]port GigabitEthernet 1/0/4 to 1/0/24
[4800G-vlan600]vlan 666
[4800G-vlan666]description Default VLAN
[4800G-vlan666]vlan 700
[4800G-vlan700]description HOT VLAN
[4800G-vlan700]vlan 800
[4800G-vlan800]description WiFi VLAN
[4800G-vlan800]vlan 850
[4800G-vlan850]description Guest Wifi VLAN
[4800G-vlan850]vlan 888
[4800G-vlan888]description TOR VLAN
[4800G-vlan888]vlan 900
[4800G-vlan900]description VOIP VLAN
[4800G-vlan900]quit
[4800G]voice vlan 900 enable 
[4800G]interface GigabitEthernet 1/0/4 to 1/0/24 
voice vlan enable 
[4800G]save
The current configuration will be written to the device. Are you sure? [Y/N]:y
Please input the file name(*.cfg)[flash:/3comoscfg.cfg]
(To leave the existing filename unchanged, press the enter key):
flash:/3comoscfg.cfg exists, overwrite? [Y/N]:y
 Validating file. Please wait...................
 The current configuration is saved to the active main board successfully.
 Configuration is saved to device successfully.
[4800G]interface GigabitEthernet 1/0/2
[4800G-GigabitEthernet1/0/2]port hybrid vlan 500 600 700 800 850 888 900 tagged
[4800G-GigabitEthernet1/0/2]port hybrid pvid vlan 666
[4800G-GigabitEthernet1/0/2]quit


[4800G] lldp compliance cdp
[4800G] voice vlan mac-address xxxx-xxff-ffff mask ffff-ff00-0000
[4800G]interface range GigabitEthernet 1/0/4 to GigabitEthernet 1/0/24
[4800G-if-range]port link-type hybrid
[4800G-if-range]undo port hybrid vlan 1
 Please wait... Done.
[4800G-if-range]port hybrid vlan 600 untagged
 Please wait... Done.
[4800G-if-range]port hybrid pvid vlan 600
[4800G-if-range]voice vlan 900 enable
[4800G-if-range]lldp compliance admin-status cdp txrx
```

## USB Install ##

Grab whatever the latest ISO is: http://mirror.rackspace.com/archlinux/iso/2017.06.01/archlinux-2017.06.01-x86_64.iso

### Find USB Drive ###

```
lsblk
sdb 8:17 1 8G 0 disk
```

### Write image to USB Drive ###

Warning destroying all information on USB drive...

```
dd bs=4M if=/home/luser/Downloads/archlinux-2017.06.01-x86_64.iso of=/dev/sdb status=progress && sync
```

Plug USB Drive into machine you want to install hypervisor on and boot.

We're going to use UEFI make sure your hardware bios is setup for UEFI.

After boot double check UEFI

```
root@archiso ~ # mount | egrep efi
efivarfs on /sys/firmware/efi/efivars type efivarfs (rw,nosuid,nodev,noexec,relatime)
```

Find your network port name

```
root@archiso ~ # ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether d4:be:d9:24:3a:6b brd ff:ff:ff:ff:ff:ff
```

On this hardware it is called eno1

Add an IP and Netmask to eno1

```
root@archiso ~ # ip link set eno1 up
root@archiso ~ # ip addr add 10.13.37.101/24 broadcast 10.13.37.255 dev eno1
```

Add route to internet gateway

```
root@archiso ~ # ip route add default via 10.13.37.1
```

Testing connection

```
root@archiso ~ # ping 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=38 time=73.9 ms
...
```

Working...

```
root@archiso ~ # ping google.ca
ping: google.com: Name or service not known
```

Not working...

Add nameserver to resolv.conf

```
root@archiso ~ # echo "nameserver 8.8.8.8" >> /etc/resolv.conf
root@archiso ~ # cat /etc/resolv.conf
nameserver 8.8.8.8
```

Test again...

```
root@archiso ~ # ping google.ca
64 bytes from ord38s04-in-f14.1e100.net (172.217.0.14): icmp_seq=1 ttl=47 time=71.0 ms
...
```

Working!

## Refresh pacman ##

```
root@archiso ~ # pacman -Syy
```

## **Optional:** For remote installing ##

Install Openssh

```
root@archiso ~ # pacman -S openssh
root@archiso ~ # systemctl start sshd
root@archiso ~ # passwd
New password: 1337pleb
Retype new password: 1337pleb
passwd: password updated successfully

root@archiso ~ # ip addr show eno1
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether d4:be:d9:24:3a:6b brd ff:ff:ff:ff:ff:ff
    inet 10.13.37.101/24 brd 10.13.37.255 scope global eno1
       valid_lft forever preferred_lft forever
```

Now you should be able to remote ```ssh root@10.13.37.101``` from another machine on the network with whatever password you set example 1337pleb to finish config.

## Destroy contents of drive and create partitions ##
```
root@archiso ~ # sgdisk --zap-all /dev/sda

root@archiso ~ # sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+12GiB  --typecode=2:8200 --change-name=2:swap \
       --new=3:0:0       --typecode=2:8300 --change-name=3:system \
       /dev/sda
         
/dev/sdaCreating new GPT entries.
Setting name!
partNum is 0
REALLY setting name!
Setting name!
partNum is 1
REALLY setting name!
Setting name!
partNum is 2
REALLY setting name!
The operation has completed successfully.
```

Show partitions and lables

```
root@archiso ~ # lsblk -o +PARTLABEL

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT                PARTLABEL
loop0    7:0    0 375.6M  1 loop /run/archiso/sfs/airootfs
sda      8:0    0 298.1G  0 disk
├─sda1   8:1    0   550M  0 part                           EFI
├─sda2   8:2    0    12G  0 part                           swap
└─sda3   8:3    0 285.6G  0 part                           system
sdb      8:16   1   3.8G  0 disk
└─sdb1   8:17   1   3.8G  0 part /run/archiso/bootmnt
sr0     11:0    1  1024M  0 rom
```

## Format the partition ##

```
root@archiso ~ # mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI

root@archiso ~ # mkswap -L swap /dev/disk/by-partlabel/swap                 :(
Setting up swapspace version 1, size = 12 GiB (12884897792 bytes)
LABEL=swap, UUID=5ad87c95-e59d-4a85-b149-9b361042c746
root@archiso ~ # swapon -L swap

root@archiso ~ # mkfs.btrfs --label system /dev/disk/by-partlabel/system    :(
btrfs-progs v4.11
See http://btrfs.wiki.kernel.org for more information.

Label:              system
UUID:               399aea80-d00f-48b2-bc4f-74ff4a9bf9aa
Node size:          16384
Sector size:        4096
Filesystem size:    285.55GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   285.55GiB  /dev/disk/by-partlabel/system
```

## Mount Partitions create subvolumes ##

```
root@archiso ~ # mount -t btrfs LABEL=system /mnt
```

Create the subvolumes which will actually be mounted in our running system:

```
root@archiso ~ # btrfs subvolume create /mnt/root
root@archiso ~ # btrfs subvolume create /mnt/home
root@archiso ~ # btrfs subvolume create /mnt/snapshots
```

Unmount everything

```
root@archiso ~ # umount -R /mnt
```

Mount subvolumes and efi boot

```
root@archiso ~ # mount -t btrfs -o subvol=root,defaults,x-mount.mkdir,compress=lzo,noatime LABEL=system /mnt
root@archiso ~ # mount -t btrfs -o subvol=home,defaults,x-mount.mkdir,compress=lzo,noatime LABEL=system /mnt/home
root@archiso ~ # mount -t btrfs -o subvol=snapshots,defaults,x-mount.mkdir,compress=lzo,noatime LABEL=system /mnt/.snapshots
root@archiso ~ # mkdir /mnt/boot 
root@archiso ~ # mount LABEL=EFI /mnt/boot
```

Install base system files

```
root@archiso ~ # pacstrap /mnt base
==> Creating install root at /mnt
==> Installing packages to /mnt
:: Synchronizing package databases...
 core                     124.4 KiB   269K/s 00:00 [#######################] 100%
 extra                   1667.4 KiB  1223K/s 00:01 [#######################] 100%
 community                  3.9 MiB  2.19M/s 00:02 [#######################] 100%
:: There are 50 members in group base:
:: Repository core
   1) bash  2) bzip2  3) coreutils  4) cryptsetup  5) device-mapper  6) dhcpcd
   7) diffutils  8) e2fsprogs  9) file  10) filesystem  11) findutils  12) gawk
   13) gcc-libs  14) gettext  15) glibc  16) grep  17) gzip  18) inetutils
   19) iproute2  20) iputils  21) jfsutils  22) less  23) licenses  24) linux
   25) logrotate  26) lvm2  27) man-db  28) man-pages  29) mdadm  30) nano
   31) netctl  32) pacman  33) pciutils  34) pcmciautils  35) perl
   36) procps-ng  37) psmisc  38) reiserfsprogs  39) s-nail  40) sed  41) shadow
   42) sysfsutils  43) systemd-sysvcompat  44) tar  45) texinfo  46) usbutils
   47) util-linux  48) vi  49) which  50) xfsprogs

Enter a selection (default=all):
resolving dependencies...
looking for conflicting packages...
warning: dependency cycle detected:
warning: libusb will be installed before its systemd dependency

Packages (130) acl-2.2.52-3  archlinux-keyring-20170320-1  attr-2.4.47-2
               ca-certificates-20170307-1  ca-certificates-cacert-20140824-4
               ca-certificates-mozilla-3.31-3  ca-certificates-utils-20170307-1
               cracklib-2.9.6-1  curl-7.54.0-3  db-5.3.28-3  dbus-1.10.18-1
               expat-2.2.0-2  gdbm-1.13-1  glib2-2.52.2+9+g3245eba16-1
               gmp-6.1.2-1  gnupg-2.1.21-3  gnutls-3.5.13-1  gpgme-1.9.0-3
               groff-1.22.3-7  hwids-20170328-1  iana-etc-20170512-1  icu-59.1-1
               iptables-1.6.1-1  kbd-2.0.4-1  keyutils-1.5.10-1  kmod-24-1
               krb5-1.15.1-1  libaio-0.3.110-1  libarchive-3.3.1-5
               libassuan-2.4.3-1  libcap-2.25-1  libelf-0.169-1  libffi-3.2.1-2
               libgcrypt-1.7.7-1  libgpg-error-1.27-1  libidn-1.33-1
               libksba-1.3.4-2  libldap-2.4.44-5  libmnl-1.0.4-1
               libnftnl-1.0.7-1  libnghttp2-1.23.1-1  libnl-3.2.29-2
               libpcap-1.8.1-2  libpipeline-1.4.1-1  libpsl-0.17.0-2
               libsasl-2.1.26-11  libseccomp-2.3.2-1
               libsecret-0.18.5+14+g9980655-1  libssh2-1.8.0-2  libsystemd-232-8
               libtasn1-4.12-1  libtirpc-1.0.1-3  libunistring-0.9.7-1
               libusb-1.0.21-1  libutil-linux-2.29.2-2
               linux-api-headers-4.10.1-1  linux-firmware-20170422.ade8332-1
               lz4-1:1.7.5-1  mkinitcpio-23-1  mkinitcpio-busybox-1.25.1-1
               mpfr-3.1.5.p2-1  ncurses-6.0+20170527-1  nettle-3.3-1  npth-1.5-1
               openresolv-3.9.0-1  openssl-1.1.0.f-1  p11-kit-0.23.7-1
               pacman-mirrorlist-20170427-1  pam-1.3.0-1  pambase-20130928-1
               pcre-8.40-1  pinentry-1.0.0-1  popt-1.16-8  readline-7.0.003-1
               sqlite-3.19.3-1  systemd-232-8  thin-provisioning-tools-0.7.0-1
               tzdata-2017b-1  xz-5.2.3-1  zlib-1:1.2.11-1  bash-4.4.012-2
               bzip2-1.0.6-6  coreutils-8.27-1  cryptsetup-1.7.5-1
               device-mapper-2.02.171-1  dhcpcd-6.11.5-1  diffutils-3.6-1
               e2fsprogs-1.43.4-1  file-5.31-1  filesystem-2017.03-2
               findutils-4.6.0-2  gawk-4.1.4-2  gcc-libs-7.1.1-2
               gettext-0.19.8.1-2  glibc-2.25-2  grep-3.0-1  gzip-1.8-2
               inetutils-1.9.4-5  iproute2-4.11.0-1  iputils-20161105.1f2bb12-2
               jfsutils-1.1.15-4  less-487-1  licenses-20140629-2
               linux-4.11.4-1  logrotate-3.12.2-1  lvm2-2.02.171-1
               man-db-2.7.6.1-2  man-pages-4.11-1  mdadm-4.0-1  nano-2.8.4-1
               netctl-1.12-2  pacman-5.0.1-5  pciutils-3.5.4-1
               pcmciautils-018-7  perl-5.26.0-1  procps-ng-3.3.12-1
               psmisc-22.21-3  reiserfsprogs-3.6.25-1  s-nail-14.8.16-2
               sed-4.4-1  shadow-4.4-3  sysfsutils-2.1.0-9
               systemd-sysvcompat-232-8  tar-1.29-2  texinfo-6.3-2
               usbutils-008-1  util-linux-2.29.2-2  vi-1:070224-2  which-2.21-2
               xfsprogs-4.11.0-1

Total Download Size:   212.45 MiB
Total Installed Size:  736.96 MiB

:: Proceed with installation? [Y/n]
:: Retrieving packages...
 linux-api-headers-4...   852.4 KiB   833K/s 00:01 [#######################] 100%
 tzdata-2017b-1-any       235.8 KiB   253K/s 00:01 [#######################] 100%
 iana-etc-20170512-1-any  360.9 KiB  2.16M/s 00:00 [#######################] 100%
 filesystem-2017.03-...    10.2 KiB  0.00B/s 00:00 [#######################] 100%
 glibc-2.25-2-x86_64        8.2 MiB  2.37M/s 00:03 [#######################] 100%
 gcc-libs-7.1.1-2-x86_64   17.4 MiB   907K/s 00:20 [#######################] 100%
 ncurses-6.0+2017052...  1053.3 KiB   751K/s 00:01 [#######################] 100%
 readline-7.0.003-1-...   294.7 KiB   631K/s 00:00 [#######################] 100%
 bash-4.4.012-2-x86_64   1417.7 KiB   648K/s 00:02 [#######################] 100%
 bzip2-1.0.6-6-x86_64      52.8 KiB  0.00B/s 00:00 [#######################] 100%
 attr-2.4.47-2-x86_64      70.0 KiB  22.8M/s 00:00 [#######################] 100%
 acl-2.2.52-3-x86_64      132.0 KiB   857K/s 00:00 [#######################] 100%
 gmp-6.1.2-1-x86_64       408.5 KiB   652K/s 00:01 [#######################] 100%
 libcap-2.25-1-x86_64      37.9 KiB  9.25M/s 00:00 [#######################] 100%
 gdbm-1.13-1-x86_64       150.4 KiB   475K/s 00:00 [#######################] 100%
 db-5.3.28-3-x86_64      1097.6 KiB   312K/s 00:04 [#######################] 100%
 perl-5.26.0-1-x86_64      13.6 MiB  1028K/s 00:14 [#######################] 100%
 openssl-1.1.0.f-1-x...     2.9 MiB  3.08M/s 00:01 [#######################] 100%
 coreutils-8.27-1-x86_64    2.2 MiB  2.74M/s 00:01 [#######################] 100%
 libgpg-error-1.27-1...   150.4 KiB  14.7M/s 00:00 [#######################] 100%
 libgcrypt-1.7.7-1-x...   466.0 KiB  2.84M/s 00:00 [#######################] 100%
 lz4-1:1.7.5-1-x86_64      82.7 KiB  26.9M/s 00:00 [#######################] 100%
 xz-5.2.3-1-x86_64        229.1 KiB  11.2M/s 00:00 [#######################] 100%
 libsystemd-232-8-x86_64  358.1 KiB  11.7M/s 00:00 [#######################] 100%
 expat-2.2.0-2-x86_64      76.3 KiB  10.6M/s 00:00 [#######################] 100%
 dbus-1.10.18-1-x86_64    273.7 KiB  13.4M/s 00:00 [#######################] 100%
 libmnl-1.0.4-1-x86_64     10.5 KiB  0.00B/s 00:00 [#######################] 100%
 libnftnl-1.0.7-1-x86_64   59.9 KiB  0.00B/s 00:00 [#######################] 100%
 libnl-3.2.29-2-x86_64    350.4 KiB  12.7M/s 00:00 [#######################] 100%
 libusb-1.0.21-1-x86_64    54.0 KiB  0.00B/s 00:00 [#######################] 100%
 libpcap-1.8.1-2-x86_64   216.9 KiB  12.5M/s 00:00 [#######################] 100%
 iptables-1.6.1-1-x86_64  327.4 KiB  11.8M/s 00:00 [#######################] 100%
 zlib-1:1.2.11-1-x86_64    86.4 KiB  12.0M/s 00:00 [#######################] 100%
 cracklib-2.9.6-1-x86_64  249.9 KiB  14.4M/s 00:00 [#######################] 100%
 libutil-linux-2.29....   317.5 KiB  13.5M/s 00:00 [#######################] 100%
 e2fsprogs-1.43.4-1-...   959.5 KiB  2.96M/s 00:00 [#######################] 100%
 libsasl-2.1.26-11-x...   137.3 KiB  13.4M/s 00:00 [#######################] 100%
 libldap-2.4.44-5-x86_64  284.9 KiB  12.1M/s 00:00 [#######################] 100%
 keyutils-1.5.10-1-x...    67.5 KiB  22.0M/s 00:00 [#######################] 100%
 krb5-1.15.1-1-x86_64    1120.1 KiB  3.22M/s 00:00 [#######################] 100%
 libtirpc-1.0.1-3-x86_64  174.0 KiB  12.1M/s 00:00 [#######################] 100%
 pambase-20130928-1-any  1708.0   B  0.00B/s 00:00 [#######################] 100%
 pam-1.3.0-1-x86_64       609.7 KiB  3.36M/s 00:00 [#######################] 100%
 kbd-2.0.4-1-x86_64      1119.9 KiB  2.28M/s 00:00 [#######################] 100%
 kmod-24-1-x86_64         109.8 KiB  10.7M/s 00:00 [#######################] 100%
 hwids-20170328-1-any     340.2 KiB  2.16M/s 00:00 [#######################] 100%
 libidn-1.33-1-x86_64     206.9 KiB  11.9M/s 00:00 [#######################] 100%
 libelf-0.169-1-x86_64    368.8 KiB  2.31M/s 00:00 [#######################] 100%
 libseccomp-2.3.2-1-...    66.3 KiB  9.26M/s 00:00 [#######################] 100%
 shadow-4.4-3-x86_64     1060.6 KiB  2.22M/s 00:00 [#######################] 100%
 util-linux-2.29.2-2...  1828.5 KiB  1951K/s 00:01 [#######################] 100%
 systemd-232-8-x86_64       3.7 MiB  2014K/s 00:02 [#######################] 100%
 device-mapper-2.02....   265.6 KiB  13.0M/s 00:00 [#######################] 100%
 popt-1.16-8-x86_64        65.5 KiB  16.0M/s 00:00 [#######################] 100%
 cryptsetup-1.7.5-1-...   240.8 KiB  11.8M/s 00:00 [#######################] 100%
 dhcpcd-6.11.5-1-x86_64   156.8 KiB  11.8M/s 00:00 [#######################] 100%
 diffutils-3.6-1-x86_64   282.8 KiB  12.0M/s 00:00 [#######################] 100%
 file-5.31-1-x86_64       259.0 KiB  12.6M/s 00:00 [#######################] 100%
 findutils-4.6.0-2-x...   420.7 KiB  2.52M/s 00:00 [#######################] 100%
 mpfr-3.1.5.p2-1-x86_64   254.5 KiB  10.8M/s 00:00 [#######################] 100%
 gawk-4.1.4-2-x86_64      987.1 KiB  2.05M/s 00:00 [#######################] 100%
 pcre-8.40-1-x86_64       922.5 KiB  2.65M/s 00:00 [#######################] 100%
 libffi-3.2.1-2-x86_64     31.5 KiB  0.00B/s 00:00 [#######################] 100%
 glib2-2.52.2+9+g324...     2.3 MiB  1663K/s 00:01 [#######################] 100%
 libunistring-0.9.7-...   491.1 KiB  2.71M/s 00:00 [#######################] 100%
 gettext-0.19.8.1-2-...  2026.9 KiB  1616K/s 00:01 [#######################] 100%
 grep-3.0-1-x86_64        202.7 KiB  15.2M/s 00:00 [#######################] 100%
 less-487-1-x86_64         93.6 KiB  30.5M/s 00:00 [#######################] 100%
 gzip-1.8-2-x86_64         75.8 KiB  18.5M/s 00:00 [#######################] 100%
 inetutils-1.9.4-5-x...   285.8 KiB  1743K/s 00:00 [#######################] 100%
 iproute2-4.11.0-1-x...   634.4 KiB  1940K/s 00:00 [#######################] 100%
 sysfsutils-2.1.0-9-...    30.2 KiB  0.00B/s 00:00 [#######################] 100%
 iputils-20161105.1f...    71.2 KiB  23.2M/s 00:00 [#######################] 100%
 jfsutils-1.1.15-4-x...   167.5 KiB  12.6M/s 00:00 [#######################] 100%
 licenses-20140629-2-any   63.0 KiB  20.5M/s 00:00 [#######################] 100%
 linux-firmware-2017...    41.9 MiB  1502K/s 00:29 [#######################] 100%
 mkinitcpio-busybox-...   157.5 KiB  15.4M/s 00:00 [#######################] 100%
 libarchive-3.3.1-5-...   449.0 KiB  2.69M/s 00:00 [#######################] 100%
 mkinitcpio-23-1-any       38.8 KiB  0.00B/s 00:00 [#######################] 100%
 linux-4.11.4-1-x86_64     61.3 MiB  1044K/s 01:00 [#######################] 100%
 logrotate-3.12.2-1-...    37.1 KiB  0.00B/s 00:00 [#######################] 100%
 libaio-0.3.110-1-x86_64    4.4 KiB  0.00B/s 00:00 [#######################] 100%
 thin-provisioning-t...   370.9 KiB  2.17M/s 00:00 [#######################] 100%
 lvm2-2.02.171-1-x86_64  1281.1 KiB  2002K/s 00:01 [#######################] 100%
 groff-1.22.3-7-x86_64   1824.6 KiB  2.75M/s 00:01 [#######################] 100%
 libpipeline-1.4.1-1...    36.2 KiB  0.00B/s 00:00 [#######################] 100%
 man-db-2.7.6.1-2-x86_64  756.1 KiB  2.36M/s 00:00 [#######################] 100%
 man-pages-4.11-1-any       5.7 MiB  2.42M/s 00:02 [#######################] 100%
 mdadm-4.0-1-x86_64       394.4 KiB  10.4M/s 00:00 [#######################] 100%
 nano-2.8.4-1-x86_64      418.4 KiB  11.4M/s 00:00 [#######################] 100%
 openresolv-3.9.0-1-any    21.1 KiB  0.00B/s 00:00 [#######################] 100%
 netctl-1.12-2-any         36.8 KiB  0.00B/s 00:00 [#######################] 100%
 libtasn1-4.12-1-x86_64   117.4 KiB  11.5M/s 00:00 [#######################] 100%
 p11-kit-0.23.7-1-x86_64  445.7 KiB  2.77M/s 00:00 [#######################] 100%
 ca-certificates-uti...     7.5 KiB  0.00B/s 00:00 [#######################] 100%
 ca-certificates-moz...   402.0 KiB   638K/s 00:01 [#######################] 100%
 ca-certificates-cac...     7.1 KiB  0.00B/s 00:00 [#######################] 100%
 ca-certificates-201...  1904.0   B  0.00B/s 00:00 [#######################] 100%
 libssh2-1.8.0-2-x86_64   180.2 KiB  10.4M/s 00:00 [#######################] 100%
 icu-59.1-1-x86_64          8.1 MiB  2.87M/s 00:03 [#######################] 100%
 libpsl-0.17.0-2-x86_64    49.4 KiB  12.1M/s 00:00 [#######################] 100%
 libnghttp2-1.23.1-1...    84.2 KiB  11.7M/s 00:00 [#######################] 100%
 curl-7.54.0-3-x86_64     872.4 KiB  2.58M/s 00:00 [#######################] 100%
 npth-1.5-1-x86_64         12.8 KiB  0.00B/s 00:00 [#######################] 100%
 libksba-1.3.4-2-x86_64   114.6 KiB  11.2M/s 00:00 [#######################] 100%
 libassuan-2.4.3-1-x...    84.6 KiB  13.8M/s 00:00 [#######################] 100%
 libsecret-0.18.5+14...   193.3 KiB  11.1M/s 00:00 [#######################] 100%
 pinentry-1.0.0-1-x86_64   98.1 KiB  16.0M/s 00:00 [#######################] 100%
 nettle-3.3-1-x86_64      321.7 KiB  11.6M/s 00:00 [#######################] 100%
 gnutls-3.5.13-1-x86_64     2.3 MiB  1829K/s 00:01 [#######################] 100%
 sqlite-3.19.3-1-x86_64  1259.3 KiB  1946K/s 00:01 [#######################] 100%
 gnupg-2.1.21-3-x86_64   2020.5 KiB  1825K/s 00:01 [#######################] 100%
 gpgme-1.9.0-3-x86_64     361.9 KiB  2.21M/s 00:00 [#######################] 100%
 pacman-mirrorlist-2...     5.2 KiB  0.00B/s 00:00 [#######################] 100%
 archlinux-keyring-2...   638.7 KiB  2034K/s 00:00 [#######################] 100%
 pacman-5.0.1-5-x86_64    731.5 KiB  2.21M/s 00:00 [#######################] 100%
 pciutils-3.5.4-1-x86_64   82.4 KiB  26.8M/s 00:00 [#######################] 100%
 pcmciautils-018-7-x...    19.7 KiB  0.00B/s 00:00 [#######################] 100%
 procps-ng-3.3.12-1-...   299.5 KiB  1958K/s 00:00 [#######################] 100%
 psmisc-22.21-3-x86_64    101.3 KiB  16.5M/s 00:00 [#######################] 100%
 reiserfsprogs-3.6.2...   201.0 KiB  14.0M/s 00:00 [#######################] 100%
 s-nail-14.8.16-2-x86_64  310.7 KiB  1979K/s 00:00 [#######################] 100%
 sed-4.4-1-x86_64         174.0 KiB  13.1M/s 00:00 [#######################] 100%
 systemd-sysvcompat-...     7.3 KiB  0.00B/s 00:00 [#######################] 100%
 tar-1.29-2-x86_64        673.9 KiB  2.06M/s 00:00 [#######################] 100%
 texinfo-6.3-2-x86_64    1170.3 KiB  1888K/s 00:01 [#######################] 100%
 usbutils-008-1-x86_64     61.3 KiB  19.9M/s 00:00 [#######################] 100%
 vi-1:070224-2-x86_64     148.0 KiB  11.1M/s 00:00 [#######################] 100%
 which-2.21-2-x86_64       15.5 KiB  0.00B/s 00:00 [#######################] 100%
 xfsprogs-4.11.0-1-x...   813.5 KiB  2.41M/s 00:00 [#######################] 100%
(130/130) checking keys in keyring                 [#######################] 100%
(130/130) checking package integrity               [#######################] 100%
(130/130) loading package files                    [#######################] 100%
(130/130) checking for file conflicts              [#######################] 100%
(130/130) checking available disk space            [#######################] 100%
:: Processing package changes...
(  1/130) installing linux-api-headers             [#######################] 100%
(  2/130) installing tzdata                        [#######################] 100%
(  3/130) installing iana-etc                      [#######################] 100%
(  4/130) installing filesystem                    [#######################] 100%
(  5/130) installing glibc                         [#######################] 100%
(  6/130) installing gcc-libs                      [#######################] 100%
(  7/130) installing ncurses                       [#######################] 100%
(  8/130) installing readline                      [#######################] 100%
(  9/130) installing bash                          [#######################] 100%
Optional dependencies for bash
    bash-completion: for tab completion
( 10/130) installing bzip2                         [#######################] 100%
( 11/130) installing attr                          [#######################] 100%
( 12/130) installing acl                           [#######################] 100%
( 13/130) installing gmp                           [#######################] 100%
( 14/130) installing libcap                        [#######################] 100%
( 15/130) installing gdbm                          [#######################] 100%
( 16/130) installing db                            [#######################] 100%
( 17/130) installing perl                          [#######################] 100%
( 18/130) installing openssl                       [#######################] 100%
Optional dependencies for openssl
    ca-certificates [pending]
( 19/130) installing coreutils                     [#######################] 100%
( 20/130) installing libgpg-error                  [#######################] 100%
( 21/130) installing libgcrypt                     [#######################] 100%
( 22/130) installing lz4                           [#######################] 100%
( 23/130) installing xz                            [#######################] 100%
( 24/130) installing libsystemd                    [#######################] 100%
( 25/130) installing expat                         [#######################] 100%
( 26/130) installing dbus                          [#######################] 100%
( 27/130) installing libmnl                        [#######################] 100%
( 28/130) installing libnftnl                      [#######################] 100%
( 29/130) installing libnl                         [#######################] 100%
( 30/130) installing libusb                        [#######################] 100%
( 31/130) installing libpcap                       [#######################] 100%
( 32/130) installing iptables                      [#######################] 100%
( 33/130) installing zlib                          [#######################] 100%
( 34/130) installing cracklib                      [#######################] 100%
( 35/130) installing libutil-linux                 [#######################] 100%
( 36/130) installing e2fsprogs                     [#######################] 100%
( 37/130) installing libsasl                       [#######################] 100%
( 38/130) installing libldap                       [#######################] 100%
( 39/130) installing keyutils                      [#######################] 100%
( 40/130) installing krb5                          [#######################] 100%
( 41/130) installing libtirpc                      [#######################] 100%
( 42/130) installing pambase                       [#######################] 100%
( 43/130) installing pam                           [#######################] 100%
( 44/130) installing kbd                           [#######################] 100%
( 45/130) installing kmod                          [#######################] 100%
( 46/130) installing hwids                         [#######################] 100%
( 47/130) installing libidn                        [#######################] 100%
( 48/130) installing libelf                        [#######################] 100%
( 49/130) installing libseccomp                    [#######################] 100%
( 50/130) installing shadow                        [#######################] 100%
( 51/130) installing util-linux                    [#######################] 100%
Optional dependencies for util-linux
    python: python bindings to libmount
( 52/130) installing systemd                       [#######################] 100%
Initializing machine ID from random generator.
Created symlink /etc/systemd/system/getty.target.wants/getty@tty1.service → /usr/lib/systemd/system/getty@.service.
Created symlink /etc/systemd/system/multi-user.target.wants/remote-fs.target → /usr/lib/systemd/system/remote-fs.target.
:: Append 'init=/usr/lib/systemd/systemd' to your kernel command line in your
   bootloader to replace sysvinit with systemd, or install systemd-sysvcompat
Optional dependencies for systemd
    cryptsetup: required for encrypted block devices [pending]
    libmicrohttpd: remote journald capabilities
    quota-tools: kernel-level quota management
    systemd-sysvcompat: symlink package to provide sysvinit binaries [pending]
    polkit: allow administration as unprivileged user
( 53/130) installing device-mapper                 [#######################] 100%
( 54/130) installing popt                          [#######################] 100%
( 55/130) installing cryptsetup                    [#######################] 100%
( 56/130) installing dhcpcd                        [#######################] 100%
Optional dependencies for dhcpcd
    openresolv: resolvconf support [pending]
( 57/130) installing diffutils                     [#######################] 100%
( 58/130) installing file                          [#######################] 100%
( 59/130) installing findutils                     [#######################] 100%
( 60/130) installing mpfr                          [#######################] 100%
( 61/130) installing gawk                          [#######################] 100%
( 62/130) installing pcre                          [#######################] 100%
( 63/130) installing libffi                        [#######################] 100%
( 64/130) installing glib2                         [#######################] 100%
Optional dependencies for glib2
    python: for gdbus-codegen and gtester-report
    libelf: gresource inspection tool [installed]
( 65/130) installing libunistring                  [#######################] 100%
( 66/130) installing gettext                       [#######################] 100%
Optional dependencies for gettext
    git: for autopoint infrastructure updates
( 67/130) installing grep                          [#######################] 100%
( 68/130) installing less                          [#######################] 100%
( 69/130) installing gzip                          [#######################] 100%
( 70/130) installing inetutils                     [#######################] 100%
( 71/130) installing iproute2                      [#######################] 100%
Optional dependencies for iproute2
    linux-atm: ATM support
( 72/130) installing sysfsutils                    [#######################] 100%
( 73/130) installing iputils                       [#######################] 100%
Optional dependencies for iputils
    xinetd: for tftpd
( 74/130) installing jfsutils                      [#######################] 100%
( 75/130) installing licenses                      [#######################] 100%
( 76/130) installing linux-firmware                [#######################] 100%
( 77/130) installing mkinitcpio-busybox            [#######################] 100%
( 78/130) installing libarchive                    [#######################] 100%
( 79/130) installing mkinitcpio                    [#######################] 100%
Optional dependencies for mkinitcpio
    xz: Use lzma or xz compression for the initramfs image [installed]
    bzip2: Use bzip2 compression for the initramfs image [installed]
    lzop: Use lzo compression for the initramfs image
    lz4: Use lz4 compression for the initramfs image [installed]
    mkinitcpio-nfs-utils: Support for root filesystem on NFS
( 80/130) installing linux                         [#######################] 100%
>>> Updating module dependencies. Please wait ...
Optional dependencies for linux
    crda: to set the correct wireless channels of your country
( 81/130) installing logrotate                     [#######################] 100%
( 82/130) installing libaio                        [#######################] 100%
( 83/130) installing thin-provisioning-tools       [#######################] 100%
( 84/130) installing lvm2                          [#######################] 100%
( 85/130) installing groff                         [#######################] 100%
Optional dependencies for groff
    netpbm: for use together with man -H command interaction in browsers
    psutils: for use together with man -H command interaction in browsers
    libxaw: for gxditview
( 86/130) installing libpipeline                   [#######################] 100%
( 87/130) installing man-db                        [#######################] 100%
Optional dependencies for man-db
    gzip [installed]
( 88/130) installing man-pages                     [#######################] 100%
( 89/130) installing mdadm                         [#######################] 100%
( 90/130) installing nano                          [#######################] 100%
( 91/130) installing openresolv                    [#######################] 100%
( 92/130) installing netctl                        [#######################] 100%
Optional dependencies for netctl
    dialog: for the menu based wifi assistant
    dhclient: for DHCP support (or dhcpcd)
    dhcpcd: for DHCP support (or dhclient) [installed]
    wpa_supplicant: for wireless networking support
    ifplugd: for automatic wired connections through netctl-ifplugd
    wpa_actiond: for automatic wireless connections through netctl-auto
    ppp: for PPP connections
    openvswitch: for Open vSwitch connections
( 93/130) installing libtasn1                      [#######################] 100%
( 94/130) installing p11-kit                       [#######################] 100%
( 95/130) installing ca-certificates-utils         [#######################] 100%
( 96/130) installing ca-certificates-mozilla       [#######################] 100%
( 97/130) installing ca-certificates-cacert        [#######################] 100%
( 98/130) installing ca-certificates               [#######################] 100%
( 99/130) installing libssh2                       [#######################] 100%
(100/130) installing icu                           [#######################] 100%
(101/130) installing libpsl                        [#######################] 100%
(102/130) installing libnghttp2                    [#######################] 100%
(103/130) installing curl                          [#######################] 100%
(104/130) installing npth                          [#######################] 100%
(105/130) installing libksba                       [#######################] 100%
(106/130) installing libassuan                     [#######################] 100%
(107/130) installing libsecret                     [#######################] 100%
Optional dependencies for libsecret
    gnome-keyring: key storage service (or use any other service implementing
    org.freedesktop.secrets)
(108/130) installing pinentry                      [#######################] 100%
Optional dependencies for pinentry
    gtk2: gtk2 backend
    qt5-base: qt backend
    gcr: gnome3 backend
(109/130) installing nettle                        [#######################] 100%
(110/130) installing gnutls                        [#######################] 100%
Optional dependencies for gnutls
    guile: for use with Guile bindings
(111/130) installing sqlite                        [#######################] 100%
(112/130) installing gnupg                         [#######################] 100%
Optional dependencies for gnupg
    libldap: gpg2keys_ldap [installed]
    libusb-compat: scdaemon
(113/130) installing gpgme                         [#######################] 100%
(114/130) installing pacman-mirrorlist             [#######################] 100%
(115/130) installing archlinux-keyring             [#######################] 100%
(116/130) installing pacman                        [#######################] 100%
(117/130) installing pciutils                      [#######################] 100%
(118/130) installing pcmciautils                   [#######################] 100%
(119/130) installing procps-ng                     [#######################] 100%
(120/130) installing psmisc                        [#######################] 100%
(121/130) installing reiserfsprogs                 [#######################] 100%
(122/130) installing s-nail                        [#######################] 100%
Optional dependencies for s-nail
    smtp-forwarder: for sending mail
(123/130) installing sed                           [#######################] 100%
(124/130) installing systemd-sysvcompat            [#######################] 100%
(125/130) installing tar                           [#######################] 100%
(126/130) installing texinfo                       [#######################] 100%
(127/130) installing usbutils                      [#######################] 100%
Optional dependencies for usbutils
    python2: for lsusb.py usage
    coreutils: for lsusb.py usage [installed]
(128/130) installing vi                            [#######################] 100%
Optional dependencies for vi
    s-nail: used by the preserve command for notification [installed]
(129/130) installing which                         [#######################] 100%
(130/130) installing xfsprogs                      [#######################] 100%
:: Running post-transaction hooks...
(1/7) Updating linux initcpios
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.4-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> ERROR: file not found: `fsck.btrfs'
==> WARNING: No fsck helpers found. fsck will not be run on boot.
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: 4.11.4-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux-fallback.img
==> Image generation successful
error: command failed to execute correctly
(2/7) Updating udev hardware database...
(3/7) Updating system user accounts...
(4/7) Creating temporary files...
(5/7) Arming ConditionNeedsUpdate...
(6/7) Updating the info directory file...
(7/7) Rebuilding certificate stores...
pacstrap /mnt base  34.27s user 9.80s system 19% cpu 3:51.22 total

```

Create an fstab filesystem table file, using labels (-L) to identify the filesystems.

```
root@archiso ~ # genfstab -L -p /mnt >> /mnt/etc/fstab

root@archiso ~ # cat /mnt/etc/fstab
#
# /etc/fstab: static file system information
#
# <file system> <dir>   <type>  <options>       <dump>  <pass>
# /dev/sda3 UUID=399aea80-d00f-48b2-bc4f-74ff4a9bf9aa
LABEL=system            /               btrfs           rw,noatime,compress=lzo,space_cache,subvolid=257,subvol=/root,subvol=root        0 0

# /dev/sda3 UUID=399aea80-d00f-48b2-bc4f-74ff4a9bf9aa
LABEL=system            /home           btrfs           rw,noatime,compress=lzo,space_cache,subvolid=258,subvol=/home,subvol=home        0 0

# /dev/sda3 UUID=399aea80-d00f-48b2-bc4f-74ff4a9bf9aa
LABEL=system            /.snapshots     btrfs           rw,noatime,compress=lzo,space_cache,subvolid=259,subvol=/snapshots,subvol=snapshots      0 0

# /dev/sda1 UUID=A15A-8166
LABEL=EFI               /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro     0 2

# /dev/sda2 UUID=5ad87c95-e59d-4a85-b149-9b361042c746
LABEL=swap              none            swap            defaults        0 0
```

Boot into new system

```
root@archiso ~ # systemd-nspawn -bD /mnt
Spawning container mnt on /mnt.
Press ^] three times within 1s to kill container.
systemd 232 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
Detected virtualization systemd-nspawn.
Detected architecture x86-64.

Welcome to Arch Linux!

Failed to install release agent, ignoring: No such file or directory
[  OK  ] Listening on LVM2 metadata daemon socket.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Listening on Journal Socket.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Reached target Remote File Systems.
[  OK  ] Created slice System Slice.
[  OK  ] Reached target Slices.
         Mounting POSIX Message Queue File System...
[  OK  ] Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[  OK  ] Created slice system-getty.slice.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
[  OK  ] Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Reached target Paths.
[  OK  ] Listening on Process Core Dump Socket.
         Mounting Huge Pages File System...
[  OK  ] Reached target Encrypted Volumes.
         Starting Remount Root and Kernel File Systems...
[  OK  ] Reached target Swap.
         Starting Journal Service...
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Huge Pages File System.
systemd-remount-fs.service: Main process exited, code=exited, status=1/FAILURE
[FAILED] Failed to start Remount Root and Kernel File Systems.
See 'systemctl status systemd-remount-fs.service' for details.
systemd-remount-fs.service: Unit entered failed state.
systemd-remount-fs.service: Failed with result 'exit-code'.
         Starting Create System Users...
[  OK  ] Started Create System Users.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
         Starting Rebuild Journal Catalog...
         Starting Rebuild Dynamic Linker Cache...
[  OK  ] Started Rebuild Journal Catalog.
[  OK  ] Started Rebuild Dynamic Linker Cache.
         Starting Update is Completed...
[  OK  ] Started Update is Completed.
[  OK  ] Started Journal Service.
         Starting Flush Journal to Persistent Storage...
[  OK  ] Started Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[FAILED] Failed to start Create Volatile Files and Directories.
See 'systemctl status systemd-tmpfiles-setup.service' for details.
         Starting Update UTMP about System Boot/Shutdown...
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily man-db cache update.
[  OK  ] Started Daily verification of password and group files.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Started Daily rotation of log files.
[  OK  ] Reached target Timers.
[  OK  ] Reached target Basic System.
         Starting Login Service...
[  OK  ] Started D-Bus System Message Bus.
         Starting Permit User Sessions...
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Console Getty.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started Login Service.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.

Arch Linux 4.11.3-1-ARCH (console)

mnt login:
```

This will boot your new base Arch Linux system. After the standard boot messages scroll by you will be presented with a login (enter root and hit enter to login).

```
mnt login: root
[root@mnt ~]#
```

```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
[root@mnt ~]# locale-gen
Generating locales...
  en_US.UTF-8... done
Generation complete.
```

```
[root@mnt ~]# localectl list-locales
en_US.utf8
[root@mnt ~]# localectl set-locale LANG=en_US.UTF-8
[root@mnt ~]# timedatectl set-ntp 1
[root@mnt ~]# timedatectl list-timezones
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
Africa/Bamako
Africa/Bangui
Africa/Banjul
Africa/Bissau
Africa/Blantyre
Africa/Brazzaville
Africa/Bujumbura
Africa/Cairo
Africa/Casablanca
Africa/Ceuta
Africa/Conakry
Africa/Dakar
Africa/Dar_es_Salaam
Africa/Djibouti
Africa/Douala
Africa/El_Aaiun
Africa/Freetown
Africa/Gaborone
Africa/Harare
Africa/Johannesburg
Africa/Juba
Africa/Kampala
Africa/Khartoum
Africa/Kigali
Africa/Kinshasa
Africa/Lagos
Africa/Libreville
Africa/Lome
Africa/Luanda
Africa/Lubumbashi
Africa/Lusaka
Africa/Malabo
Africa/Maputo
Africa/Maseru
Africa/Mbabane
Africa/Mogadishu
Africa/Monrovia
Africa/Nairobi
Africa/Ndjamena
Africa/Niamey
Africa/Nouakchott
Africa/Ouagadougou
Africa/Porto-Novo
Africa/Sao_Tome
Africa/Tripoli
Africa/Tunis
Africa/Windhoek
America/Adak
America/Anchorage
America/Anguilla
America/Antigua
America/Araguaina
America/Argentina/Buenos_Aires
America/Argentina/Catamarca
America/Argentina/Cordoba
America/Argentina/Jujuy
America/Argentina/La_Rioja
America/Argentina/Mendoza
America/Argentina/Rio_Gallegos
America/Argentina/Salta
America/Argentina/San_Juan
America/Argentina/San_Luis
America/Argentina/Tucuman
America/Argentina/Ushuaia
America/Aruba
America/Asuncion
America/Atikokan
America/Bahia
America/Bahia_Banderas
America/Barbados
America/Belem
America/Belize
America/Blanc-Sablon
America/Boa_Vista
America/Bogota
America/Boise
America/Cambridge_Bay
America/Campo_Grande
America/Cancun
America/Caracas
America/Cayenne
America/Cayman
America/Chicago
America/Chihuahua
America/Costa_Rica
America/Creston
America/Cuiaba
America/Curacao
America/Danmarkshavn
America/Dawson
America/Dawson_Creek
America/Denver
America/Detroit
America/Dominica
America/Edmonton
America/Eirunepe
America/El_Salvador
America/Fort_Nelson
America/Fortaleza
America/Glace_Bay
America/Godthab
America/Goose_Bay
America/Grand_Turk
America/Grenada
America/Guadeloupe
America/Guatemala
America/Guayaquil
America/Guyana
America/Halifax
America/Havana
America/Hermosillo
America/Indiana/Indianapolis
America/Indiana/Knox
America/Indiana/Marengo
America/Indiana/Petersburg
America/Indiana/Tell_City
America/Indiana/Vevay
America/Indiana/Vincennes
America/Indiana/Winamac
America/Inuvik
America/Iqaluit
America/Jamaica
America/Juneau
America/Kentucky/Louisville
America/Kentucky/Monticello
America/Kralendijk
America/La_Paz
America/Lima
America/Los_Angeles
America/Lower_Princes
America/Maceio
America/Managua
America/Manaus
America/Marigot
America/Martinique
America/Matamoros
America/Mazatlan
America/Menominee
America/Merida
America/Metlakatla
America/Mexico_City
America/Miquelon
America/Moncton
America/Monterrey
America/Montevideo
America/Montserrat
America/Nassau
America/New_York
America/Nipigon
America/Nome
America/Noronha
America/North_Dakota/Beulah
America/North_Dakota/Center
America/North_Dakota/New_Salem
America/Ojinaga
America/Panama
America/Pangnirtung
America/Paramaribo
America/Phoenix
America/Port-au-Prince
America/Port_of_Spain
America/Porto_Velho
America/Puerto_Rico
America/Punta_Arenas
America/Rainy_River
America/Rankin_Inlet
America/Recife
America/Regina
America/Resolute
America/Rio_Branco
America/Santarem
America/Santiago
America/Santo_Domingo
America/Sao_Paulo
America/Scoresbysund
America/Sitka
America/St_Barthelemy
America/St_Johns
America/St_Kitts
America/St_Lucia
America/St_Thomas
America/St_Vincent
America/Swift_Current
America/Tegucigalpa
America/Thule
America/Thunder_Bay
America/Tijuana
America/Toronto
America/Tortola
America/Vancouver
America/Whitehorse
America/Winnipeg
America/Yakutat
America/Yellowknife
Antarctica/Casey
Antarctica/Davis
Antarctica/DumontDUrville
Antarctica/Macquarie
Antarctica/Mawson
Antarctica/McMurdo
Antarctica/Palmer
Antarctica/Rothera
Antarctica/Syowa
Antarctica/Troll
Antarctica/Vostok
Arctic/Longyearbyen
Asia/Aden
Asia/Almaty
Asia/Amman
Asia/Anadyr
Asia/Aqtau
Asia/Aqtobe
Asia/Ashgabat
Asia/Atyrau
Asia/Baghdad
Asia/Bahrain
Asia/Baku
Asia/Bangkok
Asia/Barnaul
Asia/Beirut
Asia/Bishkek
Asia/Brunei
Asia/Chita
Asia/Choibalsan
Asia/Colombo
Asia/Damascus
Asia/Dhaka
Asia/Dili
Asia/Dubai
Asia/Dushanbe
Asia/Famagusta
Asia/Gaza
Asia/Hebron
Asia/Ho_Chi_Minh
Asia/Hong_Kong
Asia/Hovd
Asia/Irkutsk
Asia/Jakarta
Asia/Jayapura
Asia/Jerusalem
Asia/Kabul
Asia/Kamchatka
Asia/Karachi
Asia/Kathmandu
Asia/Khandyga
Asia/Kolkata
Asia/Krasnoyarsk
Asia/Kuala_Lumpur
Asia/Kuching
Asia/Kuwait
Asia/Macau
Asia/Magadan
Asia/Makassar
Asia/Manila
Asia/Muscat
Asia/Nicosia
Asia/Novokuznetsk
Asia/Novosibirsk
Asia/Omsk
Asia/Oral
Asia/Phnom_Penh
Asia/Pontianak
Asia/Pyongyang
Asia/Qatar
Asia/Qyzylorda
Asia/Riyadh
Asia/Sakhalin
Asia/Samarkand
Asia/Seoul
Asia/Shanghai
Asia/Singapore
Asia/Srednekolymsk
Asia/Taipei
Asia/Tashkent
Asia/Tbilisi
Asia/Tehran
Asia/Thimphu
Asia/Tokyo
Asia/Tomsk
Asia/Ulaanbaatar
Asia/Urumqi
Asia/Ust-Nera
Asia/Vientiane
Asia/Vladivostok
Asia/Yakutsk
Asia/Yangon
Asia/Yekaterinburg
Asia/Yerevan
Atlantic/Azores
Atlantic/Bermuda
Atlantic/Canary
Atlantic/Cape_Verde
Atlantic/Faroe
Atlantic/Madeira
Atlantic/Reykjavik
Atlantic/South_Georgia
Atlantic/St_Helena
Atlantic/Stanley
Australia/Adelaide
Australia/Brisbane
Australia/Broken_Hill
Australia/Currie
Australia/Darwin
Australia/Eucla
Australia/Hobart
Australia/Lindeman
Australia/Lord_Howe
Australia/Melbourne
Australia/Perth
Australia/Sydney
Europe/Amsterdam
Europe/Andorra
Europe/Astrakhan
Europe/Athens
Europe/Belgrade
Europe/Berlin
Europe/Bratislava
Europe/Brussels
Europe/Bucharest
Europe/Budapest
Europe/Busingen
Europe/Chisinau
Europe/Copenhagen
Europe/Dublin
Europe/Gibraltar
Europe/Guernsey
Europe/Helsinki
Europe/Isle_of_Man
Europe/Istanbul
Europe/Jersey
Europe/Kaliningrad
Europe/Kiev
Europe/Kirov
Europe/Lisbon
Europe/Ljubljana
Europe/London
Europe/Luxembourg
Europe/Madrid
Europe/Malta
Europe/Mariehamn
Europe/Minsk
Europe/Monaco
Europe/Moscow
Europe/Oslo
Europe/Paris
Europe/Podgorica
Europe/Prague
Europe/Riga
Europe/Rome
Europe/Samara
Europe/San_Marino
Europe/Sarajevo
Europe/Saratov
Europe/Simferopol
Europe/Skopje
Europe/Sofia
Europe/Stockholm
Europe/Tallinn
Europe/Tirane
Europe/Ulyanovsk
Europe/Uzhgorod
Europe/Vaduz
Europe/Vatican
Europe/Vienna
Europe/Vilnius
Europe/Volgograd
Europe/Warsaw
Europe/Zagreb
Europe/Zaporozhye
Europe/Zurich
Indian/Antananarivo
Indian/Chagos
Indian/Christmas
Indian/Cocos
Indian/Comoro
Indian/Kerguelen
Indian/Mahe
Indian/Maldives
Indian/Mauritius
Indian/Mayotte
Indian/Reunion
Pacific/Apia
Pacific/Auckland
Pacific/Bougainville
Pacific/Chatham
Pacific/Chuuk
Pacific/Easter
Pacific/Efate
Pacific/Enderbury
Pacific/Fakaofo
Pacific/Fiji
Pacific/Funafuti
Pacific/Galapagos
Pacific/Gambier
Pacific/Guadalcanal
Pacific/Guam
Pacific/Honolulu
Asia/Vientiane
Asia/Vladivostok
Asia/Yakutsk
Asia/Yangon
Asia/Yekaterinburg
Asia/Yerevan
Atlantic/Azores
Atlantic/Bermuda
Atlantic/Canary
Atlantic/Cape_Verde
Atlantic/Faroe
Atlantic/Madeira
Atlantic/Reykjavik
Atlantic/South_Georgia
Atlantic/St_Helena
Atlantic/Stanley
Australia/Adelaide
Australia/Brisbane
Australia/Broken_Hill
Australia/Currie
Australia/Darwin
Australia/Eucla
Australia/Hobart
America/Montevideo
America/Montserrat
America/Nassau
America/New_York
America/Nipigon
America/Nome
America/Noronha
America/North_Dakota/Beulah
America/North_Dakota/Center
America/North_Dakota/New_Salem
America/Ojinaga
America/Panama
America/Pangnirtung
America/Paramaribo
America/Phoenix
America/Port-au-Prince
America/Port_of_Spain
America/Porto_Velho
America/Puerto_Rico
America/Punta_Arenas
America/Rainy_River
America/Rankin_Inlet
America/Recife
America/Regina
America/Resolute
America/Rio_Branco
America/Santarem
America/Santiago
America/Santo_Domingo
America/Sao_Paulo
America/Scoresbysund
America/Sitka
America/St_Barthelemy
America/St_Johns
America/St_Kitts
America/St_Lucia
America/St_Thomas
America/St_Vincent
America/Swift_Current
America/Tegucigalpa
America/Thule
America/Thunder_Bay
America/Tijuana
America/Toronto
America/Tortola
America/Vancouver

[root@mnt ~]# timedatectl set-timezone America/Toronto
[root@mnt ~]# hostnamectl set-hostname myhostname
echo "127.0.1.1	myhostname.localdomain	myhostname" >> /etc/hosts

[root@mnt ~]# cat /etc/hosts
#
# /etc/hosts: static lookup table for host names
#

#<ip-address>   <hostname.domain.org>   <hostname>
127.0.0.1       localhost.localdomain   localhost
::1             localhost.localdomain   localhost
127.0.1.1	myhostname.localdomain	myhostname
# End of file
```

```
[root@mnt ~]# pacman -Syu base-devel btrfs-progs iw gptfdisk zsh vim terminus-font
```

Add btrfs to HOOKS to initramfs

```
[root@mnt ~]# nano /etc/mkinitcpio.conf
HOOKS="base udev autodetect modconf block filesystems keyboard btrfs"
```

Regenerate the initramfs image

```
[root@mnt ~]# mkinitcpio -p linux
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.4-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [btrfs]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> Image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: 4.11.4-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [btrfs]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux-fallback.img
==> Image generation successful
```

Set your root password

```
[root@mnt ~]# passwd
New password: 1337pleb
Retype new password: 1337pleb
passwd: password updated successfully
```

Leave the systemd-nspawn environment

Issue a poweroff to exit the nspawned environment.

```
[root@mnt ~]# poweroff
         Stopping User Manager for UID 0...
[  OK  ] Removed slice system-getty.slice.
[  OK  ] Stopped Session c2 of user root.
[  OK  ] Stopped target Graphical Interface.
[  OK  ] Stopped target Multi-User System.
[  OK  ] Stopped target Login Prompts.
         Stopping Console Getty...
[  OK  ] Stopped target Timers.
[  OK  ] Stopped Daily Cleanup of Temporary Directories.
[  OK  ] Stopped Daily verification of password and group files.
[  OK  ] Stopped Daily man-db cache update.
         Starting Generate shutdown-ramfs...
[  OK  ] Stopped Daily rotation of log files.
[  OK  ] Stopped target System Time Synchronized.
         Stopping D-Bus System Message Bus...
[  OK  ] Stopped D-Bus System Message Bus.
[  OK  ] Stopped Console Getty.
[  OK  ] Stopped User Manager for UID 0.
[  OK  ] Removed slice User Slice of root.
         Stopping Login Service...
         Stopping Permit User Sessions...
[  OK  ] Stopped Login Service.
[  OK  ] Stopped Permit User Sessions.
[  OK  ] Stopped target Basic System.
[  OK  ] Stopped target Paths.
[  OK  ] Stopped target Sockets.
[  OK  ] Closed D-Bus System Message Bus Socket.
[  OK  ] Stopped target Slices.
[  OK  ] Removed slice User and Session Slice.
[  OK  ] Stopped target System Initialization.
         Stopping Update UTMP about System Boot/Shutdown...
[  OK  ] Stopped target Encrypted Volumes.
[  OK  ] Stopped Dispatch Password Requests to Console Directory Watch.
[  OK  ] Stopped Forward Password Requests to Wall Directory Watch.
[  OK  ] Stopped Update is Completed.
[  OK  ] Stopped Create System Users.
[  OK  ] Stopped Rebuild Dynamic Linker Cache.
[  OK  ] Stopped Rebuild Journal Catalog.
[  OK  ] Stopped target Local File Systems.
         Unmounting Temporary Directory...
         Unmounting /.snapshots...
         Unmounting /run/systemd/nspawn/incoming...
         Unmounting /run/user/0...
         Unmounting /boot...
         Unmounting /home...
         Unmounting /proc/sys/kernel/random/boot_id...
         Unmounting /proc/sysrq-trigger...
[  OK  ] Stopped target Remote File Systems.
[  OK  ] Stopped Update UTMP about System Boot/Shutdown.
[  OK  ] Unmounted /.snapshots.
[  OK  ] Unmounted /run/user/0.
[  OK  ] Unmounted /home.
[  OK  ] Unmounted /run/systemd/nspawn/incoming.
[  OK  ] Unmounted Temporary Directory.
[  OK  ] Unmounted /boot.
[  OK  ] Unmounted /proc/sys/kernel/random/boot_id.
[  OK  ] Stopped target Swap.
[  OK  ] Reached target Unmount All Filesystems.
[  OK  ] Stopped target Local File Systems (Pre).
[  OK  ] Unmounted /proc/sysrq-trigger.
[  OK  ] Started Generate shutdown-ramfs.
[  OK  ] Reached target Shutdown.
Sending SIGTERM to remaining processes...
Sending SIGKILL to remaining processes...
Powering off.
Container mnt has been shut down.
systemd-nspawn -bD /mnt  28.71s user 11.05s system 1% cpu 35:37.54 total
```

??

```
efibootmgr -d /dev/sda -p 1 -c -L "Arch Linux" -l /vmlinuz-linux -u "root=UUID=$UUID rootflags=subvol=root rw initrd=/initramfs-linux.img"
```

??

```
efibootmgr -d /dev/sda -p 1 -c -L "Arch Linux" -l /vmlinuz-linux -u "root=UUID=399aea80-d00f-48b2-bc4f-74ff4a9bf9aa rootflags=subvol=root rw initrd=/initramfs-linux.img"
```

Reboot failed...

efibootmgr entries didn't work comes to a kernel panic.

systemd-boot

```
bootctl install 
```

```
nano /boot/loader/loader.conf
timeout 3
default arch
editor 0
```

```
/boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=LABEL=system rw rootflags=subvol=root
```

Reboot Failure...

Click on dell boot (F12) option for systemd-boot, just goes to a black screen (glitched: if you push the up/down buttons, the dell boot menu options start to show up again)

Grub install

```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
Installing for x86_64-efi platform.
GPTH CRC check failed, 99180435 != 684361cf.
GPTH CRC check failed, 99180435 != 684361cf.
GPTH CRC check failed, 99180435 != 684361cf.
GPTH CRC check failed, 99180435 != 684361cf.
GPTH CRC check failed, 99180435 != 684361cf.
GPTH CRC check failed, 99180435 != 684361cf.
Installation finished. No error reported.
```

We are hoping for output like this from the grub-install command:
Installation finished. No error reported.

Got that but with errors above and then it seems the GPT partition backup gets corrupted after that command.

And it just does the black screen thing above like systemd-boot.















Ignore from here down old doc...
















## Mount the partition ##

mkdir /mnt/btrfs-root
mount -o defaults,relatime,discard,ssd,nodev,nosuid /dev/sda1 /mnt/btrfs-root
mount -o defaults,relatime,discard,nodev,nosuid /dev/sda1 /mnt/btrfs-root

## Create the subvolumes ##

mkdir -p /mnt/btrfs-root/__snapshot
mkdir -p /mnt/btrfs-root/__current
btrfs subvolume create /mnt/btrfs-root/__current/root
btrfs subvolume create /mnt/btrfs-root/__current/home

## Mount the subvolumes ##

mkdir -p /mnt/btrfs-current

mount -o defaults,relatime,discard,ssd,nodev,subvol=__current/root /dev/sda1 /mnt/btrfs-current
mount -o defaults,relatime,discard,nodev,subvol=__current/root /dev/sda1 /mnt/btrfs-current
mkdir -p /mnt/btrfs-current/home

mount -o defaults,relatime,discard,ssd,nodev,nosuid,subvol=__current/home /dev/sda1 /mnt/btrfs-current/home
mount -o defaults,relatime,discard,nodev,nosuid,subvol=__current/home /dev/sda1 /mnt/btrfs-current/home
## Install Arch Linux ##

nano /etc/pacman.d/mirrorlist 
 * Select the mirror to be used

pacstrap /mnt/btrfs-current base base-devel
genfstab -U -p /mnt/btrfs-current >> /mnt/btrfs-current/etc/fstab
nano /mnt/btrfs-current/etc/fstab
 * copy the partition info for / and mount it on /run/btrfs-root (remember to remove subvol parameter! and add nodev,nosuid,noexec parameters)

## Configure the system ##
 
arch-chroot /mnt/btrfs-current /bin/bash

pacman -S btrfs-progs

nano /etc/locale.gen
 * Uncomment en_US.UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime
hwclock --systohc --utc

echo 'idv-HP-EliteBook-840-G1' > /etc/hostname
nano /etc/nsswitch
 * set the hostname

pacman -S wicd
systemctl enable wicd.service

nano /etc/mkinitcpio.conf
 * Remove fsck and add btrfs to HOOKS
mkinitcpio -p linux

passwd
groupadd idv
useradd -m -g idv -G users,wheel,storage,power,network -s /bin/bash -c "Ihor Dvoretskyi" idv
passwd idv

## Install boot loader ##

pacman -S grub-bios
grub-install --target=i386-pc --recheck /dev/sda
nano /etc/default/grub
 * Edit settings (e.g., disable gfx, quiet, etc.)
grub-mkconfig -o /boot/grub/grub.cfg

## Unmount and reboot ##

exit

umount /mnt/btrfs-current/home
umount /mnt/btrfs-current
umount /mnt/btrfs-root

reboot

## Post installation configuration ##

### Power management ###

nano /etc/modprobe.d/blacklist.conf
 * blacklist nouveau

Download and compile bbswitch from https://aur.archlinux.org/packages/bbswitch/

nano /etc/mkinitcpio.conf
 * Add "i915 bbswitch" to MODULES
 * Add "/etc/modprobe.d/i915.conf /etc/modprobe.d/bbswitch.conf" to FILES
nano /etc/modprobe.d/i915.conf
 options i915 modeset=1
 options i915 i915_enable_rc6=1
 options i915 i915_enable_fbc=1
 options i915 lvds_downclock=1
nano /etc/modprobe.d/bbswitch.conf
 options bbswitch load_state=0
 options bbswitch unload_state=1
mkinitcpio -p linux

### Hardening ###

chmod 700 /boot /etc/{iptables,arptables}

nano /etc/securetty
 * Comment tty1

nano /etc/iptables/iptables.rules
 *filter
 :INPUT DROP [0:0]
 :FORWARD DROP [0:0]
 :OUTPUT ACCEPT [0:0]
 -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
 -A INPUT -i lo -j ACCEPT 
 -A INPUT -p udp --sport 53 -j ACCEPT
 -A INPUT -p icmp -j REJECT
 -A INPUT -p tcp -j REJECT --reject-with tcp-reset 
 -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable 
 -A INPUT -j REJECT --reject-with icmp-proto-unreachable 
 COMMIT
systemctl enable iptables.service

nano /etc/sysctl.conf
 * net.ipv4.conf.all.log_martians = 1
 * net.ipv4.conf.all.rp_filter = 1
 * net.ipv4.icmp_echo_ignore_broadcasts = 1
 * net.ipv4.icmp_ignore_bogus_error_responses = 1

### Snapshot ###

echo `date "+%Y%m%d-%H%M%S"` > /run/btrfs-root/__current/ROOT/SNAPSHOT
echo "Fresh install" >> /run/btrfs-root/__current/ROOT/SNAPSHOT
btrfs subvolume snapshot -r /run/btrfs-root/__current/ROOT /run/btrfs-root/__snapshot/ROOT@`head -n 1 /run/btrfs-root/__current/ROOT/SNAPSHOT`
cd /run/btrfs-root/__snapshot/
ln -s ROOT@`cat /run/btrfs-root/__current/ROOT/SNAPSHOT` fresh-install
rm /run/btrfs-root/__current/ROOT/SNAPSHOT 

#### Software Installation ####
su
visudo
 * Enable sudo for wheel
 * Uncomment %wheel ALL=(ALL) ALL
 * :wq
 * exit
 sudo pacman -S dialog wpa_supplicant
 sudo wifi-menu
 * Chose your wifi connection.
 or
 ip addr
 dhcpcd eno1
 
 ping google.ca
 ping 8.8.8.8
 
 sudo pacman -S libvirt virt-manager qemu dmidecode ovmf dopenssh ebtables bridge-utils openbsd-netcat
 
 sudo systemctl enable sshd
 sudo systemctl start sshd
 
 sudo systemctl enable libvirtd
 sudo systemctl start libvirtd
 
 sed -i s/78/kvm/ /etc/libvirt/qemu.conf
 
 Enable UEFI Booting of VMs
 
 sudo nano /etc/libvirt/qemu.conf

 nvram=["/usr/share/ovmf/ovmf_code_x64.bin:/usr/share/ovmf/ovmf_vars_x64.bin"]
 
 sudo pacman -S xorg xorg-xinit i3-wm i3status i3lock dmenu nautilus
 echo "exec i3" > ~/.xinitrc
 
 
 
 
