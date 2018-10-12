---
layout: post
title: PXE pfSense TFTP NFS Arch Linux Booting
---
Needed to boot 24 machines with a custom Arch Linux build.

# Process #

## pfSense ##

This assumes you have pfSense & DHCP already running...

In pfSense click Services => DHCP Server => Other Options

TFTP server enter just the IP.

```
TFTP Server: 10.0.1.10
```

Network Booting enter these three values depending on the folder your tftp server resides in.

**Note:** *Don't forget to click enable!*

```
Enable: X Enables network booting
Next Server: 10.0.1.10
Default BIOS file name pxelinux.0
Root path: /srv/tftp/
```

Click save.

## TFTP/NFS server ##

Setup TFTP/NFS and Download the Arch ISO, mount & copy files to the TFTP/NFS Server. 

### Downloads ###

Make a directory to store downloads required.

```
mkdir /srv/extra
```

### TFTP Server ###

Install TFTP Server.

```
sudo pacman -S tftp-hba
```

Setup TFTP Server with --verbose mode so you can see if the pxeboot is actually getting to it.

```
vi /etc/conf.d/tftpd
TFTPD_ARGS="--secure /srv/tftp/ --verbose"
```

Start the TFTP Server.

```
sudo systemctl enable tftpd
sudo systemctl start tftpd
```

Set file permissions

```
chmod 777 /srv/tftp
```

Test TFTP Server by creating a file on it and then download from it.

```
echo "hello" | tee /srv/tftp/hello.txt
```

On another system on the same network...

```
sudo pacman -S tftp-hpa
echo "get hello.txt" | tftp 10.0.1.10
tftp> get hello.txt
tftp>
cat hello.txt
hello
```

Check journal for tftp contact "--verbose" mode enables the ability to see what files are getting grabbed otherwise you will see nothing.

```
journalctl -u tftpd -f
```

Example of hello.txt file grab:

```
-- Logs begin at ... etc --
Day Time System in.tftpd[PID]: RRQ from 10.0.1.51 filename hello.txt
```

Example PXEBoot system file grab:

```
-- Logs begin at ... etc --
Day Time System in.tftpd[PID]: RRQ from 10.0.1.50 filename archlinux/arch/boot/x86_64/vmlinuz
Day Time System in.tftpd[PID]: RRQ from 10.0.1.50 filename archlinux/arch/boot/x86_64/archiso.img
Day Time System in.tftpd[PID]: RRQ from 10.0.1.50 filename pxelinux.0
```


### NFS Server ###

Install NFS Server.

```
sudo pacman -S nfs-utils
```

Make pxeboot directory for NFS share.

```
mkdir -p /srv/pxeboot/
```

Setup shares

```
echo "/srv/pxeboot 10.0.1.0/24(ro,no_root_squash,no_subtree_check)" >> /etc/exports
exportfs -a
```

ro: This option gives the client machine read-only access to the volume.

no_subtree_check: This option prevents subtree checking, which is a process where the host must check whether the file is actually still available in the exported tree for every request. This can cause many problems when a file is renamed while the client has it opened. In almost all cases, it is better to disable subtree checking.

no_root_squash: By default, NFS translates requests from a root user remotely into a non-privileged user on the server. This was supposed to be a security feature by not allowing a root account on the client to use the filesystem of the host as root. This directive disables this for certain shares.

**Note:** *exportfs -rav if the server is currently running.*

Enable/Start the NFS service.

```
sudo systemctl enable nfs-server
sudo systemctl start nfs-server
```

### TEST NFS Share ###

Add a test file to the NFS Server.

```
echo "hello" | sudo tee /srv/pxeboot/hello.txt
```

From another machine on the same network mount the NFS share.

```
sudo pacman -S nfs-utils
mkdir -p /mnt/nfs/archlinux
sudo mount 10.0.1.10:/srv/pxeboot /mnt/nfs/home
ls /mnt/nfs/home
hello.txt
```

