---
layout: post
title: Arch Linux Infrastructure - NAS - Part 7.3 - Import ZFS to Rockstor
---

Current Linux Kernel is 4.10 for Rockstor 3.9.1 in this article.

**Note:** *Do not use kABI-tracking kmod kmod-zfs as it's only for CentOS stock Linux Kernel 3.10 currently.*

EL7.4 Package: http://download.zfsonlinux.org/epel/zfs-release.el7_4.noarch.rpm

```
yum install http://download.zfsonlinux.org/epel/zfs-release.el7_4.noarch.rpm
```

Fingerprint: C93A FFFD 9F3F 7B03 C310 CEB6 A9D5 A1C0 F14A B620

```
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
```

Output:

```
pub  2048R/F14AB620 2013-03-21 ZFS on Linux <zfs@zfsonlinux.org>
    Key fingerprint = C93A FFFD 9F3F 7B03 C310  CEB6 A9D5 A1C0 F14A B620
    sub  2048R/99685629 2013-03-21
```

DKMS ZFS Install

```
yum install kernel-ml-devel zfs
```

Enable ZFS Services

```
systemctl preset zfs-import-cache zfs-import-scan zfs-mount zfs-share zfs-zed zfs.target zfs-import-scan
```

```
systemctl start zfs-import-scan
```

Modprobe

```
/sbin/modprobe zfs
/sbin/modprobe spl
```

Reboot

```
reboot
```

Check Mounts

```
[root@rockstor ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        3.9G     0  3.9G   0% /dev
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           3.9G  8.8M  3.9G   1% /run
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sdf3        13G  2.2G  9.0G  20% /
tmpfs           3.9G  4.0K  3.9G   1% /tmp
/dev/sdf3        13G  2.2G  9.0G  20% /home
/dev/sdf1       477M  119M  329M  27% /boot
tmpfs           798M     0  798M   0% /run/user/0
/dev/sdf3        13G  2.2G  9.0G  20% /mnt2/rockstor_rockstor
```

Check ZFS Pools

```
[root@rockstor ~]# zpool import
   pool: ZFSPOOL001
     id: 470786607286338326
  state: ONLINE
 status: The pool was last accessed by another system.
 action: The pool can be imported using its name or numeric identifier and
	the '-f' flag.
   see: http://zfsonlinux.org/msg/ZFS-8000-EY
 config:

	ZFSPOOL001  ONLINE
	  raidz1-0  ONLINE
	    sdb     ONLINE
	    sda     ONLINE
	    sdd     ONLINE
```

Import ZPool.

```
[root@rockstor ~]# zpool import ZFSPOOL001
cannot import 'ZFSPOOL001': pool was previously in use from another system.
Last accessed by  (hostid=a3452e9b) at Sat Sep  2 22:30:14 2017
The pool can be imported, use 'zpool import -f' to import the pool.

[root@rockstor ~]# zpool import -f ZFSPOOL001
```

Check zpool status.

```
[root@rockstor ~]# zpool status
  pool: ZFSPOOL001
 state: ONLINE
status: Some supported features are not enabled on the pool. The pool can
	still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(5) for details.
  scan: scrub repaired 0B in 0h19m with 0 errors on Sun Aug 20 00:19:54 2017
config:

	NAME        STATE     READ WRITE CKSUM
	ZFSPOOL001  ONLINE       0     0     0
	  raidz1-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sda     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0

errors: No known data errors

  pool: freenas-boot
 state: ONLINE
status: Some supported features are not enabled on the pool. The pool can
	still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(5) for details.
  scan: scrub repaired 0B in 0h3m with 0 errors on Mon Aug 14 03:48:40 2017
config:

	NAME          STATE     READ WRITE CKSUM
	freenas-boot  ONLINE       0     0     0
	  sde         ONLINE       0     0     0

errors: No known data errors
```

Check Pool iostats.

