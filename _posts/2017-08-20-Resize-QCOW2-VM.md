---
layout: post
title: Arch Linux Infrastructure - Hypervisor - Resize VM
---

Shutdown the Guest VM.

Check the current size and view the partition name you want to expand using libvirt utility.

```
sudo virt-filesystems --long --parts --blkdevs -h -a indisk.qcow2
```

```
Name       Type       MBR  Size  Parent
/dev/sda1  partition  -    200M  /dev/sda
/dev/sda2  partition  -    1.0G  /dev/sda
/dev/sda3  partition  -    8.8G  /dev/sda
/dev/sda   device     -    10G   -
```

Create the new (20G) output disk.

**QCOW2**

```
sudo qemu-img create -f qcow2 -o preallocation=metadata outdisk.qcow2 20G
```

```
Formatting 'outdisk.qcow2', fmt=qcow2 size=21474836480 encryption=off cluster_size=65536 preallocation=metadata lazy_refcounts=off refcount_bits=16
```

Copy the old to the new while expand the appropriate partition (Assuming /dev/sda3).

```
sudo virt-resize --expand /dev/sda3 indisk.qcow2 outdisk.qcow2
```

```
[   0.0] Examining indisk.qcow2
**********

Summary of changes:

/dev/sda1: This partition will be left alone.

/dev/sda2: This partition will be left alone.

/dev/sda3: This partition will be resized from 8.8G to 18.8G.  The LVM PV 
on /dev/sda3 will be expanded using the 'pvresize' method.

**********
[   4.8] Setting up initial partition table on outdisk.qcow2
[  13.0] Copying /dev/sda1
[  13.7] Copying /dev/sda2
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ 00:00
[  21.3] Copying /dev/sda3
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ 00:00
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ --:--
[ 444.0] Expanding /dev/sda3 using the 'pvresize' method

Resize operation completed with no errors.  Before deleting the old disk, 
carefully check that the resized disk boots and works correctly.
```

Rename the indisk.qcow2 file as a backup, rename the outdisk.qcow2 as indisk.qcow2 (or modify the guest XML).

```
mv indisk.qcow2 indiskBak20170820.qcow2
mv outdisk.qcow2 indisk.qcow2
```

Reboot the guest and test the new disk file carefully before deleting the original file.
