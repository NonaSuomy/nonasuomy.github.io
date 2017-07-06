---
layout: post
title: Arch Linux Infrastructure - Automation Server - Part 5 - Everybody Get's Sensored!
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutIoT.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router ](../Infrastructure-Part-4)

[Part 05 - VoIP Server ](../Infrastructure-Part-5)

Part 06 - Automation Server - You Are Here!

[Part 07 - Underconstruction](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Automation Server Setup #

## Start i3-WM ##

```
startx
```

### Open Terminal (urxvt) ###

Alt + Enter

### Change Directory To Hypervisor Media Installs ###

```
cd /var/lib/libvirt/images/iso
```

### Download Install Media ###

### Find the latest version ### 

#### Arch Linux ####

**Note:** *We're doing a UEFI install lastest versions of Arch install media support this.*

Grab whatever the latest ISO is: https://www.archlinux.org/download/

```
sudo wget http://mirror.rackspace.com/archlinux/iso/2017.07.01/archlinux-2017.07.01-x86_64.iso

### Verify Interfaces Have Been Created ###

Check that we have the interfaces brv300 and eno1.300 from the previous step setup (Automation VLAN). 

```
ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
3: brv500: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 9a:de:fd:00:4c:9c brd ff:ff:ff:ff:ff:ff
4: brv450: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether b2:40:b2:19:5d:b2 brd ff:ff:ff:ff:ff:ff
5: brv400: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 82:f9:79:52:52:f5 brd ff:ff:ff:ff:ff:ff
6: brv300: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ce:0c:c4:f6:9b:41 brd ff:ff:ff:ff:ff:ff
7: brv200: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 56:9c:3a:04:c4:f8 brd ff:ff:ff:ff:ff:ff
8: brv100: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ae:df:f9:a5:92:e9 brd ff:ff:ff:ff:ff:ff
9: eno1.200@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv200 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
10: eno1.300@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv300 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
11: eno1.400@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv400 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
12: eno1.500@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv500 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
13: eno1.450@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv450 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
14: eno1.100@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv100 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
```

### Start virt-manager ###

```
sudo virt-manager
```

virt-manager should now be on screen...

You should be connected to your hypervisor.

Click File => New Virtual Machine

```
New VM
Create a new virtual machine
Step 1 of 5

Connection: QEMU/KVM

Choose how you would like to install the operating system
* Local install media (ISO image or CDROM)
* Network Install (HTTP,FTP, or NFS)
* Network Boot (PXE)
* Import existing disk image
```

Choose local install media and click Forward

```
New VM
Create a new virtual machine
Step 2 of 5

Locate your install media
* Use CDROM or DVD
  No device present
* Use ISO image:
  ComboBox V Browse...
Automatically detect operating system based on install media
OS type: -
Version: -
```

Click Browse

You should see the iso storage pool on the left, click it.

Then click your Arch Linux ISO.

Then click "Choose Volume".

Leave Automatically detect checked and click Forward.

```
New VM
Create a new virtual machine
Step 3 of 5

Choose Memory and CPU settings
Memory (RAM): 1024 - + MiB
CPUs: 1 - +
Up to 4 available
```

Click Forward

```
New VM
Create a new virtual machine
Step 4 of 5

Enable storage for this virtual machine
* Create a disk image for the virtual machine
  40.0 - + GiB
  1000 GiB available in the default location
* Select or create custom storage
  Manage...
```

Click Forward

```
New VM
Create a new virtual machine
Step 5 of 5

Ready to begin the installation
Name: AutomationServer
OS: Generic
Install: Local CDROM/ISO
Memory: 1024 MiB
CPUs: 1
Storage: 40.0 GiB /var/lib/libvirt/images/AutomationServer.qcow2
X Customize configuration before install

Network selection
* Specify shared device name
  Bridge name: brv300
```

Click the checkmark on "Customize configuration before install".

Click the "Network selection" drop down arrow.

Click the Dropdown Box and select "Specify shared device name"

Bridge name: brv300

Click Finish

Now you should see the full virtual machine settings window.

```
AutomationServer on QEMU/KVM
Begin Installation    Cancel Installaion

Overview
CPUs
Memory
Boot Options
IDE Disk 1
IDE CDROM 1
NIC :fe:ed:30
Mouse
Display Spice
Sound: ich6
Console
Channel spice
Video QXL
Controller USB
USB Redirector 1
USB Redirector 2

Add Hardware

Basic Details
   Name: AutomationServer
   UUID: xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   Status: Shutoff (Shut Down)
   Title:
   Description:
Hypervisor Details
   Hypervisor: KVM
   Achitecture: x86_64
   Emulator: /usr/sbin/qemu-system-x86_64
   Firmware: UEFI x86_64: /usr/share/ovmf/ovmf_code_x64.bin
   Chipset: i440FX
   
Cancel Apply
```

Click Firmware change BIOS to UEFI x86_64: /usr/share/ovmf/ovmf_code_x64.bin

**Note:** *You only get one chance to change this Firmware field, it will go readonly after you Begin the Installaion.*

Click on CPUs at the left.

```
CPUs
  Logical host CPUs: 4
  Current allocation: 1 - +
  Maximum allocation: 1 - +
Configuration
  X Copy host CPU configuration
v Topology
  Manually set CPU topology
  Sockets: 1 - +
  Cores: 1 - +
  Threads: 1 - +
```

Click the Copy host CPU configuration check box.

Click on Boot Options

```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE CDROM 1
  X IDE Disk 1
  NIC :fe:ed:50
  ...
V Direct kernel boot
  Enable direct kernel boot
  Kernel path:
  Initrd path:
  Kernel args:
```

Click on IDE CDROM 1

```
Virual Disk
  Sorce path: - Connect
  Device type: IDE CDROM 1
  Storage size: -
  Readonly: X
  Shareable:
V Advanced options
  Disk bus: IDE
  Serial number:
  Storage format: raw
V Performance options
  Cache mode: Hypervisor default
  IO mode: Hypervisor default
```

Click on Connect

```
Choose Media
Choose Source Device or File
  X ISO Image Location
    Location: Browse
  CD-ROM or DVD
    Device Media: No device present
```

Click on Browse

```
Choose Storage Volume

default
Filesystem Directory

iso
Filesystem Directory 

Size: 145.24 GiB Free / 140.32 GiB in Use
Location: /var/lib/libvirt/images/iso

Volumes + @ X

Volumes                                   Size         Format
archlinux-2017.07.01-x86_64.iso           510.00 MiB   iso
IncrediblePBX13.2.iso                     849.00 MiB   iso
OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso   858.43 MiB   iso
pfSense-CE-2.3.4-RELEASE-amd64.iso        626.79 MiB   iso
```

Click on Arch Linux iso then click Choose Volume

Click OK

```
Virual Disk
  Sorce path: /var/lib/libvirt/images/iso/archlinux-2017.07.01-x86_64.iso  Disconnect
  Device type: IDE CDROM 1
  Storage size: 510.00 MiB
  Readonly: X
  Shareable:
```

Click Boot Options

```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE CDROM 1
  X IDE DISK 1
     NIC :fe:ed:30
```     

Make sure the IDE CDROM 1 is at the top of the Boot device order like above.

Click Apply.

Click on NIC :xx:xx:50

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv300
Device model: virtio
MAC address: X 42:de:ad:fe:ed:30
```

Click Apply.

We just setup this virtual machine interface so that is uses the Automation VLAN bridge setup prior.

Click on Display Spice

```
Spice Server
  Type: Spice server
  Listen type: Address
  Address: Hypervisor default
  Port: X Auto
  Password: 
  Keymap:
```

Change to VNC server

```
VNC Server
  Type: VNC server
  Listen type: Address
  Address: All interfaces
  Port: X Auto
  Password: 
  Keymap:
```

Click Apply.

Finally click "Begin Installation" at the top left.

After the VM boots ...

Push Enter on Arch Linux archiso x86_64 UEFI CD

We're going to use UEFI make sure your hardware bios is setup for UEFI (Ideally you wouldn't see the entry above if you didn't boot with UEFI).

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
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:fe:ed:30 brd ff:ff:ff:ff:ff:ff
```

On this hardware it is called ens3

root@archiso ~ # ip addr show ens3

We should see something like inet 10.0.3.50/24 if you setup the virtual router properly it should be dishing out DHCP addresses.

Testing connection

```
root@archiso ~ # ping 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=38 time=73.9 ms
...
root@archiso ~ # ping google.ca
64 bytes from ord38s04-in-f14.1e100.net (172.217.0.14): icmp_seq=1 ttl=47 time=71.0 ms
...
```

If it doesn't work you possible forgot to add 

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

root@archiso ~ # ip addr show ens3
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 42:de:ad:fe:ed:30 brd ff:ff:ff:ff:ff:ff
    inet 10.0.3.50/24 brd 10.13.37.255 scope global ens3
       valid_lft forever preferred_lft forever
```

Now you should be able to remote ```ssh root@10.0.3.50``` from another machine on the network with whatever password you set example 1337pleb to finish config.

## Destroy Contents Of Drive & Create Partitions ##

```
root@archiso ~ # sgdisk --zap-all /dev/sda

root@archiso ~ # sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+4GiB  --typecode=2:8200 --change-name=2:SWAP \
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
loop0    7:0    0 398.3M  1 loop /run/archiso/sfs/airootfs 
sda      8:0    0    40G  0 disk                           
├─sda1   8:1    0   550M  0 part                           EFI
├─sda2   8:2    0     4G  0 part                           SWAP
└─sda3   8:3    0  35.5G  0 part                           ROOT
sr0     11:0    1   510M  0 rom  /run/archiso/bootmnt      
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

Performing full device TRIM /dev/sda3 (35.46GiB) ...
Label:              ROOT
UUID:               117c3f13-d9a0-41ab-889e-6c4208e43489
Node size:          16384
Sector size:        4096
Filesystem size:    35.46GiB
Block group profiles:  X Start virtual machine on host boot up
359
Boot device order
360
  X Enable boot menu
361
  X IDE CDROM 1
362
  X IDE DISK 1
363
     NIC :fe:ed:30
364
```     
365
​
366
Make sure the IDE CDROM 1 is at the top of the Boot device order like above.
367
​
368
Click Apply.
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    35.46GiB  /dev/sda3
```

### Format SWAP Partition & Turn It On ###

```
root@archiso ~ # mkswap -L SWAP /dev/sda2                                  :(
Setting up swapspace version 1, size = 4 GiB (4294963200 bytes)
LABEL=SWAP, UUID=542a0b22-3757-45bd-83e4-eb9977d4bef4
root@archiso ~ # swapon /dev/sda2
root@archiso ~ # free -h
                     total        used        free      shared  buff/cache   available
Mem:          996M         59M        621M        120M        315M        681M
Swap:          4.0G          0B        4.0G

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
dev            devtmpfs  478M     0  478M   0% /dev
run            tmpfs     499M  108M  391M  22% /run
/dev/sr0       iso9660   510M  510M     0 100% /run/archiso/bootmnt
cowspace       tmpfs     256M   12M  245M   5% /run/archiso/cowspace
/dev/loop0     squashfs  399M  399M     0 100% /run/archiso/sfs/airootfs
airootfs       overlay   256M   12M  245M   5% /
tmpfs          tmpfs     499M     0  499M   0% /dev/shm  X Start virtual machine on host boot up
359
Boot device order
360
  X Enable boot menu
361
  X IDE CDROM 1
362
  X IDE DISK 1
363
     NIC :fe:ed:30
364
```     
365
​
366
Make sure the IDE CDROM 1 is at the top of the Boot device order like above.
367
​
368
Click Apply.
tmpfs          tmpfs     499M     0  499M   0% /sys/fs/cgroup
tmpfs          tmpfs     499M     0  499M   0% /tmp
tmpfs          tmpfs     499M  1.5M  497M   1% /etc/pacman.d/gnupg
tmpfs          tmpfs     100M     0  100M   0% /run/user/0
/dev/sda3      btrfs      36G   17M   34G   1% /mnt
/dev/sda3      btrfs      36G   17M   34G   1% /mnt/home
/dev/sda3      btrfs      36G   17M   34G   1% /mnt/.snapshots
/dev/sda1      vfat      549M  4.0K  549M   1% /mnt/boot
```

### Pacstrap All The Things To /mnt ###

Installing: base base-devel btrfs-progs dosfstools bash-completion

```
root@archiso ~ # pacstrap /mnt base base-devel btrfs-progs dosfstools bash-completion efibootmgr
==> Creating install root at /mnt
==> Installing packages to /mnt
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community                      3.9 MiB  2.36M/s 00:02 [############################] 100%
:: There are 50 members in group base:
:: Repository core
   1) bash  2) bzip2  3) coreutils  4) cryptsetup  5) device-mapper  6) dhcpcd
   7) diffutils  8) e2fsprogs  9) file  10) filesystem  11) findutils  12) gawk
   13) gcc-libs  14) gettext  15) glibc  16) grep  17) gzip  18) inetutils  19) iproute2
   20) iputils  21) jfsutils  22) less  23) licenses  24) linux  25) logrotate  26) lvm2
   27) man-db  28) man-pages  29) mdadm  30) nano  31) netctl  32) pacman  33) pciutils
   34) pcmciautils  35) perl  36) procps-ng  37) psmisc  38) reiserfsprogs  39) s-nail
   40) sed  41) shadow  42) sysfsutils  43) systemd-sysvcompat  44) tar  45) texinfo
   46) usbutils  47) util-linux  48) vi  49) which  50) xfsprogs  X Start virtual machine on host boot up
359
Boot device order
360
  X Enable boot menu
361
  X IDE CDROM 1
362
  X IDE DISK 1
363
     NIC :fe:ed:30
364
```     
365
​
366
Make sure the IDE CDROM 1 is at the top of the Boot device order like above.
367
​
368
Click Apply.

Enter a selection (default=all): 
:: There are 25 members in group base-devel:
:: Repository core
   1) autoconf  2) automake  3) binutils  4) bison  5) fakeroot  6) file  7) findutils
   8) flex  9) gawk  10) gcc  11) gettext  12) grep  13) groff  14) gzip  15) libtool
   16) m4  17) make  18) pacman  19) patch  20) pkg-config  21) sed  22) sudo
   23) texinfo  24) util-linux  25) which

