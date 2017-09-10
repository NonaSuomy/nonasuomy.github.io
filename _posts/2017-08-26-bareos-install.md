---
layout: post
title: Arch Linux Infrastructure - NAS - Part 7 - Bareos Install
---

Installing Bareos on RockStor (CentOS 7)

# Bareos #

Add official bareos repo.

```
yum install wget
```

```
wget -O /etc/yum.repos.d/bareos.repo http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo
```

Install the required packages.

```
yum install bareos bareos-database-mysql bareos-webui bareos-storage-tape mariadb-server
```

Start mariadb & start at boot.

```
systemctl enable mariadb
systemctl start mariadb
```

Run the mysql_secure_install script.

```
mysql_secure_installation
```

Create a file.

```
nano ~/.my.cnf
```

```
[client]
host=localhost
user=root
password=PASSWORD
```

Install Bareos using MySQL scripts.

```
/usr/lib/bareos/scripts/create_bareos_database
/usr/lib/bareos/scripts/make_bareos_tables
/usr/lib/bareos/scripts/grant_bareos_privileges
```

```
[root@server ~]# /usr/lib/bareos/scripts/create_bareos_database
Creating mysql database
Creating of bareos database succeeded.
[root@server ~]# /usr/lib/bareos/scripts/make_bareos_tables
Making mysql tables
Creation of Bareos MySQL tables succeeded.
[root@server ~]# /usr/lib/bareos/scripts/grant_bareos_privileges
Granting mysql tables
Privileges for user bareos granted ON database bareos.
```

Start the services.

```
systemctl start bareos-dir
systemctl start bareos-sd
systemctl start bareos-fd
systemctl start httpd
```

The bareos-webui should now be running

```
http://ip/bareos-webui/
```

The configuration for it can be found in /etc/httpd/conf.d/bareos-webui.conf

