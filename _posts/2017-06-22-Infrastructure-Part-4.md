---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 4 - Virtual Router
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutFW.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

Part 04 - Virtual Router - You Are Here!

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

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

**Tip:** *If you want your right IP showing in the i3status bar "E: no IP (1000 Mbit/s)" edit /etc/i3status.conf*
```
sudo nano /etc/i3status.conf 
```

```
order += "ipv6"
order += "disk /"
order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "load"
order += "tztime local"

ethernet _first_ {
        # if you use %speed, i3status requires root privileges
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
}
```

Change to

```
order += "ipv6"
order += "disk /"
order += "wireless _first_"
order += "ethernet brv200"
order += "battery all"
order += "load"
order += "tztime local"

ethernet brv200 {
        # if you use %speed, i3status requires root privileges
        format_up = "E: %ip (10 Gbit/s)"
        format_down = "E: down"
}
```

Now in the i3status bar you should see your IP address getting dhcp inception from the virtual router if it was setup properly and working.

```
xx##::#x:#xxx:xx#x:#### | 9001 TiB | W: down | E: 192.168.1.100 (10 Gbit/s) | Fully Charged  | 1.18 | 2017-06-28 19:48:50
```

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

**Note:** *RELEASE only works with Firmware: BIOS mode not UEFI!* :(

[https://nyifiles.pfsense.org/mirror/downloads/](https://nyifiles.pfsense.org/mirror/downloads/)

```
sudo wget https://nyifiles.pfsense.org/mirror/downloads/pfSense-CE-2.3.4-RELEASE-amd64.iso.gz
sudo gunzip pfSense-CE-2.3.4-RELEASE-amd64.iso.gz
```

**Note:** *pfSense 2.4 BETA works with Firmware: UEFI.* 

[https://snapshots.pfsense.org/amd64/pfSense_master/installer/?C=M;O=D](https://snapshots.pfsense.org/amd64/pfSense_master/installer/?C=M;O=D)

```
sudo wget https://snapshots.pfsense.org/amd64/pfSense_master/installer/pfSense-CE-2.4.0-BETA-amd64-latest.iso.gz
sudo gunzip pfSense-CE-2.4.0-BETA-amd64-latest.iso.gz
```

#### OPNsense ####

[http://mirrors.nycbug.org/pub/opnsense/releases/mirror/](
http://mirrors.nycbug.org/pub/opnsense/releases/mirror/)

```
sudo wget http://mirrors.nycbug.org/pub/opnsense/releases/mirror/OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso.bz2
sudo bzip2 -d OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso.bz2
```

#### PIAF ####

[https://sourceforge.net/projects/pbxinaflash/files/](https://sourceforge.net/projects/pbxinaflash/files/)

```
sudo wget https://downloads.sourceforge.net/project/pbxinaflash/IncrediblePBX13-12%20with%20Incredible%20PBX%20GUI/IncrediblePBX13.2.iso
```

#### Arch Linux ####

[http://mirror.rackspace.com/archlinux/iso/](http://mirror.rackspace.com/archlinux/iso/)

```
sudo wget http://mirror.rackspace.com/archlinux/iso/2017.06.01/archlinux-2017.06.01-x86_64.iso
```

Grab any other distribution install media you require for your hypervisor...

**Caution:** *you will no longer have interenet access after this part until you get the vm router working, so make sure you have everything you need. :)*

## Setup Network VLAN interfaces ##

Heres a bash script to create all the interfaces below, run with ```sudo sh networkcfgs.sh``` [Script Download](https://gist.github.com/NonaSuomy/260059a998181b9fb975fe373eb34ef2)

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
Id=450
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

**Note:** *Don't enable and start this if you still need to setup your virtual router.*

```
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
```

### Verify Interfaces Have Been Created ###

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

### Configure qemu.conf and libvirtd.conf ###

Change these settings so your local user can login without sudo.

```
sudo nano /etc/libvirt/qemu.conf

# The user for QEMU processes run by the system instance. It can be
# specified as a user name or as a user id. The qemu driver will try to
# parse this value first as a name and then, if the name doesn't exist,
# as a user id.
#
# Since a sequence of digits is a valid user name, a leading plus sign
# can be used to ensure that a user id will not be interpreted as a user
# name.
#
# Some examples of valid values are:
#
#       user = "qemu"   # A user named "qemu"
#       user = "+0"     # Super user (uid=0)
#       user = "100"    # A user named "100" or a user with uid=100
#
user = "root"

# The group for QEMU processes run by the system instance. It can be
# specified in a similar way to user.
group = "root"
```


```
sudo nano /etc/libvirt/libvirtd.conf

# Network connectivity controls
#

# Flag listening for secure TLS connections on the public TCP/IP port.
# NB, must pass the --listen flag to the libvirtd process for this to
# have any effect.
#
# It is necessary to setup a CA and issue server certificates before
# using this capability.
#
# This is enabled by default, uncomment this to disable it
listen_tls = 0

#################################################################
#
# UNIX socket access controls
#

# Set the UNIX domain socket group ownership. This can be used to
# allow a 'trusted' set of users access to management capabilities
# without becoming root.
#
# This is restricted to 'root' by default.
unix_sock_group = "libvirt"

# Set the UNIX socket permissions for the R/O socket. This is used
# for monitoring VM status only
#
# Default allows any user. If setting group ownership, you may want to
# restrict this too.
unix_sock_ro_perms = "0777"

# Set the UNIX socket permissions for the R/W socket. This is used
# for full management of VMs
#
# Default allows only root. If PolicyKit is enabled on the socket,
# the default will change to allow everyone (eg, 0777)
#
# If not using PolicyKit and setting group ownership for access
# control, then you may want to relax this too.
unix_sock_rw_perms = "0770"


# Set the UNIX socket permissions for the admin interface socket.
#
# Default allows only owner (root), do not change it unless you are
# sure to whom you are exposing the access to.
#unix_sock_admin_perms = "0700"

# Set the name of the directory in which sockets will be found/created.
unix_sock_dir = "/var/run/libvirt"

#################################################################
#
# Authentication.
#
#  - none: do not perform auth checks. If you can connect to the
#          socket you are allowed. This is suitable if there are
#          restrictions on connecting to the socket (eg, UNIX
#          socket permissions), or if there is a lower layer in
#          the network providing auth (eg, TLS/x509 certificates)
#
#  - sasl: use SASL infrastructure. The actual auth scheme is then
#          controlled from /etc/sasl2/libvirt.conf. For the TCP
#          socket only GSSAPI & DIGEST-MD5 mechanisms will be used.
#          For non-TCP or TLS sockets, any scheme is allowed.
#
#  - polkit: use PolicyKit to authenticate. This is only suitable
#            for use on the UNIX sockets. The default policy will
#            require a user to supply their own password to gain
#            full read/write access (aka sudo like), while anyone
#            is allowed read/only access.
#
# Set an authentication scheme for UNIX read-only sockets
# By default socket permissions allow anyone to connect
#
# To restrict monitoring of domains you may wish to enable
# an authentication mechanism here
auth_unix_ro = "none"

# Set an authentication scheme for UNIX read-write sockets
# By default socket permissions only allow root. If PolicyKit
# support was compiled into libvirt, the default will be to
# use 'polkit' auth.
#
# If the unix_sock_rw_perms are changed you may wish to enable
# an authentication mechanism here
auth_unix_rw = "none"


# Listen for unencrypted TCP connections on the public TCP/IP port.
# NB, must pass the --listen flag to the libvirtd process for this to
# have any effect.
#
# Using the TCP socket requires SASL authentication by default. Only
# SASL mechanisms which support data encryption are allowed. This is
# DIGEST_MD5 and GSSAPI (Kerberos5)
#
# This is disabled by default, uncomment this to enable it.
listen_tcp = 1

# Override the default configuration which binds to all network
# interfaces. This can be a numeric IPv4/6 address, or hostname
#
# If the libvirtd service is started in parallel with network
# startup (e.g. with systemd), binding to addresses other than
# the wildcards (0.0.0.0/::) might not be available yet.
#
#listen_addr = "192.168.0.1"
listen_addr = "0.0.0.0"

# Change the authentication scheme for TCP sockets.
#
# If you don't enable SASL, then all TCP traffic is cleartext.
# Don't do this outside of a dev/test scenario. For real world
# use, always enable SASL and use the GSSAPI or DIGEST-MD5
# mechanism in /etc/sasl2/libvirt.conf
#auth_tcp = "sasl"
auth_tcp = "none"
```

If you start virt-manager without sudo and it gives you "failed to initialize KVM: Permission denied" error try this:

```
sudo rmmod kvm_intel
sudo rmmod kvm
sudo modprobe kvm
sudo modprobe kvm_intel
```

The above commands reload the kvm_intel and kvm kernel modules.


### Start virt-manager ###

```
sudo virt-manager
```

virt-manager should now be on screen...

**Note:** *If we don't connect to 0.0.0.0 (local machine) it will make the vm but you won't be able to see the vnc session.*

Click File => Add Connection...

Hypervisor: QEMU/KVM
X Connect to remote host
Method: SSH
Username: root
Hostname: 0.0.0.0
Autoconnect: Check
Generated URI: qemu+ssh://root@0.0.0.0/system

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
FirewallRouter on QEMU/KVM
Begin Installation    Cancel Installaion

Overview
CPUs
Memory
Boot Options
IDE Disk 1
IDE CDROM 1
NIC :be:ef:10
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
   Name: FirewallRouter
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

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv100
Device model: virtio
MAC address: X 42:de:ad:be:ef:10
```

**Note:** *Changing the MAC to something you can recognise makes it easier to sort out in the VM Virtual Router we will see that :10 and know it's for our wan connection and is vlan 100 :20 is our LAN VLAN 200 etc.*

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

We just setup all the virtual machine interfaces and attached them to their corrisponding VLAN bridges for the Virtual Router to handle all the traffic.

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

Click on Boot Options.

```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE CDROM 1
  X IDE Disk 1
  NIC :be:ef:50
  ...
V Direct kernel boot
  Enable direct kernel boot
  Kernel path:
  Initrd path:
  Kernel args:
```

Click on IDE CDROM 1.

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

Click on Connect.

```
Choose Media
Choose Source Device or File
  X ISO Image Location
    Location: Browse
  CD-ROM or DVD
    Device Media: No device present
```

Click on Browse.

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

Click on pfSense or OPNsense iso then click Choose Volume.

Click OK.

```
Virual Disk
  Sorce path: ...irt/images/iso/pfSense...iso Disconnect
  Device type: IDE CDROM 1
  Storage size: 858.43 MiB
  Readonly: X
  Shareable:
```

Make sure the IDE CDROM 1 is at the top of the Boot device order.

Click on Display Spice.

```
Spice Server
  Type: Spice server
```

Change to VNC server.

```
VNC Server
  Type: VNC server
  Listen type: Address
  Address: All interfaces
  Port: X Auto
  Password: 
  Keymap:
```

Finally click "Begin Installation" at the top left.

After installation is finished, power off the VM then click on "Boot Options" and change the order "IDE Disk 1" to be first and Disconnect the "IDE CDROM 1" mounted iso.
 
```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE Disk 1
  X IDE CDROM 1
  NIC :be:ef:50
  ...
```

Click Show graphical console then click Power on the virtual machine.

```
pfSense/OPNsense Installer

Welcome

Welcome to pfSense/OPNsense! Would ou like to begin an installation or use th Rscue Shell?

Install   Rescue Shell
```

Click Install.

```
pfSense/OPNsense Installer

Keymap Selection

The system console driver for pfSense/OPNsense defaults to standard "US" keyboard map.  Other keymaps can be chosen below.

>>> Continue with default keymap
...
```

Click Continue with default keymap if that is your correct keymap.

```
pfSense/OPNsense Installer

Paritioning

How would you like to partition your disk?

Auto (UFS) Guided Disk Setup
Manual      Manual Disk Setup (experts)
Shell           Open a shell and parition by hand
Auto (ZFS) Guided Root-on-ZFS

OK   Cancel
```

Click on Auto (UFS) Guided Disk Setup.

```
pfSense/OPNsense Installer

Partition

Would you like to use this entire disk (ada0) for pfSense/OPNsense or partition it to share it with other operating systems?  Using the entire disk will erase any data currently stored there.

Entire Disk   Partition
```

Click on Entire Disk.

```
pfSense/OPNsense Installer

Partition Scheme

Select a partition scheme for this volume:

APM    Apple Partition Map
BSD     BSD Labels
GPT     GUID Partition Table
MBR    DOS Partitions
PC98   NEC PC9801 Partition Table
VTOC8 Sun VTOC8 Partition Table

OK   Cancle
```

Click GPT GUID Partition Table.

```
pfSense/OPNsense Installer

Partition Editor

Please review the disk setup.  When complete, press the Finish button.

ada0               10 GB     GPT
    ada0p1       200 MB  efi
    ada0p2       9.3 GB    freebsd-ufs      /
    ada0p3       512 MB  freebsd-swap  none

Create   Delete   Modify   Revert   Auto   Finish
```

Click Finish.

Click Confirm.

```
pfSense/OPNsense Installer

Manual Configuration

The installation is now finished.  Before exiting the installer, would you like to open a shell in the new system to make an final manual modifications?

Yes   No
```

Click No.

```
pfSense/OPNsense Installer

Complete

Installation of pfSense/OPNsense complete!  Would you like to reboot ino the installed system now?

Reboot   Shell
```

Click Reboot.

Click the Light Bulb (Show virtual hardware details).

Click Boot Options.

Change the boot order to make IDE Disk 1 first.

```
Autostart
   X Start virtual machine on host boot up
Boot device order
   X Enable boot menu
   X IDE Disk 1
   X IDE CDROM 1
```

Click IDE CDROM 1.

```
Virtual Disk
   Source path: /var/lib/libvirt/images/iso/pfSense-CE-2.4.0-BETA-amd64-latest.iso Disconnect
```

Click Disconnect.

Click Show the graphical console.

Click power on the virtual machine again.

```
Welcome to pfSense 2.4.0-BETA...

No core dumps found.
...ELF ldconfig path: /lib /usr/lib /usr/lib/compat /usr/local/lib /usr/local/lib/ipsec /usr/local/lib/perl5/5.24/mach/CORE
32-bit compatibility ldconfig path:
done.
uhub0: 2 ports with 2 removable, self powered
uhub1: 2 ports with 2 removable, self powered
uhub2: 2 ports with 2 removable, self powered
Extenal config loader 1.0 is now starting...
Launching the init system....... done.
Initializing............................done.
Starting device manager (devd)...done.
Loading configuration......done.

Default interfaces not found -- Running interface assignment option.
vtnet0: link state changed to UP
vtnet1: link state changed to UP
vtnet2: link state changed to UP
vtnet3: link state changed to UP
vtnet4: link state changed to UP
vtnet5: link state changed to UP

Valid interfaces are:

vtnet0 42:de:ad:be:ef:10 (down) VirtIO Networking Adapter
vtnet1 42:de:ad:be:ef:20 (down) VirtIO Networking Adapter
vtnet2 42:de:ad:be:ef:30 (down) VirtIO Networking Adapter
vtnet3 42:de:ad:be:ef:40 (down) VirtIO Networking Adapter
vtnet4 42:de:ad:be:ef:45 (down) VirtIO Networking Adapter
vtnet5 42:de:ad:be:ef:50 (down) VirtIO Networking Adapter

Do VLANs need to be set up first?
If VLANs will not be used, or only for optional interfaces, it is typical to say no here and use the webConfiguraor to configure VLANs late, if required.

Should VLANs be set up now [y|n]?
```

Type: n 
enter

```
If the names of the interfaces are not known, auto-detection can be used instead.  To use auto-detection, please disconnect all interfaces before pressing 'a' to begin the process.

Enter the WAN interface name or 'a' for auto-detection
(vtnet0 vtnet1 vtnet2 vtnet3 vtnet4 vtnet5 or a):
```

Type: vtnet0

```
Enter the LAN interface name or 'a' for auto-detection
NOTE: this enables full Firewalling/NAT mode.
(vtnet1 a or nothing if finished):
```

Type: vtnet1

```
Enter the Optional 1 interface name or 'a' for auto-detection
( a or nothing if finshed):
```

Type: vtnet2

```
Enter the Optional 2 interface name or 'a' for auto-detection
( a or nothing if finshed):
```

Type: vtnet3

```
Enter the Optional 3 interface name or 'a' for auto-detection
( a or nothing if finshed):
```

Type: vtnet4

```
Enter the Optional 4 interface name or 'a' for auto-detection
( a or nothing if finshed):
```

Push Enter

```
The interfaces will be assigned as follows:

WAN  -> vtnet0
LAN   -> vtnet1
OPT1   -> vtnet2
OPT2   -> vtnet3
OPT3   -> vtnet4
OPT4   -> vtnet5

Do you want to proceed [y|n]?
```

Type: y

```
...done.
pfSense 2.4.0-BETA amd64 Tue Jun 27 14:43:48 CDT 2017
Bootup complete

FreeBSD/amd64 (pfSense.localdomain) (ttyv0)

*** Welcome to pfSense 2.4.0-BETA (amd64) on pfSense ***

WAN (wan)  ->  vtnet0  -> v4/DHCP4:  XXX.XXX.XXX.XXX/24
LAN (lan)  ->  vtnet1  -> v4:  192.168.1.1/24
OPT1 -> vtnet2
OPT2 -> vtnet3
OPT3 -> vtnet4
OPT4 -> vtnet5

0) Logout (SSH only)                                 9) pfTop  
1) Assign Interfaces                                10) Filter Logs
2) Set interface(s) IP address                 11) Restart webConfigurator
3) Reset webConfigurator password    12) PHP shell + pfSense tools
4) Reset to facory defaults                      13) Update from console
5) Reboot system                                      14) Enable Secure Shell (sshd)
6) Hal system                                             15) Restore recent configuration
7) Ping host                                                16) Restore PHP-FPM
8) Shell

