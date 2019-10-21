---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 4a - Arch Linux Router - Systemd-networkd
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutFW.png "Arch Linux Router - Systemd-networkd")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

Part 04a - VM Arch Linux Router - Systemd-networkd - You Are Here!

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Infrastructure ASCII Art Diagram #

```
.----------------.
| WAN [~~~][E01] |
.----------------.
        ∧
{ VLAN 0100 WAN }
        ∨                                                                      
.--------------------------------------------------.                         
| [E] 3Com PoE Switch                              |<-{ Trunk WiFi     }               
| [01][03][05][07][09][11][13][15][17][19][21][23] |  { VLAN 0400/0450 } 
| [02][04][06][08][10][12][14][16][18][20][22][24] |  |        
.--------------------------------------------------.  |              ~\ ~|~ /~
    ∧                   ∧                             |    .--------------------------.
{ Trunk }                \--{ VLAN 0200 LAN   }---\    \-->| [*ArchRouterVM] VAP WiFi |
    ∨                       { VLAN 0300 AutoM }   |        .--------------------------. 
                            { VLAN 0500 Voice }   |
.-----------------------------------------------. |          
| [E02] Arch Hypervisor /-{ VLAN 0400 WiFi  * } | |        .----------------.
|     ∨----------------/--{ VLAN 0450 GWiFi * } | |------->| [E04] Arch NAS |          { VLAN0200LAN  }
| .--------.                       .----------. | |        .----------------.
| | ArchVM |<--->{ VLAN 0500 }<--->| ArchVM   | | |
| | Router |     {   Voice   }     | Asterisk | | |        .----------------------.    { VLAN0200LAN   }
| .--------.<-------\              .----------. | |------->| RJ45Patch [E05][E06] |<->([E08] 01 RPi) 
|      ∧             \                          | |        | [E07][E08][E09][E10] |<->([E09] 02 RPi)
| { VLAN 0200 LAN }   \-{ VLAN 0300  }          | |        | [E11][E12][E13][E14] |<->([E10] 01 RPi)
|      ∨                { Automation }-\        | |        | [E15][E16][E17][E18] |
| .---------.                          ∨        | |        | [E19][E20][E21][E22] |
| | ArchVM  |                    .------------. | |        | [E23][E00][E00][E00] |<-\ { VLAN0500Voice }
| | SSH/TOR |                    | ArchVM     | | |        .----------------------.  | { VLAN0200LAN   }
| | IRC     |                    | Automation | | |                                  ∨
| .---------.                    .------------. | |_       ([E05] VoIPSet)<->(01 Workstation)
.-----------------------------------------------.   \      ([E06] VoIPSet)<->(02 Workstation)
                                                     \     ([E07] VoIPSet)<->(03 Workstation)
.--------------------------------------------------.  \
| [I] I2C Bus Automation Patch                     |   \   .-------------------------.
| [01][03][05][07][09][11][13][15][17][19][21][23] |    \->| [E24] PoE Network MQTT  | { VLAN0300AutoM }
| [02][04][06][08][10][12][14][16][18][20][22][24] |<----->| [I01] I2C Bus Master    |
.--------------------------------------------------.       | PoE/I2C/MQTT Controller |
   ∧                                                       .-------------------------.
   | { I2C Twisted Pair Buffered Bus } 
   \---|---------------|---------------|----------------|--------------|----------------|----------\
       ∨               ∨               ∨               ∨              ∨                ∨          |
.-------------. .-------------. .-------------. .-------------. .-------------. .-------------.    |
| [I02] North | | [I02] East  | | [I03] South | | [I04] West  | | [I05] Door  | | [I06] Audio |    |
| Controller  | | Controller  | | Controller  | | Controller  | | Controller  | | Controller  |    |
.-------------. .-------------. .-------------. .-------------. .-------------. .-------------.    |
∧               ∧               ∧               ∧               ∧              ∧                  |
∨               ∨               ∨               ∨               ∨              ∨                  |
[Door]          [Door]          [Door]          [Window]        [2FA PINPAD]    [Internet Radio]   |
[Window]        [Window]        [Window]        [Window]        [RFID]          [Notifications]    |
[Window]        [Window]        [Window]        [Window]        [Motor Driver]  [MQTT Control]     |
[Window]        [Window]        [Window]        [Window]                                           |
[Temp/Humi]     [Temp/Humi]     [Temp/Humi]     [Temp/Humi]                                        |
                                                                                                   |
       /---------------|---------------|----------------|---------------|---------------|----------/
       ∨               ∨               ∨               ∨               ∨               ∨
.--------------. .-------------. .-------------. .-------------. .-------------. .-------------.    
| [I12] Garage | | [I11] Extra | | [I10] Extra | | [I09] Extra | | [I08] Extra | | [I07] Extra |    
| Controller   | | Controller  | | Controller  | | Controller  | | Controller  | | Controller  |    
.--------------. .-------------. .-------------. .-------------. .-------------. .-------------.    
∧                ∧               ∧               ∧               ∧              ∧                  
∨                ∨               ∨               ∨               ∨              ∨                  
[Encoder]        [N/A]           [N/A]           [N/A]           [N/A]          [N/A]   
[Relay]          [N/A]           [N/A]           [N/A]           [N/A]          [N/A]    
[Hall Effect O]  [N/A]           [N/A]           [N/A]           [N/A]          [N/A]     
[Hall Effect C]  [N/A]           [N/A]           [N/A]                                           
[Temp/Humi]      [N/A]           [N/A]           [N/A]                                        
                                                                                                   
```

## PHYSICAL BOX ##

### Start virt-manager ###

**Note:** *If you require to run virt-manager from a Windows box checkout the guide here: [virt-manager-windows](../virt-manager-windows)*

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
Memory (RAM): 2048 - + MiB
CPUs: 2 - +
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
Memory: 2048 MiB
CPUs: 1
Storage: 20.0 GiB /var/lib/libvirt/images/VirtualRouter.qcow2
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
   Firmware: UEFI x86_64: /usr/share/ovmf/x64/OVMF_CODE.fd
   Chipset: Q35
   
Cancel Apply
```

Click Firmware change BIOS to UEFI x86_64: /usr/share/ovmf/x64/OVMF_CODE.fd

**Note:** *You only get one chance to change this Firmware field, it will go read only after you Begin the Installation.*

First make this a bridged macvtap with eno1 then setup Arch.

```
Virtual Network Interface
Network source: Host device eno1: macvtap
                Source mode: Bridge
Device model: virtio
MAC address: X 42:de:ad:be:ef:10
```

**Note:**  *Do not use this next config until you know your VLAN’s are working, after Arch and all the tools you need are installed. You can then switch the 42:de:ad:be:ef:10 network interface to a shared device name brv100 shown below.*

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv100
Device model: virtio
MAC address: X 42:de:ad:be:ef:10
```

**Note:** *Changing the MAC to something you can recognise makes it easier to sort out in the VM Router we will see that :10 and know it's for our WAN connection and is VLAN 100 :20 is our LAN VLAN 200 etc.*

Click Apply.

**Note:** *The rest of these can be shared with the bridges as they will not be in use to get an internet connection from the hypervisor.*

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

We just setup all the virtual machine interfaces and attached them to their corresponding VLAN bridges for the Virtual Router to handle all the traffic.

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
Virtual Disk
  Source path: - Connect
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

Click on Arch Linux iso then click Choose Volume.

Click OK.

```
Virtual Disk
  Source path: ...irt/images/iso/archlin...iso Disconnect
  Device type: IDE CDROM 1
  Storage size: 488.00 MiB
  Readonly: X
  Shareable:
```

Make sure the IDE CDROM 1 is at the top of the Boot device order.

Click on Display Spice.

```
Spice Server
  Type: Spice server
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

## VIRTUAL MACHINE (RouterVM) ##

```
Arch Linux 5.2.5-arch1-1-ARCH (tty1)

archiso login: root (automatic login)

root@archiso ~ # _
```

We're going to use UEFI make sure you selected OVMF for VM BIOS.

After boot double check UEFI.

```
root@archiso ~ # mount | egrep efi
efivarfs on /sys/firmware/efi/efivars type efivarfs (rw,nosuid,nodev,noexec,relatime)
```

Find your network interface name.

```
root@archiso ~ # ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:10 brd ff:ff:ff:ff:ff:ff
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:20 brd ff:ff:ff:ff:ff:ff
4: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:30 brd ff:ff:ff:ff:ff:ff
5: enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:40 brd ff:ff:ff:ff:ff:ff
6: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:45 brd ff:ff:ff:ff:ff:ff
7: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 42:de:ad:be:ef:50 brd ff:ff:ff:ff:ff:ff
```

On this VM it is called enp1s0 and you will see all the other bridged interfaces made earlier.

Add a DHCP IP to enp1s0 (Should automatically obtain if network is working).

dhcpcd enp1s0 

**Note:** *Leave the VM’s nic in MACVTAP or NAT mode for the setup install of Arch then change after install to shared brv100.*

If you want to add a static IP and Netmask to enp1s0.

```
root@archiso ~ # ip link set enp1s0 up
root@archiso ~ # ip addr add 10.0.1.20/24 broadcast 10.0.1.255 dev enp1s0
```

Add route to internet gateway

```
root@archiso ~ # ip route add default via 10.0.1.1
```

Testing connection

```
root@archiso ~ # ping 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=38 time=73.9 ms
...
```

Working...

```
root@archiso ~ # ping google.com
ping: google.com: Name or service not known
```

Not working...

Add nameserver to resolv.conf

```
root@archiso ~ # echo "nameserver 8.8.8.8" >> /etc/resolv.conf
root@archiso ~ # cat /etc/resolv.conf
nameserver 8.8.8.8
```

Test again...

```
root@archiso ~ # ping google.com
64 bytes from ord38s04-in-f14.1e100.net (172.217.0.14): icmp_seq=1 ttl=47 time=71.0 ms
...
```

Working!

**Refresh pacman**

```
root@archiso ~ # pacman -Syy
```

## **Optional:** For remote installing ##

### Install Openssh ###

```
root@archiso ~ # pacman -S openssh
root@archiso ~ # systemctl start sshd
root@archiso ~ # passwd
New password: 1337pleb
Retype new password: 1337pleb
passwd: password updated successfully

root@archiso ~ # ip addr show eno1
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether d4:be:d9:24:3a:6b brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.101/24 brd 10.0.1.255 scope global enp1s0
       valid_lft forever preferred_lft forever
```

Now you should be able to remote ```ssh root@10.0.1.101``` from another machine on the network with whatever password you set example 1337pleb to finish config.

## Destroy Contents Of Drive & Create Partitions ##

```
root@archiso ~ # sgdisk --zap-all /dev/vda

root@archiso ~ # sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+3GiB  --typecode=2:8200 --change-name=2:SWAP \
       --new=3:0:0       --typecode=3:8300 --change-name=3:ROOT \
       /dev/vda
         