In some cases you may have to add it to selinux security (I didn't).

```
setsebool -P httpd_can_network_connect on
```

The web interface.

Web login of bareos.

 
Create a login. Start the bareos-console.

```
bconsole
```

Add user.

```
configure add console name=admin password=password123 profile=webui-admin
```

**Note:** *This didn't work for me tossed up a forbidden error, will have to look into this later for now add your webui password here.*

```
Could not add directive "password": character '@' (include) is forbidden.
```

```
mv /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
```

Change your password.

```
nano /etc/bareos/bareos-dir.d/console/admin.conf

#
# Restricted console used by bareos-webui
#
Console {
  Name = admin
  Password = "admin"
  Profile = "webui-admin"
}
```

Restart bareos services and httpd.

```
systemctl restart bareos-dir
systemctl restart bareos-sd
systemctl restart bareos-fd
systemctl restart httpd
```

Should be able to login with that username and password now.

### Adding An Autochanging Tape Library ###

Check for autochanger and tape drives.

```
lsscsi --generic

[0:0:0:0]    tape    IBM      ULTRIUM-TD3      88M0  /dev/st0   /dev/sg4 
[0:0:0:1]    mediumx IBM      33614LX          0029  /dev/sch0  /dev/sg6 
[3:0:1:0]    disk    ATA      WDC WD30EFRX-68E 0A82  /dev/sda   /dev/sg0 
[4:0:0:0]    disk    ATA      WDC WD30EFRX-68E 0A82  /dev/sdb   /dev/sg1 
[5:0:0:0]    disk    ATA      WDC WD30EFRX-68E 0A80  /dev/sdc   /dev/sg2 
[7:0:0:0]    disk    Lexar    USB Flash Drive  1100  /dev/sdd   /dev/sg3 
[8:0:0:0]    tape    IBM      ULTRIUM-TD3      88M0  /dev/st1   /dev/sg5
```

```
ls -rtl /dev/tape/by-id
total 0
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-35005076312020c2e -> ../../st0
lrwxrwxrwx 1 root root 10 Aug 24 20:44 scsi-35005076312020c2e-nst -> ../../nst0
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-35005076312020ac6 -> ../../st1
lrwxrwxrwx 1 root root 10 Aug 24 20:44 scsi-35005076312020ac6-nst -> ../../nst1
lrwxrwxrwx 1 root root  9 Aug 24 20:44 scsi-3100000e09e0b4486 -> ../../sg6
```

Make sure you installed bareos-storage-tape above or else the files in these locations wont be there.

```
/usr/lib/bareos/scripts/mtx-changer
/etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf.example
/etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example
/etc/bareos/bareos-dir.d/storage/tape.conf.example
```

Copy and Rename all tape related example files.

```
cp /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf.example /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf
cp /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example /etc/bareos/bareos-sd.d/device/tapedrive-0.conf
cp /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example /etc/bareos/bareos-sd.d/device/tapedrive-1.conf
cp /etc/bareos/bareos-dir.d/storage/Tape.conf.example /etc/bareos/bareos-dir.d/storage/Tape.conf
```

Change owner and permissions.

```
chown bareos:bareos /etc/bareos/bareos-sd.d/autochanger/*
chown bareos:bareos /etc/bareos/bareos-sd.d/device/*
chown bareos:bareos /etc/bareos/bareos-dir.d/storage/*
chmod 640 /etc/bareos/bareos-sd.d/autochanger/*
chmod 640 /etc/bareos/bareos-sd.d/device/*
chmod 640 /etc/bareos/bareos-dir.d/storage/*
```

Autochanger Setup.

```
nano /etc/bareos/bareos-sd.d/autochanager/autochanger-0.conf

#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-350011d00018a5f03-nst),
# because the short device names like /dev/sg7
# might change on reboot.
#

Autochanger {
  Name = "autochanger-0"
  # adapt this, to match your storage loader
  Changer Device = /dev/tape/by-id/scsi-35001234567890

  # an Autochanger can contain multiple drive devices
  Device = tapedrive-0
  Device = tapedrive-1

  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
}
```

Tape drive 0 setup.

```
#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-350011d00018a5f03-nst),
# because the short device names like /dev/nst1
# might change on reboot.
#

Device {

    Name = "tapedrive-0"
    DeviceType = tape

    # default:0, only required if the autoloader have multiple drives.
    DriveIndex = 0

    # if only one drive is available, this is normally /dev/nst0.
    # However, it is advised to access it via id (/dev/tape/by-id/...).
    #ArchiveDevice = /dev/nst0
    ArchiveDevice = /dev/tape/by-id/scsi-35001234567891-nst

    # arbitrary string that descripes the the storage media.
    # Bareos uses this to determine, which device can be handle what medi$
    MediaType = LTO

    # enable "Check Labels" if tapes with ANSI/IBM labels
    # should be preserved
    #Check Labels = yes

    AutoChanger = yes                       # default: no
    AutomaticMount = yes                    # default: no
    MaximumFileSize = 10GB                  # default: 1000000000 (1GB)
}
```

Tape drive 1 setup.

```
#
# Preparations:
#
# on Linux use "lsscsi --generic"
# to get a list of your SCSI devices.
# However, normaly you should access your devices by-id
# (eg. /dev/tape/by-id/scsi-35001234567892-nst),
# because the short device names like /dev/nst1
# might change on reboot.
#

Device {

    Name = "tapedrive-1"
    DeviceType = tape

    # default:0, only required if the autoloader have multiple drives.
    DriveIndex = 1

    # if only one drive is available, this is normally /dev/nst0.
    # However, it is advised to access it via id (/dev/tape/by-id/...).
    #ArchiveDevice = /dev/nst1
    ArchiveDevice = /dev/tape/by-id/scsi-350011d00018a5f04-nst

    # arbitrary string that descripes the the storage media.
    # Bareos uses this to determine, which device can be handle what medi$
    MediaType = LTO

    # enable "Check Labels" if tapes with ANSI/IBM labels
    # should be preserved
    #Check Labels = yes

    AutoChanger = yes                       # default: no
    AutomaticMount = yes                    # default: no
    MaximumFileSize = 10GB                  # default: 1000000000 (1GB)
}
```

Get storage director password.

```
cat /etc/bareos/bareos-sd.d/director/bareos-dir.conf

Director {
  Name = bareos-dir
  Password = "Storage director password will show up here."
  Description = "Director, who is permitted to contact this storage daemon."
}
```

Setup Tape.conf

```
nano /etc/bareos/bareos-dir.d/storage/Tape.conf

Storage {
  Name = Tape
  Address  = localhost
  Password = "storage director password here"
  Device = autochanger-0
  Media Type = LTO
  Auto Changer = yes
}
```

Restart bareos services and httpd.

```
systemctl restart bareos-dir
systemctl restart bareos-sd
systemctl restart bareos-fd
systemctl restart httpd
```

Under the storage tab there should now be the tape storage.

### Testing Tools ###

```
NAME
       mt - control magnetic tape drive operation

SYNOPSIS
       mt [-V] [-f device] [--file=device] [--rsh-command=command] [--version] operation [count]

DESCRIPTION
       This  manual page documents the GNU version of mt.  mt performs the given operation, which
       must be one of the tape operations listed below, on a tape drive.

       The default tape device to operate on is taken from the file /usr/include/sys/mtio.h  when
       mt  is  compiled.   It  can  be overridden by giving a device file name in the environment
       variable TAPE or by a command line option (see below), which also overrides  the  environ-
       ment variable.

       The  device must be either a character special file or a remote tape drive.  To use a tape
       drive on another machine as the archive, use a filename that starts with `HOSTNAME:'.  The
       hostname  can be preceded by a username and an `@' to access the remote tape drive as that
       user, if you have permission to do so (typically  an  entry  in	that  user's  `~/.rhosts'
       file).

       The  available  operations  are listed below.  Unique abbreviations are accepted.  Not all
       operations are available on all systems, or work on all types of tape drives.  Some opera-
       tions  optionally  take	a  repeat  count, which can be given after the operation name and
       defaults to 1.

       eof, weof
	      Write count EOF marks at current position.

       fsf    Forward space count files.  The tape is positioned on the first block of	the  next
	      file.

       bsf    Backward	space count files.  The tape is positioned on the first block of the next
	      file.

       fsr    Forward space count records.

       bsr    Backward space count records.

       bsfm   Backward space count file marks.	The tape is positioned on  the	beginning-of-the-
	      tape side of the file mark.

       fsfm   Forward  space  count  file marks.  The tape is positioned on the beginning-of-the-
	      tape side of the file mark.

       asf    Absolute space to file number count.  Equivalent to rewind followed by fsf count.

       seek   Seek to block number count.

       eom    Space to the end of the recorded media  on  the  tape  (for  appending  files  onto
	      tapes).

       rewind Rewind the tape.

       offline, rewoffl
	      Rewind the tape and, if applicable, unload the tape.

       status Print status information about the tape unit.

       retension
	      Rewind the tape, then wind it to the end of the reel, then rewind it again.

       erase  Erase the tape.

       mt  exits with a status of 0 if the operation succeeded, 1 if the operation or device name
       given was invalid, or 2 if the operation failed.

   OPTIONS
       -f, --file=device
	      Use device as the file name of the tape drive to operate on.  To use a  tape  drive
	      on  another machine, use a filename that starts with `HOSTNAME:'.  The hostname can
	      be preceded by a username and an `@' to access the remote tape drive as that  user,
	      if  you  have  permission  to  do so (typically an entry in that user's `~/.rhosts'
	      file).

       --rsh-command=command
	      Notifies mt that it should use command to communicate with remote  devices  instead
	      of /usr/bin/ssh or /usr/bin/rsh.

       -V, --version
	      Print the version number of mt.

