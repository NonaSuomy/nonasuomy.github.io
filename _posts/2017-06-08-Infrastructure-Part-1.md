---
layout: post
title: Arch Linux Infrastructure Part 1
---

==Switch Hardware==

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

===Factory Reset===

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

===Firmware Updates===

====FTP Method====

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

====TFTP Method====

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

===How to enable Web Interface===

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

Grab:

cfdisk /dev/sda
 * If previously used drive and you don't care about the data, use the delete partitions option.
 * New, Patition size: default size, primary, partition type: Linux (83).
 * Select Bootable.
 * Write, yes.
 * Quit.
 
 == Format the partition ==

mkfs.btrfs -L "Arch Linux" /dev/sda1

== Mount the partition ==

mkdir /mnt/btrfs-root
mount -o defaults,relatime,discard,ssd,nodev,nosuid /dev/sda1 /mnt/btrfs-root
mount -o defaults,relatime,discard,nodev,nosuid /dev/sda1 /mnt/btrfs-root

== Create the subvolumes ==

mkdir -p /mnt/btrfs-root/__snapshot
mkdir -p /mnt/btrfs-root/__current
btrfs subvolume create /mnt/btrfs-root/__current/root
btrfs subvolume create /mnt/btrfs-root/__current/home

== Mount the subvolumes ==

mkdir -p /mnt/btrfs-current

mount -o defaults,relatime,discard,ssd,nodev,subvol=__current/root /dev/sda1 /mnt/btrfs-current
mount -o defaults,relatime,discard,nodev,subvol=__current/root /dev/sda1 /mnt/btrfs-current
mkdir -p /mnt/btrfs-current/home

mount -o defaults,relatime,discard,ssd,nodev,nosuid,subvol=__current/home /dev/sda1 /mnt/btrfs-current/home
mount -o defaults,relatime,discard,nodev,nosuid,subvol=__current/home /dev/sda1 /mnt/btrfs-current/home
== Install Arch Linux ==

nano /etc/pacman.d/mirrorlist 
 * Select the mirror to be used

pacstrap /mnt/btrfs-current base base-devel
genfstab -U -p /mnt/btrfs-current >> /mnt/btrfs-current/etc/fstab
nano /mnt/btrfs-current/etc/fstab
 * copy the partition info for / and mount it on /run/btrfs-root (remember to remove subvol parameter! and add nodev,nosuid,noexec parameters)

== Configure the system ==
 
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

== Install boot loader ==

pacman -S grub-bios
grub-install --target=i386-pc --recheck /dev/sda
nano /etc/default/grub
 * Edit settings (e.g., disable gfx, quiet, etc.)
grub-mkconfig -o /boot/grub/grub.cfg

== Unmount and reboot ==

exit

umount /mnt/btrfs-current/home
umount /mnt/btrfs-current
umount /mnt/btrfs-root

reboot

== Post installation configuration ==

=== Power management ===

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

=== Hardening ===

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

=== Snapshot ===

echo `date "+%Y%m%d-%H%M%S"` > /run/btrfs-root/__current/ROOT/SNAPSHOT
echo "Fresh install" >> /run/btrfs-root/__current/ROOT/SNAPSHOT
btrfs subvolume snapshot -r /run/btrfs-root/__current/ROOT /run/btrfs-root/__snapshot/ROOT@`head -n 1 /run/btrfs-root/__current/ROOT/SNAPSHOT`
cd /run/btrfs-root/__snapshot/
ln -s ROOT@`cat /run/btrfs-root/__current/ROOT/SNAPSHOT` fresh-install
rm /run/btrfs-root/__current/ROOT/SNAPSHOT 

==== Software Installation ===
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
 
 
 
 