Enter a selection (default=all): 
warning: skipping target: file
warning: skipping target: findutils
warning: skipping target: gawk
warning: skipping target: gettext
warning: skipping target: grep
warning: skipping target: gzip
warning: skipping target: pacman
warning: skipping target: sed
warning: skipping target: texinfo
warning: skipping target: util-linux
warning: skipping target: which
resolving dependencies...
looking for conflicting packages...

Packages (153) acl-2.2.52-3  archlinux-keyring-20170611-1  attr-2.4.47-2
               ca-certificates-20170307-1  ca-certificates-cacert-20140824-4
               ca-certificates-mozilla-3.31-3  ca-certificates-utils-20170307-1
               cracklib-2.9.6-1  curl-7.54.1-1  db-5.3.28-3  dbus-1.10.18-1  efivar-31-1
               expat-2.2.1-1  gc-7.6.0-1  gdbm-1.13-1  glib2-2.52.3-1  gmp-6.1.2-1
               gnupg-2.1.21-3  gnutls-3.5.14-1  gpgme-1.9.0-3  guile-2.2.2-1
               hwids-20170328-1  iana-etc-20170512-1  icu-59.1-1  iptables-1.6.1-1
               kbd-2.0.4-1  keyutils-1.5.10-1  kmod-24-1  krb5-1.15.1-1  libaio-0.3.110-1
               libarchive-3.3.1-5  libassuan-2.4.3-1  libatomic_ops-7.4.6-1
               libcap-2.25-1  libelf-0.169-1  libffi-3.2.1-2  libgcrypt-1.7.8-1
               libgpg-error-1.27-1  libidn-1.33-1  libksba-1.3.4-2  libldap-2.4.44-5
               libmnl-1.0.4-1  libmpc-1.0.3-2  libnftnl-1.0.7-1  libnghttp2-1.23.1-1
               libnl-3.3.0-1  libpcap-1.8.1-2  libpipeline-1.4.1-1  libpsl-0.17.0-2
               libsasl-2.1.26-11  libseccomp-2.3.2-1  libsecret-0.18.5+14+g9980655-1
               libssh2-1.8.0-2  libsystemd-233.75-2  libtasn1-4.12-1  libtirpc-1.0.1-3
               libunistring-0.9.7-1  libusb-1.0.21-2  libutil-linux-2.29.2-2
               linux-api-headers-4.10.1-1  linux-firmware-20170422.ade8332-1
               lz4-1:1.7.5-1  lzo-2.10-1  mkinitcpio-23-1  mkinitcpio-busybox-1.26.1-1
               mpfr-3.1.5.p2-1  ncurses-6.0+20170527-1  nettle-3.3-1  npth-1.5-1
               openresolv-3.9.0-1  openssl-1.1.0.f-1  p11-kit-0.23.7-1
               pacman-mirrorlist-20170628-1  pam-1.3.0-1  pambase-20130928-1  pcre-8.40-1
               pinentry-1.0.0-1  popt-1.16-8  readline-7.0.003-1  sqlite-3.19.3-1
               systemd-233.75-2  thin-provisioning-tools-0.7.0-1  tzdata-2017b-1
               xz-5.2.3-1  zlib-1:1.2.11-1  autoconf-2.69-4  automake-1.15.1-1
               bash-4.4.012-2  bash-completion-2.5-1  binutils-2.28.0-3  bison-3.0.4-2
               btrfs-progs-4.11.1-1  bzip2-1.0.6-6  coreutils-8.27-1  cryptsetup-1.7.5-1
               device-mapper-2.02.172-2  dhcpcd-6.11.5-1  diffutils-3.6-1
               dosfstools-4.1-1  e2fsprogs-1.43.4-1  efibootmgr-15-1  fakeroot-1.21-2
               file-5.31-1  filesystem-2017.03-2  findutils-4.6.0-2  flex-2.6.4-1
               gawk-4.1.4-2  gcc-7.1.1-3  gcc-libs-7.1.1-3  gettext-0.19.8.1-2
               glibc-2.25-5  grep-3.1-1  groff-1.22.3-7  gzip-1.8-2  inetutils-1.9.4-5
               iproute2-4.12.0-1  iputils-20161105.1f2bb12-2  jfsutils-1.1.15-4
               less-487-1  libtool-2.4.6-8  licenses-20140629-2  linux-4.11.9-1
               logrotate-3.12.2-1  lvm2-2.02.172-2  m4-1.4.18-1  make-4.2.1-2
               man-db-2.7.6.1-2  man-pages-4.11-1  mdadm-4.0-1  nano-2.8.5-1
               netctl-1.12-2  pacman-5.0.2-1  patch-2.7.5-1  pciutils-3.5.4-1
               pcmciautils-018-7  perl-5.26.0-1  pkg-config-0.29.2-1  procps-ng-3.3.12-1
               psmisc-23.1-1  reiserfsprogs-3.6.25-1  s-nail-14.8.16-2  sed-4.4-1
               shadow-4.4-3  sudo-1.8.20.p2-1  sysfsutils-2.1.0-9
               systemd-sysvcompat-233.75-2  tar-1.29-2  texinfo-6.4-1  usbutils-008-1
               util-linux-2.29.2-2  vi-1:070224-2  which-2.21-2  xfsprogs-4.11.0-1

