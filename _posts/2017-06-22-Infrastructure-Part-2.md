---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 2 - Hypervisor
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVM.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

Part 02 - Hypervisor OS Install - You Are Here!

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Hypervisor OS Install #

Like living on the razors edge, how about an Arch Linux Hypervisor (These steps could be used for other systemd-networkd distributions).

## USB Install ##

Grab whatever the latest ISO is: [archlinux-2017.06.01-x86_64.iso](http://mirror.rackspace.com/archlinux/iso/2017.06.01/archlinux-2017.06.01-x86_64.iso)

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

### Install Openssh ###

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

## Destroy Contents Of Drive & Create Partitions ##

```
root@archiso ~ # sgdisk --zap-all /dev/sda

root@archiso ~ # sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+12GiB  --typecode=2:8200 --change-name=2:SWAP \
       --new=3:0:0       --typecode=3:8300 --change-name=3:ROOT \
       /dev/sda
         
Creating new GPT entries.
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

### Show Partitions & Lables ###

```
root@archiso ~ # lsblk -o +PARTLABEL

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT                PARTLABEL
loop0    7:0    0 375.6M  1 loop /run/archiso/sfs/airootfs
sda      8:0    0 298.1G  0 disk
├─sda1   8:1    0   550M  0 part                           EFI
├─sda2   8:2    0    12G  0 part                           SWAP
└─sda3   8:3    0 285.6G  0 part                           ROOT
sdb      8:16   1   3.8G  0 disk
└─sdb1   8:17   1   3.8G  0 part /run/archiso/bootmnt
sr0     11:0    1  1024M  0 rom
```

### Format EFI Partition ###

```
root@archiso ~ # mkfs.vfat -F 32 -n EFI /dev/sda1
mkfs.fat 4.1 (2017-01-24)
```

### Format ROOT Partition ###

```
root@archiso ~ # mkfs.btrfs -f -L ROOT /dev/sda3
btrfs-progs v4.11
See http://btrfs.wiki.kernel.org for more information.
 
Label:              ROOT
UUID:               f42e42e1-2b97-4c87-b0ae-7b9d1096c676
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
    1   285.55GiB  /dev/sda3
```

### Format SWAP Partition & Turn It On ###

```
root@archiso ~ # mkswap -L SWAP /dev/sda2                                  :(
mkswap: /dev/sda2: warning: wiping old swap signature.
Setting up swapspace version 1, size = 12 GiB (12884897792 bytes)
LABEL=SWAP, UUID=9689b746-3b09-4b3f-a871-497cb7d43651
root@archiso ~ # swapon /dev/sda2
root@archiso ~ # free -h
              total        used        free      shared  buff/cache   available
Mem:           7.7G        119M        7.2G        122M        326M        7.2G
Swap:           11G          0B         11G
```

### Create BTRFS Mountpoints ###

```
root@archiso ~ # mount /dev/sda3 /mnt
root@archiso ~ # cd /mnt
root@archiso /mnt # btrfs sub create @
Create subvolume './@'
root@archiso /mnt # btrfs sub create @home
Create subvolume './@home'
root@archiso /mnt # btrfs sub create @snapshots
Create subvolume './@snapshots'
root@archiso /mnt # ls
@  @home  @snapshots

```

### Mount BTRFS Filesystem ###

```
root@archiso /mnt # cd
root@archiso ~ # umount /mnt
root@archiso ~ # mount -o noatime,compress=lzo,space_cache,subvol=@ /dev/sda3 /mnt
root@archiso ~ # mkdir -p /mnt/boot
root@archiso ~ # mkdir -p /mnt/home
root@archiso ~ # mkdir -p /mnt/.snapshots
root@archiso ~ # mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/sda3 /mnt/home
root@archiso ~ # mount -o noatime,compress=lzo,space_cache,subvol=@snapshots /dev/sda3 /mnt/.snapshots
root@archiso ~ # mount /dev/sda1 /mnt/boot/
root@archiso ~ # df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
dev            devtmpfs  3.9G     0  3.9G   0% /dev
run            tmpfs     3.9G  110M  3.8G   3% /run
/dev/sdb1      vfat      3.8G  487M  3.3G  13% /run/archiso/bootmnt
cowspace       tmpfs     256M   12M  245M   5% /run/archiso/cowspace
/dev/loop0     squashfs  376M  376M     0 100% /run/archiso/sfs/airootfs
airootfs       overlay   256M   12M  245M   5% /
tmpfs          tmpfs     3.9G     0  3.9G   0% /dev/shm
tmpfs          tmpfs     3.9G     0  3.9G   0% /sys/fs/cgroup
tmpfs          tmpfs     3.9G     0  3.9G   0% /tmp
tmpfs          tmpfs     3.9G  1.4M  3.9G   1% /etc/pacman.d/gnupg
tmpfs          tmpfs     787M     0  787M   0% /run/user/0
/dev/sda3      btrfs     286G   17M  284G   1% /mnt
/dev/sda3      btrfs     286G   17M  284G   1% /mnt/home
/dev/sda3      btrfs     286G   17M  284G   1% /mnt/.snapshots
/dev/sda1      vfat      549M  4.0K  549M   1% /mnt/boot
```

### Pacstrap All The Things To /mnt ###

Installing: base base-devel btrfs-progs dosfstools bash-completion

```
root@archiso ~ # pacstrap /mnt base base-devel btrfs-progs dosfstools bash-completion
==> Creating install root at /mnt
==> Installing packages to /mnt
:: Synchronizing package databases...
 core                     124.2 KiB   268K/s 00:00 [######################] 100%
 extra                   1667.7 KiB  3.09M/s 00:01 [######################] 100%
 community                  3.9 MiB  5.49M/s 00:01 [######################] 100%
:: There are 50 members in group base:
:: Repository core
   1) bash  2) bzip2  3) coreutils  4) cryptsetup  5) device-mapper  6) dhcpcd
   7) diffutils  8) e2fsprogs  9) file  10) filesystem  11) findutils  12) gawk
   13) gcc-libs  14) gettext  15) glibc  16) grep  17) gzip  18) inetutils
   19) iproute2  20) iputils  21) jfsutils  22) less  23) licenses  24) linux
   25) logrotate  26) lvm2  27) man-db  28) man-pages  29) mdadm  30) nano
   31) netctl  32) pacman  33) pciutils  34) pcmciautils  35) perl
   36) procps-ng  37) psmisc  38) reiserfsprogs  39) s-nail  40) sed
   41) shadow  42) sysfsutils  43) systemd-sysvcompat  44) tar  45) texinfo
   46) usbutils  47) util-linux  48) vi  49) which  50) xfsprogs
 
