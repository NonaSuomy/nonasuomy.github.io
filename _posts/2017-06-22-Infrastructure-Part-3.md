---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3 - Hypervisor OS Setup
---

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

## Setup Network VLAN interfaces ##

### Hardware NIC interface eno1 ###
 
10-eno1.network
 
```
sudo nano /etc/systemd/network/10-eno1.network
[Match]
Name=eno1
 
[Network]
VLAN=eno1.100
VLAN=eno1.200
VLAN=eno1.300
VLAN=eno1.400
VLAN=eno1.450
VLAN=eno1.500
```
 
### WAN VLAN 100 ###

eno1.100.netdev

```
sudo nano /etc/systemd/network/eno1.100.netdev
[NetDev]
Name=eno1.100
Kind=vlan
 
[VLAN]
Id=100
```

eno1.100.network

```
sudo nano /etc/systemd/network/eno1.100.network
[Match]
Name=eno1.100
 
[Network]
Bridge=brv100
```

brv100.netdev

```
sudo nano /etc/systemd/network/brv100.netdev
[NetDev]
Name=brv100
Kind=bridge
```

brv100.network

```
sudo nano /etc/systemd/network/brv100.network
[Match]
Name=brv100
 
[Network]
```
 
### LAN VLAN 200 ###

eno1.200.netdev

```
sudo nano /etc/systemd/network/eno1.200.netdev
[NetDev]
Name=eno1.200
Kind=vlan
 
[VLAN]
Id=200
```

eno1.200.network

```
sudo nano /etc/systemd/network/eno1.200.network
[Match]
Name=eno1.200
 
[Network]
Bridge=brv200
```

brv200.netdev

```
sudo nano /etc/systemd/network/brv200.netdev
[NetDev]
Name=brv200
Kind=bridge
```

brv200.network

**Note:** *Setting DHCP=yes here gives the hypervisor a network connection from our LAN VLAN 200 so it can do updates and install software.*

```
sudo nano /etc/systemd/network/brv200.network
[Match]
Name=brv200
 
[Network]
DHCP=yes
```
 
### Automation VLAN 300 ###

eno1.300.netdev

```
sudo nano /etc/systemd/network/eno1.300.netdev
[NetDev]
Name=eno1.300
Kind=vlan
 
[VLAN]
Id=300
```

eno1.300.network

```
sudo nano /etc/systemd/network/eno1.300.network
[Match]
Name=eno1.300
 
[Network]
Bridge=brv300
```

brv300.netdev

```
sudo nano /etc/systemd/network/brv300.netdev
[NetDev]
Name=brv300
Kind=bridge
```

brv300.network

```
sudo nano /etc/systemd/network/brv300.network
[Match]
Name=brv300
 
[Network]
```
 
### GUEST WiFi VLAN 400 ###

eno1.400.netdev

```
sudo nano /etc/systemd/network/eno1.400.netdev
[NetDev]
Name=eno1.400
Kind=vlan
 
[VLAN]
Id=400
```

eno1.400.network

```
sudo nano /etc/systemd/network/eno1.400.network
[Match]
Name=eno1.400
 
[Network]
Bridge=brv400
```

brv400.netdev

```
sudo nano /etc/systemd/network/brv400.netdev
[NetDev]
Name=brv400
Kind=bridge
```

brv400.network

```
sudo nano /etc/systemd/network/brv400.network
[Match]
Name=brv400
 
[Network]
```
 
### Main WiFi 450 ###

eno1.450.netdev

```
sudo nano /etc/systemd/network/eno1.450.netdev
[NetDev]
Name=eno1.450
Kind=vlan
 
[VLAN]
Id=850
```

eno1.450.network

```
sudo nano /etc/systemd/network/eno1.450.network
[Match]
Name=eno1.450
 
[Network]
Bridge=brv450
```

brv450.netdev

```
sudo nano /etc/systemd/network/brv450.netdev
[NetDev]
Name=brv450
Kind=bridge
```

brv450.network

```
sudo nano /etc/systemd/network/brv450.network
[Match]
Name=brv450
 
[Network]
```
 
### Voice VLAN 500 ###
 
```
sudo nano /etc/systemd/network/eno1.500.netdev
[NetDev]
Name=eno1.500
Kind=vlan
 
[VLAN]
Id=500
```

eno1.500.network

```
sudo nano /etc/systemd/network/eno1.500.network
[Match]
Name=eno1.500
 
[Network]
Bridge=brv500
```

brv500.netdev

```
sudo nano /etc/systemd/network/brv500.netdev
[NetDev]
Name=brv500
Kind=bridge
```

brv500.network

```
sudo nano /etc/systemd/network/brv500.network
[Match]
Name=brv500
 
[Network]
```

### Enable systemd-networkd Service ###

**Note:** *Don't enable and start this if you still need to setup your virtual router*

```
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
```

Link to part 4
 
< To be continued... >
 
VM Guest Virtual Router: pfSense or OPNsense or Custom
 
VM Guest Automation Server: OpenHAB
 
VM Guest PBX Server: PIAF
 
VM Guest TOR Server: TOR (Remote)
 
VM Guest Fileserver: FreeNAS or ETC.
 