REPORTING BUGS
       Report cpio bugs to bug-cpio@gnu.org

       GNU cpio home page: <http://www.gnu.org/software/cpio/>

       General help using GNU software: <http://www.gnu.org/gethelp/>

       Report cpio translation bugs to <http://translationproject.org/team/>
```

**mtx** -- Control SCSI media changer devices.

Mtx is a set of low level driver programs to control features of SCSI backup related devices such as autoloaders, tape changers, mediajukeboxes, and tape drives. It can also report much more data, including serial numbers, maximum block sizes, and TapeAlert(tm) messages that most modern tape drives implement, as well as do raw SCSI READ and WRITE commands to tape drives. 

```
SYNOPSIS

       mtx  [-f <scsi-generic-device>] [nobarcode] [invert] [noattach] command
       [ command ... ]


DESCRIPTION

       The mtx command controls single or multi-drive SCSI media changers such
       as  tape  changers, autoloaders, tape libraries, or optical media juke-
       boxes.  It can also be used with media changers that use the ’ATTACHED’
       API,  presuming  that they properly report the MChanger bit as required
       by the SCSI T-10 SMC specification.


OPTIONS

       The first argument, given following -f , is  the  SCSI  generic  device
       corresponding  to  your media changer.  Consult your operating system’s
       documentation for more information (for example, under Linux these  are
       generally   /dev/sg0   through   /dev/sg15,  under  FreeBSD  these  are
       /dev/pass0 through /dev/passX, under SunOS  it  may  be  a  file  under
       /dev/rdsk).

       The ’invert’ option will invert (flip) the media (for optical jukeboxes
       that allow such) before inserting it into the drive or returning it  to
       the storage slot.

       The  ’noattach’ option forces the regular media changer API even if the
       media changer incorrectly reported that it uses the ’ATTACHED’ API.

       The ’nobarcode’ option forces the loader to not request  barcodes  even
       if the loader is capable of reporting them.

       Following  these  options there may follow one or more robotics control
       commands. Note that the ’invert’ and ’noattach’ options apply to ALL of
       robotics control commands.



