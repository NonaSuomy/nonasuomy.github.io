---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 4.1 - Virtual Router - LXC ClearOS
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutFW.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router - KVM pfSense/OPNsense](../Infrastructure-Part-4)

Part 04.1 - ALT - Virtual Router - LXC ClearOS - You Are Here!

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Virtual Router Setup #

## KVM ##

Create a new KVM virtual machine and install ClearOS to it from the install media.

Follow the pfsense guide if you need help with virt-manager.

After complete and running shutdown vm.

Mount the qcow2 image with libguestfs.

```
yaourt libguestfs
```

**Takes a long time to install...**

```
mkdir /mnt/clearosmnt

sudo guestmount -a /var/lib/libvirt/images/clearos.qcow2 -m /dev/clearos/root /mnt/clearosmnt
```

## LXC ##

### Create a new empty lxc container ###

Create a new empty LXC container with a default configuration. I'll name it 'clearos'.

```
lxc-create --name clearos
```

LXC's containers are created within /var/lib/lxc and you should now see /var/lib/lxc/clearos container. The container containes one entry for now: config for its configuration we will add a rootfs directory which will contain the containers filesystem.

### Copy the KVM image into the LXC container ###

```
rsync -av /mnt/clearosmnt/* /var/lib/lxc/clearos/rootfs
```

### Prepare the container's device nodes and fix fstab ###

LXC does not support udev, so we'll have to create the container's device nodes by ourself. To simplify this, I've used the following bash script and copied it to /usr/local/sbin/create-lxc-nodes.sh

```
nano /usr/local/sbin/create-lxc-nodes.sh
```

```
#!/bin/bash
ROOT=$(pwd)
DEV=${ROOT}/dev
mv ${DEV} ${DEV}.old
mkdir -p ${DEV}
mknod -m 666 ${DEV}/null c 1 3
mknod -m 666 ${DEV}/zero c 1 5
mknod -m 666 ${DEV}/random c 1 8
mknod -m 666 ${DEV}/urandom c 1 9
mkdir -m 755 ${DEV}/pts
mkdir -m 1777 ${DEV}/shm
mknod -m 666 ${DEV}/tty c 5 0
mknod -m 600 ${DEV}/console c 5 1
mknod -m 666 ${DEV}/tty0 c 4 0
mknod -m 666 ${DEV}/tty1 c 4 1
mknod -m 666 ${DEV}/tty2 c 4 2
mknod -m 666 ${DEV}/tty3 c 4 3
mknod -m 666 ${DEV}/tty4 c 4 4
mknod -m 666 ${DEV}/tty5 c 4 5
mknod -m 666 ${DEV}/tty6 c 4 6
mknod -m 666 ${DEV}/full c 1 7
mknod -m 600 ${DEV}/initctl p
mknod -m 666 ${DEV}/ptmx c 5 2
```

Use this script to create all needed device nodes:

```
cd /var/lib/lxc/clearos/rootfs
/usr/local/sbin/create-lxc-nodes.sh
```

As all filesystems were already prepared by the host system there's no need for the guest system's init system to do any work during bootup (actually this might rather be harmful). 

To prevent any problems comment out each and every line within the guests "etc/fstab" configuration file.

```
nano /var/lib/lxc/clearos/rootfs/etc/fstab
```

```
#
# /etc/fstab
# Created by anaconda on Sat Aug  5 17:05:30 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
#/dev/mapper/clearos-root /                       xfs     defaults        0 0
#UUID=718e371f-4221-4724-b784-df7cbd79df08 /boot                   xfs     defaults        0 0
#UUID=319B-8266          /boot/efi               vfat    umask=0077,shortname=winnt 0 0
#/dev/mapper/clearos-swap swap                    swap    defaults        0 0
```


### Create LXC Configuration File ###

Each LXC container's configuration is stored in the "config" file which is situated around the "rootfs" directory. Create a new one.

```
nano /var/lib/lxc/clearos/config
```

```
# Template used to create this container: (null)
# Parameters passed to the template:
lxc.mount.entry = proc proc proc nodev,noexec,nosuid 0 0
lxc.mount.entry = sysfs sys sysfs defaults  0 0
lxc.tty = 2
lxc.pts = 1024
lxc.cgroup.devices.deny = a
lxc.cgroup.devices.allow = c 1:3 rwm
lxc.cgroup.devices.allow = c 1:5 rwm
lxc.cgroup.devices.allow = c 5:1 rwm
lxc.cgroup.devices.allow = c 5:0 rwm
lxc.cgroup.devices.allow = c 4:0 rwm
lxc.cgroup.devices.allow = c 4:1 rwm
lxc.cgroup.devices.allow = c 1:9 rwm
lxc.cgroup.devices.allow = c 1:8 rwm
lxc.cgroup.devices.allow = c 136:* rwm
lxc.cgroup.devices.allow = c 5:2 rwm
lxc.cgroup.devices.allow = c 254:0 rm
lxc.utsname = clearos
lxc.network.type = veth
lxc.network.name = eth0
lxc.network.link = brv100
lxc.network.hwaddr = 00:16:3e:f1:35:10
lxc.network.flags = up
lxc.network.type = veth
lxc.network.name = eth1
lxc.network.link = brv200
lxc.network.hwaddr = 00:16:3e:f1:35:20
lxc.network.flags = up
lxc.network.type = veth
lxc.network.name = eth2
lxc.network.link = brv300
lxc.network.hwaddr = 00:16:3e:f1:35:30
lxc.network.flags = up
lxc.network.type = veth
lxc.network.name = eth3
lxc.network.link = brv400
lxc.network.hwaddr = 00:16:3e:f1:35:40
lxc.network.flags = up
lxc.network.type = veth
lxc.network.name = eth4
lxc.network.link = brv450
lxc.network.hwaddr = 00:16:3e:f1:35:45
lxc.network.flags = up
lxc.network.type = veth
lxc.network.name = eth5
lxc.network.link = brv500
lxc.network.hwaddr = 00:16:3e:f1:35:50
lxc.network.flags = up
lxc.cap.drop = sys_module
lxc.cap.drop = mac_admin
lxc.cap.drop = mac_override
lxc.cap.drop = sys_time
lxc.rootfs = /var/lib/lxc/clearos/rootfs
```