Add Arch files to the TFTP/NFS directories.

```
mkdir /srv/pxeboot/archlinux
mkdir /mnt/archiso
wget -P /srv/extra/ http://mirror.rackspace.com/archlinux/iso/2018.10.01/archlinux-2018.10.01-x86_64.iso
sudo mount -o loop,ro /srv/extra/archlinux-2018.10.01-x86_64.iso /mnt/archiso
mkdir -p /srv/tftp/archlinux/arch/arch/boot/x86_64/
cp /mnt/archiso/arch/boot/x86_64/{archiso.img,vmlinuz} /srv/tftp/archlinux/arch/boot/x86_64/
cp -r /mnt/archiso/* /srv/pxeboot/archlinux/
```

Make the direcotry & file /srv/tftp/pxelinux.cfg/default

```
mkdir -p /srv/tftp/pxelinux.cfg

vi /srv/tftp/pxelinux.cfg/default

# Use the low-colour menu system. This file, and the high-colour 'vesamenu.c32'
# version, are provided by the syslinux package and can be found in the
# '/srv/extra/syslinux' directory. Copy it to '/srv/tftp'.
DEFAULT menu.c32
# Prompt the user. Set to '1' to automatically choose the default option. This
# is really meant for files matched to MAC addresses.
PROMPT 0
# Time out and use the default menu option. Defined as tenths of a second.
TIMEOUT 20
menu title PXEBoot Arch Network Loader
LABEL archlinux
menu label Arch Linux Factory
kernel archlinux/arch/boot/x86_64/vmlinuz
append initrd=archlinux/arch/boot/x86_64/archiso.img archisobasedir=arch archiso_nfs_srv=10.0.1.10:/srv/pxeroot/archlinux ip=:::::eth0:dhcp -
```

**Note:** *You can add multiple sections to the above like below if you want to make different images to boot. Just add more /srv/pxeboot/archlinuxcustom etc directories and customise away.*

**Note:** *If you add multiple directories you need to add them to your NFS Server /etc/exports as well or you will get permission denied.*

### [Optional Stuff] ###

```
vi /srv/tftp/pxelinux.cfg/default

# Use the low-colour menu system. This file, and the high-colour 'vesamenu.c32'
# version, are provided by the syslinux package and can be found in the
# '/srv/extra/syslinux' directory. Copy it to '/srv/tftp'.
DEFAULT menu.c32
# Prompt the user. Set to '1' to automatically choose the default option. This
# is really meant for files matched to MAC addresses.
PROMPT 0
# Time out and use the default menu option. Defined as tenths of a second.
TIMEOUT 20
menu title PXEBoot Arch Network Loader
LABEL archlinux
menu label Arch Linux Factory
kernel archlinux/arch/boot/x86_64/vmlinuz
append initrd=archlinux/arch/boot/x86_64/archiso.img archisobasedir=arch archiso_nfs_srv=10.0.1.10:/srv/pxeroot/archlinux ip=:::::eth0:dhcp -

LABEL archlinuxcustom
menu label Arch Linux Custom
kernel archlinux/arch/boot/x86_64/vmlinuz
append initrd=archlinux/arch/boot/x86_64/archiso.img archisobasedir=arch archiso_nfs_srv=10.0.1.10:/srv/pxeroot/archlinuxcustom ip=:::::eth0:dhcp -

LABEL archlinuxlarge
menu label Arch Linux LARGE!
kernel archlinux/arch/boot/x86_64/vmlinuz
append initrd=archlinux/arch/boot/x86_64/archiso.img cow_spacesize=4G archisobasedir=arch archiso_nfs_srv=10.0.1.10:/srv/pxeroot/archlinuxlarge ip=:::::eth0:dhcp -
```

Get syslinux.