COMMANDS

       --version Report the mtx version number (e.g. mtx 1.2.8) and exit.


       inquiry   Report  the  product type (Medium Changer, Tape Drive, etc.),
                 Vendor ID, Product ID, Revision, and whether  this  uses  the
                 Attached  Changer  API (some tape drives use this rather than
                 reporting  a  Medium  Changer  on  a  separate  LUN  or  SCSI
                 address).

       noattach  Make  further  commands  use  the  regular  media changer API
                 rather than the _ATTACHED API, no matter what the  "Attached"
                 bit  said  in  the Inquiry info.  Needed with some brain-dead
                 changers that  report  Attached  bit  but  don’t  respond  to
                 _ATTACHED API.

       inventory Makes  the  robot  arm  go and check what elements are in the
                 slots. This is needed for a few  libraries  like  the  Breece
                 Hill  ones that do not automatically check the tape inventory
                 at system startup.

       status    Reports how many drives and storage elements are contained in
                 the  device.  For  each  drive,  reports whether it has media
                 loaded in it, and if so, from which storage  slot  the  media
                 originated.  For  each  storage  slot,  reports whether it is
                 empty or full, and if the media changer has a bar  code,  MIC
                 reader, or some other way of uniquely identifying media with-
                 out loading it into a drive,  this  reports  the  volume  tag
                 and/or  alternate  volume  tag  for each piece of media.  For
                 historical reasons drives are numbered  from  0  and  storage
                 slots are numbered from 1.

       load <slotnum> [ <drivenum> ]
                 Load media from slot <slotnum> into drive <drivenum>. Drive 0
                 is assumed if the drive number is omitted.

       unload [<slotnum>] [ <drivenum> ]
                 Unloads media from drive <drivenum> into slot  <slotnum>.  If
                 <drivenum>  is  omitted,  defaults to drive 0 (as do all com-
                 mands).  If <slotnum> is omitted, defaults to the  slot  that
                 the drive was loaded from. Note that there’s currently no way
                 to say ’unload drive 1’s media to the  slot  it  came  from’,
                 other than to explicitly use that slot number as the destina-
                 tion.

       [eepos <operation>] transfer <slotnum> <slotnum>
                 Transfers media from one slot to another, assuming that  your
                 mechanism  is capable of doing so. Usually used to move media
                 to/from  an  import/export   port.   ’eepos’   is   used   to
                 extend/retract the import/export tray on certain mid-range to
                 high end tape libraries (if, e.g., the tray was slot 32,  you
                 might  say  say ’eepos 1 transfer 32 32’ to extend the tray).
                 Valid values for eepos <operation> are 0 (do nothing  to  the
                 import/export tray), 1, and 2 (what 1 and 2 do varies depend-
                 ing upon the library, consult your library’s SCSI-level docu-
                 mentation).

       first [<drivenum>]
                 Loads  drive  <drivenum>  from  the  first  slot in the media
                 changer. Unloads the drive if there is already media  in  it.
                 Note that this command may not be what you want on large tape
                 libraries -- e.g. on Exabyte 220, the first slot is usually a
                 cleaning  tape.  If  <drivenum> is omitted, defaults to first
                 drive.


       last [<drivenum>]
                 Loads drive <drivenum>  from  the  last  slot  in  the  media
                 changer.  Unloads the drive if there is already a tape in it.

       next [<drivenum>]
                 Unloads the drive and loads the next tape in sequence. If the
                 drive was empty, loads the first tape into the drive.



