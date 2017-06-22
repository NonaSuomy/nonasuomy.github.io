---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3 - Hypervisor OS Setup
---

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

Part 03 - Hypervisor OS Setup - You Are Here!

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - Underconstruction](../Infrastructure-Part-5)

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

### Install sudo ###

```
pacman -S sudo
```

### Make A New User ###

```
useradd -m -G wheel kvm libvirt docker -s /bin/bash plebuser
```

### Set password for user ###

```
passwd plebuser
New password: 1337pleb
Retype new password: 1337pleb
passwd: password updated successfully
```

```
EDITOR=nano visudo
```

### Edit visudo ###

```
nano visudo
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
su plebuser
cd ~/
```

### Install Virtual Machine Packages ###

Install libvirt, virt-manager, qemu, dmidecode, ovmf, openssh, ebtables, bridge-utils, openbsd-netcat, tcpdump
 
```
sudo pacman -S libvirt virt-manager qemu dmidecode ovmf openssh ebtables bridge-utils openbsd-netcat tcpdump
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
sudo pacman -S xorg xorg-xinit i3-wm i3status i3lock dmenu ranger xrvt-unicode chromium firefox scrot
echo "exec i3" > ~/.xinitrc
startx
```

### i3 Wizard ###

i3 wizard will ask you two questions, reply ALT and then Yes to create the config file.
 
ALT D for menu of apps push page up/down to scroll through or just type a search like chromium when you install it.
 
ALT ENTER for Terminal.
 
ALT SHIFT E exit i3 


### PCI Passthrough For Wireless Access Point ###
 
```
sudo nano /etc/modprobe.d/modprobe.conf
options kvm_intel nested=1
```

#### Blacklist Intel Chipset ####

I have two wireless network cards, blacklist the Intel driver as were using an the atheros chipset.

```
sudo nano /etc/modprobe.d/blacklist.conf
blacklist iwlwifi
```

#### Check If IOMMU Is Enable ###

```
grep -E "vmx|svm" /proc/cpuinfo
dmesg | grep -iE "dmar|iommu"
```

#### Find Hardware ID ####

```
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0154] (rev 09)
00:02.0 VGA compatible controller [0300]: Intel Corporation 3rd Gen Core processor Graphics Controller [8086:0166] (rev 09)
00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C216 Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C216 Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C216 Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C216 Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4)
00:1c.1 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 [8086:1e12] (rev c4)
00:1c.2 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 [8086:1e14] (rev c4)
00:1c.3 PCI bridge [0604]: Intel Corporation 7 Series/C216 Chipset Family PCI Express Root Port 4 [8086:1e16] (rev c4)
00:1c.5 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6 [8086:1e1a] (rev c4)
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C216 Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation QM77 Express Chipset LPC Controller [8086:1e55] (rev 04)
00:1f.2 RAID bus controller [0104]: Intel Corporation 82801 Mobile SATA Controller [RAID mode] [8086:282a] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C216 Chipset Family SMBus Controller [8086:1e22] (rev 04)
02:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] [8086:0082] (rev 34)
0b:00.0 SD Host controller [0805]: O2 Micro, Inc. OZ600FJ0/OZ900FJ0/OZ600FJS SD/MMC Card Reader Controller [1217:8221] (rev 05)
```

Intel Hardware ID: 8086:0082

#### Enable Hardware ID For IOMMU In Bootloader ####

```
sudo nano /boot/loader/entries/arch.conf
title   Arch Linux BTRFS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=LABEL=ROOT rootflags=subvol=@ rw intel_iommu=on pci-stub.ids=8086:0082
```

Now we should be able to the WiFi Hardware in our VM for PCI-Passthrough.

Continue to [Part 04 - Virtual Router](../Infrastructure-Part-4)