```
wget -P /srv/extra/ https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/Testing/6.04/syslinux-6.04-pre1.zip
unzip -d /srv/extra/syslinux syslinux-6.04-pre1.zip
cp /srv/extra/syslinux/bios/core/pxelinux.0 /srv/tftp
cp /srv/extra/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 /srv/tftp/
cp /srv/extra/syslinux/bios/com32/libutil.c32 /srv/tftp/
cp /srv/extra/syslinux/memdisk/memdisk /srv/tftp/
```

## VirtualBox - Test PXE build ## 

Use virtualbox or other vm system to test the PXE quickly before deploying.

```
sudo pacman -S virtualbox
```

Virtualbox => Machine => New

**Name and operating system**

```
Name:PXETest
Type:Linux
Version: Arch Linux (64-bit)
```

**Memory size**

**Note:** *If a requirement for larger than the default 256MB memory loaded cowspace then this value will need to be increased. Otherwise you will get a kernel panic.* 

```
1024MB
```

**Hard disk**

```
X Do not add a virtual hard disk
```

You are about to create a new virtual machine without a hard disk... etc...

Continue.

Right click the new virtual machine of "PXETest" and click Settings.

Click System (Option on the left) => Motherboard tab.

Boot Order: X Network

Move "Network" to the top of the list with the arrow buttons.

Click Network (Option on the left) => Adapter 1 tab.

Attached to: Bridge Adapter
Name: enp0s25 (What ever your computer nic is called that is on the same network as the TFTP/NFS Server.)

Advanced
Adapter Type: Intel PRO/1000 MT Desktop (82540EM)

Click OK

Click Start => Normal start

"Please select a virtual optical disk file or a physical optical drive containing a disk to start your new virtual machine from. The disk should be suitable for starting a computer from. As this virtual machine has no hard drive you will not be able to install an operating system on it at the moment."

Empty

Click Cancel and the machine should start the PXE boot process.

```
iPXE (PCI C8:00.0) starting execution...ok
iPXE initialising devices...ok

iPXE 1.0.0+ -- Open Source Network Boot Firmware -- http://ipxe.org
Features: DNS TFTP HTTP PXE PXEXT Menu

net0: 08:00:27:62:7c:4d using 82540em on PCI00:03.0 (open)
  [Link:down, TX:0 TXE:0 RX:0 RXE:0]
  [Link status: Down (http://ipxe.org/38086101)]
Waiting for link-up on net0... ok
DHCP (net0 08:00:27:62:7c:4d)...
net0: 10.0.1.50/255.255.255.0 gw 10.0.1.1
Next server: 10.0.1.10
Filename: pxelinux.0
Root path: /srv/tftp/
tftp://10.0.1.10/pxelinux.0... ok

PXELINUX 6.04 PXE 6.04-pre1 Copyright (C) 1994-2015 H. Peter Anvin et al
```

```
+=============================+
| PXEBoot Arch Network Loader |
+=============================+
| Arch Linux Factory          |
| Arch Linux Custom           |
| Arch Linux LARGE!           |
+=============================+
 Press [Tab] to edit options
 Automatic boot in 2 seconds...
```

```
Loading archlinux/arch/boot/x86_64/vmlinuz... ok
Loading archlinux/arch/boot/x86_64/archiso.img... ok
Probing EDD (edd=off to disable)... ok
:: running early hook [udev]
Starting version 239
:: running early hook [archiso_pxe_ndb]
:: running hook [udev]
:: Triggering uevents...
:: running hook [memdisk]
:: running hook [archiso]
:: running hook [archiso_loop_mnt]
:: running hook [archiso_pxe_common]
IP-Config: eth0 hardware address 08:00:27:62:7c:4d mtu 1500 DHCP
IP-Config: eth0 guessed broadcast address 10.0.1.255
IP-Config: eth0 complete (from 10.0.1.1):
 address: 10.0.1.50  broadcast: 10.0.1.255  netmask: 255.255.255.0
 gateway: 10.0.1.1   dns0     : 10.0.1.1    dns1   : 0.0.0.0
 domain : woot
 rootserver: 10.0.1.10 rootpath: /srv/tftp/
 filename  : pxelinux.0
 :: running hook [archiso_pxe_nbd]
 :: running hook [archiso_pxe_http]
 :: running hook [archiso_pxe_nfs]
 :: Mounting '10.0.1.10:/srv/pxeboot/archlinux'
 :: Mounting /run/archiso/copytoram (tmpfs) filesystem, size=75%
 :: Mounting /run/archiso/cowspace (tmpfs) filesystem, size=256M...
 :: Copying squashfs image to RAM...
```