```
[root@rockstor ~]# zpool iostat -v ZFSPOOL001
              capacity     operations     bandwidth 
pool        alloc   free   read  write   read  write
----------  -----  -----  -----  -----  -----  -----
ZFSPOOL001   200G  7.93T     22      8   398K  99.9K
  raidz1     200G  7.93T     22      8   398K  99.9K
    sdb         -      -      6      2   139K  33.4K
    sda         -      -      8      2   130K  33.3K
    sdd         -      -      6      2   129K  33.2K
----------  -----  -----  -----  -----  -----  -----
```

Check Mount Points Again.

```
[root@rockstor ~]# df -h
Filesystem                            Size  Used Avail Use% Mounted on
devtmpfs                              3.9G     0  3.9G   0% /dev
tmpfs                                 3.9G     0  3.9G   0% /dev/shm
tmpfs                                 3.9G  8.8M  3.9G   1% /run
tmpfs                                 3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sdf3                              13G  2.2G  9.0G  20% /
tmpfs                                 3.9G  4.0K  3.9G   1% /tmp
/dev/sdf3                              13G  2.2G  9.0G  20% /home
/dev/sdf1                             477M  119M  329M  27% /boot
tmpfs                                 798M     0  798M   0% /run/user/0
/dev/sdf3                              13G  2.2G  9.0G  20% /mnt2/rockstor_rockstor
ZFSPOOL001                                    5.2T  128K  5.2T   1% /ZFSPOOL001
ZFSPOOL001/Storage                            5.3T  127G  5.2T   3% /ZFSPOOL001/Storage
ZFSPOOL001/jails                              5.2T  256K  5.2T   1% /ZFSPOOL001/jails
ZFSPOOL001/jails/.warden-template-pluginjail  5.2T  593M  5.2T   1% /ZFSPOOL001/jails/.warden-template-pluginjail
ZFSPOOL001/jails/.warden-template-standard    5.2T  2.2G  5.2T   1% /ZFSPOOL001/jails/.warden-template-standard
ZFSPOOL001/jails/bacula-sd_2                  5.2T  757M  5.2T   1% /ZFSPOOL001/jails/bacula-sd_2
ZFSPOOL001/jails/bareos-fd_1                  5.2T  2.5G  5.2T   1% /ZFSPOOL001/jails/bareos-fd_1
ZFSPOOL001/jails/madsonic_1                   5.2T  1.1G  5.2T   1% /ZFSPOOL001/jails/madsonic_1
ZFSPOOL001/jails/nextcloud_2                  5.2T  1.9G  5.2T   1% /ZFSPOOL001/jails/nextcloud_2
ZFSPOOL001/jails/resilio_1                    5.2T  737M  5.2T   1% /ZFSPOOL001/jails/resilio_1
ZFSPOOL001/jails/subsonic_1                   5.2T  1.1G  5.2T   1% /ZFSPOOL001/jails/subsonic_1
ZFSPOOL001/jails/syncthing_1                  5.2T  745M  5.2T   1% /ZFSPOOL001/jails/syncthing_1
ZFSPOOL001/jails/transmission_1               5.2T  678M  5.2T   1% /ZFSPOOL001/jails/transmission_1
[root@rockstor ~]# cd /ZFSPOOL001
[root@rockstor ZFSPOOL001]# ls
jails  Storage
[root@rockstor ZFSPOOL001]# cd Storage
[root@rockstor Storage]# ls
folder001  folder002  folder003
```

### Some Other Stuff ###

#### RSync Files From ZFS to BTRFS Mounts ####

Made a btrfs storage pool on a fresh 8TB Drive for transfer in Rockstor WebGUI.

Storage => Pools => Create Pool

Select options and name fresh attached drive, should see it show up under /mnt2/BTRFSPOOL001/