Enter an option:
```

From this point you should have internet access on your Hypervisor through the virtual bridge brv200.

Load up the web browser of choice and hit your Virtual Router IP 192.168.1.1 (We're going to change this address now).
You will have to hit the new IP after this in your browser 10.0.0.1.

**Note:** *There is a glitch in the network drivers for VM where we have to disable all the hardware offloading, otherwise you will be able to ping stuff (8.8.8.8 google.com) but you won't be able to actually hit a website.*

Click System => Advanced => Networking.

There are 3 checkmarks here we have to make sure are checked!

```
Network Interfaces
  Device polling: (Unchecked)
  Hardware Checksum Offloading: (Checked)
  Hardware TCP Segmentation Offloading (Checked)
  Hardware Large Receive Offloading (Checked)
  ARP Handling: (Unchecked)
```

The only one for me unchecked that required checking was "Hardware Checksum Offloading".

Carry on...

Click Interfaces => [LAN].

Change IPv4 address.

```
Static IPv4 configuration
 IPv4 address 10.0.0.1/24 
```

Click Save.

Click Services => DHCP => Server.

```
Range   from	            to
              10.0.0.50    10.0.0.200
```

I leave 50 address at the start of the range and 54 at the end for DHCP Static use.

Click Save.

Apply changes.

Save any work and reboot your Hypervisor!

```
startx
```

You should now have a 10.0.0.51 address or similar on your hypervisor.

Run your browser of choice.

(Alt+d type chromium/firefox/etc)

Hit the new address for the virtual router http://10.0.0.1

Enable all the OPT interfaces.

Interfaces => OPT1,OPT2,OPT3,OPT4.

```
General configuration
 Enable
 (Checkmark) Enable Interface