AUTHORS

       The  original  ’mtx’  program was written by Leonard Zubkoff and exten-
       sively revised for large multi-drive libraries with bar code readers by
       Eric  Lee  Green  <eric@badtux.org>,  to  whom  all  problems should be
       reported for this revision. See ’mtx.c’ for other contributors.


BUGS AND LIMITATIONS

       You may need to do a ’mt offline’ on the tape drive to eject  the  tape
       before  you  can  issue the ’mtx unload’ command. The Exabyte EZ-17 and
       220 in particular will happily sit there snapping the robot arm’s claws
       around thin air trying to grab a tape that’s not there.

       For  some Linux distributions, you may need to re-compile the kernel to
       scan  SCSI  LUN’s  in  order  to  detect  the  media   changer.   Check
       /proc/scsi/scsi to see what’s going on.

       If  you  try  to  unload  a tape to its ’source’ slot, and said slot is
       full, it will instead put the tape into the first empty slot.  Unfortu-
       nately  the  list of empty slots is not updated between commands on the
       command line, so if you try to unload another drive to a full  ’source’
       slot  during the same invocation of ’mtx’, it will try to unload to the
       same (no longer empty) slot and will urp with a SCSI error.


       This program reads the  Mode  Sense  Element  Address  Assignment  Page
       (SCSI)  and  requests  data  on  all  available  elements.  For  larger
       libraries (more than a couple dozen elements) this sets a  big  Alloca-
       tion_Size in the SCSI command block for the REQUEST_ELEMENT_STATUS com-
       mand in order to be able to read  the  entire  result  of  a  big  tape
       library.  Some  operating  systems may not be able to handle this. Ver-
       sions of Linux earlier than 2.2.6, in particular, may fail this request
       due to inability to find contiguous pages of memory for the SCSI trans-
       fer (later versions of Linux ’sg’ device do scatter-gather so that this
       should no longer be a problem).

       The  eepos command remains in effect for all further commands on a com-
       mand line. Thus you might want to follow eepos 1 transfer  32  32  with
       eepos 0 as the next command (which clears the eepos bits).

       Need a better name for ’eepos’ command! (’eepos’ is the name of the bit
       field in the actual low-level SCSI command, and has nothing to do  with
       what it does).


       This  program  has  only  been tested on Linux with a limited number of
       tape loaders (a dual-drive Exabyte  220  tape  library,  with  bar-code
       reader  and 21 slots, an Exabyte EZ-17 7-slot autoloader, and a Seagate
       DDS-4 autochanger with 6 slots). It may not  work  on  other  operating
       systems  with  larger  libraries,  due  to  the  big SCSI request size.
       Report problems to Eric Lee Green <eric@badtux.org>.