Allow a couple of devices (mostly terminals) and provide a mounted proc and sys filesystem to the guest. Note the container's name (lxc.utsname) and the configured path for it's root filesystem (/var/lib/lxc/clearos/rootfs). In addition this configuration file contains the network configuration (IP address which the container will be assigned to by the internal DHCP server). Please don't forget to provide an unique MAC address (hwaddr) to each container.

### Start The Container ###

Start the container in the background and Attach into it.

```
lxc-start --name clearos -d
lxc-attach --name clearos
```

Say hello to your new container!

Edit network interfaces.

```
nano /var/lib/lxc/clearos/rootfs/etc/clearos/network.conf
```

```
# Network mode
MODE="gateway"

# Network interface roles
EXTIF="eth0"
LANIF="eth1 eth2 eth3 eth4 eth5"
DMZIF=""
HOTIF=""

# Domain and Internet Hostname
DEFAULT_DOMAIN="local.domain"
INTERNET_HOSTNAME="internet.local.domain"

# Extra LANS
EXTRALANS=""

# ISP Maximum Speeds
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth0
```

```
TYPE="Ethernet"
BOOTPROTO="dhcp"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
UUID="8839d2a0-b6bb-4baa-8e99-903d296f76f2"
DEVICE="eth0"
ONBOOT="yes"
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth1
```

Set the static IP address here that you will use to login to the webGUI with make sure it's in the same range as your host's IP or you won't be able to get in.

```
TYPE="Ethernet"
BOOTPROTO="none"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
IPADDR=10.0.1.1
NETMASK=255.255.255.0
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth1"
DEVICE="eth1"
ONBOOT="yes"
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth2
```

```
DEVICE=eth2
TYPE="Ethernet"
ONBOOT="yes"
USERCTL="no"
BOOTPROTO="static"
IPADDR="10.0.2.1"
NETMASK="255.255.255.0"
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth3
```

```
DEVICE=eth3
TYPE="Ethernet"
ONBOOT="yes"
USERCTL="no"
BOOTPROTO="static"
IPADDR="10.0.3.1"
NETMASK="255.255.255.0"
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth4
```

```
DEVICE=eth4
TYPE="Ethernet"
ONBOOT="yes"
USERCTL="no"
BOOTPROTO="static"
IPADDR="10.0.4.1"
NETMASK="255.255.255.0"
```

```
nano /var/lib/lxc/clearos/rootfs/etc/sysconfig/network-scripts/ifcfg-eth5
```

```
DEVICE=eth5
TYPE="Ethernet"
ONBOOT="yes"
USERCTL="no"
BOOTPROTO="static"
IPADDR="10.0.5.1"
NETMASK="255.255.255.0"
```

Reboot container.

```
lxc-stop -n clearos -r
```

If you change the config kill and start the container to re-read from the config file then attach again.

```
lxc-stop -n clearos -k
lxc-start --name clearos -d
lxc-attach --name clearos
```

Otherwise you won't see all the interfaces we added above.

If you attach to the interface and you want to see if the IP's are working.

```
/usr/sbin/ip addr
```

You should see all the interfaces we made eth0, eth1, eth2, eth3, eth4 and eth5 and their IP address.

Try this if you are not attached to the LXC

```
[root@hypervisor ~]# lxc-ls --fancy
NAME    STATE   AUTOSTART GROUPS IPV4 IPV6 
clearos STOPPED 0         -      -    -    
```

If it's running you will see an IP address there of the first interface (WAN).

```

If you want to auto start this container 

```
nano /var/lib/lxc/clearos/config
```

```
lxc.start.auto = 1
```

We can check that line works with

```
lxc-ls --fancy
```

You can even set a boot order and a boot delay :

```
lxc.start.delay = 0 (in seconds)
lxc.start.order = 0 (higher means earlier)
```

Ignore the rest of this as it is for a Ubuntu system but you might want to do something similar for a CentOS system...

### Improve The Container ###

There are some things that are not needed anymore. All commands are entered within the container.

 $ apt-get remove --purge acpid acpi
 $ update-rc.d -f hwclock.sh remove
 $ update-rc.d -f mountall.sh remove
 $ update-rc.d -f checkfs.sh remove
 $ update-rc.d -f udev remove
Let's see how we can improve the container in the future..