Arch should start loading now from RAM...

## Extra Fun ##

### Customize ARCHISO to load from PXE ###

Install archiso and setup folders for build directory.

```
sudo pacman -S archiso
mkdir -p ~/code/archlive
cp -r /usr/share/archiso/configs/releng/ ~/code/archlive/archcustom
cd ~/code/archlive/archcustom
```

Edit the packages.x86_64 file for extra stuff you want to add to your customized build

```
vi packages.x86_64

stuffhere

```

Edit pacman.conf if your packakges need stuff like multilibs etc.

```
vi pacman.conf


stuffhere
```

Add skel directory to airootfs for stuff you want to add to the boot users home directory.

```
mkdir airootfs/etc/skel
cd airootfs/etc/skel
echo "hello" | tee hello.txt
cd ..
echo "nameserver 8.8.8.8" | tee resolv.conf
cd ../../
mkdir ~/code/archlive/archcustom/out
```

Build custom Arch ISO

```
sudo ./build.sh -v
```

Check out the ISO.

```
cd out
ls
archlinux-2018.10.10-x86_64.iso
```

Mount new ISO to copy to /srv/pxeboot/archcustom/

```
mkdir /srv/pxeboot/archcustom
mkdir /mnt/archcustom
sudo mount -o loop,ro ~/code/archlive/out/archlinux-2018.10.01-x86_64.iso /mnt/archcustom
cp /mnt/archcustom/* /srv/pxeboot/archcustom/
```

SCP it to the server if you built it on another machine...

```
scp -r /mnt/archcustom/* root@10.0.1.52:/srv/pxeboot/archcustom
```

Look back at one of the notes above that talks about adding multiple entries to the pxeboot menu that points to this directory we just made.

If need be to rebuild the image again because of some added updates you must first purge the working directory.

**Note:** *If you get gcc dependacy issues in the future after not building in a while just delete the whole "work" directory and rebuild.*

For some reason if you want to boot this image maybe for debug purposes on a hardware system you can "burn" it to the usb drive.

Find the USB drive attached to the system.

```
lsblk
NAME        MAJ:MIN RM   SIZE  RO TYPE MOUNTPOINT
sdg           8:0    1   9001P 0 disk 
└─sdg1        8:1    1   9001P 0 part 
nvme0n1     259:0    0 238.5G  0 disk 
etc...
```

Write image to USB drive.

```
sudo dd bs=4M if=~/code/archlive/out/archlinux-2018.10.01-x86_64.iso of=/dev/sdg status=progress oflag=sync
```

Now try to boot it on a physical machine or vm.

## Troubleshooting ##

```
Intel ( R ) Boot Agent FE v4.1.16
Copyright (C) 1997-2004, Intel Corporation
Intel (R) Boot Agent PXE Base Code (PXE-2.1 build 084)
Copyright (C) 1997-2004, Intel Corporation
CLIENT MAC ADDR: 00 13 20 5A DC BC GUID: 8CE1188A CB63 11D9 9FB4 00E018820125
PXE-E53: No boot filename received
PXE-M0F: Exiting Intel Boot Agent.
```

If something like this happens, check all paths and network connections something is amiss!

Maybe the machine is on the wrong vlan or network interface or not plugged in, a share permission, typos, files in the wrong spot, etc, happens to the best of us... good luck.
