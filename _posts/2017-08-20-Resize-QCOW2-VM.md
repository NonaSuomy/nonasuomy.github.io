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

Resize the partition inside the VM.

**Red Hat Enterprise Linux & derivatives, CentOS, Scientific Linux, etc**

```
vgdisplay
```

```
  --- Volume group ---
  VG Name               scientific_server
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               18.80 GiB
  PE Size               4.00 MiB
  Total PE              4813
  Alloc PE / Size       2253 / 8.80 GiB
  Free  PE / Size       2560 / 10.00 GiB
  VG UUID               5b1ccM-N1G7-zQum-QRXv-O8Us-dzJH-6LdAyC
```

```
lvdisplay
```

```
  --- Logical volume ---
  LV Path                /dev/scientific_server/swap
  LV Name                swap
  VG Name                scientific_server
  LV UUID                arRXqi-blzx-bjWb-IFbV-L7k1-L7SE-1GGsV7
  LV Write Access        read/write
  LV Creation host, time server.local, 2017-08-16 19:07:54 -0400
  LV Status              available
  # open                 2
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:1
   
  --- Logical volume ---
  LV Path                /dev/scientific_server/root
  LV Name                root
  VG Name                scientific_server
  LV UUID                4rwPsh-0Xht-DXff-g5Vu-C3in-jMaV-5A7DqP
  LV Write Access        read/write
  LV Creation host, time server.local, 2017-08-16 19:07:55 -0400
  LV Status              available
  # open                 1
  LV Size                7.80 GiB
  Current LE             1997
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0
```

```
lvextend --extents +100%FREE /dev/scientific_server/root
```

```
  Size of logical volume scientific_server/root changed from 7.80 GiB (1997 extents) to 17.80 GiB (4557 extents).
  Logical volume scientific_server/root successfully resized.
```

```
vgs
```

```
  VG                  #PV #LV #SN Attr   VSize  VFree
  scientific_server   1   2   0 wz--n- 18.80g    0 
```

```
xfs_growfs /dev/mapper/scientific_server-root 
```

```
meta-data=/dev/mapper/scientific_server-root isize=512    agcount=4, agsize=511232 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=2044928, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 2044928 to 4666368
```

```
df -h
```

```
Filesystem                            Size  Used Avail Use% Mounted on
/dev/mapper/scientific_server-root   18G  7.8G   11G  44% /
devtmpfs                              486M     0  486M   0% /dev
tmpfs                                 496M     0  496M   0% /dev/shm
tmpfs                                 496M  6.7M  490M   2% /run
tmpfs                                 496M     0  496M   0% /sys/fs/cgroup
/dev/vda2                            1014M  176M  839M  18% /boot
/dev/vda1                             200M  9.5M  191M   5% /boot/efi
tmpfs                                 100M     0  100M   0% /run/user/0
```


**Other File Systems**

EXT3/4 Based File Systems

```
resize2fs /dev/centos/var
```