Enter a selection (default=all):
resolving dependencies...
looking for conflicting packages...
warning: dependency cycle detected:
warning: libusb will be installed before its systemd dependency
 
Packages (134) acl-2.2.52-3  archlinux-keyring-20170320-1  attr-2.4.47-2
               ca-certificates-20170307-1  ca-certificates-cacert-20140824-4
               ca-certificates-mozilla-3.31-3  ca-certificates-utils-20170307-1
               cracklib-2.9.6-1  curl-7.54.1-1  db-5.3.28-3  dbus-1.10.18-1
               expat-2.2.0-2  gdbm-1.13-1  glib2-2.52.2+9+g3245eba16-1
               gmp-6.1.2-1  gnupg-2.1.21-3  gnutls-3.5.13-1  gpgme-1.9.0-3
               groff-1.22.3-7  hwids-20170328-1  iana-etc-20170512-1
               icu-59.1-1  iptables-1.6.1-1  kbd-2.0.4-1  keyutils-1.5.10-1
               kmod-24-1  krb5-1.15.1-1  libaio-0.3.110-1  libarchive-3.3.1-5
               libassuan-2.4.3-1  libcap-2.25-1  libelf-0.169-1  libffi-3.2.1-2
               libgcrypt-1.7.7-1  libgpg-error-1.27-1  libidn-1.33-1
               libksba-1.3.4-2  libldap-2.4.44-5  libmnl-1.0.4-1
               libnftnl-1.0.7-1  libnghttp2-1.23.1-1  libnl-3.2.29-2
               libpcap-1.8.1-2  libpipeline-1.4.1-1  libpsl-0.17.0-2
               libsasl-2.1.26-11  libseccomp-2.3.2-1
               libsecret-0.18.5+14+g9980655-1  libssh2-1.8.0-2
               libsystemd-232-8  libtasn1-4.12-1  libtirpc-1.0.1-3
               libunistring-0.9.7-1  libusb-1.0.21-1  libutil-linux-2.29.2-2
               linux-api-headers-4.10.1-1  linux-firmware-20170422.ade8332-1
               lz4-1:1.7.5-1  lzo-2.10-1  mkinitcpio-23-1
               mkinitcpio-busybox-1.25.1-1  mpfr-3.1.5.p2-1
               ncurses-6.0+20170527-1  nettle-3.3-1  npth-1.5-1
               openresolv-3.9.0-1  openssl-1.1.0.f-1  p11-kit-0.23.7-1
               pacman-mirrorlist-20170427-1  pam-1.3.0-1  pambase-20130928-1
               pcre-8.40-1  pinentry-1.0.0-1  popt-1.16-8  readline-7.0.003-1
               sqlite-3.19.3-1  systemd-232-8  thin-provisioning-tools-0.7.0-1
               tzdata-2017b-1  xz-5.2.3-1  zlib-1:1.2.11-1  bash-4.4.012-2
               bash-completion-2.5-1  btrfs-progs-4.11-1  bzip2-1.0.6-6
               coreutils-8.27-1  cryptsetup-1.7.5-1  device-mapper-2.02.171-1
               dhcpcd-6.11.5-1  diffutils-3.6-1  dosfstools-4.1-1
               e2fsprogs-1.43.4-1  file-5.31-1  filesystem-2017.03-2
               findutils-4.6.0-2  gawk-4.1.4-2  gcc-libs-7.1.1-2
               gettext-0.19.8.1-2  glibc-2.25-2  grep-3.0-1  gzip-1.8-2
               inetutils-1.9.4-5  iproute2-4.11.0-1  iputils-20161105.1f2bb12-2
               jfsutils-1.1.15-4  less-487-1  licenses-20140629-2
               linux-4.11.5-1  logrotate-3.12.2-1  lvm2-2.02.171-1
               man-db-2.7.6.1-2  man-pages-4.11-1  mdadm-4.0-1  nano-2.8.4-1
               netctl-1.12-2  pacman-5.0.2-1  pciutils-3.5.4-1
               pcmciautils-018-7  perl-5.26.0-1  procps-ng-3.3.12-1
               psmisc-22.21-3  reiserfsprogs-3.6.25-1  s-nail-14.8.16-2
               sed-4.4-1  shadow-4.4-3  sysfsutils-2.1.0-9
               systemd-sysvcompat-232-8  tar-1.29-2  texinfo-6.3-2
               usbutils-008-1  util-linux-2.29.2-2  vi-1:070224-2  which-2.21-2
               xfsprogs-4.11.0-1
 
Total Download Size:   213.38 MiB
Total Installed Size:  742.32 MiB
 
