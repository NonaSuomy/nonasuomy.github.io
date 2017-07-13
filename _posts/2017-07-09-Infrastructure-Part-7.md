---
layout: post
title: Arch Linux Infrastructure - NAS - Part 7 - NASferatu
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutNAS.png "NASferatu")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

Part 07 - NAS - You Are Here!

[Part 08 - TOR](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# NASferatu #

## Optional: Tape Backup ##

[Tape Backup](../TapeBackup)

## Setup USB For Install ##

Download FreeNAS.

[http://www.freenas.org/download-freenas-release/](http://www.freenas.org/download-freenas-release/)

At the time of writing this.

[https://download.freenas.org/11/latest/x64/FreeNAS-11.0-U1.iso](https://download.freenas.org/11/latest/x64/FreeNAS-11.0-U1.iso)

Write FreeNAS to an 8GB USB Drive.

```
cd ~/Downloads

lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 119.2G  0 disk 
├─sda1   8:1    0   512M  0 part /boot
├─sda2   8:2    0    10G  0 part [SWAP]
└─sda3   8:3    0 108.8G  0 part /
sdb      8:16   1   8G  0 disk 
└─sdb1   8:17   1   8G  0 part

sudo dd if=FreeNAS-11.0-U1.iso of=/dev/sdb bs=64k
[sudo] password for nonasuomy: 
8788+1 records in
8788+1 records out
575950848 bytes (576 MB, 549 MiB) copied, 367.878 s, 1.6 MB/s
```

if= refers to the input file, or the name of the file to write to the device.

of= refers to the output file; in this case, the device name of the flash card or removable USB drive. Note that USB device numbers are dynamic, and the target device might be da1 or da2 or another name depending on which devices are attached. Before attaching the target USB drive, use ls /dev/da*. Then attach the target USB drive, wait ten seconds, and run ls /dev/da* again to see the new device name and number of the target USB drive. On Linux, use /dev/sdX, where X refers to the letter of the USB device.

bs= refers to the block size, the amount of data to write at a time. The larger 64K block size shown here helps speed up writes to the USB drive.


Insert 8GB USB Drive into NAS System and boot.

**Note:** *In the BIOS settings, you should make this USB Drive your default boot option as this is the only drive we need for the OS, so we don't consume precious SATA ports that we can use for mass stroage.*

We need a system with at least 8GB of RAM as well.

Continue to [Part 08 - TOR](../Infrastructure-Part-8).
