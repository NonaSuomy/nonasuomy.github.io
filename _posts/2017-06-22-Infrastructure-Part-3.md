---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3 - Hypervisor OS Setup
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVM.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

Part 03 - Hypervisor OS Setup - You Are Here!

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Underconstruction](../Infrastructure-Part-6)

[Part 07 - Underconstruction](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Hypervisor OS Setup #

### Connect To a Network ###

```
ip addr
dhcpcd eno1
 
ping google.ca
ping 8.8.8.8
```

### WiFi Connection ###

```
pacman -S dialog wpa_supplicant
wifi-menu
```

## Setup & Install ##

Turn off Nano’s word wrap default :S
# nano ~/.nanorc
set nowrap
Exit - Ctrl+X, Save - Y, File - <Enter>.

### Install sudo (May already be installed) ###

```
pacman -S sudo
```

### Make A New User ###

```
useradd -m -G wheel -s /bin/bash plebuser
```

### Set password for user ###

```
passwd plebuser
New password: 1337pleb
Retype new password: 1337pleb
passwd: password updated successfully
```

### Edit visudo ###

```
EDITOR=nano visudo
```

### Enable sudo for wheel group ###

Uncomment 

```
#%wheel ALL=(ALL) ALL
```
 
to

```
%wheel ALL=(ALL) ALL
```

### Change To New User Account ###

```
exit
Arch Linux 4.11.6-1ARCH (tty1)
login: plebuser
cd
```

### Install Virtual Machine Packages ###

Install libvirt, virt-manager, qemu, qemu-arch-extra, dmidecode, ovmf, openssh, ebtables, bridge-utils, openbsd-netcat, tcpdump
 
```
sudo pacman -S libvirt virt-manager qemu qemu-arch-extra dmidecode ovmf openssh ebtables bridge-utils openbsd-netcat tcpdump
```

### Add User To Virtual Machine Groups ###

```
sudo usermod -a -G kvm,libvirt nonasuomy
```

### Enable sshd Service ###

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

### Enable libvirtd Service ###

```
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```
 
### Change qemu running group from 78 to kvm ###
 
```
sudo sed -i s/78/kvm/ /etc/libvirt/qemu.conf
```
 
### Enable UEFI Booting of VMs ###
 
```
sudo nano /etc/libvirt/qemu.conf
nvram=["/usr/share/ovmf/ovmf_code_x64.bin:/usr/share/ovmf/ovmf_vars_x64.bin"]
```
 
### Setup A Windows Manager For Virt-Manager ###

i3-wm (Windows manager to use virt-manager)
 
```
sudo pacman -S xorg xorg-xinit i3-wm i3status i3lock dmenu ranger rxvt-unicode chromium firefox scrot
```

Hit <Enter> on any default option selections during install process.

#### Configure startx To Start i3-wm ####

```
echo "exec i3" >> ~/.xinitrc
startx
```

### i3 Wizard ###

i3 wizard will ask you two questions, Create the configuration YES , Select ALT for the MOD key 
(Otherwise it gets touchy if you have to use MSWin Boxes and you have the MOD key set to the Windows Key).
 
Push ALT+D for a menu of apps push page up/down to scroll through or just type a search like chromium when you install it.
 
ALT+ENTER for Terminal.
 
ALT+SHIFT+E exit i3 

### Next Part ###

Continue to [Part 04 - Virtual Router](../Infrastructure-Part-4)