:: Proceed with installation? [Y/n]
:: Retrieving packages...
 linux-api-headers-4...   852.4 KiB  2.66M/s 00:00 [######################] 100%
 tzdata-2017b-1-any       235.8 KiB  11.5M/s 00:00 [######################] 100%
 iana-etc-20170512-1-any  360.9 KiB  2005K/s 00:00 [######################] 100%
 filesystem-2017.03-...    10.2 KiB  0.00B/s 00:00 [######################] 100%
 glibc-2.25-2-x86_64        8.2 MiB   834K/s 00:10 [######################] 100%
 gcc-libs-7.1.1-2-x86_64   17.4 MiB   483K/s 00:37 [######################] 100%
 ncurses-6.0+2017052...  1053.3 KiB   849K/s 00:01 [######################] 100%
 readline-7.0.003-1-...   294.7 KiB   932K/s 00:00 [######################] 100%
 bash-4.4.012-2-x86_64   1417.7 KiB   911K/s 00:02 [######################] 100%
 bzip2-1.0.6-6-x86_64      52.8 KiB  0.00B/s 00:00 [######################] 100%
 attr-2.4.47-2-x86_64      70.0 KiB  22.8M/s 00:00 [######################] 100%
 acl-2.2.52-3-x86_64      132.0 KiB   810K/s 00:00 [######################] 100%
 gmp-6.1.2-1-x86_64       408.5 KiB   659K/s 00:01 [######################] 100%
 libcap-2.25-1-x86_64      37.9 KiB  0.00B/s 00:00 [######################] 100%
 gdbm-1.13-1-x86_64       150.4 KiB   958K/s 00:00 [######################] 100%
 db-5.3.28-3-x86_64      1097.6 KiB   784K/s 00:01 [######################] 100%
 perl-5.26.0-1-x86_64      13.6 MiB   702K/s 00:20 [######################] 100%
 openssl-1.1.0.f-1-x...     2.9 MiB  1568K/s 00:02 [######################] 100%
 coreutils-8.27-1-x86_64    2.2 MiB  1103K/s 00:02 [######################] 100%
 libgpg-error-1.27-1...   150.4 KiB   964K/s 00:00 [######################] 100%
 libgcrypt-1.7.7-1-x...   466.0 KiB   991K/s 00:00 [######################] 100%
 lz4-1:1.7.5-1-x86_64      82.7 KiB  11.5M/s 00:00 [######################] 100%
 xz-5.2.3-1-x86_64        229.1 KiB   739K/s 00:00 [######################] 100%
 libsystemd-232-8-x86_64  358.1 KiB   578K/s 00:01 [######################] 100%
 expat-2.2.0-2-x86_64      76.3 KiB   486K/s 00:00 [######################] 100%
 dbus-1.10.18-1-x86_64    273.7 KiB   441K/s 00:01 [######################] 100%
 libmnl-1.0.4-1-x86_64     10.5 KiB  0.00B/s 00:00 [######################] 100%
 libnftnl-1.0.7-1-x86_64   59.9 KiB  14.6M/s 00:00 [######################] 100%
 libnl-3.2.29-2-x86_64    350.4 KiB   560K/s 00:01 [######################] 100%
 libusb-1.0.21-1-x86_64    54.0 KiB   344K/s 00:00 [######################] 100%
 libpcap-1.8.1-2-x86_64   216.9 KiB   466K/s 00:00 [######################] 100%
 iptables-1.6.1-1-x86_64  327.4 KiB   526K/s 00:01 [######################] 100%
 zlib-1:1.2.11-1-x86_64    86.4 KiB   550K/s 00:00 [######################] 100%
 cracklib-2.9.6-1-x86_64  249.9 KiB   540K/s 00:00 [######################] 100%
 libutil-linux-2.29....   317.5 KiB   515K/s 00:01 [######################] 100%
 e2fsprogs-1.43.4-1-...   959.5 KiB   413K/s 00:02 [######################] 100%
 libsasl-2.1.26-11-x...   137.3 KiB   294K/s 00:00 [######################] 100%
 libldap-2.4.44-5-x86_64  284.9 KiB   229K/s 00:01 [######################] 100%
 keyutils-1.5.10-1-x...    67.5 KiB   216K/s 00:00 [######################] 100%
 krb5-1.15.1-1-x86_64    1120.1 KiB   258K/s 00:04 [######################] 100%
 libtirpc-1.0.1-3-x86_64  174.0 KiB   279K/s 00:01 [######################] 100%
 pambase-20130928-1-any  1708.0   B  0.00B/s 00:00 [######################] 100%
 pam-1.3.0-1-x86_64       609.7 KiB   302K/s 00:02 [######################] 100%
 kbd-2.0.4-1-x86_64      1119.9 KiB   400K/s 00:03 [######################] 100%
 kmod-24-1-x86_64         109.8 KiB   350K/s 00:00 [######################] 100%
 hwids-20170328-1-any     340.2 KiB   307K/s 00:01 [######################] 100%
 libidn-1.33-1-x86_64     206.9 KiB   223K/s 00:01 [######################] 100%
 libelf-0.169-1-x86_64    368.8 KiB   215K/s 00:02 [######################] 100%
 libseccomp-2.3.2-1-...    66.3 KiB   214K/s 00:00 [######################] 100%
 shadow-4.4-3-x86_64     1060.6 KiB   185K/s 00:06 [######################] 100%
 util-linux-2.29.2-2...  1828.5 KiB   522K/s 00:04 [######################] 100%
 systemd-232-8-x86_64       3.7 MiB   625K/s 00:06 [######################] 100%
 device-mapper-2.02....   265.6 KiB   570K/s 00:00 [######################] 100%
 popt-1.16-8-x86_64        65.5 KiB  0.00B/s 00:00 [######################] 100%
 cryptsetup-1.7.5-1-...   240.8 KiB   767K/s 00:00 [######################] 100%
 dhcpcd-6.11.5-1-x86_64   156.8 KiB   980K/s 00:00 [######################] 100%
 diffutils-3.6-1-x86_64   282.8 KiB   904K/s 00:00 [######################] 100%
 file-5.31-1-x86_64       259.0 KiB   828K/s 00:00 [######################] 100%
 findutils-4.6.0-2-x...   420.7 KiB   679K/s 00:01 [######################] 100%
 mpfr-3.1.5.p2-1-x86_64   254.5 KiB   813K/s 00:00 [######################] 100%
 gawk-4.1.4-2-x86_64      987.1 KiB   707K/s 00:01 [######################] 100%
 pcre-8.40-1-x86_64       922.5 KiB   738K/s 00:01 [######################] 100%
 libffi-3.2.1-2-x86_64     31.5 KiB  0.00B/s 00:00 [######################] 100%
 glib2-2.52.2+9+g324...     2.3 MiB   261K/s 00:09 [######################] 100%
 libunistring-0.9.7-...   491.1 KiB   167K/s 00:03 [######################] 100%
 gettext-0.19.8.1-2-...  2026.9 KiB   543K/s 00:04 [######################] 100%
 grep-3.0-1-x86_64        202.7 KiB  1236K/s 00:00 [######################] 100%
 less-487-1-x86_64         93.6 KiB   596K/s 00:00 [######################] 100%
 gzip-1.8-2-x86_64         75.8 KiB  24.7M/s 00:00 [######################] 100%
 inetutils-1.9.4-5-x...   285.8 KiB   613K/s 00:00 [######################] 100%
 iproute2-4.11.0-1-x...   634.4 KiB   584K/s 00:01 [######################] 100%
 sysfsutils-2.1.0-9-...    30.2 KiB  0.00B/s 00:00 [######################] 100%
 iputils-20161105.1f...    71.2 KiB   462K/s 00:00 [######################] 100%
 jfsutils-1.1.15-4-x...   167.5 KiB   540K/s 00:00 [######################] 100%
 licenses-20140629-2-any   63.0 KiB  15.4M/s 00:00 [######################] 100%
 linux-firmware-2017...    41.9 MiB   788K/s 00:54 [######################] 100%
 mkinitcpio-busybox-...   157.5 KiB  11.0M/s 00:00 [######################] 100%
 libarchive-3.3.1-5-...   449.0 KiB  1448K/s 00:00 [######################] 100%
 mkinitcpio-23-1-any       38.8 KiB  0.00B/s 00:00 [######################] 100%
 linux-4.11.5-1-x86_64     61.3 MiB   396K/s 02:38 [######################] 100%
 logrotate-3.12.2-1-...    37.1 KiB  0.00B/s 00:00 [######################] 100%
 libaio-0.3.110-1-x86_64    4.4 KiB  0.00B/s 00:00 [######################] 100%
 thin-provisioning-t...   370.9 KiB   397K/s 00:01 [######################] 100%
 lvm2-2.02.171-1-x86_64  1281.1 KiB   376K/s 00:03 [######################] 100%
 groff-1.22.3-7-x86_64   1824.6 KiB   302K/s 00:06 [######################] 100%
 libpipeline-1.4.1-1...    36.2 KiB   230K/s 00:00 [######################] 100%
 man-db-2.7.6.1-2-x86_64  756.1 KiB   160K/s 00:05 [######################] 100%
 man-pages-4.11-1-any       5.7 MiB   242K/s 00:24 [######################] 100%
 mdadm-4.0-1-x86_64       394.4 KiB   196K/s 00:02 [######################] 100%
 nano-2.8.4-1-x86_64      418.4 KiB   180K/s 00:02 [######################] 100%
 openresolv-3.9.0-1-any    21.1 KiB  0.00B/s 00:00 [######################] 100%
 netctl-1.12-2-any         36.8 KiB   241K/s 00:00 [######################] 100%
 libtasn1-4.12-1-x86_64   117.4 KiB   122K/s 00:01 [######################] 100%
 p11-kit-0.23.7-1-x86_64  445.7 KiB   135K/s 00:03 [######################] 100%
 ca-certificates-uti...     7.5 KiB  0.00B/s 00:00 [######################] 100%
 ca-certificates-moz...   402.0 KiB   137K/s 00:03 [######################] 100%
 ca-certificates-cac...     7.1 KiB   307K/s 00:00 [######################] 100%
 ca-certificates-201...  1904.0   B  0.00B/s 00:00 [######################] 100%
 libssh2-1.8.0-2-x86_64   180.2 KiB   192K/s 00:01 [######################] 100%
 icu-59.1-1-x86_64          8.1 MiB   278K/s 00:30 [######################] 100%
 libpsl-0.17.0-2-x86_64    49.4 KiB  0.00B/s 00:00 [######################] 100%
 libnghttp2-1.23.1-1...    84.2 KiB   547K/s 00:00 [######################] 100%
 curl-7.54.1-1-x86_64     904.2 KiB   521K/s 00:02 [######################] 100%
 npth-1.5-1-x86_64         12.8 KiB  0.00B/s 00:00 [######################] 100%
 libksba-1.3.4-2-x86_64   114.6 KiB   730K/s 00:00 [######################] 100%
 libassuan-2.4.3-1-x...    84.6 KiB  20.7M/s 00:00 [######################] 100%
 libsecret-0.18.5+14...   193.3 KiB   624K/s 00:00 [######################] 100%
 pinentry-1.0.0-1-x86_64   98.1 KiB   625K/s 00:00 [######################] 100%
 nettle-3.3-1-x86_64      321.7 KiB   689K/s 00:00 [######################] 100%
 gnutls-3.5.13-1-x86_64     2.3 MiB  1150K/s 00:02 [######################] 100%
 sqlite-3.19.3-1-x86_64  1259.3 KiB  1145K/s 00:01 [######################] 100%
 gnupg-2.1.21-3-x86_64   2020.5 KiB   802K/s 00:03 [######################] 100%
 gpgme-1.9.0-3-x86_64     361.9 KiB  1142K/s 00:00 [######################] 100%
 pacman-mirrorlist-2...     5.2 KiB  0.00B/s 00:00 [######################] 100%
 archlinux-keyring-2...   638.7 KiB  1009K/s 00:01 [######################] 100%
 pacman-5.0.2-1-x86_64    735.7 KiB   785K/s 00:01 [######################] 100%
 pciutils-3.5.4-1-x86_64   82.4 KiB  26.8M/s 00:00 [######################] 100%
 pcmciautils-018-7-x...    19.7 KiB  0.00B/s 00:00 [######################] 100%
 procps-ng-3.3.12-1-...   299.5 KiB   936K/s 00:00 [######################] 100%
 psmisc-22.21-3-x86_64    101.3 KiB  14.1M/s 00:00 [######################] 100%
 reiserfsprogs-3.6.2...   201.0 KiB  1256K/s 00:00 [######################] 100%
 s-nail-14.8.16-2-x86_64  310.7 KiB   983K/s 00:00 [######################] 100%
 sed-4.4-1-x86_64         174.0 KiB  1108K/s 00:00 [######################] 100%
 systemd-sysvcompat-...     7.3 KiB  0.00B/s 00:00 [######################] 100%
 tar-1.29-2-x86_64        673.9 KiB   864K/s 00:01 [######################] 100%
 texinfo-6.3-2-x86_64    1170.3 KiB   834K/s 00:01 [######################] 100%
 usbutils-008-1-x86_64     61.3 KiB  0.00B/s 00:00 [######################] 100%
 vi-1:070224-2-x86_64     148.0 KiB   943K/s 00:00 [######################] 100%
 which-2.21-2-x86_64       15.5 KiB  0.00B/s 00:00 [######################] 100%
 xfsprogs-4.11.0-1-x...   813.5 KiB   878K/s 00:01 [######################] 100%
 lzo-2.10-1-x86_64         82.1 KiB  26.7M/s 00:00 [######################] 100%
 btrfs-progs-4.11-1-...   597.3 KiB   766K/s 00:01 [######################] 100%
 dosfstools-4.1-1-x86_64   56.0 KiB  13.7M/s 00:00 [######################] 100%
 bash-completion-2.5...   171.9 KiB  1048K/s 00:00 [######################] 100%
(134/134) checking keys in keyring                 [######################] 100%
(134/134) checking package integrity               [######################] 100%
(134/134) loading package files                    [######################] 100%
(134/134) checking for file conflicts              [######################] 100%
(134/134) checking available disk space            [######################] 100%
:: Processing package changes...
(  1/134) installing linux-api-headers             [######################] 100%
(  2/134) installing tzdata                        [######################] 100%
(  3/134) installing iana-etc                      [######################] 100%
(  4/134) installing filesystem                    [######################] 100%
(  5/134) installing glibc                         [######################] 100%
(  6/134) installing gcc-libs                      [######################] 100%
(  7/134) installing ncurses                       [######################] 100%
(  8/134) installing readline                      [######################] 100%
(  9/134) installing bash                          [######################] 100%
Optional dependencies for bash
    bash-completion: for tab completion [pending]
( 10/134) installing bzip2                         [######################] 100%
( 11/134) installing attr                          [######################] 100%
( 12/134) installing acl                           [######################] 100%
( 13/134) installing gmp                           [######################] 100%
( 14/134) installing libcap                        [######################] 100%
( 15/134) installing gdbm                          [######################] 100%
( 16/134) installing db                            [######################] 100%
( 17/134) installing perl                          [######################] 100%
( 18/134) installing openssl                       [######################] 100%
Optional dependencies for openssl
    ca-certificates [pending]
( 19/134) installing coreutils                     [######################] 100%
( 20/134) installing libgpg-error                  [######################] 100%
( 21/134) installing libgcrypt                     [######################] 100%
( 22/134) installing lz4                           [######################] 100%
( 23/134) installing xz                            [######################] 100%
( 24/134) installing libsystemd                    [######################] 100%
( 25/134) installing expat                         [######################] 100%
( 26/134) installing dbus                          [######################] 100%
( 27/134) installing libmnl                        [######################] 100%
( 28/134) installing libnftnl                      [######################] 100%
( 29/134) installing libnl                         [######################] 100%
( 30/134) installing libusb                        [######################] 100%
( 31/134) installing libpcap                       [######################] 100%
( 32/134) installing iptables                      [######################] 100%
( 33/134) installing zlib                          [######################] 100%
( 34/134) installing cracklib                      [######################] 100%
( 35/134) installing libutil-linux                 [######################] 100%
( 36/134) installing e2fsprogs                     [######################] 100%
( 37/134) installing libsasl                       [######################] 100%
( 38/134) installing libldap                       [######################] 100%
( 39/134) installing keyutils                      [######################] 100%
( 40/134) installing krb5                          [######################] 100%
( 41/134) installing libtirpc                      [######################] 100%
( 42/134) installing pambase                       [######################] 100%
( 43/134) installing pam                           [######################] 100%
( 44/134) installing kbd                           [######################] 100%
( 45/134) installing kmod                          [######################] 100%
( 46/134) installing hwids                         [######################] 100%
( 47/134) installing libidn                        [######################] 100%
( 48/134) installing libelf                        [######################] 100%
( 49/134) installing libseccomp                    [######################] 100%
( 50/134) installing shadow                        [######################] 100%
( 51/134) installing util-linux                    [######################] 100%
Optional dependencies for util-linux
    python: python bindings to libmount
( 52/134) installing systemd                       [######################] 100%
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
( 53/134) installing device-mapper                 [######################] 100%
( 54/134) installing popt                          [######################] 100%
( 55/134) installing cryptsetup                    [######################] 100%
( 56/134) installing dhcpcd                        [######################] 100%
Optional dependencies for dhcpcd
    openresolv: resolvconf support [pending]
( 57/134) installing diffutils                     [######################] 100%
( 58/134) installing file                          [######################] 100%
( 59/134) installing findutils                     [######################] 100%
( 60/134) installing mpfr                          [######################] 100%
( 61/134) installing gawk                          [######################] 100%
( 62/134) installing pcre                          [######################] 100%
( 63/134) installing libffi                        [######################] 100%
( 64/134) installing glib2                         [######################] 100%
Optional dependencies for glib2
    python: for gdbus-codegen and gtester-report
    libelf: gresource inspection tool [installed]
( 65/134) installing libunistring                  [######################] 100%
( 66/134) installing gettext                       [######################] 100%
Optional dependencies for gettext
    git: for autopoint infrastructure updates
( 67/134) installing grep                          [######################] 100%
( 68/134) installing less                          [######################] 100%
( 69/134) installing gzip                          [######################] 100%
( 70/134) installing inetutils                     [######################] 100%
( 71/134) installing iproute2                      [######################] 100%
Optional dependencies for iproute2
    linux-atm: ATM support
( 72/134) installing sysfsutils                    [######################] 100%
( 73/134) installing iputils                       [######################] 100%
Optional dependencies for iputils
    xinetd: for tftpd
( 74/134) installing jfsutils                      [######################] 100%
( 75/134) installing licenses                      [######################] 100%
( 76/134) installing linux-firmware                [######################] 100%
( 77/134) installing mkinitcpio-busybox            [######################] 100%
( 78/134) installing libarchive                    [######################] 100%
( 79/134) installing mkinitcpio                    [######################] 100%
Optional dependencies for mkinitcpio
    xz: Use lzma or xz compression for the initramfs image [installed]
    bzip2: Use bzip2 compression for the initramfs image [installed]
    lzop: Use lzo compression for the initramfs image
    lz4: Use lz4 compression for the initramfs image [installed]
    mkinitcpio-nfs-utils: Support for root filesystem on NFS
( 80/134) installing linux                         [######################] 100%
>>> Updating module dependencies. Please wait ...
Optional dependencies for linux
    crda: to set the correct wireless channels of your country
( 81/134) installing logrotate                     [######################] 100%
( 82/134) installing libaio                        [######################] 100%
( 83/134) installing thin-provisioning-tools       [######################] 100%
( 84/134) installing lvm2                          [######################] 100%
( 85/134) installing groff                         [######################] 100%
Optional dependencies for groff
    netpbm: for use together with man -H command interaction in browsers
    psutils: for use together with man -H command interaction in browsers
    libxaw: for gxditview
( 86/134) installing libpipeline                   [######################] 100%
( 87/134) installing man-db                        [######################] 100%
Optional dependencies for man-db
    gzip [installed]
( 88/134) installing man-pages                     [######################] 100%
( 89/134) installing mdadm                         [######################] 100%
( 90/134) installing nano                          [######################] 100%
( 91/134) installing openresolv                    [######################] 100%
( 92/134) installing netctl                        [######################] 100%
Optional dependencies for netctl
    dialog: for the menu based wifi assistant
    dhclient: for DHCP support (or dhcpcd)
    dhcpcd: for DHCP support (or dhclient) [installed]
    wpa_supplicant: for wireless networking support
    ifplugd: for automatic wired connections through netctl-ifplugd
    wpa_actiond: for automatic wireless connections through netctl-auto
    ppp: for PPP connections
    openvswitch: for Open vSwitch connections
( 93/134) installing libtasn1                      [######################] 100%
( 94/134) installing p11-kit                       [######################] 100%
( 95/134) installing ca-certificates-utils         [######################] 100%
( 96/134) installing ca-certificates-mozilla       [######################] 100%
( 97/134) installing ca-certificates-cacert        [######################] 100%
( 98/134) installing ca-certificates               [######################] 100%
( 99/134) installing libssh2                       [######################] 100%
(100/134) installing icu                           [######################] 100%
(101/134) installing libpsl                        [######################] 100%
(102/134) installing libnghttp2                    [######################] 100%
(103/134) installing curl                          [######################] 100%
(104/134) installing npth                          [######################] 100%
(105/134) installing libksba                       [######################] 100%
(106/134) installing libassuan                     [######################] 100%
(107/134) installing libsecret                     [######################] 100%
Optional dependencies for libsecret
    gnome-keyring: key storage service (or use any other service implementing
    org.freedesktop.secrets)
(108/134) installing pinentry                      [######################] 100%
Optional dependencies for pinentry
    gtk2: gtk2 backend
    qt5-base: qt backend
    gcr: gnome3 backend
(109/134) installing nettle                        [######################] 100%
(110/134) installing gnutls                        [######################] 100%
Optional dependencies for gnutls
    guile: for use with Guile bindings
(111/134) installing sqlite                        [######################] 100%
(112/134) installing gnupg                         [######################] 100%
Optional dependencies for gnupg
    libldap: gpg2keys_ldap [installed]
    libusb-compat: scdaemon
(113/134) installing gpgme                         [######################] 100%
(114/134) installing pacman-mirrorlist             [######################] 100%
(115/134) installing archlinux-keyring             [######################] 100%
(116/134) installing pacman                        [######################] 100%
(117/134) installing pciutils                      [######################] 100%
(118/134) installing pcmciautils                   [######################] 100%
(119/134) installing procps-ng                     [######################] 100%
(120/134) installing psmisc                        [######################] 100%
(121/134) installing reiserfsprogs                 [######################] 100%
(122/134) installing s-nail                        [######################] 100%
Optional dependencies for s-nail
    smtp-forwarder: for sending mail
(123/134) installing sed                           [######################] 100%
(124/134) installing systemd-sysvcompat            [######################] 100%
(125/134) installing tar                           [######################] 100%
(126/134) installing texinfo                       [######################] 100%
(127/134) installing usbutils                      [######################] 100%
Optional dependencies for usbutils
    python2: for lsusb.py usage
    coreutils: for lsusb.py usage [installed]
(128/134) installing vi                            [######################] 100%
Optional dependencies for vi
    s-nail: used by the preserve command for notification [installed]
(129/134) installing which                         [######################] 100%
(130/134) installing xfsprogs                      [######################] 100%
(131/134) installing lzo                           [######################] 100%
(132/134) installing btrfs-progs                   [######################] 100%
(133/134) installing dosfstools                    [######################] 100%
(134/134) installing bash-completion               [######################] 100%
:: Running post-transaction hooks...
(1/7) Updating linux initcpios
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.5-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> Image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: 4.11.5-1-ARCH
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
(2/7) Updating udev hardware database...
(3/7) Updating system user accounts...
(4/7) Creating temporary files...
(5/7) Arming ConditionNeedsUpdate...
(6/7) Updating the info directory file...
(7/7) Rebuilding certificate stores...
pacstrap /mnt base btrfs-progs dosfstools bash-completion  35.58s user 11.38s system 9% cpu 8:39.55 total
```

### Generate FSTAB ###

```
root@archiso ~ # genfstab -Lp /mnt >> /mnt/etc/fstab
```

### Verify FSTAB ###

```
root@archiso ~ # cat /mnt/etc/fstab
#
# /etc/fstab: static file system information
#
# <file system> <dir>   <type>  <options>       <dump>  <pass>
# /dev/sda3 UUID=f42e42e1-2b97-4c87-b0ae-7b9d1096c676
LABEL=ROOT              /               btrfs           rw,noatime,compress=lzo,space_cache,subvolid=257,subvol=/@,subvol=@     0 0
 
# /dev/sda3 UUID=f42e42e1-2b97-4c87-b0ae-7b9d1096c676
LABEL=ROOT              /home           btrfs           rw,noatime,compress=lzo,space_cache,subvolid=258,subvol=/@home,subvol=@home     0 0
 
# /dev/sda3 UUID=f42e42e1-2b97-4c87-b0ae-7b9d1096c676
LABEL=ROOT              /.snapshots     btrfs           rw,noatime,compress=lzo,space_cache,subvolid=259,subvol=/@snapshots,subvol=@snapshots   0 0
 
# /dev/sda1 UUID=B5F4-518A
LABEL=EFI               /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro   0 2
 
# /dev/sda2 UUID=9689b746-3b09-4b3f-a871-497cb7d43651
LABEL=SWAP              none            swap            defaults        0 0
```

### Chroot Into The Filesystem and Configure Some Basics ###

```
root@archiso ~ # arch-chroot /mnt/
[root@archiso /]# echo hq > /etc/hostname
[root@archiso /]# echo LANG=en_US.UTF-8 > /etc/locale.conf
[root@archiso /]# echo LANGUAGE=en_US >> /etc/locale.conf
[root@archiso /]# echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
[root@archiso /]# locale-gen
Generating locales...
  en_US.UTF-8... done
Generation complete.
```

### pacman.conf ###

```
[root@archiso /]# nano -w /etc/pacman.conf
```

#### Fun ####

Add to [options] and you will see Yellow Pacman eating dots instead of # for the progressbar.

```
[options]
Color
ILoveCandy
```

#### Uncomment multilibs (If you require 32 bit libraries) ####

```
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

to

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

#### Add the AUR ####

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

### Update Pacman ###

```
[root@archiso /]# pacman -Sy
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
 multilib                 176.2 KiB   378K/s 00:00 [----------------------] 100%
 archlinuxfr               15.2 KiB   112K/s 00:00 [----------------------] 100%
```

### Edit Mkinitcpio For BTRFS Changes ###

```
[root@archiso /]# nano -w /etc/mkinitcpio.conf
# vim:set ft=sh
# MODULES
# The following modules are loaded before any boot hooks are
# run.  Advanced users may wish to specify all system modules
# in this array.  For instance:
#     MODULES="piix ide_disk reiserfs"
MODULES=""

# BINARIES
# This setting includes any additional binaries a given user may
# wish into the CPIO image.  This is run last, so it may be used to
# override the actual binaries included by a given hook
# BINARIES are dependency parsed, so you may safely ignore libraries
BINARIES=""

# FILES
# This setting is similar to BINARIES above, however, files are added
# as-is and are not parsed in any way.  This is useful for config files.
FILES=""

# HOOKS
# This is the most important setting in this file.  The HOOKS control the
# modules and scripts added to the image, and what happens at boot time.
# Order is important, and it is recommended that you do not change the
# order in which HOOKS are added.  Run 'mkinitcpio -H <hook name>' for
# help on a given hook.
# 'base' is _required_ unless you know precisely what you are doing.
# 'udev' is _required_ in order to automatically load modules
# 'filesystems' is _required_ unless you specify your fs modules in MODULES
# Examples:
##   This setup specifies all modules in the MODULES setting above.
##   No raid, lvm2, or encrypted root is needed.
#    HOOKS="base"
#
##   This setup will autodetect all modules for your system and should
##   work as a sane default
#    HOOKS="base udev autodetect block filesystems"
#
##   This setup will generate a 'full' image which supports most systems.
##   No autodetection is done.
#    HOOKS="base udev block filesystems"
#
##   This setup assembles a pata mdadm array with an encrypted root FS.
##   Note: See 'mkinitcpio -H mdadm' for more information on raid devices.
#    HOOKS="base udev block mdadm encrypt filesystems"
#
##   This setup loads an lvm2 volume group on a usb device.
#    HOOKS="base udev block lvm2 filesystems"
#
##   NOTE: If you have /usr on a separate partition, you MUST include the
#    usr, fsck and shutdown hooks.
HOOKS="base udev autodetect modconf block btrfs filesystems keyboard"

# COMPRESSION
# Use this to compress the initramfs image. By default, gzip compression
# is used. Use 'cat' to create an uncompressed image.
#COMPRESSION="gzip"
#COMPRESSION="bzip2"
#COMPRESSION="lzma"
#COMPRESSION="xz"
#COMPRESSION="lzop"
#COMPRESSION="lz4"

# COMPRESSION_OPTIONS
# Additional options for the compressor
#COMPRESSION_OPTIONS=""
```

### Regenerate initramfs ###

```
[root@archiso /]# mkinitcpio -p linux
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.5-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [btrfs]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> Image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: 4.11.5-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
  -> Running build hook: [btrfs]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux-fallback.img
==> Image generation successful
```

### Set root password ###

```
[root@archiso /]# passwd
New password: Plebmast0r
Retype new password: Plebmast0r
passwd: password updated successfully
```

### Install systemd-boot (Used to be Gummiboot) ###

Install to mounted EFI /boot folder.

```
[root@archiso /]# bootctl --path=/boot install
Created "boot/EFI".
Created "boot/EFI/systemd".
Created "boot/EFI/BOOT".
Created "boot/loader".
Created "boot/loader/entries".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "boot/EFI/systemd/systemd-bootx64.efi".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "boot/EFI/BOOT/BOOTX64.EFI".
Created EFI boot entry "Linux Boot Manager".
```

### Modify boot loader and entries ###

Verify bootloader files exist.

```
[root@archiso /]# cd /boot/loader
[root@archiso loader]# ls
entries  loader.conf
```

### Edit loader.conf ###

```
[root@archiso loader]# nano loader.conf
default arch
timeout 4
editor  0
```

### Edit arch.conf ###

#### btrfs subvolume root installations ####

If booting a btrfs subvolume as root, amend the options line with ```rootflags=subvol=<root subvolume>```. 
In the example below, root has been mounted as a btrfs subvolume called 'ROOT' (e.g.  ```mount -o subvol=ROOT /dev/sdxY /mnt``` ):

```
[root@archiso loader]# cd entries/
[root@archiso entries]# nano -w arch.conf
title    Arch Linux BTRFS
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=PARTLABEL=ROOT rw rootflags=subvol=@
```

### Install efibootmgr ###

```
[root@archiso entries]# pacman -S efibootmgr
resolving dependencies...
looking for conflicting packages...
 
Packages (2) efivar-31-1  efibootmgr-15-1
 
Total Download Size:   0.09 MiB
Total Installed Size:  0.29 MiB
 
:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 efivar-31-1-x86_64        75.4 KiB   243K/s 00:00 [######################] 100%
 efibootmgr-15-1-x86_64    20.2 KiB  0.00B/s 00:00 [######################] 100%
(2/2) checking keys in keyring                     [######################] 100%
(2/2) checking package integrity                   [######################] 100%
(2/2) loading package files                        [######################] 100%
(2/2) checking for file conflicts                  [######################] 100%
(2/2) checking available disk space                [######################] 100%
:: Processing package changes...
(1/2) installing efivar                            [######################] 100%
(2/2) installing efibootmgr                        [######################] 100%
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

### Check out the EFI boot menu ###

Check to see if we can see the "Linux Boot Manager" now in the EFI boot menu.

```
[root@archiso entries]# efibootmgr -v
BootCurrent: 0008
Timeout: 1 seconds
BootOrder: 0000,0002,0003,0004,0005,0008
Boot0000* Linux Boot Manager    HD(1,GPT,94459880-7fce-4d79-bcd0-e99ee66b0ca5,0x800,0x113000)/File(\EFI\systemd\systemd-bootx64.efi)
Boot0002* Internal HDD (IRRT)   BBS(HD,,0x0)WDC WD3200LPVX-22V0TT0          .
Boot0003* USB Storage Device    BBS(USB,,0x0)USB Storage Device.
Boot0004* CD/DVD/CD-RW Drive    BBS(CDROM,,0x0)P1: HL-DT-ST DVD+/-RW GU60N   .
Boot0005* Onboard NIC   BBS(Network,,0x0)IBA GE Slot 00C8 v1533.
Boot0008  UEFI: INT13(,0x81)    PciRoot(0x0)/Pci(0x19,0x0)/VenHw(aa7ba38a-dabf-40c3-8d18-b55b39609ef7,8101000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)/HD(1,MBR,0x22c91b15,0x800,0x78a000)
```

### Exit arch-chroot and unmount everything ###

```
[root@archiso entries]# exit
exit
arch-chroot /mnt/  10.54s user 2.72s system 1% cpu 16:15.60 total
root@archiso ~ # umount -R /mnt/
```

### Remove install media, Reboot & hope for the best ###

```
root@archiso ~ # reboot
``` 

If everything goes well you should now be at a linux console waiting for you to login with your root user account and password we set before with passwd.

Continue to [Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)
