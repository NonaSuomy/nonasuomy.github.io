---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 4 - Virtual Router
---

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

Part 04 - Virtual Router - You Are Here!

[Part 05 - Underconstruction](../Infrastructure-Part-5)

[Part 06 - Underconstruction](../Infrastructure-Part-6)

[Part 07 - Underconstruction](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Virtual Router Setup #

## Start i3-WM ##

```
startx
```

### Open Terminal (urxvt) ###

Alt + <Enter>

### Make ISO Directory For Hypervisor Media Installs ###

```
sudo mkdir /var/lib/libvirt/images/iso
cd /var/lib/libvirt/images/iso
```

### Download Some Install Media ###

```
sudo pacman -S wget
```

### Find the latest version ### 

#### pfSense ####

https://nyifiles.pfsense.org/mirror/downloads/

```
sudo wget https://nyifiles.pfsense.org/mirror/downloads/pfSense-CE-2.3.4-RELEASE-amd64.iso.gz
```

#### OPNsense ####

http://mirrors.nycbug.org/pub/opnsense/releases/mirror/

```
sudo wget http://mirrors.nycbug.org/pub/opnsense/releases/mirror/OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso.bz2
```

#### PIAF ####

https://sourceforge.net/projects/pbxinaflash/files/

```
sudo wget https://downloads.sourceforge.net/project/pbxinaflash/IncrediblePBX13-12%20with%20Incredible%20PBX%20GUI/IncrediblePBX13.2.iso
```

#### Arch Linux ####

http://mirror.rackspace.com/archlinux/iso/

```
sudo wget http://mirror.rackspace.com/archlinux/iso/2017.06.01/archlinux-2017.06.01-x86_64.iso
```

Grab any other distribution install media you require for your hypervisor...

**Caution:** *you will no longer have interenet access after this part so make sure you have everything you need :)*

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

### Verify Interfaces Have Been Created ###

```
ip addr
```

...



### Start virt-manager ###

Alt + D then type virt-manager <Enter>

If you added your user to the libvirt and kvm user groups in the prior document it will show up with the vm connection already made. If not you will have to use sudo virt-manager in the console then add the connection manually like below.

```
sudo virt-manager
```

virt-manager should now be on screen...

Click File => Add Connection...

Hypervisor: QEMU/KVM
Leave "Connect to remote host" unchecked if on local hypervisor.
Autoconnect: Check
Generated URI: qemu:///system

Click Connect

Now you should be connected to your hypervisor.

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

```
Choose Storage Volume
```

On the left bottom click the +

```
Add a New Storage Pool
Create storage pool
Step 1 of 2

Select the storage pool type you would like to configure.
Name: iso
Type: dir:Filesystem Directory
```

Click Forward

```
Add a New Storage Pool
Create storage pool
Step 2 of 2

Target Path: /var/lib/libvirt/images/iso
```

Click Finish

Now you should see the iso storage pool on the left, click it.

Then click your Virtual Router ISO.

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
  10.0 - + GiB
  100 GiB available in the default location
* Select or create custom storage
  Manage...
```

Click Forward

```
New VM
Create a new virtual machine
Step 5 of 5

Ready to begin the installation
Name: VirtualRouter
OS: Generic
Install: Local CDROM/ISO
Memory: 1024 MiB
CPUs: 1
Storage: 10.0 GiB /var/lib/libvirt/images/VirtualRouter.qcow2
X Customize configuration before install

Network selection
* Specify shared device name
  Bridge name: brv100
```

Click Finish

Now you should see the full virtual machine settings window.

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv100
Device model: virtio
MAC address: X 42:de:ad:be:ef:10
```

**Note:** *Changing the MAC to something you can recognise makes it easier to sort out in the VM Virtual Router we will see that :10 and know it's for our wan connection and is vlan 100 :20 is our LAN VLAN 200 etc.

Click Apply.

Click Add Hardware in the lower left.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv200
MAC address: X 42:de:ad:be:ef:20
Device model: virtio
```

Click Finish.

Click Add Hardware in the lower left again.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv300
MAC address: X 42:de:ad:be:ef:30
Device model: virtio
```

Click Finish.

Click Add Hardware in the lower left again.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv400
MAC address: X 42:de:ad:be:ef:40
Device model: virtio
```

Click Finish.

Click Add Hardware in the lower left again.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv450
MAC address: X 42:de:ad:be:ef:45
Device model: virtio
```

Click Finish.

Click Add Hardware in the lower left again.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv500
MAC address: X 42:de:ad:be:ef:50
Device model: virtio
```

Click Finish.

Click Add Hardware in the lower left again.

```
Add New Virtual Hardware
Network
Network source: Specify shared device name
                Bridge name: brv600
MAC address: X 42:de:ad:be:ef:60
Device model: virtio
```

Click Finish.

Click button in the top right of window.

We just setup all the virtual machine interfaces and attached them to their corrisponding VLAN bridges for the Virtual Router to handle all the traffic.

Click on CPUs at the left.

Click the Copy host CPU configuration check box.

Finally click "Begin Installation" at the top left.


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

< To be continued... >

Continue to [Part 05 - Underconstruction](../Infrastructure-Part-5)

VM Guest PBX Server: PIAF

VM Guest Automation Server: OpenHAB
 
VM Guest TOR Server: TOR (Remote)
 
VM Guest Fileserver: FreeNAS or ETC.
 