``` 

```
OPT1
Description: IoT
IPv4 Configuration Type: Static IPv4
Static IPv4 configuration -  IPv4 address : 10.0.1.1/24
Save

OPT2
Description: WiFi Main
IPv4 Configuration Type: Static IPv4
Static IPv4 configuration -  IPv4 address : 10.0.2.1/24
Save

OPT3
Descripion: WiFi Guest
IPv4 Configuration Type: Static IPv4
Static IPv4 configuration -  IPv4 address : 10.13.37.1/24
Save

OPT4
Description: Voice
IPv4 Configuration Type: Static IPv4
Static IPv4 configuration -  IPv4 address : 10.0.3.1/24
Save
```

Apply changes.

Services => DHCP => Server.

```
IoT
(Checkmark) Enable DHCP server on the IoT interface
Range from 10.0.1.50 to 10.0.1.200
Save

WiFiMain
(Checkmark) Enable DHCP server on the IoT interface
Range from 10.0.2.50 to 10.0.2.200
Save

WiFiGuest
(Checkmark) Enable DHCP server on the IoT interface
Range from 10.13.37.50 to 10.13.37.200
Save

Voice
(Checkmark) Enable DHCP server on the IoT interface
Range from 10.0.5.50 to 10.0.5.200
Additional Options Advanced - Show Additional BOOTP/DHCP Options
Number: 128 Type: Text Value: VLAN-A=500;
Number: 66 Type: Text Value: 10.0.5.254
Number: 160 Type: Text Value: ftp://PlcmSpIp:PlcmSpIp@10.0.5.254
Save
DHCP Static Mappings for this interface.
+
Static DHCP Mapping
MAC address: 42:de:ad:be:a7:50
IP address: 10.0.4.254
Description: VoIP Server
Save
```

Apply Changes.

Click Firewall => Rules = Each one of your network tabs.

For instance IoT

```
Proto	Source	Description	
No interfaces rules are currently defined. All incoming connections on this interface will be blocked until you add a pass rule.
Move selected rule to end, Delete selected rule, add new rule
```

Click Add new rule.

For now we are just going to make a wide open blanket rule, we should lock this down when we finish setting up all our gear.

```
Firewall: Rules