Creating new GPT entries.
Setting name!
partNum is 0
REALLY setting name!
Setting name!
partNum is 1
REALLY setting name!
Setting name!
partNum is 2
REALLY setting name!
The operation has completed successfully.
```

### Show Partitions & Labels ###

```
root@archiso ~ # lsblk -o +PARTLABEL

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT                PARTLABEL
loop0    7:0    0 508.2M  1 loop /run/archiso/sfs/airootfs
sr0     11:0    1  622M  0 rom /run/archiso/bootmnt
vda  254:0    0 20G  0 disk
├─vda1   254:1    0   550M  0 part                           EFI
├─vda2   254:2    0        3G  0 part                           SWAP
└─vda3   254:3    0  16.5G  0 part                           ROOT
```

### Format EFI Partition ###

**No Label**

```
root@archiso ~ # mkfs.vfat -F 32 /dev/vda1
```

**Use Label**

```
root@archiso ~ # mkfs.vfat -F 32 -n EFI /dev/vda1
mkfs.fat 4.1 (2017-01-24)
```

### Format SWAP Partition ###

**No Label**

```
root@archiso ~ # mkswap /dev/vda2                                  :(
mkswap: /dev/vda2: warning: wiping old swap signature.
Setting up swapspace version 1, size = 3 GiB (xxx bytes)
LABEL=SWAP, UUID=9689b746-3b09-4b3f-a871-497cb7d43651
```

**Use Label**

```
root@archiso ~ # mkswap -L SWAP /dev/vda2                                  :(
mkswap: /dev/vda2: warning: wiping old swap signature.
Setting up swapspace version 1, size = 3 GiB (xxx bytes)
LABEL=SWAP, UUID=9689b746-3b09-4b3f-a871-497cb7d43651
```

### Turn SWAP On ###

```
root@archiso ~ # swapon /dev/vda2
```

### Checkout SWAP Space ###

```
root@archiso ~ # free -h
              total        used        free      shared  buff/cache   available
Mem:           982Mi        69Mi        594Mi        103Mi        319Mi        672Mi
Swap:           3.0Gi          0B         3.0Gi
```

### Format ROOT Partition ###

**EXT4**

```
root@archiso ~ # mkfs.ext4 -L ROOT /dev/vda3
```

### Create Mountpoints ###

```
root@archiso ~ # mount /dev/vda3 /mnt
root@archiso ~ # mkdir -p /mnt/boot
root@archiso ~ # mount /dev/vda1 /mnt/boot/
```

### Pacstrap All The Things To /mnt ###

Installing: base base-devel zsh

```
root@archiso ~ # pacstrap /mnt base base-devel zsh
```

```
==> Creating install root at /mnt
==> Installing packages to /mnt
:: Synchronizing package databases...
 core                     124.2 KiB   268K/s 00:00 [######################] 100%
 extra                   1667.7 KiB  3.09M/s 00:01 [######################] 100%
 community                  3.9 MiB  5.49M/s 00:01 [######################] 100%
:: There are 50 members in group base:
:: Repository core
   1) bash  2) bzip2  3) coreutils  4) cryptsetup  5) device-mapper  6) dhcpcd
   7) diffutils  8) e2fsprogs  9) file  10) filesystem  11) findutils  12) gawk
   13) gcc-libs  14) gettext  15) glibc  16) grep  17) gzip  18) inetutils
   19) iproute2  20) iputils  21) jfsutils  22) less  23) licenses  24) linux
   25) logrotate  26) lvm2  27) man-db  28) man-pages  29) mdadm  30) nano
   31) netctl  32) pacman  33) pciutils  34) pcmciautils  35) perl
   36) procps-ng  37) psmisc  38) reiserfsprogs  39) s-nail  40) sed
   41) shadow  42) sysfsutils  43) systemd-sysvcompat  44) tar  45) texinfo
   46) usbutils  47) util-linux  48) vi  49) which  50) xfsprogs
 
Enter a selection (default=all):
resolving dependencies...
looking for conflicting packages...
warning: dependency cycle detected:
warning: libusb will be installed before its systemd dependency
 
Packages (134) acl-2.2.52-3  archlinux-keyring-20170320-1  attr-2.4.47-2
               ca-certificates-20170307-1  ca-certificates-cacert-20140824-4
               ca-certificates-mozilla-3.31-3  ca-certificates-utils-20170307-1
               cracklib-2.9.6-1  curl-7.54.1-1  db-5.3.28-3  dbus-1.10.18-1
               expat-2.2.0-2  gdbm-1.13-1  glib2-2.52.2+9+g3245eba16-1
               gmp-6.1.2-1  gnupg-2.1.21-3  gnutls-3.5.13-1  gpgme-1.9.0-3
               groff-1.22.3-7  hwids-20170328-1  iana-etc-20170512-1
               icu-59.1-1  iptables-1.6.1-1  kbd-2.0.4-1  keyutils-1.5.10-1
               kmod-24-1  krb5-1.15.1-1  libaio-0.3.110-1  libarchive-3.3.1-5
               libassuan-2.4.3-1  libcap-2.25-1  libelf-0.169-1  libffi-3.2.1-2
               libgcrypt-1.7.7-1  libgpg-error-1.27-1  libidn-1.33-1
               libksba-1.3.4-2  libldap-2.4.44-5  libmnl-1.0.4-1
               libnftnl-1.0.7-1  libnghttp2-1.23.1-1  libnl-3.2.29-2
               libpcap-1.8.1-2  libpipeline-1.4.1-1  libpsl-0.17.0-2
               libsasl-2.1.26-11  libseccomp-2.3.2-1
               libsecret-0.18.5+14+g9980655-1  libssh2-1.8.0-2
               libsystemd-232-8  libtasn1-4.12-1  libtirpc-1.0.1-3
               libunistring-0.9.7-1  libusb-1.0.21-1  libutil-linux-2.29.2-2
               linux-api-headers-4.10.1-1  linux-firmware-20170422.ade8332-1
               lz4-1:1.7.5-1  lzo-2.10-1  mkinitcpio-23-1
               mkinitcpio-busybox-1.25.1-1  mpfr-3.1.5.p2-1
               ncurses-6.0+20170527-1  nettle-3.3-1  npth-1.5-1
               openresolv-3.9.0-1  openssl-1.1.0.f-1  p11-kit-0.23.7-1
               pacman-mirrorlist-20170427-1  pam-1.3.0-1  pambase-20130928-1
               pcre-8.40-1  pinentry-1.0.0-1  popt-1.16-8  readline-7.0.003-1
               sqlite-3.19.3-1  systemd-232-8  thin-provisioning-tools-0.7.0-1
               tzdata-2017b-1  xz-5.2.3-1  zlib-1:1.2.11-1  bash-4.4.012-2
               bash-completion-2.5-1  btrfs-progs-4.11-1  bzip2-1.0.6-6
               coreutils-8.27-1  cryptsetup-1.7.5-1  device-mapper-2.02.171-1
               dhcpcd-6.11.5-1  diffutils-3.6-1  dosfstools-4.1-1
               e2fsprogs-1.43.4-1  file-5.31-1  filesystem-2017.03-2
               findutils-4.6.0-2  gawk-4.1.4-2  gcc-libs-7.1.1-2
               gettext-0.19.8.1-2  glibc-2.25-2  grep-3.0-1  gzip-1.8-2
               inetutils-1.9.4-5  iproute2-4.11.0-1  iputils-20161105.1f2bb12-2
               jfsutils-1.1.15-4  less-487-1  licenses-20140629-2
               linux-4.11.5-1  logrotate-3.12.2-1  lvm2-2.02.171-1
               man-db-2.7.6.1-2  man-pages-4.11-1  mdadm-4.0-1  nano-2.8.4-1
               netctl-1.12-2  pacman-5.0.2-1  pciutils-3.5.4-1
               pcmciautils-018-7  perl-5.26.0-1  procps-ng-3.3.12-1
               psmisc-22.21-3  reiserfsprogs-3.6.25-1  s-nail-14.8.16-2
               sed-4.4-1  shadow-4.4-3  sysfsutils-2.1.0-9
               systemd-sysvcompat-232-8  tar-1.29-2  texinfo-6.3-2
               usbutils-008-1  util-linux-2.29.2-2  vi-1:070224-2  which-2.21-2
               xfsprogs-4.11.0-1
 
Total Download Size:   213.38 MiB
Total Installed Size:  742.32 MiB
 