HINTS

       Under Linux, cat /proc/scsi/scsi will tell you what  SCSI  devices  you
       have.   You  can  then refer to them as /dev/sga, /dev/sgb, etc. by the
       order they are reported.

       Under FreeBSD, camcontrol devlist will tell you what SCSI  devices  you
       have, along with which pass device controls them.

       Under  Solaris,  set  up your ’sgen’ driver so that it’ll look for tape
       changers (see /kernel/drv/sgen.conf and the sgen man page), type  touch
       /reconfigure then reboot. You can find your changer in /devices by typ-
       ing /usr/sbin/devfsadm -C to clean out no-longer-extant entries in your
       /devices  directory, then find /devices -name hanger -print to find the
       device name. Set the symbolic link /dev/changer to point to that device
       name (if it is not doing so already).

       With  BRU,  set your mount and unmount commands as described on the EST
       web site at http://www.estinc.com to move to the next tape when backing
       up or restoring. With GNU tar, see mtx.doc for an example of how to use
       tar and mtx to make multi-tape backups.



AVAILABILITY

       This version of mtx is currently being maintained  by  Eric  Lee  Green
       <eric@badtux.org>  formerly  of Enhanced Software Technologies Inc. The
       ’mtx’ home page is http://mtx.sourceforge.net and the  actual  code  is
       currently   available   there   and   via   CVS   from   http://source-
       forge.net/projects/mtx/ .



SEE ALSO

       mt(1),tapeinfo(1),scsitape(1),loaderinfo(1)
```

### Show Autochange Information ###

**mtx**

```
mtx -f /dev/sg6 inquiry
```

Output

```
Product Type: Medium Changer
Vendor ID: 'IBM     '
Product ID: '33614LX         '
Revision: '0029'
Attached Changer API: No    
```

### Show Tape Information ###

Show the tape library scan in tape library memory.

**mtx**

```
Data Transfer Element 0 is tape drive 1 LTO (IBM Gen 3) Address 0x80.
Data Transfer Element 1 is tape drive 2 LTO (IBM Gen 3) Address 0x81.

Storage Element 1 is hand 1 UNIVERSAL Slots 1 - 1 Address 0x0 - 0x0
Storage Element 2 is hand 2 PassThru Fixed Slots UNIVERSAL Slots 1 - 2 Address 0x100 - 0x101
Storage Element 3 is Left Load Ports LTO Slots 1 - 18 Address 0x500 - 0x511.
...
Storage Element 20 is Right Load Ports LTO Slots 19 - 36 Address 0x512 - 0x523.
...
```

```
mtx -f /dev/sg6 status
```

Output

```
  Storage Changer /dev/sg6:2 Drives, 38 Slots ( 36 Import/Export )
