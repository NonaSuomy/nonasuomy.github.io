---
layout: post
title: Arch Linux Infrastructure - VoIP Server - Part 5 - VoIPServer
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVoIP.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router ](../Infrastructure-Part-5)

Part 05 - VoIP Server - You Are Here!

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

Alt + Enter

### Change Directory To Hypervisor Media Installs ###

```
cd /var/lib/libvirt/images/iso
```

### Download Install Media ###

### Find the latest version ### 

#### PIAF ####

**Note:** *This won't work for a UEFI install use manual install of Scientific Linux 7*

https://sourceforge.net/projects/pbxinaflash/files/

```
sudo wget https://downloads.sourceforge.net/project/pbxinaflash/IncrediblePBX13-12%20with%20Incredible%20PBX%20GUI/IncrediblePBX13.2.iso
```

#### Scientific Linux 7 ####

http://ftp1.scientificlinux.org/linux/scientific/7x/x86_64/iso/

```
sudo wget http://ftp1.scientificlinux.org/linux/scientific/7x/x86_64/iso/SL-7.3-x86_64-netinst.iso
```

### Verify Interfaces Have Been Created ###

Check that we have the interfaces brv500 and eno1.500 from the previous step setup (Voice VLAN). 

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

Then click your Scentific Linux 7 ISO.

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
Name: VoIPServer
OS: Generic
Install: Local CDROM/ISO
Memory: 1024 MiB
CPUs: 1
Storage: 10.0 GiB /var/lib/libvirt/images/VirtualRouter.qcow2
X Customize configuration before install

Network selection
* Specify shared device name
  Bridge name: brv500
```

Click the checkmark on "Customize configuration before install".

Click the "Network selection" drop down arrow.

Click the Dropdown Box and select "Specify shared device name"

Bridge name: brv500

Click Finish

Now you should see the full virtual machine settings window.

```
VoIPServer on QEMU/KVM
Begin Installation    Cancel Installaion

Overview
CPUs
Memory
Boot Options
IDE Disk 1
IDE CDROM 1
NIC :fe:ed:50
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
   Name: VoIPServre
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
archlinux-2017.06.01-x86_64.iso           488.00 MiB   iso
IncrediblePBX13.2.iso                     849.00 MiB   iso
OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso   858.43 MiB   iso
pfSense-CE-2.3.4-RELEASE-amd64.iso        626.79 MiB   iso
```

Click on Scientific Linux iso then click Choose Volume

Click OK

```
Virual Disk
  Sorce path: /var/lib/libvirt/images/iso/SL-7.3-x86_64-netinst.iso  Disconnect
  Device type: IDE CDROM 1
  Storage size: 858.43 MiB
  Readonly: X
  Shareable:
```

Make sure the IDE CDROM 1 is at the top of the Boot device order.

Click on NIC :xx:xx:50

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv500
Device model: virtio
MAC address: X 42:de:ad:fe:ed:50
```

Click Apply.

We just setup this virtual machine interface so that is uses the Voice VLAN bridge setup prior.

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

Click your language preference.

Click Continue.

Under System click Network & Host Name.

Click Ethernet (eth0) ON.

Host name: voipserv.localdomain click apply.

Click Done.

Click Software Selection Minimal install.

Click Done.

Under System click Installation Destination.

Select your vitual disk ATA QEMU HARDDISK.

Leave Automatically configure partitioning.

Click Done.

Click Begin Installation.

Under User Settings click Root Password.

Set your root password.

Click Done.

Click User Creation.

Setup a regular user with administration permissions checked.

Wait for install to finish...

Click Reboot.

The machine will power off.

Click the Light Bulb (Show virtual hardware details).

Click on "Boot Options" and change the order "IDE Disk 1" to be first and Disconnect the "IDE CDROM 1" mounted iso.
 
```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE Disk 1
  X IDE CDROM 1
  NIC :fe:ed:50
  ...
```
Click Apply.

Click IDE CDROM 1.

```
Virtual Disk
   Source path: /var/lib/libvirt/images/iso/SL-7.3-x86_64-netinst.iso   Disconnect
```

Click Disconnect.

Click Show the graphical console.

Click Play button "Power on the virtual machine" again.

You will now be at the login console.

```
Scientific Linux 7.3 (Nitrogen)
Kernel 3.10.0-514.26.1.e17.x86_64 on an x86_64

voipserv login:
```

Type root and the password you setup in the install process.

```
voipserv login: root
Password: PlebMast0r
[root@voipserv ~]#
```

### Install some tools and updates/patch ###

```
setenforce 0
yum -y install net-tools nano wget tar
yum -y upgrade --skip-broken

# decipher your server's IP address
ifconfig

# patch grub and ignore errors if your server doesn't use it
sed -i 's|quiet|quiet net.ifnames=0 biosdevdame=0|' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# for older CentOS/SL 6.7 platforms, perform 3 steps below:
#wget http://incrediblepbx.com/update-kernel-devel
#chmod +x update-kernel-devel
#./update-kernel-devel

reboot
```

### Install IncrediblePBX13 ###

```
cd /root
wget http://incrediblepbx.com/incrediblepbx13-12.2-centos.tar.gz
tar zxvf incrediblepbx*
./create-swapfile-DO
./IncrediblePBX*
```

The Incredible PBX installer runs unattended so find something to do for the next 30-60 minutes unless you just like watching over 1000 packages install. When the installation is complete, reboot your server and log back in as root. You should be greeted by something like the status of the major apps as well as your free RAM and DISK space and IP.

### Finalization ###

```
Make your root password very secure: passwd
Create admin password for GUI access: /root/admin-pw-change
Set your correct time zone: /root/timezone-setup
Create admin password for web apps: htpasswd /etc/pbx/wwwpasswd admin
Make a copy of your Knock codes: cat /root/knock.FAQ
Decipher IP address and other info about your server: status
```