```
df -h

Filesystem                            Size  Used Avail Use% Mounted on
devtmpfs                              3.9G     0  3.9G   0% /dev
tmpfs                                 3.9G     0  3.9G   0% /dev/shm
tmpfs                                 3.9G  8.8M  3.9G   1% /run
tmpfs                                 3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sdf3                              13G  2.2G  9.0G  20% /
tmpfs                                 3.9G  4.0K  3.9G   1% /tmp
/dev/sdf3                              13G  2.2G  9.0G  20% /home
/dev/sdf1                             477M  119M  329M  27% /boot
tmpfs                                 798M     0  798M   0% /run/user/0
/dev/sdf3                              13G  2.2G  9.0G  20% /mnt2/rockstor_rockstor
ZFSPOOL001                                    5.2T  128K  5.2T   1% /ZFSPOOL001
ZFSPOOL001/Storage                            5.3T  127G  5.2T   3% /ZFSPOOL001/Storage
ZFSPOOL001/jails                              5.2T  256K  5.2T   1% /ZFSPOOL001/jails
ZFSPOOL001/jails/.warden-template-pluginjail  5.2T  593M  5.2T   1% /ZFSPOOL001/jails/.warden-template-pluginjail
ZFSPOOL001/jails/.warden-template-standard    5.2T  2.2G  5.2T   1% /ZFSPOOL001/jails/.warden-template-standard
ZFSPOOL001/jails/bacula-sd_2                  5.2T  757M  5.2T   1% /ZFSPOOL001/jails/bacula-sd_2
ZFSPOOL001/jails/bareos-fd_1                  5.2T  2.5G  5.2T   1% /ZFSPOOL001/jails/bareos-fd_1
ZFSPOOL001/jails/madsonic_1                   5.2T  1.1G  5.2T   1% /ZFSPOOL001/jails/madsonic_1
ZFSPOOL001/jails/nextcloud_2                  5.2T  1.9G  5.2T   1% /ZFSPOOL001/jails/nextcloud_2
ZFSPOOL001/jails/resilio_1                    5.2T  737M  5.2T   1% /ZFSPOOL001/jails/resilio_1
ZFSPOOL001/jails/subsonic_1                   5.2T  1.1G  5.2T   1% /ZFSPOOL001/jails/subsonic_1
ZFSPOOL001/jails/syncthing_1                  5.2T  745M  5.2T   1% /ZFSPOOL001/jails/syncthing_1
ZFSPOOL001/jails/transmission_1               5.2T  678M  5.2T   1% /ZFSPOOL001/jails/transmission_1
/dev/sdc                                      7.3T  5.7G  7.3T   1% /mnt2/BTRFSPOOL001
```

Install tmux to run in the background for transfer.

```
yum install tmux
```

Start tmux session.

```
tmux new -s mytransfer
```

RSync Args

```
 -r, --recursive             recurse into directories
 -l, --links                 copy symlinks as symlinks
 -t, --times                 preserve modification times
 -D                          same as --devices --specials
 -v, --verbose               increase verbosity
--size-only                  skip files that match in size
--delete                     delete extraneous files from dest dirs
--dry-run                    Test do nothing else!
```

Copy files.

```
rsync -rltDv --size-only -P /ZFSPOOL001/Storage /mnt2/BTRFSPOOL001/
```

Detach from session.

```
ctrl+b d
```

Reattach to session.

```
tmux a -t mytransfer
```

#### ZFS REMOVAL ####

If you want to remove zfs for any reason.

**Note:** *Do not do this unless you no longer require the use of ZFS Pools.*

```
yum remove zfs zfs-kmod spl spl-kmod libzfs2 libnvpair1 libuutil1 libzpool2 zfs-release

find /lib/modules/ \( -name "splat.ko" -or -name "zcommon.ko" \
-or -name "zpios.ko" -or -name "spl.ko" -or -name "zavl.ko" -or \
-name "zfs.ko" -or -name "znvpair.ko" -or -name "zunicode.ko" \) \
-exec /bin/rm {} \;
```