Data Transfer Element 0:Full (Storage Element 2 Loaded):VolumeTag = LT1000L3                        
Data Transfer Element 1:Empty
      Storage Element 1:Full :VolumeTag=LT1001L3                        
      Storage Element 2:Empty
      Storage Element 3 IMPORT/EXPORT:Empty
      Storage Element 4 IMPORT/EXPORT:Empty
      Storage Element 5 IMPORT/EXPORT:Full :VolumeTag=LT1002L3                        
      Storage Element 6 IMPORT/EXPORT:Full :VolumeTag=LT1003L3                        
      Storage Element 7 IMPORT/EXPORT:Full :VolumeTag=LT1004L3                        
      Storage Element 8 IMPORT/EXPORT:Full :VolumeTag=LT1005L3                        
      Storage Element 9 IMPORT/EXPORT:Full :VolumeTag=LT1006L3                        
      Storage Element 10 IMPORT/EXPORT:Full :VolumeTag=LT1007L3                        
      Storage Element 11 IMPORT/EXPORT:Full :VolumeTag=LT1008L3                        
      Storage Element 12 IMPORT/EXPORT:Empty
      Storage Element 13 IMPORT/EXPORT:Empty
      Storage Element 14 IMPORT/EXPORT:Empty
      Storage Element 15 IMPORT/EXPORT:Empty
      Storage Element 16 IMPORT/EXPORT:Empty
      Storage Element 17 IMPORT/EXPORT:Empty
      Storage Element 18 IMPORT/EXPORT:Empty
      Storage Element 19 IMPORT/EXPORT:Empty
      Storage Element 20 IMPORT/EXPORT:Empty
      Storage Element 21 IMPORT/EXPORT:Empty
      Storage Element 22 IMPORT/EXPORT:Empty
      Storage Element 23 IMPORT/EXPORT:Empty
      Storage Element 24 IMPORT/EXPORT:Empty
      Storage Element 25 IMPORT/EXPORT:Empty
      Storage Element 26 IMPORT/EXPORT:Empty
      Storage Element 27 IMPORT/EXPORT:Empty
      Storage Element 28 IMPORT/EXPORT:Empty
      Storage Element 29 IMPORT/EXPORT:Empty
      Storage Element 30 IMPORT/EXPORT:Empty
      Storage Element 31 IMPORT/EXPORT:Empty
      Storage Element 32 IMPORT/EXPORT:Empty
      Storage Element 33 IMPORT/EXPORT:Full 
      Storage Element 34 IMPORT/EXPORT:Empty
      Storage Element 35 IMPORT/EXPORT:Empty
      Storage Element 36 IMPORT/EXPORT:Empty
      Storage Element 37 IMPORT/EXPORT:Empty
      Storage Element 38 IMPORT/EXPORT:Empty
```

If this error spits out ```READ ELEMENT STATUS Command Failed```

```
mtx -f /dev/sg6 status
```

```
mtx: Request Sense: Long Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=70 (Current)
mtx: Request Sense: Sense Key=Not Ready
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 04
mtx: Request Sense: Additional Sense Qualifier = 12
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
Mode sense (0x1A) for Page 0x1D failed
mtx: Request Sense: Long Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=70 (Current)
mtx: Request Sense: Sense Key=Not Ready
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 04
mtx: Request Sense: Additional Sense Qualifier = 12
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
READ ELEMENT STATUS Command Failed
```

The tape library is probably not online, or is in sequential mode instead of random mode fix it from the front panel of your loader settings.

### Move Tape In Library ###

Tell tape autochanger to move tape from a slot to a drive or slot to slot etc.

**mtx**

Load storage element 13 into tape drive 0 and 1 for a test.

```
mtx -f /dev/sg6 load 3 0                                                                                    
Loading media from Storage Element 13 into drive 0...done
mtx -f /dev/sg6 load 4 1                                                                                    
Loading media from Storage Element 13 into drive 1...done 
```

### Write Test To Tape ###

First load a tape into both drives.

```
mtx -f /dev/sg6 load 3 0
mtx -f /dev/sg6 load 4 1
```

**Note:** *Tape Drive 0 was sg5 and tape drive 1 was sg4.*

Rewind the tapes.

```
mt -f /dev/sg4 rewind
mt -f /dev/sg5 rewind

mt -f /dev/sg4 weof
mt -f /dev/sg5 weof

mt -f /dev/sg4 rewind
mt -f /dev/sg5 rewind
```

Write to tape with tar.

```
tar cf /dev/sg4 /etc/bareos/
tar cf /dev/sg5 /etc/bareos/
```

Read back data from tape.

```
tar tf /dev/sg4
tar tf /dev/sg5
```

### Unload Tape From Drive ###

**mtx**

```
mtx -f /dev/sg6 unload 3 0
Unloading drive 0 into Storage Element 3...done
```

### Move Tapes Between Slots ###

**mtx**

mtx -f <sg device> transfer <source slot> <destination slot>

```
mtx -f /dev/sg6 transfer 3 5
mtx -f /dev/sg6 status
```