:: Proceed with installation? [Y/n]
:: Retrieving packages...
 linux-api-headers-4...   852.4 KiB  2.66M/s 00:00 [######################] 100%
 tzdata-2017b-1-any       235.8 KiB  11.5M/s 00:00 [######################] 100%
 iana-etc-20170512-1-any  360.9 KiB  2005K/s 00:00 [######################] 100%
 filesystem-2017.03-...    10.2 KiB  0.00B/s 00:00 [######################] 100%
 glibc-2.25-2-x86_64        8.2 MiB   834K/s 00:10 [######################] 100%
 gcc-libs-7.1.1-2-x86_64   17.4 MiB   483K/s 00:37 [######################] 100%
 ncurses-6.0+2017052...  1053.3 KiB   849K/s 00:01 [######################] 100%
 readline-7.0.003-1-...   294.7 KiB   932K/s 00:00 [######################] 100%
 bash-4.4.012-2-x86_64   1417.7 KiB   911K/s 00:02 [######################] 100%
 bzip2-1.0.6-6-x86_64      52.8 KiB  0.00B/s 00:00 [######################] 100%
 attr-2.4.47-2-x86_64      70.0 KiB  22.8M/s 00:00 [######################] 100%
 acl-2.2.52-3-x86_64      132.0 KiB   810K/s 00:00 [######################] 100%
 gmp-6.1.2-1-x86_64       408.5 KiB   659K/s 00:01 [######################] 100%
 libcap-2.25-1-x86_64      37.9 KiB  0.00B/s 00:00 [######################] 100%
 gdbm-1.13-1-x86_64       150.4 KiB   958K/s 00:00 [######################] 100%
 db-5.3.28-3-x86_64      1097.6 KiB   784K/s 00:01 [######################] 100%
 perl-5.26.0-1-x86_64      13.6 MiB   702K/s 00:20 [######################] 100%
 openssl-1.1.0.f-1-x...     2.9 MiB  1568K/s 00:02 [######################] 100%
 coreutils-8.27-1-x86_64    2.2 MiB  1103K/s 00:02 [######################] 100%
 libgpg-error-1.27-1...   150.4 KiB   964K/s 00:00 [######################] 100%
 libgcrypt-1.7.7-1-x...   466.0 KiB   991K/s 00:00 [######################] 100%
 lz4-1:1.7.5-1-x86_64      82.7 KiB  11.5M/s 00:00 [######################] 100%
 xz-5.2.3-1-x86_64        229.1 KiB   739K/s 00:00 [######################] 100%
 libsystemd-232-8-x86_64  358.1 KiB   578K/s 00:01 [######################] 100%
 expat-2.2.0-2-x86_64      76.3 KiB   486K/s 00:00 [######################] 100%
 dbus-1.10.18-1-x86_64    273.7 KiB   441K/s 00:01 [######################] 100%
 libmnl-1.0.4-1-x86_64     10.5 KiB  0.00B/s 00:00 [######################] 100%
 libnftnl-1.0.7-1-x86_64   59.9 KiB  14.6M/s 00:00 [######################] 100%
 libnl-3.2.29-2-x86_64    350.4 KiB   560K/s 00:01 [######################] 100%
 libusb-1.0.21-1-x86_64    54.0 KiB   344K/s 00:00 [######################] 100%
 libpcap-1.8.1-2-x86_64   216.9 KiB   466K/s 00:00 [######################] 100%
 iptables-1.6.1-1-x86_64  327.4 KiB   526K/s 00:01 [######################] 100%
 zlib-1:1.2.11-1-x86_64    86.4 KiB   550K/s 00:00 [######################] 100%
 cracklib-2.9.6-1-x86_64  249.9 KiB   540K/s 00:00 [######################] 100%
 libutil-linux-2.29....   317.5 KiB   515K/s 00:01 [######################] 100%
 e2fsprogs-1.43.4-1-...   959.5 KiB   413K/s 00:02 [######################] 100%
 libsasl-2.1.26-11-x...   137.3 KiB   294K/s 00:00 [######################] 100%
 libldap-2.4.44-5-x86_64  284.9 KiB   229K/s 00:01 [######################] 100%
 keyutils-1.5.10-1-x...    67.5 KiB   216K/s 00:00 [######################] 100%
 krb5-1.15.1-1-x86_64    1120.1 KiB   258K/s 00:04 [######################] 100%
 libtirpc-1.0.1-3-x86_64  174.0 KiB   279K/s 00:01 [######################] 100%
 pambase-20130928-1-any  1708.0   B  0.00B/s 00:00 [######################] 100%
 pam-1.3.0-1-x86_64       609.7 KiB   302K/s 00:02 [######################] 100%
 kbd-2.0.4-1-x86_64      1119.9 KiB   400K/s 00:03 [######################] 100%
 kmod-24-1-x86_64         109.8 KiB   350K/s 00:00 [######################] 100%
 hwids-20170328-1-any     340.2 KiB   307K/s 00:01 [######################] 100%
 libidn-1.33-1-x86_64     206.9 KiB   223K/s 00:01 [######################] 100%
 libelf-0.169-1-x86_64    368.8 KiB   215K/s 00:02 [######################] 100%
 libseccomp-2.3.2-1-...    66.3 KiB   214K/s 00:00 [######################] 100%
 shadow-4.4-3-x86_64     1060.6 KiB   185K/s 00:06 [######################] 100%
 util-linux-2.29.2-2...  1828.5 KiB   522K/s 00:04 [######################] 100%
 systemd-232-8-x86_64       3.7 MiB   625K/s 00:06 [######################] 100%
 device-mapper-2.02....   265.6 KiB   570K/s 00:00 [######################] 100%
 popt-1.16-8-x86_64        65.5 KiB  0.00B/s 00:00 [######################] 100%
 cryptsetup-1.7.5-1-...   240.8 KiB   767K/s 00:00 [######################] 100%
 dhcpcd-6.11.5-1-x86_64   156.8 KiB   980K/s 00:00 [######################] 100%
 diffutils-3.6-1-x86_64   282.8 KiB   904K/s 00:00 [######################] 100%
 file-5.31-1-x86_64       259.0 KiB   828K/s 00:00 [######################] 100%
 findutils-4.6.0-2-x...   420.7 KiB   679K/s 00:01 [######################] 100%
 mpfr-3.1.5.p2-1-x86_64   254.5 KiB   813K/s 00:00 [######################] 100%
 gawk-4.1.4-2-x86_64      987.1 KiB   707K/s 00:01 [######################] 100%
 pcre-8.40-1-x86_64       922.5 KiB   738K/s 00:01 [######################] 100%
 libffi-3.2.1-2-x86_64     31.5 KiB  0.00B/s 00:00 [######################] 100%
 glib2-2.52.2+9+g324...     2.3 MiB   261K/s 00:09 [######################] 100%
 libunistring-0.9.7-...   491.1 KiB   167K/s 00:03 [######################] 100%
 gettext-0.19.8.1-2-...  2026.9 KiB   543K/s 00:04 [######################] 100%
 grep-3.0-1-x86_64        202.7 KiB  1236K/s 00:00 [######################] 100%
 less-487-1-x86_64         93.6 KiB   596K/s 00:00 [######################] 100%
 gzip-1.8-2-x86_64         75.8 KiB  24.7M/s 00:00 [######################] 100%
 inetutils-1.9.4-5-x...   285.8 KiB   613K/s 00:00 [######################] 100%
 iproute2-4.11.0-1-x...   634.4 KiB   584K/s 00:01 [######################] 100%
 sysfsutils-2.1.0-9-...    30.2 KiB  0.00B/s 00:00 [######################] 100%
 iputils-20161105.1f...    71.2 KiB   462K/s 00:00 [######################] 100%
 jfsutils-1.1.15-4-x...   167.5 KiB   540K/s 00:00 [######################] 100%
 licenses-20140629-2-any   63.0 KiB  15.4M/s 00:00 [######################] 100%
 linux-firmware-2017...    41.9 MiB   788K/s 00:54 [######################] 100%
 mkinitcpio-busybox-...   157.5 KiB  11.0M/s 00:00 [######################] 100%
 libarchive-3.3.1-5-...   449.0 KiB  1448K/s 00:00 [######################] 100%
 mkinitcpio-23-1-any       38.8 KiB  0.00B/s 00:00 [######################] 100%
 linux-4.11.5-1-x86_64     61.3 MiB   396K/s 02:38 [######################] 100%
 logrotate-3.12.2-1-...    37.1 KiB  0.00B/s 00:00 [######################] 100%
 libaio-0.3.110-1-x86_64    4.4 KiB  0.00B/s 00:00 [######################] 100%
 thin-provisioning-t...   370.9 KiB   397K/s 00:01 [######################] 100%
 lvm2-2.02.171-1-x86_64  1281.1 KiB   376K/s 00:03 [######################] 100%
 groff-1.22.3-7-x86_64   1824.6 KiB   302K/s 00:06 [######################] 100%
 libpipeline-1.4.1-1...    36.2 KiB   230K/s 00:00 [######################] 100%
 man-db-2.7.6.1-2-x86_64  756.1 KiB   160K/s 00:05 [######################] 100%
 man-pages-4.11-1-any       5.7 MiB   242K/s 00:24 [######################] 100%
 mdadm-4.0-1-x86_64       394.4 KiB   196K/s 00:02 [######################] 100%
 nano-2.8.4-1-x86_64      418.4 KiB   180K/s 00:02 [######################] 100%
 openresolv-3.9.0-1-any    21.1 KiB  0.00B/s 00:00 [######################] 100%
 netctl-1.12-2-any         36.8 KiB   241K/s 00:00 [######################] 100%
 libtasn1-4.12-1-x86_64   117.4 KiB   122K/s 00:01 [######################] 100%
 p11-kit-0.23.7-1-x86_64  445.7 KiB   135K/s 00:03 [######################] 100%
 ca-certificates-uti...     7.5 KiB  0.00B/s 00:00 [######################] 100%
 ca-certificates-moz...   402.0 KiB   137K/s 00:03 [######################] 100%
 ca-certificates-cac...     7.1 KiB   307K/s 00:00 [######################] 100%
 ca-certificates-201...  1904.0   B  0.00B/s 00:00 [######################] 100%
 libssh2-1.8.0-2-x86_64   180.2 KiB   192K/s 00:01 [######################] 100%
 icu-59.1-1-x86_64          8.1 MiB   278K/s 00:30 [######################] 100%
 libpsl-0.17.0-2-x86_64    49.4 KiB  0.00B/s 00:00 [######################] 100%
 libnghttp2-1.23.1-1...    84.2 KiB   547K/s 00:00 [######################] 100%
 curl-7.54.1-1-x86_64     904.2 KiB   521K/s 00:02 [######################] 100%
 npth-1.5-1-x86_64         12.8 KiB  0.00B/s 00:00 [######################] 100%
 libksba-1.3.4-2-x86_64   114.6 KiB   730K/s 00:00 [######################] 100%
 libassuan-2.4.3-1-x...    84.6 KiB  20.7M/s 00:00 [######################] 100%
 libsecret-0.18.5+14...   193.3 KiB   624K/s 00:00 [######################] 100%
 pinentry-1.0.0-1-x86_64   98.1 KiB   625K/s 00:00 [######################] 100%
 nettle-3.3-1-x86_64      321.7 KiB   689K/s 00:00 [######################] 100%
 gnutls-3.5.13-1-x86_64     2.3 MiB  1150K/s 00:02 [######################] 100%
 sqlite-3.19.3-1-x86_64  1259.3 KiB  1145K/s 00:01 [######################] 100%
 gnupg-2.1.21-3-x86_64   2020.5 KiB   802K/s 00:03 [######################] 100%
 gpgme-1.9.0-3-x86_64     361.9 KiB  1142K/s 00:00 [######################] 100%
 pacman-mirrorlist-2...     5.2 KiB  0.00B/s 00:00 [######################] 100%
 archlinux-keyring-2...   638.7 KiB  1009K/s 00:01 [######################] 100%
 pacman-5.0.2-1-x86_64    735.7 KiB   785K/s 00:01 [######################] 100%
 pciutils-3.5.4-1-x86_64   82.4 KiB  26.8M/s 00:00 [######################] 100%
 pcmciautils-018-7-x...    19.7 KiB  0.00B/s 00:00 [######################] 100%
 procps-ng-3.3.12-1-...   299.5 KiB   936K/s 00:00 [######################] 100%
 psmisc-22.21-3-x86_64    101.3 KiB  14.1M/s 00:00 [######################] 100%
 reiserfsprogs-3.6.2...   201.0 KiB  1256K/s 00:00 [######################] 100%
 s-nail-14.8.16-2-x86_64  310.7 KiB   983K/s 00:00 [######################] 100%
 sed-4.4-1-x86_64         174.0 KiB  1108K/s 00:00 [######################] 100%
 systemd-sysvcompat-...     7.3 KiB  0.00B/s 00:00 [######################] 100%
 tar-1.29-2-x86_64        673.9 KiB   864K/s 00:01 [######################] 100%
 texinfo-6.3-2-x86_64    1170.3 KiB   834K/s 00:01 [######################] 100%
 usbutils-008-1-x86_64     61.3 KiB  0.00B/s 00:00 [######################] 100%
 vi-1:070224-2-x86_64     148.0 KiB   943K/s 00:00 [######################] 100%
 which-2.21-2-x86_64       15.5 KiB  0.00B/s 00:00 [######################] 100%
 xfsprogs-4.11.0-1-x...   813.5 KiB   878K/s 00:01 [######################] 100%
 lzo-2.10-1-x86_64         82.1 KiB  26.7M/s 00:00 [######################] 100%
 btrfs-progs-4.11-1-...   597.3 KiB   766K/s 00:01 [######################] 100%
 dosfstools-4.1-1-x86_64   56.0 KiB  13.7M/s 00:00 [######################] 100%
 bash-completion-2.5...   171.9 KiB  1048K/s 00:00 [######################] 100%
(134/134) checking keys in keyring                 [######################] 100%
(134/134) checking package integrity               [######################] 100%
(134/134) loading package files                    [######################] 100%
(134/134) checking for file conflicts              [######################] 100%
(134/134) checking available disk space            [######################] 100%
:: Processing package changes...
(  1/134) installing linux-api-headers             [######################] 100%
(  2/134) installing tzdata                        [######################] 100%
(  3/134) installing iana-etc                      [######################] 100%
(  4/134) installing filesystem                    [######################] 100%
(  5/134) installing glibc                         [######################] 100%
(  6/134) installing gcc-libs                      [######################] 100%
(  7/134) installing ncurses                       [######################] 100%
(  8/134) installing readline                      [######################] 100%
(  9/134) installing bash                          [######################] 100%
Optional dependencies for bash
    bash-completion: for tab completion [pending]
( 10/134) installing bzip2                         [######################] 100%
( 11/134) installing attr                          [######################] 100%
( 12/134) installing acl                           [######################] 100%
( 13/134) installing gmp                           [######################] 100%
( 14/134) installing libcap                        [######################] 100%
( 15/134) installing gdbm                          [######################] 100%
( 16/134) installing db                            [######################] 100%
( 17/134) installing perl                          [######################] 100%
( 18/134) installing openssl                       [######################] 100%
Optional dependencies for openssl
    ca-certificates [pending]
( 19/134) installing coreutils                     [######################] 100%
( 20/134) installing libgpg-error                  [######################] 100%
( 21/134) installing libgcrypt                     [######################] 100%
( 22/134) installing lz4                           [######################] 100%
( 23/134) installing xz                            [######################] 100%
( 24/134) installing libsystemd                    [######################] 100%
( 25/134) installing expat                         [######################] 100%
( 26/134) installing dbus                          [######################] 100%
( 27/134) installing libmnl                        [######################] 100%
( 28/134) installing libnftnl                      [######################] 100%
( 29/134) installing libnl                         [######################] 100%
( 30/134) installing libusb                        [######################] 100%
( 31/134) installing libpcap                       [######################] 100%
( 32/134) installing iptables                      [######################] 100%
( 33/134) installing zlib                          [######################] 100%
( 34/134) installing cracklib                      [######################] 100%
( 35/134) installing libutil-linux                 [######################] 100%
( 36/134) installing e2fsprogs                     [######################] 100%
( 37/134) installing libsasl                       [######################] 100%
( 38/134) installing libldap                       [######################] 100%
( 39/134) installing keyutils                      [######################] 100%
( 40/134) installing krb5                          [######################] 100%
( 41/134) installing libtirpc                      [######################] 100%
( 42/134) installing pambase                       [######################] 100%
( 43/134) installing pam                           [######################] 100%
( 44/134) installing kbd                           [######################] 100%
( 45/134) installing kmod                          [######################] 100%
( 46/134) installing hwids                         [######################] 100%
( 47/134) installing libidn                        [######################] 100%
( 48/134) installing libelf                        [######################] 100%
( 49/134) installing libseccomp                    [######################] 100%
( 50/134) installing shadow                        [######################] 100%
( 51/134) installing util-linux                    [######################] 100%
Optional dependencies for util-linux
    python: python bindings to libmount
( 52/134) installing systemd                       [######################] 100%
Initializing machine ID from random generator.
Created symlink /etc/systemd/system/getty.target.wants/getty@tty1.service → /usr/lib/systemd/system/getty@.service.
Created symlink /etc/systemd/system/multi-user.target.wants/remote-fs.target → /usr/lib/systemd/system/remote-fs.target.
:: Append 'init=/usr/lib/systemd/systemd' to your kernel command line in your
   bootloader to replace sysvinit with systemd, or install systemd-sysvcompat
Optional dependencies for systemd
    cryptsetup: required for encrypted block devices [pending]
    libmicrohttpd: remote journald capabilities
    quota-tools: kernel-level quota management
    systemd-sysvcompat: symlink package to provide sysvinit binaries [pending]
    polkit: allow administration as unprivileged user
( 53/134) installing device-mapper                 [######################] 100%
( 54/134) installing popt                          [######################] 100%
( 55/134) installing cryptsetup                    [######################] 100%
( 56/134) installing dhcpcd                        [######################] 100%
Optional dependencies for dhcpcd
    openresolv: resolvconf support [pending]
( 57/134) installing diffutils                     [######################] 100%
( 58/134) installing file                          [######################] 100%
( 59/134) installing findutils                     [######################] 100%
( 60/134) installing mpfr                          [######################] 100%
( 61/134) installing gawk                          [######################] 100%
( 62/134) installing pcre                          [######################] 100%
( 63/134) installing libffi                        [######################] 100%
( 64/134) installing glib2                         [######################] 100%
Optional dependencies for glib2
    python: for gdbus-codegen and gtester-report
    libelf: gresource inspection tool [installed]
( 65/134) installing libunistring                  [######################] 100%
( 66/134) installing gettext                       [######################] 100%
Optional dependencies for gettext
    git: for autopoint infrastructure updates
( 67/134) installing grep                          [######################] 100%
( 68/134) installing less                          [######################] 100%
( 69/134) installing gzip                          [######################] 100%
( 70/134) installing inetutils                     [######################] 100%
( 71/134) installing iproute2                      [######################] 100%
Optional dependencies for iproute2
    linux-atm: ATM support
( 72/134) installing sysfsutils                    [######################] 100%
( 73/134) installing iputils                       [######################] 100%
Optional dependencies for iputils
    xinetd: for tftpd
( 74/134) installing jfsutils                      [######################] 100%
( 75/134) installing licenses                      [######################] 100%
( 76/134) installing linux-firmware                [######################] 100%
( 77/134) installing mkinitcpio-busybox            [######################] 100%
( 78/134) installing libarchive                    [######################] 100%
( 79/134) installing mkinitcpio                    [######################] 100%
Optional dependencies for mkinitcpio
    xz: Use lzma or xz compression for the initramfs image [installed]
    bzip2: Use bzip2 compression for the initramfs image [installed]
    lzop: Use lzo compression for the initramfs image
    lz4: Use lz4 compression for the initramfs image [installed]
    mkinitcpio-nfs-utils: Support for root filesystem on NFS
( 80/134) installing linux                         [######################] 100%
>>> Updating module dependencies. Please wait ...
Optional dependencies for linux
    crda: to set the correct wireless channels of your country
( 81/134) installing logrotate                     [######################] 100%
( 82/134) installing libaio                        [######################] 100%
( 83/134) installing thin-provisioning-tools       [######################] 100%
( 84/134) installing lvm2                          [######################] 100%
( 85/134) installing groff                         [######################] 100%
Optional dependencies for groff
    netpbm: for use together with man -H command interaction in browsers
    psutils: for use together with man -H command interaction in browsers
    libxaw: for gxditview
( 86/134) installing libpipeline                   [######################] 100%
( 87/134) installing man-db                        [######################] 100%
Optional dependencies for man-db
    gzip [installed]
( 88/134) installing man-pages                     [######################] 100%
( 89/134) installing mdadm                         [######################] 100%
( 90/134) installing nano                          [######################] 100%
( 91/134) installing openresolv                    [######################] 100%
( 92/134) installing netctl                        [######################] 100%
Optional dependencies for netctl
    dialog: for the menu based wifi assistant
    dhclient: for DHCP support (or dhcpcd)
    dhcpcd: for DHCP support (or dhclient) [installed]
    wpa_supplicant: for wireless networking support
    ifplugd: for automatic wired connections through netctl-ifplugd
    wpa_actiond: for automatic wireless connections through netctl-auto
    ppp: for PPP connections
    openvswitch: for Open vSwitch connections
( 93/134) installing libtasn1                      [######################] 100%
( 94/134) installing p11-kit                       [######################] 100%
( 95/134) installing ca-certificates-utils         [######################] 100%
( 96/134) installing ca-certificates-mozilla       [######################] 100%
( 97/134) installing ca-certificates-cacert        [######################] 100%
( 98/134) installing ca-certificates               [######################] 100%
( 99/134) installing libssh2                       [######################] 100%
(100/134) installing icu                           [######################] 100%
(101/134) installing libpsl                        [######################] 100%
(102/134) installing libnghttp2                    [######################] 100%
(103/134) installing curl                          [######################] 100%
(104/134) installing npth                          [######################] 100%
(105/134) installing libksba                       [######################] 100%
(106/134) installing libassuan                     [######################] 100%
(107/134) installing libsecret                     [######################] 100%
Optional dependencies for libsecret
    gnome-keyring: key storage service (or use any other service implementing
    org.freedesktop.secrets)
(108/134) installing pinentry                      [######################] 100%
Optional dependencies for pinentry
    gtk2: gtk2 backend
    qt5-base: qt backend
    gcr: gnome3 backend
(109/134) installing nettle                        [######################] 100%
(110/134) installing gnutls                        [######################] 100%
Optional dependencies for gnutls
    guile: for use with Guile bindings
(111/134) installing sqlite                        [######################] 100%
(112/134) installing gnupg                         [######################] 100%
Optional dependencies for gnupg
    libldap: gpg2keys_ldap [installed]
    libusb-compat: scdaemon
(113/134) installing gpgme                         [######################] 100%
(114/134) installing pacman-mirrorlist             [######################] 100%
(115/134) installing archlinux-keyring             [######################] 100%
(116/134) installing pacman                        [######################] 100%
(117/134) installing pciutils                      [######################] 100%
(118/134) installing pcmciautils                   [######################] 100%
(119/134) installing procps-ng                     [######################] 100%
(120/134) installing psmisc                        [######################] 100%
(121/134) installing reiserfsprogs                 [######################] 100%
(122/134) installing s-nail                        [######################] 100%
Optional dependencies for s-nail
    smtp-forwarder: for sending mail
(123/134) installing sed                           [######################] 100%
(124/134) installing systemd-sysvcompat            [######################] 100%
(125/134) installing tar                           [######################] 100%
(126/134) installing texinfo                       [######################] 100%
(127/134) installing usbutils                      [######################] 100%
Optional dependencies for usbutils
    python2: for lsusb.py usage
    coreutils: for lsusb.py usage [installed]
(128/134) installing vi                            [######################] 100%
Optional dependencies for vi
    s-nail: used by the preserve command for notification [installed]
(129/134) installing which                         [######################] 100%
(130/134) installing xfsprogs                      [######################] 100%
(131/134) installing lzo                           [######################] 100%
(132/134) installing btrfs-progs                   [######################] 100%
(133/134) installing dosfstools                    [######################] 100%
(134/134) installing bash-completion               [######################] 100%
:: Running post-transaction hooks...
(1/7) Updating linux initcpios
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 4.11.5-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> Image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: 4.11.5-1-ARCH
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux-fallback.img
==> Image generation successful
(2/7) Updating udev hardware database...
(3/7) Updating system user accounts...
(4/7) Creating temporary files...
(5/7) Arming ConditionNeedsUpdate...
(6/7) Updating the info directory file...
(7/7) Rebuilding certificate stores...
pacstrap /mnt base base-devel zsh  35.58s user 11.38s system 9% cpu 8:39.55 total
```

### Generate FSTAB ###

**Use UUID**

```
root@archiso ~ # genfstab -U /mnt >> /mnt/etc/fstab
```

**Use Partition Label**

**Note:** *Can't get this working on some older Dell BIOS use -U for those.*

```
root@archiso ~ # genfstab -Lp /mnt >> /mnt/etc/fstab
```

### Verify FSTAB with Partition Labels  ###

```
root@archiso ~ # cat /mnt/etc/fstab
#
# /etc/fstab: static file system information
#
# <file system> <dir>   <type>  <options>       <dump>  <pass>
# /dev/vda3 UUID=f42e42e1-2b97-4c87-b0ae-7b9d1096c676

 
 
# /dev/vda1 UUID=B5F4-518A
LABEL=EFI               /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro   0 2
 
# /dev/vda2 UUID=9689b746-3b09-4b3f-a871-497cb7d43651
LABEL=SWAP              none            swap            defaults        0 0
```

### Chroot Into The Filesystem and Configure Some Basics ###

```
root@archiso ~ # arch-chroot /mnt
[root@archiso /]# echo hq > /etc/hostname
[root@archiso /]# echo LANG=en_US.UTF-8 > /etc/locale.conf
[root@archiso /]# echo LANGUAGE=en_US >> /etc/locale.conf
[root@archiso /]# echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
[root@archiso /]# locale-gen
Generating locales...
  en_US.UTF-8... done
Generation complete.
```

### pacman.conf ###

/etc/pacman.conf

#### Fun ####

Add to [options] and you will see Yellow Pacman eating dots instead of # for the progressbar.

```
[options]
Color
ILoveCandy
```

#### Uncomment multilibs (If you require 32 bit libraries) ####

```
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

to

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

### Update Pacman ###

```
[root@archiso /]# pacman -Sy
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
 multilib                 176.2 KiB   378K/s 00:00 [----------------------] 100%
 archlinuxfr               15.2 KiB   112K/s 00:00 [----------------------] 100%
```

### Set root password ###

```
[root@archiso /]# passwd
New password: Plebmast0r
Retype new password: Plebmast0r
passwd: password updated successfully
```

### Install systemd-boot (Used to be Gummiboot) ###

Install to mounted EFI /boot folder.

```
[root@archiso /]# bootctl install
Created "boot/EFI".
Created "boot/EFI/systemd".
Created "boot/EFI/BOOT".
Created "boot/loader".
Created "boot/loader/entries".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "boot/EFI/systemd/systemd-bootx64.efi".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "boot/EFI/BOOT/BOOTX64.EFI".
Created EFI boot entry "Linux Boot Manager".
```

### Modify boot loader and entries ###

Verify bootloader files exist.

```
[root@archiso /]# cd /boot/loader
[root@archiso loader]# ls
entries  loader.conf
```

### Edit loader.conf ###

/boot/loader/loader.conf
```
default arch
timeout 4
editor  0
```

### Edit arch.conf ###

#### EXT4 Install ####

**Use Device Name**

/boot/loader/entries/arch.conf
```
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=/dev/vda3 rw
```

**Use Label (Might not work)**

/boot/loader/entries/arch.conf
```
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=PARTLABEL=ROOT rw
```

### Install efibootmgr ###

```
[root@archiso entries]# pacman -S efibootmgr
resolving dependencies...
looking for conflicting packages...
 
Packages (2) efivar-31-1  efibootmgr-15-1
 
Total Download Size:   0.09 MiB
Total Installed Size:  0.29 MiB
 
:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 efivar-31-1-x86_64        75.4 KiB   243K/s 00:00 [######################] 100%
 efibootmgr-15-1-x86_64    20.2 KiB  0.00B/s 00:00 [######################] 100%
(2/2) checking keys in keyring                     [######################] 100%
(2/2) checking package integrity                   [######################] 100%
(2/2) loading package files                        [######################] 100%
(2/2) checking for file conflicts                  [######################] 100%
(2/2) checking available disk space                [######################] 100%
:: Processing package changes...
(1/2) installing efivar                            [######################] 100%
(2/2) installing efibootmgr                        [######################] 100%
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

### Check out the EFI boot menu ###

Check to see if we can see the "Linux Boot Manager" now in the EFI boot menu.

```
[root@archiso entries]# efibootmgr -v
BootCurrent: 0008
Timeout: 1 seconds
BootOrder: 0000,0002,0003,0004,0005,0008
Boot0000* Linux Boot Manager    HD(1,GPT,94459880-7fce-4d79-bcd0-e99eeaab0ca5,0x800,0x113000)/File(\EFI\systemd\systemd-bootx64.efi)
Boot0002* Internal HDD (IRRT)   BBS(HD,,0x0)WDC WD3200LPVX-22V0TT0          .
Boot0003* USB Storage Device    BBS(USB,,0x0)USB Storage Device.
Boot0004* CD/DVD/CD-RW Drive    BBS(CDROM,,0x0)P1: HL-DT-ST DVD+/-RW GU60N   .
Boot0005* Onboard NIC   BBS(Network,,0x0)IBA GE Slot 00C8 v1533.
Boot0008  UEFI: INT13(,0x81)    PciRoot(0x0)/Pci(0x19,0x0)/VenHw(aa7ba38a-dabf-40c3-8d18-b55b39609ef7,8101000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)/HD(1,MBR,0x22c91b15,0x800,0x78a000)
```

### Exit arch-chroot and unmount everything ###

```
[root@archiso entries]# exit
exit
arch-chroot /mnt/  10.54s user 2.72s system 1% cpu 16:15.60 total
root@archiso ~ # umount -R /mnt
```

### Remove install media, Reboot & hope for the best ###

```
root@archiso ~ # reboot
``` 

If everything goes well you should now be at a linux console waiting for you to login with your root user account and password set before with passwd.

**Virtual Machine Router**

Get an IP address from the macvtap interface.

```
dhcpcd enp1s0
```

### Router Pieces ###

```
pacman -S dnsmasq 
```

/etc/systemd/network/enp1s0.network
```
[Match]
Name=enp1s0

[Network]
DHCP=yes
IPForward=yes
```

/etc/systemd/network/enp2s0.network
```
[Match]
Name=enp2s0

[Network]
Address=10.0.10.1/24
IPForward=yes
```

/etc/systemd/network/enp3s0.network
```
[Match]
Name=enp3s0

[Network]
Address=10.0.20.1/24
IPForward=yes
```

/etc/systemd/network/enp4s0.network
```
[Match]
Name=enp4s0

[Network]
Address=10.0.30.1/24
IPForward=yes
```

/etc/systemd/network/enp5s0.network
```
[Match]
Name=enp5s0

[Network]
Address=10.0.40.1/24
IPForward=yes
```

/etc/systemd/network/enp6s0.network
```
[Match]
Name=enp6s0

[Network]
Address=10.0.50.1/24
IPForward=yes
```

#### Resolved Configuration ####

/etc/systemd/resolved.conf
```
[Resolve]
#DNS=
#FallbackDNS=1.1.1.1 9.9.9.10 8.8.8.8 2606:4700:4700::1111 2620:fe::10 2001:4860:4860::8888
#Domains=
#LLMNR=yes
#MulticastDNS=yes
#DNSOverTLS=no
DNSSEC=no
#Cache=yes
DNSStubListener=no
#ReadEtcHosts=yes
```

#### DNSMASQ Configuration ####

/etc/dnsmasq.conf
```
# Configuration file for dnsmasq.
#
# Format is one option per line, legal options are the same
# as the long options legal on the command line. See
# "/usr/sbin/dnsmasq --help" or "man 8 dnsmasq" for details.

# Listen on this specific port instead of the standard DNS port
# (53). Setting this to zero completely disables DNS function,
# leaving only DHCP and/or TFTP.
#port=5353

# The following two options make you a better netizen, since they
# tell dnsmasq to filter out queries which the public DNS cannot
# answer, and which load the servers (especially the root servers)
# unnecessarily. If you have a dial-on-demand link they also stop
# these requests from bringing up the link unnecessarily.

# Never forward plain names (without a dot or domain part)
#domain-needed
# Never forward addresses in the non-routed address spaces.
#bogus-priv

# Uncomment these to enable DNSSEC validation and caching:
# (Requires dnsmasq to be built with DNSSEC option.)
#conf-file=%%PREFIX%%/share/dnsmasq/trust-anchors.conf
#dnssec

# Replies which are not DNSSEC signed may be legitimate, because the domain
# is unsigned, or may be forgeries. Setting this option tells dnsmasq to
# check that an unsigned reply is OK, by finding a secure proof that a DS 
# record somewhere between the root and the domain does not exist. 
# The cost of setting this is that even queries in unsigned domains will need
# one or more extra DNS queries to verify.
#dnssec-check-unsigned

# Uncomment this to filter useless windows-originated DNS requests
# which can trigger dial-on-demand links needlessly.
# Note that (amongst other things) this blocks all SRV requests,
# so don't use it if you use eg Kerberos, SIP, XMMP or Google-talk.
# This option only affects forwarding, SRV records originating for
# dnsmasq (via srv-host= lines) are not suppressed by it.
#filterwin2k

# Change this line if you want dns to get its upstream servers from
# somewhere other that /etc/resolv.conf
#resolv-file=

# By  default,  dnsmasq  will  send queries to any of the upstream
# servers it knows about and tries to favour servers to are  known
# to  be  up.  Uncommenting this forces dnsmasq to try each query
# with  each  server  strictly  in  the  order  they   appear   in
# /etc/resolv.conf
#strict-order

# If you don't want dnsmasq to read /etc/resolv.conf or any other
# file, getting its servers from this file instead (see below), then
# uncomment this.
#no-resolv

# If you don't want dnsmasq to poll /etc/resolv.conf or other resolv
# files for changes and re-read them then uncomment this.
#no-poll

# Add other name servers here, with domain specs if they are for
# non-public domains.
#server=/localnet/192.168.0.1

# Example of routing PTR queries to nameservers: this will send all
# address->name queries for 192.168.3/24 to nameserver 10.1.2.3
#server=/3.168.192.in-addr.arpa/10.1.2.3

# Add local-only domains here, queries in these domains are answered
# from /etc/hosts or DHCP only.
#local=/localnet/

# Add domains which you want to force to an IP address here.
# The example below send any host in double-click.net to a local
# web-server.
#address=/double-click.net/127.0.0.1

# --address (and --server) work with IPv6 addresses too.
#address=/www.thekelleys.org.uk/fe80::20d:60ff:fe36:f83

# Add the IPs of all queries to yahoo.com, google.com, and their
# subdomains to the vpn and search ipsets:
#ipset=/yahoo.com/google.com/vpn,search

# You can control how dnsmasq talks to a server: this forces
# queries to 10.1.2.3 to be routed via eth1
# server=10.1.2.3@eth1

# and this sets the source (ie local) address used to talk to
# 10.1.2.3 to 192.168.1.1 port 55 (there must be an interface with that
# IP on the machine, obviously).
# server=10.1.2.3@192.168.1.1#55

# If you want dnsmasq to change uid and gid to something other
# than the default, edit the following lines.
#user=
#group=

# If you want dnsmasq to listen for DHCP and DNS requests only on
# specified interfaces (and the loopback) give the name of the
# interface (eg eth0) here.
# Repeat the line for more than one interface.
#interface=
# Or you can specify which interface _not_ to listen on
#except-interface=
# Or which to listen on by address (remember to include 127.0.0.1 if
# you use this.)
#listen-address=
# If you want dnsmasq to provide only DNS service on an interface,
# configure it as shown above, and then use the following line to
# disable DHCP and TFTP on it.
#no-dhcp-interface=

interface=enp2s0
interface=enp3s0
interface=enp4s0
interface=enp5s0
interface=enp6s0

# On systems which support it, dnsmasq binds the wildcard address,
# even when it is listening on only some interfaces. It then discards
# requests that it shouldn't reply to. This has the advantage of
# working even when interfaces come and go and change address. If you
# want dnsmasq to really bind only the interfaces it is listening on,
# uncomment this option. About the only time you may need this is when
# running another nameserver on the same machine.
bind-interfaces

# If you don't want dnsmasq to read /etc/hosts, uncomment the
# following line.
#no-hosts
# or if you want it to read another file, as well as /etc/hosts, use
# this.
#addn-hosts=/etc/banner_add_hosts

# Set this (and domain: see below) if you want to have a domain
# automatically added to simple names in a hosts-file.
#expand-hosts

# Set the domain for dnsmasq. this is optional, but if it is set, it
# does the following things.
# 1) Allows DHCP hosts to have fully qualified domain names, as long
#     as the domain part matches this setting.
# 2) Sets the "domain" DHCP option thereby potentially setting the
#    domain of all systems configured by DHCP
# 3) Provides the domain part for "expand-hosts"
#domain=thekelleys.org.uk

# Set a different domain for a particular subnet
#domain=wireless.thekelleys.org.uk,192.168.2.0/24

# Same idea, but range rather then subnet
#domain=reserved.thekelleys.org.uk,192.68.3.100,192.168.3.200

# Uncomment this to enable the integrated DHCP server, you need
# to supply the range of addresses available for lease and optionally
# a lease time. If you have more than one network, you will need to
# repeat this for each network on which you want to supply DHCP
# service.
#dhcp-range=192.168.0.50,192.168.0.150,12h

dhcp-range=enp2s0,10.0.10.50,10.0.10.200,12h
dhcp-range=enp3s0,10.0.20.50,10.0.20.200,12h
dhcp-range=enp4s0,10.0.30.50,10.0.30.200,12h
dhcp-range=enp5s0,10.0.35.50,10.0.35.200,12h
dhcp-range=enp6s0,10.0.40.50,10.0.40.200,12h

# This is an example of a DHCP range where the netmask is given. This
# is needed for networks we reach the dnsmasq DHCP server via a relay
# agent. If you don't know what a DHCP relay agent is, you probably
# don't need to worry about this.
#dhcp-range=192.168.0.50,192.168.0.150,255.255.255.0,12h

# This is an example of a DHCP range which sets a tag, so that
# some DHCP options may be set only for this network.
#dhcp-range=set:red,192.168.0.50,192.168.0.150

# Use this DHCP range only when the tag "green" is set.
#dhcp-range=tag:green,192.168.0.50,192.168.0.150,12h

# Specify a subnet which can't be used for dynamic address allocation,
# is available for hosts with matching --dhcp-host lines. Note that
# dhcp-host declarations will be ignored unless there is a dhcp-range
# of some type for the subnet in question.
# In this case the netmask is implied (it comes from the network
# configuration on the machine running dnsmasq) it is possible to give
# an explicit netmask instead.
#dhcp-range=192.168.0.0,static

# Enable DHCPv6. Note that the prefix-length does not need to be specified
# and defaults to 64 if missing/
#dhcp-range=1234::2, 1234::500, 64, 12h

# Do Router Advertisements, BUT NOT DHCP for this subnet.
#dhcp-range=1234::, ra-only 

# Do Router Advertisements, BUT NOT DHCP for this subnet, also try and
# add names to the DNS for the IPv6 address of SLAAC-configured dual-stack 
# hosts. Use the DHCPv4 lease to derive the name, network segment and 
# MAC address and assume that the host will also have an
# IPv6 address calculated using the SLAAC algorithm.
#dhcp-range=1234::, ra-names

# Do Router Advertisements, BUT NOT DHCP for this subnet.
# Set the lifetime to 46 hours. (Note: minimum lifetime is 2 hours.)
#dhcp-range=1234::, ra-only, 48h

# Do DHCP and Router Advertisements for this subnet. Set the A bit in the RA
# so that clients can use SLAAC addresses as well as DHCP ones.
#dhcp-range=1234::2, 1234::500, slaac

# Do Router Advertisements and stateless DHCP for this subnet. Clients will
# not get addresses from DHCP, but they will get other configuration information.
# They will use SLAAC for addresses.
#dhcp-range=1234::, ra-stateless

# Do stateless DHCP, SLAAC, and generate DNS names for SLAAC addresses
# from DHCPv4 leases.
#dhcp-range=1234::, ra-stateless, ra-names

# Do router advertisements for all subnets where we're doing DHCPv6
# Unless overridden by ra-stateless, ra-names, et al, the router 
# advertisements will have the M and O bits set, so that the clients
# get addresses and configuration from DHCPv6, and the A bit reset, so the 
# clients don't use SLAAC addresses.
#enable-ra

# Supply parameters for specified hosts using DHCP. There are lots
# of valid alternatives, so we will give examples of each. Note that
# IP addresses DO NOT have to be in the range given above, they just
# need to be on the same network. The order of the parameters in these
# do not matter, it's permissible to give name, address and MAC in any
# order.

# Always allocate the host with Ethernet address 11:22:33:44:55:66
# The IP address 192.168.0.60
#dhcp-host=11:22:33:44:55:66,192.168.0.60

# Always set the name of the host with hardware address
# 11:22:33:44:55:66 to be "fred"
#dhcp-host=11:22:33:44:55:66,fred

# Always give the host with Ethernet address 11:22:33:44:55:66
# the name fred and IP address 192.168.0.60 and lease time 45 minutes
#dhcp-host=11:22:33:44:55:66,fred,192.168.0.60,45m

# Give a host with Ethernet address 11:22:33:44:55:66 or
# 12:34:56:78:90:12 the IP address 192.168.0.60. Dnsmasq will assume
# that these two Ethernet interfaces will never be in use at the same
# time, and give the IP address to the second, even if it is already
# in use by the first. Useful for laptops with wired and wireless
# addresses.
#dhcp-host=11:22:33:44:55:66,12:34:56:78:90:12,192.168.0.60

# Give the machine which says its name is "bert" IP address
# 192.168.0.70 and an infinite lease
#dhcp-host=bert,192.168.0.70,infinite

# Always give the host with client identifier 01:02:02:04
# the IP address 192.168.0.60
#dhcp-host=id:01:02:02:04,192.168.0.60

# Always give the InfiniBand interface with hardware address
# 80:00:00:48:fe:80:00:00:00:00:00:00:f4:52:14:03:00:28:05:81 the
# ip address 192.168.0.61. The client id is derived from the prefix
# ff:00:00:00:00:00:02:00:00:02:c9:00 and the last 8 pairs of
# hex digits of the hardware address.
#dhcp-host=id:ff:00:00:00:00:00:02:00:00:02:c9:00:f4:52:14:03:00:28:05:81,192.168.0.61

# Always give the host with client identifier "marjorie"
# the IP address 192.168.0.60
#dhcp-host=id:marjorie,192.168.0.60

# Enable the address given for "judge" in /etc/hosts
# to be given to a machine presenting the name "judge" when
# it asks for a DHCP lease.
#dhcp-host=judge

# Never offer DHCP service to a machine whose Ethernet
# address is 11:22:33:44:55:66
#dhcp-host=11:22:33:44:55:66,ignore

# Ignore any client-id presented by the machine with Ethernet
# address 11:22:33:44:55:66. This is useful to prevent a machine
# being treated differently when running under different OS's or
# between PXE boot and OS boot.
#dhcp-host=11:22:33:44:55:66,id:*

# Send extra options which are tagged as "red" to
# the machine with Ethernet address 11:22:33:44:55:66
#dhcp-host=11:22:33:44:55:66,set:red

# Send extra options which are tagged as "red" to
# any machine with Ethernet address starting 11:22:33:
#dhcp-host=11:22:33:*:*:*,set:red

# Give a fixed IPv6 address and name to client with 
# DUID 00:01:00:01:16:d2:83:fc:92:d4:19:e2:d8:b2
# Note the MAC addresses CANNOT be used to identify DHCPv6 clients.
# Note also that the [] around the IPv6 address are obligatory.
#dhcp-host=id:00:01:00:01:16:d2:83:fc:92:d4:19:e2:d8:b2, fred, [1234::5] 

# Ignore any clients which are not specified in dhcp-host lines
# or /etc/ethers. Equivalent to ISC "deny unknown-clients".
# This relies on the special "known" tag which is set when
# a host is matched.
#dhcp-ignore=tag:!known

# Send extra options which are tagged as "red" to any machine whose
# DHCP vendorclass string includes the substring "Linux"
#dhcp-vendorclass=set:red,Linux

# Send extra options which are tagged as "red" to any machine one
# of whose DHCP userclass strings includes the substring "accounts"
#dhcp-userclass=set:red,accounts

# Send extra options which are tagged as "red" to any machine whose
# MAC address matches the pattern.
#dhcp-mac=set:red,00:60:8C:*:*:*

# If this line is uncommented, dnsmasq will read /etc/ethers and act
# on the ethernet-address/IP pairs found there just as if they had
# been given as --dhcp-host options. Useful if you keep
# MAC-address/host mappings there for other purposes.
#read-ethers

# Send options to hosts which ask for a DHCP lease.
# See RFC 2132 for details of available options.
# Common options can be given to dnsmasq by name:
# run "dnsmasq --help dhcp" to get a list.
# Note that all the common settings, such as netmask and
# broadcast address, DNS server and default route, are given
# sane defaults by dnsmasq. You very likely will not need
# any dhcp-options. If you use Windows clients and Samba, there
# are some options which are recommended, they are detailed at the
# end of this section.

# Override the default route supplied by dnsmasq, which assumes the
# router is the same machine as the one running dnsmasq.
#dhcp-option=3,1.2.3.4

dhcp-option=enp2s0,3,10.0.60.1
dhcp-option=enp3s0,3,10.0.70.1
dhcp-option=enp4s0,3,10.0.80.1
dhcp-option=enp5s0,3,10.0.85.1
dhcp-option=enp6s0,3,10.0.90.1

# Do the same thing, but using the option name
#dhcp-option=option:router,1.2.3.4

# Override the default route supplied by dnsmasq and send no default
# route at all. Note that this only works for the options sent by
# default (1, 3, 6, 12, 28) the same line will send a zero-length option
# for all other option numbers.
#dhcp-option=3

# Set the NTP time server addresses to 192.168.0.4 and 10.10.0.5
#dhcp-option=option:ntp-server,192.168.0.4,10.10.0.5

# Send DHCPv6 option. Note [] around IPv6 addresses.
#dhcp-option=option6:dns-server,[1234::77],[1234::88]

# Send DHCPv6 option for namservers as the machine running 
# dnsmasq and another.
#dhcp-option=option6:dns-server,[::],[1234::88]

# Ask client to poll for option changes every six hours. (RFC4242)
#dhcp-option=option6:information-refresh-time,6h

# Set option 58 client renewal time (T1). Defaults to half of the
# lease time if not specified. (RFC2132)
#dhcp-option=option:T1,1m

# Set option 59 rebinding time (T2). Defaults to 7/8 of the
# lease time if not specified. (RFC2132)
#dhcp-option=option:T2,2m

# Set the NTP time server address to be the same machine as
# is running dnsmasq
#dhcp-option=42,0.0.0.0

# Set the NIS domain name to "welly"
#dhcp-option=40,welly

# Set the default time-to-live to 50
#dhcp-option=23,50

# Set the "all subnets are local" flag
#dhcp-option=27,1

# Send the etherboot magic flag and then etherboot options (a string).
#dhcp-option=128,e4:45:74:68:00:00
#dhcp-option=129,NIC=eepro100

# Specify an option which will only be sent to the "red" network
# (see dhcp-range for the declaration of the "red" network)
# Note that the tag: part must precede the option: part.
#dhcp-option = tag:red, option:ntp-server, 192.168.1.1

# The following DHCP options set up dnsmasq in the same way as is specified
# for the ISC dhcpcd in
# http://www.samba.org/samba/ftp/docs/textdocs/DHCP-Server-Configuration.txt
# adapted for a typical dnsmasq installation where the host running
# dnsmasq is also the host running samba.
# you may want to uncomment some or all of them if you use
# Windows clients and Samba.
#dhcp-option=19,0           # option ip-forwarding off
#dhcp-option=44,0.0.0.0     # set netbios-over-TCP/IP nameserver(s) aka WINS server(s)
#dhcp-option=45,0.0.0.0     # netbios datagram distribution server
#dhcp-option=46,8           # netbios node type

# Send an empty WPAD option. This may be REQUIRED to get windows 7 to behave.
#dhcp-option=252,"\n"

# Send RFC-3397 DNS domain search DHCP option. WARNING: Your DHCP client
# probably doesn't support this......
#dhcp-option=option:domain-search,eng.apple.com,marketing.apple.com

# Send RFC-3442 classless static routes (note the netmask encoding)
#dhcp-option=121,192.168.1.0/24,1.2.3.4,10.0.0.0/8,5.6.7.8

# Send vendor-class specific options encapsulated in DHCP option 43.
# The meaning of the options is defined by the vendor-class so
# options are sent only when the client supplied vendor class
# matches the class given here. (A substring match is OK, so "MSFT"
# matches "MSFT" and "MSFT 5.0"). This example sets the
# mtftp address to 0.0.0.0 for PXEClients.
#dhcp-option=vendor:PXEClient,1,0.0.0.0

# Send microsoft-specific option to tell windows to release the DHCP lease
# when it shuts down. Note the "i" flag, to tell dnsmasq to send the
# value as a four-byte integer - that's what microsoft wants. See
# http://technet2.microsoft.com/WindowsServer/en/library/a70f1bb7-d2d4-49f0-96d6-4b7414ecfaae1033.mspx?mfr=true
#dhcp-option=vendor:MSFT,2,1i

# Send the Encapsulated-vendor-class ID needed by some configurations of
# Etherboot to allow is to recognise the DHCP server.
#dhcp-option=vendor:Etherboot,60,"Etherboot"

# Send options to PXELinux. Note that we need to send the options even
# though they don't appear in the parameter request list, so we need
# to use dhcp-option-force here.
# See http://syslinux.zytor.com/pxe.php#special for details.
# Magic number - needed before anything else is recognised
#dhcp-option-force=208,f1:00:74:7e
# Configuration file name
#dhcp-option-force=209,configs/common
# Path prefix
#dhcp-option-force=210,/tftpboot/pxelinux/files/
# Reboot time. (Note 'i' to send 32-bit value)
#dhcp-option-force=211,30i

# Set the boot filename for netboot/PXE. You will only need
# this if you want to boot machines over the network and you will need
# a TFTP server; either dnsmasq's built-in TFTP server or an
# external one. (See below for how to enable the TFTP server.)
#dhcp-boot=pxelinux.0

# The same as above, but use custom tftp-server instead machine running dnsmasq
#dhcp-boot=pxelinux,server.name,192.168.1.100

# Boot for iPXE. The idea is to send two different
# filenames, the first loads iPXE, and the second tells iPXE what to
# load. The dhcp-match sets the ipxe tag for requests from iPXE.
#dhcp-boot=undionly.kpxe
#dhcp-match=set:ipxe,175 # iPXE sends a 175 option.
#dhcp-boot=tag:ipxe,http://boot.ipxe.org/demo/boot.php

# Encapsulated options for iPXE. All the options are
# encapsulated within option 175
#dhcp-option=encap:175, 1, 5b         # priority code
#dhcp-option=encap:175, 176, 1b       # no-proxydhcp
#dhcp-option=encap:175, 177, string   # bus-id
#dhcp-option=encap:175, 189, 1b       # BIOS drive code
#dhcp-option=encap:175, 190, user     # iSCSI username
#dhcp-option=encap:175, 191, pass     # iSCSI password

# Test for the architecture of a netboot client. PXE clients are
# supposed to send their architecture as option 93. (See RFC 4578)
#dhcp-match=peecees, option:client-arch, 0 #x86-32
#dhcp-match=itanics, option:client-arch, 2 #IA64
#dhcp-match=hammers, option:client-arch, 6 #x86-64
#dhcp-match=mactels, option:client-arch, 7 #EFI x86-64

# Do real PXE, rather than just booting a single file, this is an
# alternative to dhcp-boot.
#pxe-prompt="What system shall I netboot?"
# or with timeout before first available action is taken:
#pxe-prompt="Press F8 for menu.", 60

# Available boot services. for PXE.
#pxe-service=x86PC, "Boot from local disk"

# Loads <tftp-root>/pxelinux.0 from dnsmasq TFTP server.
#pxe-service=x86PC, "Install Linux", pxelinux

# Loads <tftp-root>/pxelinux.0 from TFTP server at 1.2.3.4.
# Beware this fails on old PXE ROMS.
#pxe-service=x86PC, "Install Linux", pxelinux, 1.2.3.4

# Use bootserver on network, found my multicast or broadcast.
#pxe-service=x86PC, "Install windows from RIS server", 1

# Use bootserver at a known IP address.
#pxe-service=x86PC, "Install windows from RIS server", 1, 1.2.3.4

# If you have multicast-FTP available,
# information for that can be passed in a similar way using options 1
# to 5. See page 19 of
# http://download.intel.com/design/archives/wfm/downloads/pxespec.pdf


# Enable dnsmasq's built-in TFTP server
#enable-tftp

# Set the root directory for files available via FTP.
#tftp-root=/var/ftpd

# Do not abort if the tftp-root is unavailable
#tftp-no-fail

# Make the TFTP server more secure: with this set, only files owned by
# the user dnsmasq is running as will be send over the net.
#tftp-secure

# This option stops dnsmasq from negotiating a larger blocksize for TFTP
# transfers. It will slow things down, but may rescue some broken TFTP
# clients.
#tftp-no-blocksize

# Set the boot file name only when the "red" tag is set.
#dhcp-boot=tag:red,pxelinux.red-net

# An example of dhcp-boot with an external TFTP server: the name and IP
# address of the server are given after the filename.
# Can fail with old PXE ROMS. Overridden by --pxe-service.
#dhcp-boot=/var/ftpd/pxelinux.0,boothost,192.168.0.3

# If there are multiple external tftp servers having a same name
# (using /etc/hosts) then that name can be specified as the
# tftp_servername (the third option to dhcp-boot) and in that
# case dnsmasq resolves this name and returns the resultant IP
# addresses in round robin fashion. This facility can be used to
# load balance the tftp load among a set of servers.
#dhcp-boot=/var/ftpd/pxelinux.0,boothost,tftp_server_name

# Set the limit on DHCP leases, the default is 150
#dhcp-lease-max=150

# The DHCP server needs somewhere on disk to keep its lease database.
# This defaults to a sane location, but if you want to change it, use
# the line below.
#dhcp-leasefile=/var/lib/misc/dnsmasq.leases

# Set the DHCP server to authoritative mode. In this mode it will barge in
# and take over the lease for any client which broadcasts on the network,
# whether it has a record of the lease or not. This avoids long timeouts
# when a machine wakes up on a new network. DO NOT enable this if there's
# the slightest chance that you might end up accidentally configuring a DHCP
# server for your campus/company accidentally. The ISC server uses
# the same option, and this URL provides more information:
# http://www.isc.org/files/auth.html

dhcp-authoritative

# Set the DHCP server to enable DHCPv4 Rapid Commit Option per RFC 4039.
# In this mode it will respond to a DHCPDISCOVER message including a Rapid Commit
# option with a DHCPACK including a Rapid Commit option and fully committed address
# and configuration information. This must only be enabled if either the server is 
# the only server for the subnet, or multiple servers are present and they each
# commit a binding for all clients.
#dhcp-rapid-commit

# Run an executable when a DHCP lease is created or destroyed.
# The arguments sent to the script are "add" or "del",
# then the MAC address, the IP address and finally the hostname
# if there is one.
#dhcp-script=/bin/echo

# Set the cachesize here.
#cache-size=150

# If you want to disable negative caching, uncomment this.
#no-negcache

# Normally responses which come from /etc/hosts and the DHCP lease
# file have Time-To-Live set as zero, which conventionally means
# do not cache further. If you are happy to trade lower load on the
# server for potentially stale date, you can set a time-to-live (in
# seconds) here.
#local-ttl=

# If you want dnsmasq to detect attempts by Verisign to send queries
# to unregistered .com and .net hosts to its sitefinder service and
# have dnsmasq instead return the correct NXDOMAIN response, uncomment
# this line. You can add similar lines to do the same for other
# registries which have implemented wildcard A records.
#bogus-nxdomain=64.94.110.11

# If you want to fix up DNS results from upstream servers, use the
# alias option. This only works for IPv4.
# This alias makes a result of 1.2.3.4 appear as 5.6.7.8
#alias=1.2.3.4,5.6.7.8
# and this maps 1.2.3.x to 5.6.7.x
#alias=1.2.3.0,5.6.7.0,255.255.255.0
# and this maps 192.168.0.10->192.168.0.40 to 10.0.0.10->10.0.0.40
#alias=192.168.0.10-192.168.0.40,10.0.0.0,255.255.255.0

# Change these lines if you want dnsmasq to serve MX records.

# Return an MX record named "maildomain.com" with target
# servermachine.com and preference 50
#mx-host=maildomain.com,servermachine.com,50

# Set the default target for MX records created using the localmx option.
#mx-target=servermachine.com

# Return an MX record pointing to the mx-target for all local
# machines.
#localmx

# Return an MX record pointing to itself for all local machines.
#selfmx

# Change the following lines if you want dnsmasq to serve SRV
# records.  These are useful if you want to serve ldap requests for
# Active Directory and other windows-originated DNS requests.
# See RFC 2782.
# You may add multiple srv-host lines.
# The fields are <name>,<target>,<port>,<priority>,<weight>
# If the domain part if missing from the name (so that is just has the
# service and protocol sections) then the domain given by the domain=
# config option is used. (Note that expand-hosts does not need to be
# set for this to work.)

# A SRV record sending LDAP for the example.com domain to
# ldapserver.example.com port 389
#srv-host=_ldap._tcp.example.com,ldapserver.example.com,389

# A SRV record sending LDAP for the example.com domain to
# ldapserver.example.com port 389 (using domain=)
#domain=example.com
#srv-host=_ldap._tcp,ldapserver.example.com,389

# Two SRV records for LDAP, each with different priorities
#srv-host=_ldap._tcp.example.com,ldapserver.example.com,389,1
#srv-host=_ldap._tcp.example.com,ldapserver.example.com,389,2

# A SRV record indicating that there is no LDAP server for the domain
# example.com
#srv-host=_ldap._tcp.example.com

# The following line shows how to make dnsmasq serve an arbitrary PTR
# record. This is useful for DNS-SD. (Note that the
# domain-name expansion done for SRV records _does_not
# occur for PTR records.)
#ptr-record=_http._tcp.dns-sd-services,"New Employee Page._http._tcp.dns-sd-services"

# Change the following lines to enable dnsmasq to serve TXT records.
# These are used for things like SPF and zeroconf. (Note that the
# domain-name expansion done for SRV records _does_not
# occur for TXT records.)

#Example SPF.
#txt-record=example.com,"v=spf1 a -all"

#Example zeroconf
#txt-record=_http._tcp.example.com,name=value,paper=A4

# Provide an alias for a "local" DNS name. Note that this _only_ works
# for targets which are names from DHCP or /etc/hosts. Give host
# "bert" another name, bertrand
#cname=bertand,bert

# For debugging purposes, log each DNS query as it passes through
# dnsmasq.
#log-queries

# Log lots of extra information about DHCP transactions.
#log-dhcp

# Include another lot of configuration options.
#conf-file=/etc/dnsmasq.more.conf
#conf-dir=/etc/dnsmasq.d

# Include all the files in a directory except those ending in .bak
#conf-dir=/etc/dnsmasq.d,.bak

# Include all files in a directory which end in .conf
#conf-dir=/etc/dnsmasq.d/,*.conf

# If a DHCP client claims that its name is "wpad", ignore that.
# This fixes a security hole. see CERT Vulnerability VU#598349
#dhcp-name-match=set:wpad-ignore,wpad
#dhcp-ignore-names=tag:wpad-ignore
```

System link resolv.conf otherwise you will get a warning from dnsmasq that it can’t source it.

```
rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

systemctl enable systemd-resolved
systemctl start systemd-resolved
```

### NFTables ###

```
                                              Local
                                             Process
                                               ^ |        .--------------.
                  .-------------.              | |        |   Routing    |
                  |             |-----> Input /   \-----> |  Decision    |----> Output \
--> Prerouting -->|   Routing   |                         .--------------.              \
                  |  Decision   |                                                        --> Postrouting
                  |             |                                                       /
                  |             |---------------> Forward -----------------------------
                  .-------------.
```

Configure NFTables.

/etc/nftables.conf
```
#!/usr/bin/nft -f
# vim:set ts=2 sw=2 et:

# ipv4/ipv6 Firewall
# You can find examples in /usr/share/nftables/

# Globals
define wan0 = enp1s0
define nicvlan200 = enp2s0
define nicvlan300 = enp3s0
define nicvlan400 = enp4s0
define nicvlan450 = enp5s0
define nicvlan500 = enp6s0

# Setup “Filter” Table.
table inet filter {
  chain input {
    # Allow DHCP & DNS.
    udp dport { 67, 68, 53 } accept
    tcp dport 53 accept

    type filter hook input priority 0;

    # Allow established/related connections.
    ct state { established, related } accept

    # Early drop of invalid connections.
    ct state invalid drop

    # Allow from loopback and interfaces.
    iifname { lo, $nicvlan200, $nicvlan300, $nicvlan400, $nicvlan450, $nicvlan500 } accept

    # Allow ICMP.
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept
   
    # Everything else.
    reject with icmp type port-unreachable
  }
  chain forward {
    type filter hook forward priority 0;

    # Allow established/related connections.
    ct state { established, related } accept

    # Allow from internal nics.
    iifname { $nicvlan200, $nicvlan300, $nicvlan400, $nicvlan450, $nicvlan500 } accept
    
    # Forward SSH traffic to SSH server.
    iifname $wan0 oifname $nicvlan200 ip daddr 10.0.10.19 tcp dport ssh accept

    # Allow established/related connections.
    #oifname { $nicvlan200, $nicvlan300, $nicvlan400, $nicvlan450, $nicvlan500 } ct state { established, related } accept

    # Drop everything else.
    drop
  }
  chain output {
    type filter hook output priority 0;
  }
}

# Setup NAT.
table ip nat {
  chain prerouting {
    type nat hook prerouting priority 0
    # Nat WAN port 65222 to 22 on SSH Server.
    iif $wan0 tcp dport 65222 dnat 10.0.10.19:22
  }

  chain postrouting {
    type nat hook postrouting priority 0

    oifname $wan0 masquerade
  }
}
```

Enable, Start, and Status the services to make sure they are active (running).

```
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable dnsmasq
systemctl enable nftables

systemctl start systemd-networkd
systemctl start systemd-resolved
systemctl start dnsmasq
systemctl start nftables

systemctl status systemd-networkd
systemctl status systemd-resolved
systemctl status dnsmasq
systemctl status nftables
```

Debugging

Dnsmasq will collide with systemd-resolved if you don’t set “DNSStubListener=no” and fail to run otherwise you can also set “bind-interfaces” in dnsmasq.conf.

Use SS to find services running on port 53 to find conflicts.

```
ss -alpn sport = 53
```

Check DHCP lease file to see if systems are getting address in the right ranges.

```
/var/lib/misc/dnsmasq.leases
```

Verify your nftables

```
nft list ruleset
```

Add ```meta nftrace set 1``` to a rules line to enable tracing.

Example
```
udp dport { 67, 68, 53 } meta nftrace set 1 accept
```

Then run

```
nft monitor trace
```

Output
```
trace id 991e09c2 inet filter input packet: iif "enp2s0" ether saddr 3c:2e:ff:47:02:0c ether daddr ff:ff:ff:ff:ff:ff ip saddr 0.0.0.0 ip daddr 255.255.255.255 ip dscp cs0 ip ecn not-ect ip ttl 255 ip id 10765 ip protocol udp ip length 328 udp sport 68 udp dport 67 udp length 308 @th,64,96 310722285859775644960817152
trace id 991e09c2 inet filter input rule udp dport { 53, 67, 68 } meta nftrace set 1 accept (verdict accept)
trace id 47802731 inet filter input packet: iif "enp2s0" ether saddr 74:9e:af:5b:73:10 ether daddr ff:ff:ff:ff:ff:ff ip saddr 0.0.0.0 ip daddr 255.255.255.255 ip dscp cs0 ip ecn not-ect ip ttl 255 ip id 34458 ip protocol udp ip length 328 udp sport 68 udp dport 67 udp length 308 @th,64,96 310722280870613021131538432
trace id 47802731 inet filter input rule udp dport { 53, 67, 68 } meta nftrace set 1 accept (verdict accept)
```

Check if DNS server is around.

```
nmap -sT -p 53 10.0.20.1
```

Check for dhcp.

```
nmap --script broadcast-dhcp-discover -e enp2s0
```

Dump tcp traffic.

```
tcpdump -i enp2s0
```

Dump dhcp traffic.

```
tcpdump -i enp2s0 port 67 or port 68 -e -n
```

Output

```
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp2s0, link-type EN10MB (Ethernet), capture size 262144 bytes
16:09:59.116782 3c:2e:ff:aa:02:0c > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 342: 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 3c:2e:ff:aa:02:0c, length 300
16:10:15.605452 28:c7:ce:d6:15:83 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 594: vlan 200, p 3, ethertype IPv4, 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 28:c7:ce:d6:15:83, length 548
16:10:15.607460 4c:00:82:e0:e7:c3 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 346: vlan 200, p 0, ethertype IPv4, 10.0.10.1.67 > 255.255.255.255.68: BOOTP/DHCP, Reply, length 300
16:10:19.605449 28:c7:ce:d6:15:83 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 594: vlan 200, p 3, ethertype IPv4, 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 28:c7:ce:d6:15:83, length 548
16:10:19.606852 4c:00:82:e0:e7:c3 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 346: vlan 200, p 0, ethertype IPv4, 10.0.10.1.67 > 255.255.255.255.68: BOOTP/DHCP, Reply, length 300
16:10:19.612006 28:c7:ce:d6:15:83 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 594: vlan 200, p 3, ethertype IPv4, 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 28:c7:ce:d6:15:83, length 548
16:10:19.613211 4c:00:82:e0:e7:c3 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 346: vlan 200, p 0, ethertype IPv4, 10.0.10.1.67 > 255.255.255.255.68: BOOTP/DHCP, Reply, length 300
16:10:20.959557 3c:2e:ff:aa:02:0c > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 342: 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 3c:2e:ff:aa:02:0c, length 300
```

Check networkctl for routable configuration.

```
networkctl

IDX LINK TYPE OPERATIONAL SETUP
    1 lo    loopback carrier unmanaged
    2 enp1s0 ether routable configured
    3 enp2s0 ether routable configured
    4 enp3s0 ether routable configured
    5 enp4s0 ether routable configured
    6 enp5s0 ether routable configured
    7 enp6s0 ether routable configured
```

Output configs/logs to online service for further help (If you have a working network).

```
cat /etc/nftables.conf | nc termbin.com 9999
nft list ruleset | nc termbin.com 9999
cat /etc/dnsmasq.conf | egrep -v "(^#.*|^$)" | nc termbin.com 9999 (remove comments from dnsmasq.conf)
etc...
```

Purge iptables from existence.

```
modprobe -r iptable_raw iptable_mangle iptable_nat iptable_filter
```

Check DNSMasq for errors.

```
systemctl status dnsmasq
```

Check Networkctl for non-routable interface.

```
networkctl status -a
```

Check if interfaces have an ip address.

```
ip addr
```

Ping test.

```
ping -c 4 8.8.8.8
ping -c 4 google.com
```

### PCI Passthrough For Wireless Access Point ###

**Hardware**


/etc/modprobe.d/modprobe.conf
```
options kvm_intel nested=1
```

#### Blacklist Intel Chipset ####

I have two wireless network cards, blacklist the Intel driver as were using an atheros chipset.

/etc/modprobe.d/blacklist.conf
```
blacklist iwlwifi
```

#### Check If IOMMU Is Enabled ###

```
grep -E "vmx|svm" /proc/cpuinfo
dmesg | grep -iE "dmar|iommu"
```

#### Find Hardware ID ####

```
lspci -nn
[Taylor Peak] [8086:0082] (rev 34)
02:00.0 Network Controller [0280]: Qualcomm Atheros AR9485 Wireless Network Adapter [168c:0032]  (rev 01)
```

**Intel Hardware ID: 8086:0082**

#### Enable Hardware ID For IOMMU In Bootloader ####

/boot/loader/entries/arch.conf
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda3 rw intel_iommu=on pci-stub.ids=168c:0032
```

```
[user@hypervisor ~]$ dmesg | grep -iE "dmar|iommu"
[    0.000000] Command line: initrd=\initramfs-linux.img root=/dev/sda3 rw intel_iommu=on pci-stub.ids=168c:0032
[    0.012526] ACPI: DMAR 0x00000000D8FFE618 0000B0 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.119733] Kernel command line: initrd=\initramfs-linux.img root=/dev/sda3 rw intel_iommu=on pci-stub.ids=168c:0032
[    0.119770] DMAR: IOMMU enabled
[    0.167363] DMAR: Host address width 39
[    0.167364] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.167368] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.167368] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.167371] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.167372] DMAR: RMRR base: 0x000000d7f17000 end: 0x000000d7f25fff
[    0.167373] DMAR: RMRR base: 0x000000dd000000 end: 0x000000df1fffff
[    0.167374] DMAR-IR: IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.167375] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.167376] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.168004] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.573233] DMAR: No ATSR found
[    0.573257] DMAR: dmar0: Using Queued invalidation
[    0.573262] DMAR: dmar1: Using Queued invalidation
[    0.573318] DMAR: Setting RMRR:
[    0.573372] pci 0000:00:02.0: DMAR: Setting identity map [0xdd000000 - 0xdf1fffff]
[    0.573568] pci 0000:00:14.0: DMAR: Setting identity map [0xd7f17000 - 0xd7f25fff]
[    0.573608] pci 0000:00:1d.0: DMAR: Setting identity map [0xd7f17000 - 0xd7f25fff]
[    0.573623] DMAR: Prepare 0-16MiB unity mapping for LPC
[    0.573648] pci 0000:00:1f.0: DMAR: Setting identity map [0x0 - 0xffffff]
[    0.573778] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.573822] pci 0000:00:00.0: Adding to iommu group 0
[    0.573840] pci 0000:00:02.0: Adding to iommu group 1
[    0.573847] pci 0000:00:03.0: Adding to iommu group 2
[    0.573853] pci 0000:00:14.0: Adding to iommu group 3
[    0.573862] pci 0000:00:16.0: Adding to iommu group 4
[    0.573869] pci 0000:00:19.0: Adding to iommu group 5
[    0.573876] pci 0000:00:1b.0: Adding to iommu group 6
[    0.573883] pci 0000:00:1c.0: Adding to iommu group 7
[    0.573890] pci 0000:00:1c.3: Adding to iommu group 8
[    0.573898] pci 0000:00:1c.4: Adding to iommu group 9
[    0.573905] pci 0000:00:1d.0: Adding to iommu group 10
[    0.573918] pci 0000:00:1f.0: Adding to iommu group 11
[    0.573925] pci 0000:00:1f.2: Adding to iommu group 11
[    0.573933] pci 0000:00:1f.3: Adding to iommu group 11
[    0.573940] pci 0000:02:00.0: Adding to iommu group 12
[    0.573947] pci 0000:03:00.0: Adding to iommu group 13
[    2.739779] [drm] DMAR active, disabling use of stolen memory
```

Now we should be able to see the WiFi Hardware in our VM for PCI-Passthrough.

router001 on QEMU/KVM

Show virtual hardware details

Add Hardware

Add New Virtual Hardware

PCI Host Device

PCI Device

Details

Host Device:
0000:02:00:0 Qualcomm Atheros AR9485 Wireless Network Adapter

Run VM and the wifi card should be present.

```
lspci
0c:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter (rev 01)

ip link
8: wlp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
link/ether 18:cf... brd ff:ff:ff:ff:ff:ff
```

**Software**

pacman -S iw

iw list

Supported interface modes:
IBSS
managed
AP
AP/VLAN
monitor
mesh point
P2P-client
P2P-GO
outside context of a BSS

pacman -S hostapd

/etc/hostapd/hostapd.conf 
```
# Interface configuration
interface=wlp1s0
#bridge=brv400
driver=nl80211
# IEEE 802.11 related configuration
ssid=Test123
hw_mode=g
channel=1
auth_algs=1
wmm_enabled=1

# IEEE 802.11n related configuration
ieee80211n=1

# WPA/IEEE 802.11i configuration
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=Test4321
```

< To be continued... >

Suricata and NFTables

Continue to [Part 05 - VoIP Server](../Infrastructure-Part-5)