Edit Firewall rule	full help

Action: Pass   
Disabled: Disable this rule
Interface: IoT  
TCP/IP Version: IPv4  
Protocol: any  
Source / Invert: (Unchecked)	
Source: any 
Source: Advanced
Destination / Invert: (Unchecked)
Destination: any 
Destination port range from: any to: any 
Log (Unchecked) Log packets that are handled by this rule
Category:	
Description: All the things.

Advanced features

Source OS: Any 
No XMLRPC Sync: (Unchecked)
Schedule: none  
Gateway: default 
Advanced Options	Show/Hide
 	 
Save  Cancel
```

Click Save.

Click Apply changes.

Repeat for the rest of the interfaces we made, otherwise their respected networks won't pass any traffic.

### PCI Passthrough For Wireless Access Point ###

This section is not yet complete...

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

**Intel Hardware ID: 8086:0082**

#### Enable Hardware ID For IOMMU In Bootloader ####

```
sudo nano /boot/loader/entries/arch.conf
title   Arch Linux BTRFS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=LABEL=ROOT rootflags=subvol=@ rw intel_iommu=on pci-stub.ids=8086:0082
```

Now we should be able to see the WiFi Hardware in our VM for PCI-Passthrough.



< To be continued... >

Continue to [Part 05 - VoIP Server](../Infrastructure-Part-5)
