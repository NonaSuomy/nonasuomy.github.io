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

```
startx
```

alt+<enter>

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
Name: ISO
Type: dir:Filesystem Directory
```

Click Forward

```
Add a New Storage Pool
Create storage pool
Step 2 of 2

Target Path: /var/lib/libvirt/images/ISO
```

Click Finish

Now you should see the ISO storage pool on the left, click it.

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
  20.0 - + GiB
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
Storage: 20.0 GiB /var/lib/libvirt/images/VirtualRouter.qcow2
X Customize configuration before install

Network selection
* Specify shared device name
  Bridge name: brv500
```

Click Finish

Now you should see the full virtual machine settings window.

add more network interfaces! BRB!

Add stuff here for setting up vm...


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
 
Continue to [Part 05 - Underconstruction](../Infrastructure-Part-5)
