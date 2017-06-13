---
layout: post
title: Arch Linux Infrastructure Part 1
---

Switch Config
24 Port P.O.E. Switch H3C 4800G

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
 
 
 
 