Total Download Size:   257.73 MiB
Total Installed Size:  947.09 MiB

:: Proceed with installation? [Y/n] 
:: Retrieving packages...
 linux-api-headers-4.10....   852.4 KiB  2.52M/s 00:00 [############################] 100%
 tzdata-2017b-1-any           235.8 KiB  9.59M/s 00:00 [############################] 100%
 iana-etc-20170512-1-any      360.9 KiB  11.7M/s 00:00 [############################] 100%
 filesystem-2017.03-2-x86_64   10.2 KiB  0.00B/s 00:00 [############################] 100%
 glibc-2.25-5-x86_64            8.4 MiB  2.33M/s 00:04 [############################] 100%
 gcc-libs-7.1.1-3-x86_64       17.7 MiB  2.52M/s 00:07 [############################] 100%
 ncurses-6.0+20170527-1-...  1053.3 KiB  3.12M/s 00:00 [############################] 100%
 readline-7.0.003-1-x86_64    294.7 KiB  10.7M/s 00:00 [############################] 100%
 bash-4.4.012-2-x86_64       1417.7 KiB  2.77M/s 00:01 [############################] 100%
 bzip2-1.0.6-6-x86_64          52.8 KiB  7.37M/s 00:00 [############################] 100%
 attr-2.4.47-2-x86_64          70.0 KiB  11.4M/s 00:00 [############################] 100%
 acl-2.2.52-3-x86_64          132.0 KiB  12.9M/s 00:00 [############################] 100%
 gmp-6.1.2-1-x86_64           408.5 KiB  2.43M/s 00:00 [############################] 100%
 libcap-2.25-1-x86_64          37.9 KiB  12.3M/s 00:00 [############################] 100%
 gdbm-1.13-1-x86_64           150.4 KiB  10.5M/s 00:00 [############################] 100%
 db-5.3.28-3-x86_64          1097.6 KiB  3.00M/s 00:00 [############################] 100%
 perl-5.26.0-1-x86_64          13.6 MiB  2.78M/s 00:05 [############################] 100%
 openssl-1.1.0.f-1-x86_64       2.9 MiB  2.78M/s 00:01 [############################] 100%
 coreutils-8.27-1-x86_64        2.2 MiB  3.06M/s 00:01 [############################] 100%
 libgpg-error-1.27-1-x86_64   150.4 KiB  11.3M/s 00:00 [############################] 100%
 libgcrypt-1.7.8-1-x86_64     466.0 KiB  2.63M/s 00:00 [############################] 100%
 lz4-1:1.7.5-1-x86_64          82.7 KiB  8.07M/s 00:00 [############################] 100%
 xz-5.2.3-1-x86_64            229.1 KiB  11.2M/s 00:00 [############################] 100%
 libsystemd-233.75-2-x86_64   350.6 KiB  11.4M/s 00:00 [############################] 100%
 device-mapper-2.02.172-...   265.8 KiB  11.3M/s 00:00 [############################] 100%
 popt-1.16-8-x86_64            65.5 KiB  21.3M/s 00:00 [############################] 100%
 libutil-linux-2.29.2-2-...   317.5 KiB  11.5M/s 00:00 [############################] 100%
 cryptsetup-1.7.5-1-x86_64    240.8 KiB  9.80M/s 00:00 [############################] 100%
 expat-2.2.1-1-x86_64          83.3 KiB  11.6M/s 00:00 [############################] 100%
 dbus-1.10.18-1-x86_64        273.7 KiB  11.6M/s 00:00 [############################] 100%
 libmnl-1.0.4-1-x86_64         10.5 KiB  2.56M/s 00:00 [############################] 100%
 libnftnl-1.0.7-1-x86_64       59.9 KiB  19.5M/s 00:00 [############################] 100%
 libnl-3.3.0-1-x86_64         354.9 KiB  11.6M/s 00:00 [############################] 100%
 libusb-1.0.21-2-x86_64        54.1 KiB  17.6M/s 00:00 [#####  X Start virtual machine on host boot up
359
Boot device order
360
  X Enable boot menu
361
  X IDE CDROM 1
362
  X IDE DISK 1
363
     NIC :fe:ed:30
364
```     
365
​
366
Make sure the IDE CDROM 1 is at the top of the Boot device order like above.
367
​
368
Click Apply.#######################] 100%
 libpcap-1.8.1-2-x86_64       216.9 KiB  10.6M/s 00:00 [############################] 100%
 iptables-1.6.1-1-x86_64      327.4 KiB  11.8M/s 00:00 [############################] 100%
 zlib-1:1.2.11-1-x86_64        86.4 KiB  14.1M/s 00:00 [############################] 100%
 cracklib-2.9.6-1-x86_64      249.9 KiB  12.2M/s 00:00 [############################] 100%
 e2fsprogs-1.43.4-1-x86_64    959.5 KiB  2.84M/s 00:00 [############################] 100%
 libsasl-2.1.26-11-x86_64     137.3 KiB  9.58M/s 00:00 [############################] 100%
 libldap-2.4.44-5-x86_64      284.9 KiB  12.1M/s 00:00 [############################] 100%
 keyutils-1.5.10-1-x86_64      67.5 KiB  11.0M/s 00:00 [############################] 100%
 krb5-1.15.1-1-x86_64        1120.1 KiB  2.19M/s 00:01 [############################] 100%
 libtirpc-1.0.1-3-x86_64      174.0 KiB  7.39M/s 00:00 [############################] 100%
 pambase-20130928-1-any      1708.0   B  0.00B/s 00:00 [############################] 100%
 pam-1.3.0-1-x86_64           609.7 KiB  2.98M/s 00:00 [############################] 100%
 kbd-2.0.4-1-x86_64          1119.9 KiB  3.06M/s 00:00 [############################] 100%
 kmod-24-1-x86_64             109.8 KiB  10.7M/s 00:00 [############################] 100%
 hwids-20170328-1-any         340.2 KiB  11.1M/s 00:00 [############################] 100%
 libidn-1.33-1-x86_64         206.9 KiB  10.1M/s 00:00 [############################] 100%
 libelf-0.169-1-x86_64        368.8 KiB  12.0M/s 00:00 [############################] 100%
 libseccomp-2.3.2-1-x86_64     66.3 KiB  10.8M/s 00:00 [############################] 100%
 shadow-4.4-3-x86_64         1060.6 KiB  2.96M/s 00:00 [############################] 100%
 util-linux-2.29.2-2-x86_64  1828.5 KiB  2.73M/s 00:01 [############################] 100%
 systemd-233.75-2-x86_64        3.9 MiB  2.82M/s 00:01 [############################] 100%
 dhcpcd-6.11.5-1-x86_64       156.8 KiB  10.9M/s 00:00 [############################] 100%
 diffutils-3.6-1-x86_64       282.8 KiB  11.5M/s 00:00 [############################] 100%
 file-5.31-1-x86_64           259.0 KiB  10.5M/s 00:00 [############################] 100%
 findutils-4.6.0-2-x86_64     420.7 KiB  11.1M/s 00:00 [############################] 100%
 mpfr-3.1.5.p2-1-x86_64       254.5 KiB  12.4M/s 00:00 [############################] 100%
 gawk-4.1.4-2-x86_64          987.1 KiB  2.89M/s 00:00 [############################] 100%
 pcre-8.40-1-x86_64           922.5 KiB  2.57M/s 00:00 [############################] 100%
 libffi-3.2.1-2-x86_64         31.5 KiB  10.3M/s 00:00 [############################] 100%
 glib2-2.52.3-1-x86_64          2.3 MiB  2.32M/s 00:01 [############################] 100%
 libunistring-0.9.7-1-x86_64  491.1 KiB  2.82M/s 00:00 [############################] 100%
 gettext-0.19.8.1-2-x86_64   2026.9 KiB  2.91M/s 00:01 [############################] 100%
 grep-3.1-1-x86_64            188.4 KiB  10.8M/s 00:00 [############################] 100%
 less-487-1-x86_64             93.6 KiB  15.2M/s 00:00 [############################] 100%
 gzip-1.8-2-x86_64             75.8 KiB  12.3M/s 00:00 [############################] 100%
 inetutils-1.9.4-5-x86_64     285.8 KiB  10.3M/s 00:00 [############################] 100%
 iproute2-4.12.0-1-x86_64     655.1 KiB  1961K/s 00:00 [############################] 100%
 sysfsutils-2.1.0-9-x86_64     30.2 KiB  9.83M/s 00:00 [############################] 100%
 iputils-20161105.1f2bb1...    71.2 KiB  9.93M/s 00:00 [############################] 100%
 jfsutils-1.1.15-4-x86_64     167.5 KiB  12.6M/s 00:00 [############################] 100%
 licenses-20140629-2-any       63.0 KiB  10.3M/s 00:00 [############################] 100%
 linux-firmware-20170422...    41.9 MiB  2.66M/s 00:16 [############################] 100%
 mkinitcpio-busybox-1.26...   157.0 KiB  11.0M/s 00:00 [############################] 100%
 libarchive-3.3.1-5-x86_64    449.0 KiB  11.0M/s 00:00 [############################] 100%
 mkinitcpio-23-1-any           38.8 KiB  12.6M/s 00:00 [############################] 100%
 linux-4.11.9-1-x86_64         61.3 MiB  3.29M/s 00:19 [############################] 100%
 logrotate-3.12.2-1-x86_64     37.1 KiB  9.07M/s 00:00 [############################] 100%
 libaio-0.3.110-1-x86_64        4.4 KiB  0.00B/s 00:00 [############################] 100%
 thin-provisioning-tools...   370.9 KiB  10.1M/s 00:00 [############################] 100%
 lvm2-2.02.172-2-x86_64      1288.9 KiB  3.10M/s 00:00 [############################] 100%
 groff-1.22.3-7-x86_64       1824.6 KiB  2.73M/s 00:01 [############################] 100%
 libpipeline-1.4.1-1-x86_64    36.2 KiB  11.8M/s 00:00 [############################] 100%
 man-db-2.7.6.1-2-x86_64      756.1 KiB  3.69M/s 00:00 [############################] 100%
 man-pages-4.11-1-any           5.7 MiB  2.46M/s 00:02 [############################] 100%
 mdadm-4.0-1-x86_64           394.4 KiB  10.4M/s 00:00 [############################] 100%
 nano-2.8.5-1-x86_64          418.5 KiB  11.0M/s 00:00 [############################] 100%
 openresolv-3.9.0-1-any        21.1 KiB  0.00B/s 00:00 [############################] 100%
 netctl-1.12-2-any             36.8 KiB  8.99M/s 00:00 [############################] 100%
 libtasn1-4.12-1-x86_64       117.4 KiB  11.5M/s 00:00 [############################] 100%
 p11-kit-0.23.7-1-x86_64      445.7 KiB  2.65M/s 00:00 [############################] 100%
 ca-certificates-utils-2...     7.5 KiB  0.00B/s 00:00 [############################] 100%
 ca-certificates-mozilla...   402.0 KiB  11.9M/s 00:00 [############################] 100%
 ca-certificates-cacert-...     7.1 KiB  0.00B/s 00:00 [############################] 100%
 ca-certificates-2017030...  1904.0   B  0.00B/s 00:00 [############################] 100%
 libssh2-1.8.0-2-x86_64       180.2 KiB   365K/s 00:00 [############################] 100%
 icu-59.1-1-x86_64              8.1 MiB  3.25M/s 00:03 [############################] 100%
 libpsl-0.17.0-2-x86_64        49.4 KiB  8.04M/s 00:00 [############################] 100%
 libnghttp2-1.23.1-1-x86_64    84.2 KiB  11.7M/s 00:00 [############################] 100%
 curl-7.54.1-1-x86_64         904.2 KiB  2.65M/s 00:00 [############################] 100%
 npth-1.5-1-x86_64             12.8 KiB  4.15M/s 00:00 [############################] 100%
 libksba-1.3.4-2-x86_64       114.6 KiB  11.2M/s 00:00 [############################] 100%
 libassuan-2.4.3-1-x86_64      84.6 KiB  13.8M/s 00:00 [############################] 100%
 libsecret-0.18.5+14+g99...   193.3 KiB  11.8M/s 00:00 [############################] 100%
 pinentry-1.0.0-1-x86_64       98.1 KiB  13.7M/s 00:00 [############################] 100%
 nettle-3.3-1-x86_64          321.7 KiB  11.6M/s 00:00 [############################] 100%
 gnutls-3.5.14-1-x86_64         2.3 MiB  3.24M/s 00:01 [############################] 100%
 sqlite-3.19.3-1-x86_64      1259.3 KiB  3.42M/s 00:00 [############################] 100%
 gnupg-2.1.21-3-x86_64       2020.5 KiB  2.33M/s 00:01 [############################] 100%
 gpgme-1.9.0-3-x86_64         361.9 KiB  2.21M/s 00:00 [############################] 100%
 pacman-mirrorlist-20170...     5.5 KiB  0.00B/s 00:00 [############################] 100%
 archlinux-keyring-20170...   661.6 KiB  3.40M/s 00:00 [############################] 100%
 pacman-5.0.2-1-x86_64        735.7 KiB  3.65M/s 00:00 [############################] 100%
 pciutils-3.5.4-1-x86_64       82.4 KiB  11.5M/s 00:00 [############################] 100%
 pcmciautils-018-7-x86_64      19.7 KiB  0.00B/s 00:00 [############################] 100%
 procps-ng-3.3.12-1-x86_64    299.5 KiB  10.8M/s 00:00 [############################] 100%
 psmisc-23.1-1-x86_64          94.4 KiB  13.2M/s 00:00 [############################] 100%
 reiserfsprogs-3.6.25-1-...   201.0 KiB  11.5M/s 00:00 [############################] 100%
 s-nail-14.8.16-2-x86_64      310.7 KiB  11.2M/s 00:00 [############################] 100%
 sed-4.4-1-x86_64             174.0 KiB  9.99M/s 00:00 [############################] 100%
 systemd-sysvcompat-233....     7.6 KiB  0.00B/s 00:00 [############################] 100%
 tar-1.29-2-x86_64            673.9 KiB  3.39M/s 00:00 [############################] 100%
 texinfo-6.4-1-x86_64        1188.4 KiB  3.20M/s 00:00 [############################] 100%
 usbutils-008-1-x86_64         61.3 KiB  19.9M/s 00:00 [############################] 100%
 vi-1:070224-2-x86_64         148.0 KiB  10.3M/s 00:00 [############################] 100%
 which-2.21-2-x86_64           15.5 KiB  0.00B/s 00:00 [############################] 100%
 xfsprogs-4.11.0-1-x86_64     813.5 KiB  2.43M/s 00:00 [############################] 100%
 m4-1.4.18-1-x86_64           166.1 KiB  12.5M/s 00:00 [############################] 100%
 autoconf-2.69-4-any          583.5 KiB  3.22M/s 00:00 [############################] 100%
 automake-1.15.1-1-any        594.7 KiB  3.01M/s 00:00 [############################] 100%
 binutils-2.28.0-3-x86_64       4.7 MiB  2.47M/s 00:02 [############################] 100%
 bison-3.0.4-2-x86_64         555.3 KiB  3.06M/s 00:00 [############################] 100%
 fakeroot-1.21-2-x86_64        67.1 KiB  21.8M/s 00:00 [############################] 100%
 flex-2.6.4-1-x86_64          282.8 KiB  12.0M/s 00:00 [############################] 100%
 libmpc-1.0.3-2-x86_64         63.3 KiB  8.83M/s 00:00 [############################] 100%
 gcc-7.1.1-3-x86_64            28.8 MiB  3.32M/s 00:09 [############################] 100%
 libtool-2.4.6-8-x86_64       396.1 KiB  11.4M/s 00:00 [############################] 100%
 make-4.2.1-2-x86_64          407.7 KiB  12.1M/s 00:00 [############################] 100%
 patch-2.7.5-1-x86_64          79.2 KiB  12.9M/s 00:00 [############################] 100%
 pkg-config-0.29.2-1-x86_64    34.7 KiB  11.3M/s 00:00 [############################] 100%
 sudo-1.8.20.p2-1-x86_64      958.0 KiB  2.84M/s 00:00 [############################] 100%
 lzo-2.10-1-x86_64             82.1 KiB  11.5M/s 00:00 [############################] 100%
 btrfs-progs-4.11.1-1-x86_64  598.8 KiB  1831K/s 00:00 [############################] 100%
 dosfstools-4.1-1-x86_64       56.0 KiB  13.7M/s 00:00 [############################] 100%
 efivar-31-1-x86_64            75.4 KiB  10.5M/s 00:00 [############################] 100%
 efibootmgr-15-1-x86_64        20.2 KiB  0.00B/s 00:00 [############################] 100%
 libatomic_ops-7.4.6-1-x...    58.7 KiB  8.19M/s 00:00 [############################] 100%
 gc-7.6.0-1-x86_64            217.6 KiB  12.5M/s 00:00 [############################] 100%
 guile-2.2.2-1-x86_64           5.6 MiB  2.24M/s 00:03 [############################] 100%
 bash-completion-2.5-1-any    171.9 KiB  9.88M/s 00:00 [############################] 100%
(153/153) checking keys in keyring                     [############################] 100%
(153/153) checking package integrity                   [############################] 100%
(153/153) loading package files                        [############################] 100%
(153/153) checking for file conflicts                  [############################] 100%
(153/153) checking available disk space                [############################] 100%
:: Processing package changes...
(  1/153) installing linux-api-headers                 [############################] 100%
(  2/153) installing tzdata                            [############################] 100%
(  3/153) installing iana-etc                          [############################] 100%
(  4/153) installing filesystem                        [############################] 100%
(  5/153) installing glibc                             [############################] 100%
Optional dependencies for glibc
    gd: for memusagestat
(  6/153) installing gcc-libs                          [############################] 100%
(  7/153) installing ncurses                           [############################] 100%
(  8/153) installing readline                          [############################] 100%
(  9/153) installing bash                              [############################] 100%
Optional dependencies for bash
    bash-completion: for tab completion [pending]
( 10/153) installing bzip2                             [############################] 100%
( 11/153) installing attr                              [############################] 100%
( 12/153) installing acl                               [############################] 100%
( 13/153) installing gmp                               [############################] 100%
( 14/153) installing libcap                            [############################] 100%
( 15/153) installing gdbm                              [############################] 100%
( 16/153) installing db                                [############################] 100%
( 17/153) installing perl                              [############################] 100%
( 18/153) installing openssl                           [############################] 100%
Optional dependencies for openssl
    ca-certificates [pending]
( 19/153) installing coreutils                         [############################] 100%
( 20/153) installing libgpg-error                      [############################] 100%
( 21/153) installing libgcrypt                         [############################] 100%
( 22/153) installing lz4                               [############################] 100%
( 23/153) installing xz                                [############################] 100%
( 24/153) installing libsystemd                        [############################] 100%
( 25/153) installing device-mapper                     [############################] 100%
( 26/153) installing popt                              [############################] 100%
( 27/153) installing libutil-linux                     [############################] 100%
( 28/153) installing cryptsetup                        [############################] 100%
( 29/153) installing expat                             [############################] 100%
( 30/153) installing dbus                              [############################] 100%
( 31/153) installing libmnl                            [############################] 100%
( 32/153) installing libnftnl                          [############################] 100%
( 33/153) installing libnl                             [############################] 100%
( 34/153) installing libusb                            [############################] 100%
( 35/153) installing libpcap                           [############################] 100%
( 36/153) installing iptables                          [############################] 100%
( 37/153) installing zlib                              [############################] 100%
( 38/153) installing cracklib                          [############################] 100%
( 39/153) installing e2fsprogs                         [############################] 100%
( 40/153) installing libsasl                           [############################] 100%
( 41/153) installing libldap                           [############################] 100%
( 42/153) installing keyutils                          [############################] 100%
( 43/153) installing krb5                              [############################] 100%
( 44/153) installing libtirpc                          [############################] 100%
( 45/153) installing pambase                           [############################] 100%
( 46/153) installing pam                               [############################] 100%
( 47/153) installing kbd                               [############################] 100%
( 48/153) installing kmod                              [############################] 100%
( 49/153) installing hwids                             [############################] 100%
( 50/153) installing libidn                            [############################] 100%
( 51/153) installing libelf                            [############################] 100%
( 52/153) installing libseccomp                        [############################] 100%
( 53/153) installing shadow                            [############################] 100%
( 54/153) installing util-linux                        [############################] 100%
Optional dependencies for util-linux
    python: python bindings to libmount
( 55/153) installing systemd                           [############################] 100%
Initializing machine ID from KVM UUID.
Created symlink /etc/systemd/system/getty.target.wants/getty@tty1.service → /usr/lib/systemd/system/getty@.service.
Created symlink /etc/systemd/system/multi-user.target.wants/remote-fs.target → /usr/lib/systemd/system/remote-fs.target.
:: Append 'init=/usr/lib/systemd/systemd' to your kernel command line in your
   bootloader to replace sysvinit with systemd, or install systemd-sysvcompat
Optional dependencies for systemd
    libmicrohttpd: remote journald capabilities
    quota-tools: kernel-level quota management
    systemd-sysvcompat: symlink package to provide sysvinit binaries [pending]
    polkit: allow administration as unprivileged user
( 56/153) installing dhcpcd                            [############################] 100%
Optional dependencies for dhcpcd
    openresolv: resolvconf support [pending]
( 57/153) installing diffutils                         [############################] 100%
( 58/153) installing file                              [############################] 100%
( 59/153) installing findutils                         [############################] 100%
( 60/153) installing mpfr                              [############################] 100%
( 61/153) installing gawk                              [############################] 100%
( 62/153) installing pcre                              [############################] 100%
( 63/153) installing libffi                            [############################] 100%
( 64/153) installing glib2                             [############################] 100%
Optional dependencies for glib2
    python: for gdbus-codegen and gtester-report
    libelf: gresource inspection tool [installed]
( 65/153) installing libunistring                      [############################] 100%
( 66/153) installing gettext                           [############################] 100%
Optional dependencies for gettext
    git: for autopoint infrastructure updates
( 67/153) installing grep                              [############################] 100%
( 68/153) installing less                              [############################] 100%
( 69/153) installing gzip                              [############################] 100%
( 70/153) installing inetutils                         [############################] 100%
( 71/153) installing iproute2                          [############################] 100%
Optional dependencies for iproute2
    linux-atm: ATM support
( 72/153) installing sysfsutils                        [############################] 100%
( 73/153) installing iputils                           [############################] 100%
Optional dependencies for iputils
    xinetd: for tftpd
( 74/153) installing jfsutils                          [############################] 100%
( 75/153) installing licenses                          [############################] 100%
( 76/153) installing linux-firmware                    [############################] 100%
( 77/153) installing mkinitcpio-busybox                [############################] 100%
( 78/153) installing libarchive                        [############################] 100%
( 79/153) installing mkinitcpio                        [############################] 100%
Optional dependencies for mkinitcpio
    xz: Use lzma or xz compression for the initramfs image [installed]
    bzip2: Use bzip2 compression for the initramfs image [installed]
    lzop: Use lzo compression for the initramfs image
    lz4: Use lz4 compression for the initramfs image [installed]
    mkinitcpio-nfs-utils: Support for root filesystem on NFS
( 80/153) installing linux                             [############################] 100%
>>> Updating module dependencies. Please wait ...
Optional dependencies for linux
    crda: to set the correct wireless channels of your country
( 81/153) installing logrotate                         [############################] 100%
( 82/153) installing libaio                            [############################] 100%
( 83/153) installing thin-provisioning-tools           [############################] 100%
( 84/153) installing lvm2                              [############################] 100%
( 85/153) installing groff                             [############################] 100%
Optional dependencies for groff
    netpbm: for use together with man -H command interaction in browsers
    psutils: for use together with man -H command interaction in browsers
    libxaw: for gxditview
( 86/153) installing libpipeline                       [############################] 100%
( 87/153) installing man-db                            [############################] 100%
Optional dependencies for man-db
    gzip [installed]
( 88/153) installing man-pages                         [############################] 100%
( 89/153) installing mdadm                             [############################] 100%
( 90/153) installing nano                              [############################] 100%
( 91/153) installing openresolv                        [############################] 100%
( 92/153) installing netctl                            [############################] 100%
Optional dependencies for netctl
    dialog: for the menu based wifi assistant
    dhclient: for DHCP support (or dhcpcd)
    dhcpcd: for DHCP support (or dhclient) [installed]
    wpa_supplicant: for wireless networking support
    ifplugd: for automatic wired connections through netctl-ifplugd
    wpa_actiond: for automatic wireless connections through netctl-auto
    ppp: for PPP connections
    openvswitch: for Open vSwitch connections
( 93/153) installing libtasn1                          [############################] 100%
( 94/153) installing p11-kit                           [############################] 100%
( 95/153) installing ca-certificates-utils             [############################] 100%
( 96/153) installing ca-certificates-mozilla           [############################] 100%
( 97/153) installing ca-certificates-cacert            [############################] 100%
( 98/153) installing ca-certificates                   [############################] 100%
( 99/153) installing libssh2                           [############################] 100%
(100/153) installing icu                               [############################] 100%
(101/153) installing libpsl                            [############################] 100%
(102/153) installing libnghttp2                        [############################] 100%
(103/153) installing curl                              [############################] 100%
(104/153) installing npth                              [############################] 100%
(105/153) installing libksba                           [############################] 100%
(106/153) installing libassuan                         [############################] 100%
(107/153) installing libsecret                         [############################] 100%
Optional dependencies for libsecret
    gnome-keyring: key storage service (or use any other service implementing
    org.freedesktop.secrets)
(108/153) installing pinentry                          [############################] 100%
Optional dependencies for pinentry
    gtk2: gtk2 backend
    qt5-base: qt backend
    gcr: gnome3 backend
(109/153) installing nettle                            [############################] 100%
(110/153) installing gnutls                            [############################] 100%
Optional dependencies for gnutls
    guile: for use with Guile bindings [pending]
(111/153) installing sqlite                            [############################] 100%
(112/153) installing gnupg                             [############################] 100%
Optional dependencies for gnupg
    libldap: gpg2keys_ldap [installed]
    libusb-compat: scdaemon
(113/153) installing gpgme                             [############################] 100%
(114/153) installing pacman-mirrorlist                 [############################] 100%
(115/153) installing archlinux-keyring                 [############################] 100%
(116/153) installing pacman                            [############################] 100%
(117/153) installing pciutils                          [############################] 100%
(118/153) installing pcmciautils                       [############################] 100%
(119/153) installing procps-ng                         [############################] 100%
(120/153) installing psmisc                            [############################] 100%
(121/153) installing reiserfsprogs                     [############################] 100%
(122/153) installing s-nail                            [############################] 100%
Optional dependencies for s-nail
    smtp-forwarder: for sending mail
(123/153) installing sed                               [############################] 100%
(124/153) installing systemd-sysvcompat                [############################] 100%
(125/153) installing tar                               [############################] 100%
(126/153) installing texinfo                           [############################] 100%
(127/153) installing usbutils                          [############################] 100%
Optional dependencies for usbutils
    python2: for lsusb.py usage
    coreutils: for lsusb.py usage [installed]
(128/153) installing vi                                [############################] 100%
Optional dependencies for vi
    s-nail: used by the preserve command for notification [installed]
(129/153) installing which                             [############################] 100%
(130/153) installing xfsprogs                          [############################] 100%
(131/153) installing m4                                [############################] 100%
(132/153) installing autoconf                          [############################] 100%
(133/153) installing automake                          [############################] 100%
(134/153) installing binutils                          [############################] 100%
(135/153) installing bison                             [############################] 100%
(136/153) installing fakeroot                          [############################] 100%
(137/153) installing flex                              [############################] 100%
(138/153) installing libmpc                            [############################] 100%
(139/153) installing gcc                               [############################] 100%
(140/153) installing libtool                           [############################] 100%
(141/153) installing libatomic_ops                     [############################] 100%
(142/153) installing gc                                [############################] 100%
(143/153) installing guile                             [############################] 100%
(144/153) installing make                              [############################] 100%
(145/153) installing patch                             [############################] 100%
Optional dependencies for patch
    ed: for patch -e functionality
(146/153) installing pkg-config                        [############################] 100%
(147/153) installing sudo                              [############################] 100%
(148/153) installing lzo                               [############################] 100%
(149/153) installing btrfs-progs                       [############################] 100%
(150/153) installing dosfstools                        [############################] 100%
(151/153) installing bash-completion                   [############################] 100%
(152/153) installing efivar                            [############################] 100%
(153/153) installing efibootmgr                        [############################] 100%
:: Running post-transaction hooks...
(1/7) Updating linux initcpios
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.9-1-ARCH
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
==> Starting build: 4.11.9-1-ARCH
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
pacstrap /mnt base base-devel btrfs-progs dosfstools bash-completion   27.63s user 4.29s system 18% cpu 2:48.68 total
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
# <file system>	<dir>	<type>	<options>	<dump>	<pass>
# /dev/sda3 UUID=117c3f13-d9a0-41ab-889e-6c4208e43489
LABEL=ROOT          	/         	btrfs     	rw,noatime,compress=lzo,space_cache,subvolid=257,subvol=/@,subvol=@	0 0

# /dev/sda3 UUID=117c3f13-d9a0-41ab-889e-6c4208e43489
LABEL=ROOT          	/home     	btrfs     	rw,noatime,compress=lzo,space_cache,subvolid=258,subvol=/@home,subvol=@home	0 0

# /dev/sda3 UUID=117c3f13-d9a0-41ab-889e-6c4208e43489
LABEL=ROOT          	/.snapshots	btrfs     	rw,noatime,compress=lzo,space_cache,subvolid=259,subvol=/@snapshots,subvol=@snapshots	0 0

# /dev/sda1 UUID=6D43-2B62
LABEL=EFI           	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro	0 2

# /dev/sda2 UUID=542a0b22-3757-45bd-83e4-eb9977d4bef4
LABEL=SWAP          	none      	swap      	defaults  	0 0
```

### Chroot Into The Filesystem and Configure Some Basics ###

```
root@archiso ~ # arch-chroot /mnt/
[root@archiso /]# echo iot /etc/hostname
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

Final look.

```
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have $repo replaced by the name of the current repo
#   - URLs will have $arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
```

### Update Pacman ###

```
[root@archiso /]# pacman -Sy
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
 multilib                     172.7 KiB   373K/s 00:00 [----------------------------] 100%
 archlinuxfr                   15.3 KiB   112K/s 00:00 [----------------------------] 100%
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
==> Starting build: 4.11.9-1-ARCH
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
==> Starting build: 4.11.9-1-ARCH
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
Created "/boot/EFI".
Created "/boot/EFI/systemd".
Created "/boot/EFI/BOOT".
Created "/boot/loader".
Created "/boot/loader/entries".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/systemd/systemd-bootx64.efi".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/BOOT/BOOTX64.EFI".
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

### Check out the EFI boot menu ###

Check to see if we can see the "Linux Boot Manager" now in the EFI boot menu.

```
[root@archiso entries]# efibootmgr -v
BootCurrent: 0003
Timeout: 0 seconds
BootOrder: 0001,0003,0004,0000,0006
Boot0000* UiApp	FvVol(7cb8bdc9-f8eb-4f34-aaea-3ee4af6516a1)/FvFile(462caa21-7614-4503-836e-8ab6f4662331)
Boot0001* Linux Boot Manager	HD(1,GPT,7948c78d-ca8c-4224-9e62-e3614b64987e,0x800,0x113000)/File(\EFI\systemd\systemd-bootx64.efi)
Boot0003* UEFI QEMU DVD-ROM QM00002 	PciRoot(0x0)/Pci(0x1,0x1)/Ata(0,1,0)N.....YM....R,Y.
Boot0004* UEFI QEMU HARDDISK QM00003 	PciRoot(0x0)/Pci(0x1,0x1)/Ata(1,0,0)N.....YM....R,Y.
Boot0006* EFI Internal Shell	FvVol(7cb8bdc9-f8eb-4f34-aaea-3ee4af6516a1)/FvFile(7c04a583-9e3e-4f1c-ad65-e05268d0b4d1)
```

### Exit arch-chroot and unmount everything ###

```
[root@archiso entries]# exit
exit
arch-chroot /mnt/  6.43s user 0.72s system 1% cpu 10:45.29 total
root@archiso ~ # umount -R /mnt/
```

### Remove install media, Reboot & hope for the best ###

```
root@archiso ~ # reboot
``` 

In the Show virtual hardware details:

Click Boot Options

```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE DISK 1
  X IDE CDROM 1
     NIC :fe:ed:30
```     

Make sure the IDE DISK 1 is at the top of the Boot device order like above.

Click Apply.

Click Power on  the virtual machine.

Click Show graphical console.

If everything goes well you should now be at a linux console waiting for you to login with your root user account and password we set before with passwd.

```
Arch Linux 4.11.9-1-ARCH (tty1)

iot login: root
password: Plebmast0r
[root@iot ~]#
```

Let's setup a DHCP Static Address for this server.

On the Virtual Router WebGUI.

Services => DHCP => Server

Click IOT Tab.

Scroll down to the bottom to DHCP Static Mappings for this interface..

Click +

```
Static DHCP Mapping

 MAC address: 42:de:ad:fe:ed:30 Copy my MAC address
 Client identifier:
 IP address:10.0.3.42
 Hostname:
 Description: IoT Server
 ARP Table Static Entry:
 WINS servers:
 DNS servers:
 Gateway:
 Domain name:
 Domain search list:
 Default lease time (seconds):
 Maximum lease time (seconds):
 Dynamic DNS Advanced - Show Dynamic DNS
 NTP servers Advanced - Show NTP configuration
 TFTP server Advanced - Show TFTP configuration
Save  Cancel
```

The only 3 entries we need for this:

```
 MAC address: 42:de:ad:fe:ed:30
 IP address:10.0.3.42
 Description: IoT Server
```

Click Save.

Click Apply changes.

Back to the IoT VM.

Enable dhcpcd.

```
systemctl enable dhcpcd
Created symlink /etc/systemd/system/multi-user.target.wants/dhcpcd.service -> /usr/lib/systemd/system/dhcpcd.service.
systemctl start dhcpcd
restart
```

Log back in and check IP address.

```
ip addr show ens3
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 42:de:ad:fe:ed:30 brd ff:ff:ff:ff:ff:ff
    inet 10.0.3.42/24 brd 10.0.3.255 scope global ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::e7b4:e7ba:906b:1f21/64 scope link 
       valid_lft forever preferred_lft forever
```

Add a basic user with sudo privileges.

```
useradd -m -G wheel -s /bin/bash plebuser
passwd plebuser
password: PlebMast0r
export EDITOR=nano && sudo -E visudo

## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
```

Save and exit.

Setup remote login with SSH. 

```
pacman -S openssh
systemctl enable sshd
systemctl start sshd
```

Login from another system on the network.

```
ssh plebuser@10.0.3.42
plebuser@10.0.3.42's password: PlebMast0r
```

Continue to [Part 07 - NASferatu](../Infrastructure-Part-7)
