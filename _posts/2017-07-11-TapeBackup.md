---
layout: post
title: Arch Linux Infrastructure - NAS Server - Extra - Tape Backup
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutTAP.png "Tape Library")

[https://forums.freenas.org/index.php?threads/tape-backup-setup-freenas-bacula.30376/](https://forums.freenas.org/index.php?threads/tape-backup-setup-freenas-bacula.30376/)

[http://www.freshports.org/search.php?query=bareos](http://www.freshports.org/search.php?query=bareos)

# Tape Library #

## Setup ##

After setting up your FreeNAS box properly.

Hit the website http://FreenasIP

Click Plugs.

Click bacula-sd - Network backup solution (server) - 5.2.12_3.

Click install.

After bacula plugin jail is finished installing.

Log in to FreeNAS box.

```
ssh root@<FreenasIP>
```

List jails.

```
jls
root@freenas:~ # jls
   JID  IP Address      Hostname                      Path
     1                  bacula-sd_1                   /mnt/HQ/jails/bacula-sd_1
     2                  bareos-fd_1                   /mnt/HQ/jails/bareos-fd_1
     3                  nextcloud_1                   /mnt/HQ/jails/nextcloud_1
     4                  transmission_1                /mnt/HQ/jails/transmission_1
```

Turn yourself into bacula-sd_1 jail.

```
root@freenas:~ # jexec 1 /bin/tcsh
```

Prevent overwriting our custom configuration.

Edit ix-bacula-sd and change ```start_cmd=generate_bacula_sd``` to ```start_cmd=':'```.

```
nano /usr/local/etc/rc.d/ix-bacula-sd

name=ix-bacula-sd
#start_cmd=generate_bacula_sd
start_cmd=':'
stop_cmd=':'

```

### camcontrol ###

```
root@freenas:~ # camcontrol 
usage:  camcontrol <command>  [device id][generic args][command args]
        camcontrol devlist    [-b] [-v]
        camcontrol periphlist [dev_id][-n dev_name] [-u unit]
        camcontrol tur        [dev_id][generic args]
        camcontrol inquiry    [dev_id][generic args] [-D] [-S] [-R]
        camcontrol identify   [dev_id][generic args] [-v]
        camcontrol reportluns [dev_id][generic args] [-c] [-l] [-r report]
        camcontrol readcap    [dev_id][generic args] [-b] [-h] [-H] [-N]
                              [-q] [-s]
        camcontrol start      [dev_id][generic args]
        camcontrol stop       [dev_id][generic args]
        camcontrol load       [dev_id][generic args]
        camcontrol eject      [dev_id][generic args]
        camcontrol reprobe    [dev_id][generic args]
        camcontrol rescan     <all | bus[:target:lun]>
        camcontrol reset      <all | bus[:target:lun]>
        camcontrol defects    [dev_id][generic args] <-f format> [-P][-G]
                              [-q][-s][-S offset][-X]
        camcontrol modepage   [dev_id][generic args] <-m page | -l>
                              [-P pagectl][-e | -b][-d]
        camcontrol cmd        [dev_id][generic args]
                              <-a cmd [args] | -c cmd [args]>
                              [-d] [-f] [-i len fmt|-o len fmt [args]] [-r fmt]
        camcontrol smpcmd     [dev_id][generic args]
                              <-r len fmt [args]> <-R len fmt [args]>
        camcontrol smprg      [dev_id][generic args][-l]
        camcontrol smppc      [dev_id][generic args] <-p phy> [-l]
                              [-o operation][-d name][-m rate][-M rate]
                              [-T pp_timeout][-a enable|disable]
                              [-A enable|disable][-s enable|disable]
                              [-S enable|disable]
        camcontrol smpphylist [dev_id][generic args][-l][-q]
        camcontrol smpmaninfo [dev_id][generic args][-l]
        camcontrol debug      [-I][-P][-T][-S][-X][-c]
                              <all|bus[:target[:lun]]|off>
        camcontrol tags       [dev_id][generic args] [-N tags] [-q] [-v]
        camcontrol negotiate  [dev_id][generic args] [-a][-c]
                              [-D <enable|disable>][-M mode][-O offset]
                              [-q][-R syncrate][-v][-T <enable|disable>]
                              [-U][-W bus_width]
        camcontrol format     [dev_id][generic args][-q][-r][-w][-y]
        camcontrol sanitize   [dev_id][generic args]
                              [-a overwrite|block|crypto|exitfailure]
                              [-c passes][-I][-P pattern][-q][-U][-r][-w]
                              [-y]
        camcontrol idle       [dev_id][generic args][-t time]
        camcontrol standby    [dev_id][generic args][-t time]
        camcontrol sleep      [dev_id][generic args]
        camcontrol apm        [dev_id][generic args][-l level]
        camcontrol aam        [dev_id][generic args][-l level]
        camcontrol fwdownload [dev_id][generic args] <-f fw_image> [-q]
                              [-s][-y]
        camcontrol security   [dev_id][generic args]
                              <-d pwd | -e pwd | -f | -h pwd | -k pwd>
                              [-l <high|maximum>] [-q] [-s pwd] [-T timeout]
                              [-U <user|master>] [-y]
        camcontrol hpa        [dev_id][generic args] [-f] [-l] [-P] [-p pwd]
                              [-q] [-s max_sectors] [-U pwd] [-y]
        camcontrol persist    [dev_id][generic args] <-i action|-o action>
                              [-a][-I tid][-k key][-K sa_key][-p][-R rtp]
                              [-s scope][-S][-T type][-U]
        camcontrol attrib     [dev_id][generic args] <-r action|-w attr>
                              [-a attr_num][-c][-e elem][-F form1,form1]
                              [-p part][-s start][-T type][-V vol]
        camcontrol opcodes    [dev_id][generic args][-o opcode][-s SA]
                              [-N][-T]
        camcontrol zone       [dev_id][generic args]<-c cmd> [-a] [-l LBA]
                              [-o rep_opts] [-P print_opts]
        camcontrol epc        [dev_id][generic_args]<-c cmd> [-d] [-D] [-e]
                              [-H] [-p power_cond] [-P] [-r rst_src] [-s]
                              [-S power_src] [-T timer]
        camcontrol timestamp  [dev_id][generic_args] <-r [-f format|-m|-U]>|
                              <-s <-f format -T time | -U >>
                              
        camcontrol help
```


Check to see if the tape auto changer is showing.

```
camcontrol devlist

<IBM ULTRIUM-TD3 88M0>             at scbus2 target 0 lun 0 (pass0,sa0)
<IBM ULTRIUM-TD3 88M0>             at scbus3 target 0 lun 0 (pass1,sa1)
<IBM 33614LX 0029>                 at scbus3 target 0 lun 1 (pass2)
<WDC WD30EFRX-68EUZN0 80.00A80>    at scbus4 target 1 lun 0 (pass3,ada0)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 0 lun 0 (pass4,ada1)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 1 lun 0 (pass5,ada2)
<SanDisk U3 Cruzer Micro 8.02>     at scbus9 target 0 lun 0 (pass6,da0)
```

If your autochanger is missing and all you see is the tape drives rescan the scsi bus or just reboot the FreeNAS box.

**Note:** *Tape unit should be powered up before FreeNAS box.*

```
root@freenas:~ # camcontrol devlist

<IBM ULTRIUM-TD3 88M0>             at scbus2 target 0 lun 0 (pass0,sa0)
<IBM ULTRIUM-TD3 88M0>             at scbus3 target 0 lun 0 (pass1,sa1)
<WDC WD30EFRX-68EUZN0 80.00A80>    at scbus4 target 1 lun 0 (pass3,ada0)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 0 lun 0 (pass4,ada1)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 1 lun 0 (pass5,ada2)
<SanDisk U3 Cruzer Micro 8.02>     at scbus9 target 0 lun 0 (pass6,da0)
```

Rescan SCSI BUS 3 Target 0 LUN 1.

**Note:** *Using "all" took ~20 mins to run so it was much better to directly scan the bus we want.*

camcontrol rescan     <all | bus[:target:lun]>

```
camcontrol rescan 3:0:1
Re-scan of 3:0:1 was successful
```

Check again if the autochanger showed up.

```
root@freenas:~ # camcontrol devlist

<IBM ULTRIUM-TD3 88M0>             at scbus2 target 0 lun 0 (sa1,pass1)
<IBM ULTRIUM-TD3 88M0>             at scbus3 target 0 lun 0 (sa0,pass0)
<IBM 33614LX 0029>                 at scbus3 target 0 lun 1 (ch0,pass2)
<WDC WD30EFRX-68EUZN0 80.00A80>    at scbus4 target 1 lun 0 (pass3,ada0)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 0 lun 0 (pass4,ada1)
<WDC WD30EFRX-68EUZN0 82.00A82>    at scbus5 target 1 lun 0 (pass5,ada2)
<SanDisk U3 Cruzer Micro 8.02>     at scbus9 target 0 lun 0 (pass6,da0)
```

If you can't find the right SCSI BUS # just reboot FreeNAS with the tape unit already on and it should turn up.

Install mtx (control SCSI media	changer	devices)

The mtx command controls single or multi-drive SCSI media changers such
as tape	changers, autoloaders, tape libraries, or optical media juke-
boxes. It can also be used with media changers that use the 'ATTACHED'
API, presuming that they properly report the MChanger bit as required
by the SCSI T-10 SMC specification.

[http://www.freshports.org/misc/mtx](http://www.freshports.org/misc/mtx)

```
pkg install mtx
```

[Documentation for mtx](https://www.freebsd.org/cgi/man.cgi?query=mtx&apropos=0)

## Testing Tape Autochangers ##

Using a bunch of utilities chio, mtx, mt, and btape.

 **[chio](https://www.freebsd.org/cgi/man.cgi?query=chio&sektion=1&manpath=freebsd-release-ports)** -- Medium changer control utility.

The chio utility is used to control the operation of medium changers, such as those found in tape and optical disk jukeboxes.

```
CHIO(1)			FreeBSD	General	Commands Manual		       CHIO(1)

NAME
     chio -- medium changer control utility

SYNOPSIS
     chio [-f changer] command [-<flags>] arg1 arg2 [arg3 [...]]

DESCRIPTION
     The chio utility is used to control the operation of medium changers,
     such as those found in tape and optical disk jukeboxes.

     The options are as	follows:

     -f	changer
	     Use the device changer rather than	the default device /dev/ch0.

     The default changer may be	overridden by setting the environment variable
     CHANGER to	the desired changer device.

     A medium changer apparatus	is made	up of elements.	 There are five	ele-
     ment types: picker	(medium	transport), slot (storage), portal
     (import/export), drive (data transfer), and voltag	(select	by volume
     identifier).  The voltag pseudo-element type allows the selection of
     tapes by their volume tag (typically a barcode on the tape).

     In	this command description, the shorthand	ET will	be used	to represent
     an	element	type, and EU will be used to represent an element unit.	 For
     example, to represent the first robotic arm in the	changer, the ET	would
     be	``picker'' and the EU would be ``0''.

SUPPORTED COMMANDS
     move _from	ET_ _from EU_ _to ET_ _to EU_ [inv]
	     Move the media unit from _from ET/EU_ to _to ET/EU_.  If the
	     optional modifier inv is specified, the media unit	will be
	     inverted before insertion.

     exchange _src ET_ _src EU_	_dst1 ET_ _dst1	EU_ [_dst2 ET_ _dst2 ET_]
	     [inv1] [inv2]
	     Perform a media unit exchange operation.  The media unit in _src
	     ET/EU_ is moved to	_dst1 ET/EU_ and the media unit	previously in
	     _dst1 ET/EU_ is moved to _dst2 ET/EU_.  In	the case of a simple
	     exchange, _dst2 ET/EU_ is omitted and the values _src ET/EU_ are
	     used in their place.  The optional	modifiers inv1 and inv2	spec-
	     ify whether the media units are to	be inverted before insertion
	     into _dst1	ET/EU_ and _dst2 ET/EU_	respectively.

	     Note that not all medium changers support the exchange operation;
	     the changer must have multiple free pickers or emulate multiple
	     free pickers with transient storage.

     return _from ET_ _from EU_
	     Return the	media unit to its source element.  This	command	will
	     query the status of the specified media unit, and will move it to
	     the element specified in its source attribute.  This is a conve-
	     nient way to return media from a drive or portal to its previous
	     element in	the changer.

     position _to ET_ _to EU_ [inv]
	     Position the picker in front of the element described by _to
	     ET/EU_.  If the optional modifier inv is specified, the media
	     unit will be inverted before insertion.

	     Note that not all changers	behave as expected when	issued this
	     command.

     params  Report the	number of slots, drives, pickers, and portals in the
	     changer, and which	picker unit the	changer	is currently config-
	     ured to use.

     getpicker
	     Report which picker unit the changer is currently configured to
	     use.

     setpicker _unit_
	     Configure the changer to use picker _unit_.

     ielem [_timeout_]
	     Perform an	INITIALIZE ELEMENT STATUS operation on the changer.
	     The optional _timeout_ parameter may be given to specify a	time-
	     out in seconds for	the operations.	 This may be used if the oper-
	     ation takes unusually long	because	of buggy firmware or the like.

     voltag [-fca] _ET_	_EU_ [_label_] [_serial_]
	     Change volume tag for an element in the media changer.  This com-
	     mand is only supported by few media changers.  If it is not sup-
	     ported by a device, using this command will usually result	in an
	     "Invalid Field in CDB" error message on the console.

	     If	the -c flag is specified, the volume tag of the	specified ele-
	     ment is cleared.  If the -f flag is specified, the	volume tag is
	     superseded	with the specified volume tag even if a	volume tag is
	     already defined for the element.  It is an	error to not specify
	     the -f flag when trying to	set a label for	an element which
	     already has volume	tag information	defined.

	     The command works with the	primary	volume tag or, if the -a flag
	     is	given, with the	alternate volume tag.

     status [-vVsSbIa] [_type_]
	     Report the	status of all elements in the changer.	If _type_ is
	     specified,	report the status of all elements of type _type_.

     -v	     Print the primary volume tag for each loaded medium, if any.  The
	     volume tag	is printed as ``<LABEL:SERIAL>''.

     -V	     Print the alternate volume	tag for	each loaded medium, if any.

     -s	     Print the additional sense	code and additional sense code quali-
	     fier for each element.

     -S	     Print the element source address for each element.

     -b	     Print SCSI	bus information	for each element.  Note	that this
	     information is valid only for drives.

     -I	     Print the internal	element	addresses for each element.  The
	     internal element address is not normally used with	this driver.
	     It	is reported for	diagnostic purposes only.

     -a	     Print all additional information (as in -vVsSba).

     The status	bits are defined as follows:

     FULL    Element contains a	media unit.

     IMPEXP  Media was deposited into element by an outside human operator.

     EXCEPT  Element is	in an abnormal state.

     ACCESS  Media in this element is accessible by a picker.

     EXENAB  Element supports passing media (exporting)	to an outside human
	     operator.

     INENAB  Element supports receiving	media (importing) from an outside
	     human operator.

FILES
     /dev/ch0  default changer device

EXAMPLES
     chio move slot 3 drive 0
	     Move the media in slot 3 (fourth slot) to drive 0 (first drive).

     chio move voltag VOLUME01 drive 0
	     Move the media with the barcode VOLUME01 to drive 0 (first
	     drive).

     chio return drive 0
	     Remove the	tape from drive	0 (first drive)	and return it to its
	     original location in the rack.

     chio setpicker 2
	     Configure the changer to use picker 2 (third picker) for opera-
	     tions.

SEE ALSO
     mt(1), mount(8)

AUTHORS
     The chio program and SCSI changer driver were written by Jason R. Thorpe
     <thorpej@and.com> for And Communications, http://www.and.com/.

     Additional	work by	Hans Huebner <hans@artcom.de> and Steve	Gunn
     <csg@waterspout.com>.

FreeBSD	11.1			 May 14, 1998			  FreeBSD 11.1
```


**[mtx](http://www.freshports.org/misc/mtx/)** -- Control SCSI media changer devices.

Mtx is a set of low level driver programs to control features of SCSI backup related devices such as autoloaders, tape changers, mediajukeboxes, and tape drives. It can also report much more data, including serial numbers, maximum block sizes, and TapeAlert(tm) messages that most modern tape drives implement, as well as do raw SCSI READ and WRITE commands to tape drives.

It works like chio(1) but supports more features and drives and runs in users land. 

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

**[mt](https://www.freebsd.org/cgi/man.cgi?query=mt&sektion=1&apropos=0&manpath=FreeBSD+11.0-RELEASE+and+Ports)** -- Magnetic tape manipulating program.

 The mt utility is used to command a magnetic tape drive for operations other than reading or writing data.

```
MT(1)			FreeBSD	General	Commands Manual			 MT(1)

NAME
     mt	-- magnetic tape manipulating program

SYNOPSIS
     mt	[-f tapename] command [count]
     mt	[-f tapename] command argument

DESCRIPTION
     The mt utility is used to command a magnetic tape drive for operations
     other than	reading	or writing data.

     The -f option's tapename overrides	the TAPE environment variable
     described below.

     The available commands are	listed below.  Only as many characters as are
     required to uniquely identify a command need be specified.

     The following commands optionally take a count, which defaults to 1.

     weof   Write count	end-of-file (EOF) marks	at the current position.  This
	    returns when the file mark has been	written	to the media.

     weofi  Write count	end-of-file (EOF) marks	at the current position.  This
	    returns as soon as the command has been validated by the tape
	    drive.

     smk    Write count	setmarks at the	current	position (DDS drives only).

     fsf    Forward space count	files.

     fsr    Forward space count	records.

     fss    Forward space count	setmarks (DDS drives only).

     bsf    Backward space count files.

     bsr    Backward space count records.

     bss    Backward space count setmarks (DDS drives only).

     erase  Erase the tape using a long	(often very long) method.  With	a
	    count of 0,	it will	erase the tape using a quick method.  Opera-
	    tion is not	guaranteed if the tape is not at its beginning.	 The
	    tape will be at its	beginning upon completion.

     The following commands ignore count.

     rdhpos	  Read the hardware block position.  The block number reported
		  is specific for that hardware	only.  With drive data com-
		  pression especially, this position may have more to do with
		  the amount of	data sent to the drive than the	amount of data
		  written to tape.  Some drives	do not support this.

     rdspos	  Read the SCSI	logical	block position.	 This typically	is
		  greater than the hardware position by	the number of end-of-
		  file marks.  Some drives do not support this.

     rewind	  Rewind the tape.

     offline, rewoffl
		  Rewind the tape and place the	drive off line.	 Some drives
		  are never off	line.

     load	  Load the tape	into the drive.

     retension	  Re-tension the tape.	This winds the tape from the current
		  position to the end and then to the beginning.  This some-
		  times	improves subsequent reading and	writing, particularly
		  for streaming	drives.	 Some drives do	not support this.

     ostatus	  Output status	information about the drive.  For SCSI mag-
		  netic	tape devices, the current operating modes of density,
		  blocksize, and whether compression is	enabled	is reported.
		  The current state of the driver (what	it thinks that it is
		  doing	with the device) is reported.  If the driver knows the
		  relative position from BOT (in terms of filemarks and
		  records), it outputs that.  Note that	this information is
		  not definitive (only BOT, End	of Recorded Media, and hard-
		  ware or SCSI logical block position (if the drive supports
		  such)	are considered definitive tape positions).

		  Also note that this is the old status	command, and will be
		  eliminated in	favor of the new status	command	(see below) in
		  a future release.

     errstat	  Output (and clear) error status information about this
		  device.  For every normal operation (e.g., a read or a
		  write) and every control operation (e.g,, a rewind), the
		  driver stores	up the last command executed and it is associ-
		  ated status and any residual counts (if any).	 This command
		  retrieves and	outputs	this information.  If possible,	this
		  also clears any latched error	information.

     geteotmodel  Output the current EOT filemark model.  The model states how
		  many filemarks will be written at close if a tape was	being
		  written.

     eod, eom	  Wind the tape	to the end of the recorded data, typically
		  after	an EOF mark where another file may be written.

     rblim	  Report the block limits of the tape drive, including the
		  minimum and maximum block size, and the block	granularity if
		  any.

     The following commands may	require	an argument.

     sethpos	  Set the hardware block position.  The	argument is a hardware
		  block	number to which	to position the	tape.  Some drives do
		  not support this.

     setspos	  Set the SCSI logical block position.	The argument is	a SCSI
		  logical block	number to which	to position the	tape.  Some
		  drives do not	support	this.

     blocksize	  Set the block	size for the drive.  The argument is the num-
		  ber of bytes per block, except 0 commands the	drive to use
		  variable-length blocks.

     seteotmodel  Set the EOT filemark model to	argument and output the	old
		  and new models.  Typically this will be 2 filemarks, but
		  some devices (typically QIC cartridge	drives)	can only write
		  1 filemark.  You may only choose a value of 1	or 2.

     status	  Output status	information about the drive.  For SCSI mag-
		  netic	tape devices, the current operating modes of density,
		  blocksize, and whether compression is	enabled	is reported.
		  The current state of the driver (what	it thinks that it is
		  doing	with the device) is reported.

		  If the driver	knows the relative position from BOT (in terms
		  of filemarks and records), it	outputs	that.  If the tape
		  drive	supports the long form report of the SCSI READ POSI-
		  TION command,	the Reported File Number and Reported Record
		  Number will be numbers other than -1,	and there may be Flags
		  reported as well.

		  The BOP flag means that the logical position of the drive is
		  at the beginning of the partition.

		  The EOP flag means that the logical position of the drive is
		  between Early	Warning	and End	of Partition.

		  The BPEW flag	means that the logical position	of the drive
		  is in	a Programmable Early Warning Zone or on	the EOP	side
		  of Early Warning.

		  Note that the	Reported Record	Number is the tape block or
		  object number	relative to the	beginning of the partition.
		  The Calculated Record	Number is the tape block or object
		  number relative to the previous file mark.

		  Note that the	Calculated File	and Record Numbers are not de-
		  finitive.  The Reported File and Record Numbers are defini-
		  tive,	if they	are numbers other than -1.

		  -v	  Print	additional status information, such as the
			  maximum supported I/O	size.

		  -x	  Print	all available status data to stdout in XML
			  format.

     getdensity	  Report density support information for the tape drive	and
		  any media that is loaded.  Most drives will report at	least
		  basic	density	information similar to that reported by	status
		  command.  Newer tape drives that conform to the T-10 SSC and
		  newer	tape specifications may	report more detailed informa-
		  tion about the types of tapes	they support and the tape cur-
		  rently in the	drive.

		  -x	  Print	all available density data to stdout in	XML
			  format.  Because density information is currently
			  included in the general status XML report used for
			  mt status command, this will be the same XML output
			  via ``mt status -x''

     param	  Display or set parameters.  One of -l, -s, or	-x must	be
		  specified to indicate	which operation	to perform.

		  -l	    List parameters, values and	descriptions.  By
			    default all	parameters will	be displayed.  To dis-
			    play a specific parameter, specify the parameter
			    with -p.

		  -p name   Specify the	parameter name to list (with -l) or
			    set	(with -s).

		  -q	    Enable quiet mode for parameter listing.  This
			    will suppress printing of parameter	descriptions.

		  -s value  Specify the	parameter value	to set.	 The general
			    type of this argument (integer, unsigned integer,
			    string) is determined by the type of the variable
			    indicated by the sa(4) driver.  More detailed
			    argument checking is done by the sa(4) driver.

		  -x	    Print out all parameter information	in XML format.

     protect	  Display or set drive protection parameters.  This is used to
		  control checking and reporting a per-block checksum for tape
		  drives that support it.  Some	drives may only	support	some
		  parameters.

		  -b 0|1    Set	the Recover Buffered Data Protected bit.  If
			    set, this indicates	that checksums are transferred
			    with the logical blocks transferred	by the RECOV-
			    ERED BUFFERED DATA SCSI command.

		  -d	    Disable all	protection information settings.

		  -e	    Enable all protection information settings.	 The
			    default protection method used is Reed-Solomon CRC
			    (protection	method 1), as specified	in ECMA-319.
			    The	default	protection information length used
			    with Reed-Solomon CRC is 4 bytes.  To enable all
			    settings except one	more more settings, specify
			    the	-e argument and	then explicitly	disable	set-
			    tings that you do not wish to enable.  For exam-
			    ple, specifying -e -w 0 will enable	all settings
			    except for LBP_W.

		  -l	    List available protection parmeters	and their cur-
			    rent settings.

		  -L len    Set	the length of the protection information in
			    bytes.  For	Reed-Solomon CRC, the protection
			    information	length should be 4 bytes.

		  -m num    Specify the	numeric	value for the protection
			    method.  The numeric value for Reed-Solomon	CRC is
			    1.

		  -r 0|1    Set	the LBP_R parameter.  When set,	this indicates
			    that each block read from the tape drive will have
			    a checksum at the end.

		  -v	    Enable verbose mode	for parameter listing.	This
			    will include descriptions of each parameter.

		  -w 0|1    Set	the LBP_W parameter.  When set,	this indicates
			    that each block written to the tape	drive will
			    have a checksum at the end.	 The drive will	verify
			    the	checksum before	writing	the block to tape.

     locate	  Set the tape drive's logical position.  One of -b, -e, -f,
		  or -s	must be	specified to indicate the type of position.
		  If the partition number is specified,	the drive will first
		  relocate to the given	partition (if it exists) and then to
		  the position indicated within	that partition.	 If the	parti-
		  tion number is not specified,	the drive will relocate	to the
		  given	position within	the current partition.

		  -b block_addr	  Relocate to the given	tape block or logical
				  object identifier.  Note that	the block num-
				  ber is the Reported Record Number that is
				  relative to the beginning of the partition
				  (or beginning	of tape).

		  -e		  Relocate to the end of data.

		  -f fileno	  Relocate to the given	file number.

		  -p partition	  Specify the partition	to change to.

		  -s setmark	  Relocate to the given	set mark.

     comp	  Set the drive's compression mode.  The non-numeric values of
		  argument are:

		  off	     Turn compression off.
		  on	     Turn compression on.
		  none	     Same as off.
		  enable     Same as on.
		  IDRC	     IBM Improved Data Recording Capability compres-
			     sion (0x10).
		  DCLZ	     DCLZ compression algorithm	(0x20).

		  In addition to the above recognized compression keywords,
		  the user can supply a	numeric	compression algorithm for the
		  drive	to use.	 In most cases,	simply turning the compression
		  `on' will have the desired effect of enabling	the default
		  compression algorithm	supported by the drive.	 If this is
		  not the case (see the	status display to see which compres-
		  sion algorithm is currently in use), the user	can manually
		  specify one of the supported compression keywords (above),
		  or supply a numeric compression value	from the drive's spec-
		  ifications.

		  Note that for	some older tape	drives (for example the
		  Exabyte 8200 and 8500	series drives) it is necessary to
		  switch to a different	density	to tell	the drive to record
		  data in its compressed format.  If the user attempts to turn
		  compression on while the uncompressed	density	is selected,
		  the drive will return	an error.  This	is generally not an
		  issue	for modern tape	drives.

     density	  Set the density for the drive.  For the density codes, see
		  below.  The density value could be given either numerically,
		  or as	a string, corresponding	to the ``Reference'' field.
		  If the string	is abbreviated,	it will	be resolved in the
		  order	shown in the table, and	the first matching entry will
		  be used.  If the given string	and the	resulting canonical
		  density name do not match exactly, an	informational message
		  is output about what the given string	has been taken for.

     The initial version of the	density	table below was	taken from the
     `Historical sequential access density codes' table	(A-1) in Revision 11
     of	the SCSI-3 Stream Device Commands (SSC)	working	draft, dated November
     11, 1997.	Subsequent additions have come from a number of	sources.

     The density codes are:

       0x0    default for device
       0xE    reserved for ECMA

       Value  Width	   Tracks    Density	     Code Type Reference   Note
	       mm    in		     bpmm	bpi
       0x01   12.7  (0.5)    9	       32     (800)  NRZI  R   X3.22-1983   2
       0x02   12.7  (0.5)    9	       63   (1,600)  PE	   R   X3.39-1986   2
       0x03   12.7  (0.5)    9	      246   (6,250)  GCR   R   X3.54-1986   2
       0x05    6.3  (0.25)  4/9	      315   (8,000)  GCR   C   X3.136-1986  1
       0x06   12.7  (0.5)    9	      126   (3,200)  PE	   R   X3.157-1987  2
       0x07    6.3  (0.25)   4	      252   (6,400)  IMFM  C   X3.116-1986  1
       0x08    3.81 (0.15)   4	      315   (8,000)  GCR   CS  X3.158-1987  1
       0x09   12.7  (0.5)   18	    1,491  (37,871)  GCR   C   X3.180	    2
       0x0A   12.7  (0.5)   22	      262   (6,667)  MFM   C   X3B5/86-199  1
       0x0B    6.3  (0.25)   4	       63   (1,600)  PE	   C   X3.56-1986   1
       0x0C   12.7  (0.5)   24	      500  (12,690)  GCR   C   HI-TC1	    1,6
       0x0D   12.7  (0.5)   24	      999  (25,380)  GCR   C   HI-TC2	    1,6
       0x0F    6.3  (0.25)  15	      394  (10,000)  GCR   C   QIC-120	    1,6
       0x10    6.3  (0.25)  18	      394  (10,000)  GCR   C   QIC-150	    1,6
       0x11    6.3  (0.25)  26	      630  (16,000)  GCR   C   QIC-320	    1,6
       0x12    6.3  (0.25)  30	    2,034  (51,667)  RLL   C   QIC-1350	    1,6
       0x13    3.81 (0.15)   1	    2,400  (61,000)  DDS   CS  X3B5/88-185A 5
       0x14    8.0  (0.315)  1	    1,703  (43,245)  RLL   CS  X3.202-1991  5,11
       0x15    8.0  (0.315)  1	    1,789  (45,434)  RLL   CS  ECMA TC17    5,12
       0x16   12.7  (0.5)   48	      394  (10,000)  MFM   C   X3.193-1990  1
       0x17   12.7  (0.5)   48	    1,673  (42,500)  MFM   C   X3B5/91-174  1
       0x18   12.7  (0.5)  112	    1,673  (42,500)  MFM   C   X3B5/92-50   1
       0x19   12.7  (0.5)  128	    2,460  (62,500)  RLL   C   DLTapeIII    6,7
       0x1A   12.7  (0.5)  128	    3,214  (81,633)  RLL   C   DLTapeIV(20) 6,7
       0x1B   12.7  (0.5)  208	    3,383  (85,937)  RLL   C   DLTapeIV(35) 6,7
       0x1C    6.3  (0.25)  34	    1,654  (42,000)  MFM   C   QIC-385M	    1,6
       0x1D    6.3  (0.25)  32	    1,512  (38,400)  GCR   C   QIC-410M	    1,6
       0x1E    6.3  (0.25)  30	    1,385  (36,000)  GCR   C   QIC-1000C    1,6
       0x1F    6.3  (0.25)  30	    2,666  (67,733)  RLL   C   QIC-2100C    1,6
       0x20    6.3  (0.25) 144	    2,666  (67,733)  RLL   C   QIC-6GB(M)   1,6
       0x21    6.3  (0.25) 144	    2,666  (67,733)  RLL   C   QIC-20GB(C)  1,6
       0x22    6.3  (0.25)  42	    1,600  (40,640)  GCR   C   QIC-2GB(C)   ?
       0x23    6.3  (0.25)  38	    2,666  (67,733)  RLL   C   QIC-875M	    ?
       0x24    3.81 (0.15)   1	    2,400  (61,000)	   CS  DDS-2	    5
       0x25    3.81 (0.15)   1	    3,816  (97,000)	   CS  DDS-3	    5
       0x26    3.81 (0.15)   1	    3,816  (97,000)	   CS  DDS-4	    5
       0x27    8.0  (0.315)  1	    3,056  (77,611)  RLL   CS  Mammoth	    5
       0x28   12.7  (0.5)   36	    1,491  (37,871)  GCR   C   X3.224	    1
       0x29   12.7  (0.5)
       0x2A
       0x2B   12.7  (0.5)    3		?	 ?     ?   C   X3.267	    5
       0x40   12.7  (0.5)  384	    4,800  (123,952)	   C   LTO-1
       0x41   12.7  (0.5)  208	    3,868  (98,250)  RLL   C   DLTapeIV(40) 6,7
       0x42   12.7  (0.5)  512	    7,398  (187,909)	   C   LTO-2
       0x44   12.7  (0.5)  704	    9,638  (244,805)	   C   LTO-3
       0x46   12.7  (0.5)  896	    12,725 (323,215)	   C   LTO-4
       0x47    3.81 (0.25)   ?	    6,417  (163,000)	   CS  DAT-72
       0x48   12.7  (0.5)  448	    5,236  (133,000) PRML  C   SDLTapeI(110) 6,8,13
       0x49   12.7  (0.5)  448	    7,598  (193,000) PRML  C   SDLTapeI(160) 6,8
       0x4A   12.7  (0.5)  768		?		   C   T10000A	    10
       0x4B   12.7  (0.5) 1152		?		   C   T10000B	    10
       0x4C   12.7  (0.5) 3584		?		   C   T10000C	    10
       0x4D   12.7  (0.5) 4608		?		   C   T10000D	    10
       0x51   12.7  (0.5)  512	    11,800 (299,720)	   C   3592A1 (unencrypted)
       0x52   12.7  (0.5)  896	    11,800 (299,720)	   C   3592A2 (unencrypted)
       0x53   12.7  (0.5) 1152	    13,452 (341,681)	   C   3592A3 (unencrypted)
       0x54   12.7  (0.5) 2560	    19,686 (500,024)	   C   3592A4 (unencrypted)
       0x55   12.7  (0.5) 5120	    20,670 (525,018)	   C   3592A5 (unencrypted)
       0x58   12.7  (0.5) 1280	    15,142 (384,607)	   C   LTO-5
       0x5A   12.7  (0.5) 2176	    15,142 (384,607)	   C   LTO-6
       0x5C   12.7  (0.5) 3584	    19,107 (485,318)	   C   LTO-7
       0x71   12.7  (0.5)  512	    11,800 (299,720)	   C   3592A1 (encrypted)
       0x72   12.7  (0.5)  896	    11,800 (299,720)	   C   3592A2 (encrypted)
       0x73   12.7  (0.5) 1152	    13,452 (341,681)	   C   3592A3 (encrypted)
       0x74   12.7  (0.5) 2560	    19,686 (500,024)	   C   3592A4 (encrypted)
       0x75   12.7  (0.5) 5120	    20,670 (525,018)	   C   3592A5 (encrypted)
       0x8c    8.0  (0.315)  1	    1,789  (45,434)  RLL   CS  EXB-8500c    5,9
       0x90    8.0  (0.315)  1	    1,703  (43,245)  RLL   CS  EXB-8200c    5,9

       Code    Description				  Type Description
       ----    --------------------------------------	  ---- -----------
       NRZI    Non return to zero, change on ones	  R    Reel-to-reel
       GCR     Group code recording			  C    Cartridge
       PE      Phase encoded				  CS   Cassette
       IMFM    Inverted	modified frequency modulation
       MFM     Modified	frequency modulation
       DDS     DAT data	storage
       RLL     Run length limited
       PRML    Partial Response	Maximum	Likelihood

       NOTES
       1.  Serial recorded.
       2.  Parallel recorded.
       3.  Old format known as QIC-11.
       5.  Helical scan.
       6.  This	is not an American National Standard.  The reference is	based
	   on an industry standard definition of the media format.
       7.  DLT recording: serially recorded track pairs	(DLTapeIII and
	   DLTapeIV(20)), or track quads (DLTapeIV(35) and DLTapeIV(40)).
       8.  Super DLT (SDLT) recording: 56 serially recorded logical tracks
	   with	8 physical tracks each.
       9.  Vendor-specific Exabyte density code	for compressed format.
       10. bpi/bpmm values for the Oracle/StorageTek T10000 tape drives	are
	   not listed in the manual.  Someone with access to a drive can
	   supply the necessary	values by running 'mt getdensity'.
       11. This	is Exabyte 8200	uncompressed format.  The compressed format
	   density code	is 0x90.
       12. This	is Exabyte 8500	uncompressed format.  The compressed format
	   density code	is 0x8c.
       13. This	density	code (0x48) was	also used for DAT-160.

ENVIRONMENT
     TAPE  This	is the pathname	of the tape drive.  The	default	(if the	vari-
	   able	is unset, but not if it	is null) is /dev/nsa0.	It may be
	   overridden with the -f option.

FILES
     /dev/*sa[0-9]*  SCSI magnetic tape	interface

DIAGNOSTICS
     The exit status will be 0 when the	drive operations were successful, 2
     when the drive operations were unsuccessful, and 1	for other problems
     like an unrecognized command or a missing drive device.

COMPATIBILITY
     Some undocumented commands	support	old software.

SEE ALSO
     dd(1), ioctl(2), mtio(4), sa(4), environ(7)

HISTORY
     The mt command appeared in	4.3BSD.

     Extensions	regarding the st(4) driver appeared in 386BSD 0.1 as a sepa-
     rate st command, and have been merged into	the mt command in FreeBSD 2.1.

     The former	eof command that used to be a synonym for weof has been	aban-
     doned in FreeBSD 2.1 since	it was often confused with eom,	which is
     fairly dangerous.

BUGS
     The utility cannot	be interrupted or killed during	a long erase (which
     can be longer than	an hour), and it is easy to forget that	the default
     erase is long.

     Hardware block numbers do not always correspond to	blocks on the tape
     when the drive uses internal compression.

     Erasure is	not guaranteed if the tape is not at its beginning.

     Tape-related documentation	is poor, here and elsewhere.

FreeBSD	11.1			 May 20, 2016			  FreeBSD 11.1
```

**btape**

btape - bacula/Bareos’s Tape interface test program

```
btape [options] device-name

DESCRIPTION

This manual page documents briefly the btape command.

OPTIONS

A summary of options is included below.

-?	- Show summary of options and commands.
-b bootstrap - Specify a bootstrap file.
-c config - Specify configuration file.
-d nn	- Set debug level to nn.
-p	- Proceed inspite of I/O errors.
-s	- No signals (for debugging).
-v	- Set verbose mode.

COMMANDS

autochanger - Test autochanger
bsf - Backspace file
bsr - Backspace record
cap - List device capabilities
clear - Clear tape errors
eod - Go to end of Bareos data for append
eom - Go to the physical end of medium
fill - Fill tape, write onto second volume
unfill - Read filled tape
fsf - Forward space a file
fsr - Forward space a record
help - Print this reference
label - Write a Bareos label to the tape
load - Load a tape
quit - Quit btape
rawfill - Use write() to fill tape
readlabel - Read and print the Bareos tape label
rectest - Test record handling functions
rewind - Rewind the tape
scan - Read() tape block by block to EOT and report
scanblocks - Bareos read block by block to EOT and report
status - Print tape status
test - General test Bareos tape functions
weof - Write an EOF on the tape
wr - Write a single Bareos block
rr - Read a single record
rb - Read a single bareos block
qfill	- Quick fill command

SEE ALSO

bscan(1), bextract(1).
```

### Show Autochange Information ###

**chio**

```
chio params

/dev/ch0: 2 slots, 2 drives, 1 picker, 36 portals                                                                                   
/dev/ch0: current picker: 0         
```

**mtx**

```
mtx -f /dev/pass2 inquiry                                                                                      
Product Type: Medium Changer                                                                                                        
Vendor ID: 'IBM     '                                                                                                               
Product ID: '33614LX         '                                                                                                      
Revision: '0029'                                                                                                                    
Attached Changer API: No       
```

### Show Tape Information ###

Show the tape library scan in tape library memory.

**chio**

```
chio status -a

picker 0:  sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <0> scsi: <?:?>                                        
slot 0: <ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <256> scsi: <?:?>                                
slot 1: <ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <257> scsi: <?:?>                                
portal 0: <INEAB,EXENAB,ACCESS,IMPEXP,FULL> sense: <0x00/0x00> voltag: <UN0101L3:0> avoltag: <:0> source: <> intaddr: <1280> scsi: <
?:?>                                                                                                                                
portal 1: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1281> scsi: <?:?>                
portal 2: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1282> scsi: <?:?>                
portal 3: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1283> scsi: <?:?>                
portal 4: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1284> scsi: <?:?>                
portal 5: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1285> scsi: <?:?>                
portal 6: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1286> scsi: <?:?>                
portal 7: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1287> scsi: <?:?>                
portal 8: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1288> scsi: <?:?>                
portal 9: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1289> scsi: <?:?>                
portal 10: <INEAB,EXENAB,ACCESS,IMPEXP,FULL> sense: <0x00/0x00> voltag: <UN0102L3:0> avoltag: <:0> source: <> intaddr: <1290> scsi: 
<?:?>                                                                                                                               
portal 11: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1291> scsi: <?:?>               
portal 12: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1292> scsi: <?:?>               
portal 13: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1293> scsi: <?:?>               
portal 14: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1294> scsi: <?:?>               
portal 15: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1295> scsi: <?:?>               
portal 16: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1296> scsi: <?:?>               
portal 17: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1297> scsi: <?:?>               
portal 18: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1298> scsi: <?:?>               
portal 19: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1299> scsi: <?:?>               
portal 20: <INEAB,EXENAB,ACCESS,IMPEXP,FULL> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1300> scsi: <?:?>   
portal 21: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1301> scsi: <?:?>               
portal 22: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1302> scsi: <?:?>               
portal 23: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1303> scsi: <?:?>               
portal 24: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1304> scsi: <?:?>               
portal 25: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1305> scsi: <?:?>               
portal 26: <INEAB,EXENAB,ACCESS,IMPEXP,FULL> sense: <0x00/0x00> voltag: <UN0103L3:0> avoltag: <:0> source: <> intaddr: <1306> scsi: 
<?:?>                                                                                                                               
portal 27: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1307> scsi: <?:?>               
portal 28: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1308> scsi: <?:?>               
portal 29: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1309> scsi: <?:?>               
portal 30: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1310> scsi: <?:?>               
portal 31: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1311> scsi: <?:?>               
portal 32: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1312> scsi: <?:?>               
portal 33: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1313> scsi: <?:?>               
portal 34: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1314> scsi: <?:?>               
portal 35: <INEAB,EXENAB,ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <1315> scsi: <?:?>               
drive 0: <ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <128> scsi: <?:?>                               
drive 1: <ACCESS> sense: <0x00/0x00> voltag: <:0> avoltag: <:0> source: <> intaddr: <129> scsi: <?:?>  
```

**mtx**

Data Transfer Element 0 is tape drive 1 LTO (IBM Gen 3) Address 0x80.

Data Transfer Element 1 is tape drive 2 LTO (IBM Gen 3) Address 0x81.

Storage Element 1 is hand 1 UNIVERSAL Slots 1 - 1 Address 0x0 - 0x0

Storage Element 2 is hand 2 PassThru Fixed Slots UNIVERSAL Slots 1 - 2 Address 0x100 - 0x101

Storage Element 3 is Left Load Ports LTO Slots 1 - 18 Address 0x500 - 0x511.

...

Storage Element 20 is Right Load Ports LTO Slots 19 - 36 Address 0x512 - 0x523.

...

```
root@bacula-sd_1:/ # mtx -f /dev/pass2 status
  Storage Changer /dev/pass2:2 Drives, 38 Slots ( 36 Import/Export )
Data Transfer Element 0:Empty
Data Transfer Element 1:Empty
      Storage Element 1:Empty
      Storage Element 2:Empty
      Storage Element 3 IMPORT/EXPORT:Full :VolumeTag=UN0101L3                        
      Storage Element 4 IMPORT/EXPORT:Full :VolumeTag=UN0102L3                        
      Storage Element 5 IMPORT/EXPORT:Full :VolumeTag=UN0103L3                        
      Storage Element 6 IMPORT/EXPORT:Full 
      Storage Element 7 IMPORT/EXPORT:Empty
      Storage Element 8 IMPORT/EXPORT:Empty
      Storage Element 9 IMPORT/EXPORT:Empty
      Storage Element 10 IMPORT/EXPORT:Empty
      Storage Element 11 IMPORT/EXPORT:Empty
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
      Storage Element 33 IMPORT/EXPORT:Empty
      Storage Element 34 IMPORT/EXPORT:Empty
      Storage Element 35 IMPORT/EXPORT:Empty
      Storage Element 36 IMPORT/EXPORT:Empty
      Storage Element 37 IMPORT/EXPORT:Empty
      Storage Element 38 IMPORT/EXPORT:Empty

```

### Move Tape In Library ###

Tell tape autochanger to move tape from a slot to a drive or slot to slot etc.

**chio**

Move slot 0 to drive 0 (self explanitory)

```
chio move slot 0 drive 0
```

**mtx**

Load storage element 13 into tape drive 0 and 1 for a test.

```
mtx -f /dev/pass2 load 3 0                                                                                    
Loading media from Storage Element 13 into drive 0...done
mtx -f /dev/pass2 load 4 1                                                                                    
Loading media from Storage Element 13 into drive 1...done 
```

### Write Test To Tape ###

First load a tape into both drives.

```
mtx -f /dev/pass2 load 3 0
mtx -f /dev/pass2 load 4 1
```

**Note:** *Tape Drive 0 was sa1 and tape drive 1 was sa0.*

Rewind the tapes.

```
mt -f /dev/sa0 rewind
mt -f /dev/sa1 rewind

mt -f /dev/sa0 weof
mt -f /dev/sa1 weof

mt -f /dev/sa0 rewind
mt -f /dev/sa1 rewind
```

Write to tape with tar.

```
tar cf /dev/sa0 /usr/pbi/bacula-sd-amd64/
tar cf /dev/sa1 /usr/pbi/bacula-sd-amd64/
```

Read back data from tape.

```
tar tf /dev/sa0
tar tf /dev/sa1
```

### Unload Tape From Drive ###

**chio**

```
chio move drive 0 slot 3
```

**mtx**

```
mtx -f /dev/pass2 unload 3 0
Unloading drive 0 into Storage Element 3...done
```

### Move Tapes Between Slots ###

**chio**

```
chio move slot 0 slot 14
```

**mtx**

mtx -f <sg device> transfer <source slot> <destination slot>

```
mtx -f /dev/pass2 transfer 3 5
mtx -f /dev/pass2 status
```

Add the tape autochanger to the bacula configuration.

```
nano /mnt/HQ/jails/bacula-sd_1/usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf

################################################
# bacula-sd.conf generated by FreeNAS
################################################
Storage {
  Name = freenas-sd
  SDPort = 9103
  Working Directory = /usr/pbi
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 10
}
Device {
  Name = FileStorage
  Media Type = File
  Archive Device = /mnt/tank/bacula
  Label Media = Yes
  Random Access = Yes
  Automatic Mount = No
  Removable Media = Yes
  Always Open = No
}
Autochanger {
  Name = "IBM3361-4LX Library"
  Device = UltiumLTO300, UltiumLTO301
  Changer Device = /dev/pass2
  Changer Command = "/usr/pbi/bacula-sd-amd64/share/bacula/mtx-changer %c %o %S %a %d"
                    # %c = changer device
                    # %o = command (unload|load|loaded|list|slots)
                    # %S = slot index (1-based)
                    # %a = archive device (i.e., /dev/sd* name for tape drive)
                    # %d = drive index (0-based)
}
Device {
  # IBM3361-4LX First Tape Drive
  Name           = UltiumLTO300
  Media Type     = LTO3
  Archive Device = /dev/sa0
  AutomaticMount = yes;
  AlwaysOpen     = yes;
  RemovableMedia = yes;
  Random Access = no;
  Drive Index = 0;
  Alert Command = "sh -c '/usr/local/bacula/sbin/tapeinfo -f /dev/sa0 | /bin/sed -n /TapeAlert/p'"

  # as recommended by btape
  #Hardware End of Medium = No
  #BSF at EOM             = yes

  #Autochanger     = Yes
  #Changer Device  = /dev/pass2
  #Changer Command = "/usr/local/sbin/mtx-changer %c %o %S %a"
}
Device {
  # IBM 3361-4LX Second Tape Drive
  Name            = UltiumLTO301
  Media Type      = LTO3
  Archive Device  = /dev/sa1
  AutomaticMount  = yes;
  AlwaysOpen      = yes;
  RemovableMedia  = yes;
  Random Access = no;
  Drive Index = 1;
  Alert Command = "sh -c '/usr/local/bacula/sbin/tapeinfo -f /dev/sa1 | /bin/sed -n /TapeAlert/p'"

  # as recommended by btape
  #Hardware End of Medium = No
  #BSF at EOM             = yes

  #Autochanger     = Yes
  #Changer Device  = /dev/pass2
  #Changer Command = "/usr/local/sbin/mtx-changer %c %o %S %a"
}
```

### Test Bacula Configs ###

**Note:** *This will fail if you have not loaded a tape in the drive.*

```
root@bacula-sd_2:/ # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa0" for writing.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
*
```

At the asterisk type test then push enter.

```
*test

=== Write, rewind, and re-read test ===

I'm going to write 10000 records and an EOF
then write 10000 records and an EOF, then rewind,
and re-read the data to verify that it is correct.

This is an *essential* feature ...

btape: btape.c:1157 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1173 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1215 Rewind OK.
10000 blocks re-read correctly.
Got EOF on tape.
10000 blocks re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===

btape: btape.c:1283 Block position test
btape: btape.c:1295 Rewind OK.
Reposition to file:block 0:4
Block 5 re-read correctly.
Reposition to file:block 0:200
Block 201 re-read correctly.
Reposition to file:block 0:9999
Block 10000 re-read correctly.
Reposition to file:block 1:0
Block 10001 re-read correctly.
Reposition to file:block 1:600
Block 10601 re-read correctly.
Reposition to file:block 1:9999
Block 20000 re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===



=== Append files test ===

This test is essential to Bacula.

I'm going to write one record  in file 0,
                   two records in file 1,
             and three records in file 2

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1427 Now moving to end of medium.
btape: btape.c:627 dev.c:786 ioctl MTIOCGET error on "UltiumLTO300" (/dev/sa0). ERR=No error: 0.
We should be in file 3. I am at file 0. This is NOT correct!!!!

Append test failed. Attempting again.
Setting "Hardware End of Medium = no
    and "Fast Forward Space File = no
and retrying append test.



=== Append files test ===

This test is essential to Bacula.

I'm going to write one record  in file 0,
                   two records in file 1,
             and three records in file 2

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1427 Now moving to end of medium.
btape: btape.c:630 Moved to end of medium.
We should be in file 3. I am at file 3. This is correct!

Now the important part, I am going to attempt to append to the tape.

14-Jul 00:41 btape JobId 0: End of Volume "" at 3:0 on device "UltiumLTO300" (/dev/sa0). Write of 64512 bytes got 0.
14-Jul 00:41 btape JobId 0: Error: Re-read last block at EOT failed. ERR=block.c:1058 Read zero bytes at 3:0 on device "UltiumLTO300" (/dev/sa0).
btape: btape.c:1911 Error writing block to device.
14-Jul 00:41 btape: Fatal Error at dev.c:1548 because:
dev.c:1547 Attempt to WEOF on non-appendable Volume
btape: btape.c:605 Bad status from weof. ERR=dev.c:1547 Attempt to WEOF on non-appendable Volume

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
Done appending, there should be no I/O errors

Doing Bacula scan of blocks:
1 block of 64448 bytes in file 1
End of File mark.
2 blocks of 64448 bytes in file 2
End of File mark.
3 blocks of 64448 bytes in file 3
End of File mark.
Total files=3, blocks=6, bytes = 386,688
End scanning the tape.
We should be in file 4. I am at file 3. This is NOT correct!!!!


It looks like the append failed. Attempting again.
Setting "BSF at EOM = yes" and retrying append test.


=== Append files test ===

This test is essential to Bacula.

I'm going to write one record  in file 0,
                   two records in file 1,
             and three records in file 2

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
14-Jul 00:41 btape JobId 0: Fatal error: block.c:458 Attempt to write on read-only Volume. dev="UltiumLTO300" (/dev/sa0)
btape: btape.c:1911 Error writing block to device.
14-Jul 00:41 btape: Fatal Error at dev.c:1548 because:
dev.c:1547 Attempt to WEOF on non-appendable Volume
btape: btape.c:605 Bad status from weof. ERR=dev.c:1547 Attempt to WEOF on non-appendable Volume

btape: btape.c:1911 Error writing block to device.
btape: btape.c:1911 Error writing block to device.
14-Jul 00:41 btape: Fatal Error at dev.c:1548 because:
dev.c:1547 Attempt to WEOF on non-appendable Volume
btape: btape.c:605 Bad status from weof. ERR=dev.c:1547 Attempt to WEOF on non-appendable Volume

btape: btape.c:1911 Error writing block to device.
btape: btape.c:1911 Error writing block to device.
btape: btape.c:1911 Error writing block to device.
14-Jul 00:41 btape: Fatal Error at dev.c:1548 because:
dev.c:1547 Attempt to WEOF on non-appendable Volume
btape: btape.c:605 Bad status from weof. ERR=dev.c:1547 Attempt to WEOF on non-appendable Volume

btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1427 Now moving to end of medium.
btape: btape.c:630 Moved to end of medium.
We should be in file 3. I am at file 3. This is correct!

Now the important part, I am going to attempt to append to the tape.

btape: btape.c:1911 Error writing block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
Done appending, there should be no I/O errors

Doing Bacula scan of blocks:
Error reading block. ERR=Job failed or canceled.

Total files=0, blocks=0, bytes = 0
End scanning the tape.
We should be in file 4. I am at file 0. This is NOT correct!!!!

Append test failed.


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Unable to correct the problem. You MUST fix this
problem before Bacula can use your tape drive correctly

Perhaps running Bacula in fixed block mode will work.
Do so by setting:

Minimum Block Size = nnn
Maximum Block Size = nnn

in your Storage daemon's Device definition.
nnn must match your tape driver's block size, which
can be determined by reading your tape manufacturers
information, and the information on your kernel dirver.
Fixed block sizes, however, are not normally an ideal solution.

Some systems, e.g. OpenBSD, require you to set
   Use MTIOCGET= no
in your device resource. Use with caution.
*
```

This seems to fix that warning message at the end.

Add this to both tape devices in 

```
nano /mnt/HQ/jails/bacula-sd_1/usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf

  # as recommended by btape
  Offline On Unmount = no
  Hardware End of Medium = no
  BSF at EOM             = yes
  Backward Space Record = no
  Fast Forward Space File = yes
  TWO EOF = yes
```

Now it seems to work.

```
root@bacula-sd_1:/ # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa0" for writing.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
*test

=== Write, rewind, and re-read test ===

I'm going to write 10000 records and an EOF
then write 10000 records and an EOF, then rewind,
and re-read the data to verify that it is correct.

This is an *essential* feature ...

btape: btape.c:1157 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1173 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1215 Rewind OK.
10000 blocks re-read correctly.
Got EOF on tape.
10000 blocks re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===

btape: btape.c:1283 Block position test
btape: btape.c:1295 Rewind OK.
Reposition to file:block 0:4
Block 5 re-read correctly.
Reposition to file:block 0:200
Block 201 re-read correctly.
Reposition to file:block 0:9999
Block 10000 re-read correctly.
Reposition to file:block 1:0
Block 10001 re-read correctly.
Reposition to file:block 1:600
Block 10601 re-read correctly.
Reposition to file:block 1:9999
Block 20000 re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===



=== Append files test ===

This test is essential to Bacula.

I'm going to write one record  in file 0,
                   two records in file 1,
             and three records in file 2

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1427 Now moving to end of medium.
btape: btape.c:630 Moved to end of medium.
We should be in file 3. I am at file 3. This is correct!

Now the important part, I am going to attempt to append to the tape.

btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
Done appending, there should be no I/O errors

Doing Bacula scan of blocks:
1 block of 64448 bytes in file 1
End of File mark.
2 blocks of 64448 bytes in file 2
End of File mark.
3 blocks of 64448 bytes in file 3
End of File mark.
1 block of 64448 bytes in file 4
End of File mark.
Total files=4, blocks=7, bytes = 451,136
End scanning the tape.
We should be in file 4. I am at file 4. This is correct!

The above Bacula scan should have output identical to what follows.
Please double check it ...
=== Sample correct output ===
1 block of 64448 bytes in file 1
End of File mark.
2 blocks of 64448 bytes in file 2
End of File mark.
3 blocks of 64448 bytes in file 3
End of File mark.
1 block of 64448 bytes in file 4
End of File mark.
Total files=4, blocks=7, bytes = 451,136
=== End sample correct output ===

If the above scan output is not identical to the
sample output, you MUST correct the problem
or Bacula will not be able to write multiple Jobs to 
the tape.

Skipping read backwards test because BSR turned off.


=== Forward space files test ===

This test is essential to Bacula.

I'm going to write five files then test forward spacing

btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO300" (/dev/sa0)
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1641 Now forward spacing 1 file.
We should be in file 1. I am at file 1. This is correct!
btape: btape.c:1653 Now forward spacing 2 files.
We should be in file 3. I am at file 3. This is correct!
btape: btape.c:579 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1666 Now forward spacing 4 files.
We should be in file 4. I am at file 4. This is correct!

btape: btape.c:1684 Now forward spacing 1 more file.
We should be in file 5. I am at file 5. This is correct!

=== End Forward space files test ===

*
```

Test drive 2.

```
root@bacula-sd_1:/ # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa1
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa1" for writing.
btape: btape.c:477 open device "UltiumLTO301" (/dev/sa1): OK
*test

=== Write, rewind, and re-read test ===

I'm going to write 10000 records and an EOF
then write 10000 records and an EOF, then rewind,
and re-read the data to verify that it is correct.

This is an *essential* feature ...

btape: btape.c:1157 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1173 Wrote 10000 blocks of 64412 bytes.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1215 Rewind OK.
10000 blocks re-read correctly.
Got EOF on tape.
10000 blocks re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===

btape: btape.c:1283 Block position test
btape: btape.c:1295 Rewind OK.
Reposition to file:block 0:4
Block 5 re-read correctly.
Reposition to file:block 0:200
Block 201 re-read correctly.
Reposition to file:block 0:9999
Block 10000 re-read correctly.
Reposition to file:block 1:0
Block 10001 re-read correctly.
Reposition to file:block 1:600
Block 10601 re-read correctly.
Reposition to file:block 1:9999
Block 20000 re-read correctly.
=== Test Succeeded. End Write, rewind, and re-read test ===



=== Append files test ===

This test is essential to Bacula.

I'm going to write one record  in file 0,
                   two records in file 1,
             and three records in file 2

btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:477 open device "UltiumLTO301" (/dev/sa1): OK
btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
btape: btape.c:1427 Now moving to end of medium.
btape: btape.c:630 Moved to end of medium.
We should be in file 3. I am at file 3. This is correct!

Now the important part, I am going to attempt to append to the tape.

btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
Done appending, there should be no I/O errors

Doing Bacula scan of blocks:
1 block of 64448 bytes in file 1
End of File mark.
2 blocks of 64448 bytes in file 2
End of File mark.
3 blocks of 64448 bytes in file 3
End of File mark.
1 block of 64448 bytes in file 4
End of File mark.
Total files=4, blocks=7, bytes = 451,136
End scanning the tape.
We should be in file 4. I am at file 4. This is correct!

The above Bacula scan should have output identical to what follows.
Please double check it ...
=== Sample correct output ===
1 block of 64448 bytes in file 1
End of File mark.
2 blocks of 64448 bytes in file 2
End of File mark.
3 blocks of 64448 bytes in file 3
End of File mark.
1 block of 64448 bytes in file 4
End of File mark.
Total files=4, blocks=7, bytes = 451,136
=== End sample correct output ===

If the above scan output is not identical to the
sample output, you MUST correct the problem
or Bacula will not be able to write multiple Jobs to 
the tape.

Skipping read backwards test because BSR turned off.


=== Forward space files test ===

This test is essential to Bacula.

I'm going to write five files then test forward spacing

btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:1914 Wrote one record of 64412 bytes.
btape: btape.c:1916 Wrote block to device.
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:609 Wrote 1 EOF to "UltiumLTO301" (/dev/sa1)
btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
btape: btape.c:1641 Now forward spacing 1 file.
We should be in file 1. I am at file 1. This is correct!
btape: btape.c:1653 Now forward spacing 2 files.
We should be in file 3. I am at file 3. This is correct!
btape: btape.c:579 Rewound "UltiumLTO301" (/dev/sa1)
btape: btape.c:1666 Now forward spacing 4 files.
We should be in file 4. I am at file 4. This is correct!

btape: btape.c:1684 Now forward spacing 1 more file.
We should be in file 5. I am at file 5. This is correct!

=== End Forward space files test ===

*
```

### Test: Autochanger ###

This will fill up a tape and overflow into the next tape in sequence, Unload tape and reload the next tape.

```
root@bacula-sd_1:/ # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa0" for writing.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
*auto
root@bacula-sd_2:/usr/pbi/bacula-sd-amd64/etc # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa0" for writing.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
*auto 

Ah, I see you have an autochanger configured.
To test the autochanger you must have a blank tape
 that I can write on in Slot 1.

Do you wish to continue with the Autochanger test? (y/n): y


=== Autochanger test ===

3301 Issuing autochanger "loaded" command.
Slot 1 loaded. I am going to unload it.
3302 Issuing autochanger "unload 1 0" command.
unload status=OK 0
3303 Issuing autochanger "load 1 0" command.
3303 Autochanger "load 1 0" status is OK.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
btape: btape.c:1571 Rewound "UltiumLTO300" (/dev/sa0)
btape: btape.c:1578 Wrote EOF to "UltiumLTO300" (/dev/sa0)

The test autochanger worked!!

*
```

### Test: Fill ###

This will fill up a tape and overflow into the next tape in sequence, Unload tape and reload the next tape.

```
root@bacula-sd_1:/ # btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
Tape block granularity is 1024 bytes.
btape: butil.c:290 Using device: "/dev/sa0" for writing.
btape: btape.c:477 open device "UltiumLTO300" (/dev/sa0): OK
*fill

This command simulates Bacula writing to a tape.
It requires either one or two blank tapes, which it
will label and write.

If you have an autochanger configured, it will use
the tapes that are in slots 1 and 2, otherwise, you will
be prompted to insert the tapes when necessary.

It will print a status approximately
every 322 MB, and write an EOF every 1.000 G.  If you have
selected the simple test option, after writing the first tape
it will rewind it and re-read the last block written.

If you have selected the multiple tape test, when the first tape
fills, it will ask for a second, and after writing a few more 
blocks, it will stop.  Then it will begin re-reading the
two tapes.

This may take a long time -- hours! ...

Do you want to run the simplified test (s) with one tape
or the complete multiple tape (m) test: (s/m) m
Multiple tape test selected.
Wrote Volume label for volume "TestVolume1".
Wrote Start of Session label.
23:02:07 Begin writing Bacula records to first tape ...
Wrote block=5000, file,blk=1,4999 VolBytes=322,495,488 rate=53.74 MB/s
Wrote block=10000, file,blk=1,9999 VolBytes=645,055,488 rate=53.75 MB/s
Wrote block=15000, file,blk=1,14999 VolBytes=967,615,488 rate=56.91 MB/s
Wrote block=20000, file,blk=2,4499 VolBytes=1,290,175,488 rate=53.75 MB/s
Wrote block=25000, file,blk=2,9499 VolBytes=1,612,735,488 rate=55.61 MB/s
Wrote block=30000, file,blk=2,14499 VolBytes=1,935,295,488 rate=56.92 MB/s
23:02:42 Flush block, write EOF
Wrote block=35000, file,blk=3,3999 VolBytes=2,257,855,488 rate=55.06 MB/s
Wrote block=40000, file,blk=3,8999 VolBytes=2,580,415,488 rate=52.66 MB/s
Wrote block=45000, file,blk=3,13999 VolBytes=2,902,975,488 rate=54.77 MB/s
Wrote block=50000, file,blk=4,3499 VolBytes=3,225,535,488 rate=51.19 MB/s
Wrote block=55000, file,blk=4,8499 VolBytes=3,548,095,488 rate=51.42 MB/s
Wrote block=60000, file,blk=4,13499 VolBytes=3,870,655,488 rate=50.26 MB/s
23:03:25 Flush block, write EOF
Wrote block=65000, file,blk=5,2999 VolBytes=4,193,215,488 rate=49.91 MB/s
Wrote block=70000, file,blk=5,7999 VolBytes=4,515,775,488 rate=50.73 MB/s
Wrote block=75000, file,blk=5,12999 VolBytes=4,838,335,488 rate=51.47 MB/s
Wrote block=80000, file,blk=6,2499 VolBytes=5,160,895,488 rate=51.09 MB/s
Wrote block=85000, file,blk=6,7499 VolBytes=5,483,455,488 rate=52.22 MB/s
Wrote block=90000, file,blk=6,12499 VolBytes=5,806,015,488 rate=52.78 MB/s
23:03:59 Flush block, write EOF
Wrote block=95000, file,blk=7,1999 VolBytes=6,128,575,488 rate=52.38 MB/s
Wrote block=100000, file,blk=7,6999 VolBytes=6,451,135,488 rate=52.87 MB/s
Wrote block=105000, file,blk=7,11999 VolBytes=6,773,695,488 rate=52.91 MB/s
Wrote block=110000, file,blk=8,1499 VolBytes=7,096,255,488 rate=52.95 MB/s
Wrote block=115000, file,blk=8,6499 VolBytes=7,418,815,488 rate=52.24 MB/s
Wrote block=120000, file,blk=8,11499 VolBytes=7,741,375,488 rate=53.02 MB/s
23:04:35 Flush block, write EOF
Wrote block=125000, file,blk=9,999 VolBytes=8,063,935,488 rate=53.05 MB/s
Wrote block=130000, file,blk=9,5999 VolBytes=8,386,495,488 rate=52.09 MB/s
Wrote block=135000, file,blk=9,10999 VolBytes=8,709,055,488 rate=52.46 MB/s
Wrote block=140000, file,blk=10,499 VolBytes=9,031,615,488 rate=52.81 MB/s
Wrote block=145000, file,blk=10,5499 VolBytes=9,354,175,488 rate=51.68 MB/s
Wrote block=150000, file,blk=10,10499 VolBytes=9,676,735,488 rate=51.47 MB/s
23:05:18 Flush block, write EOF

```

### Final Configuration ###

```
nano /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf

################################################
# bacula-sd.conf generated by FreeNAS
################################################
Storage {
  Name = freenas-sd
  SDPort = 9103
  Working Directory = /usr/pbi
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 10
}
Device {
  Name = FileStorage
  Media Type = File
  Archive Device = /mnt/tank/bacula
  Label Media = Yes
  Random Access = Yes
  Automatic Mount = No
  Removable Media = Yes
  Always Open = No
}
Autochanger {
  Name = "IBM3361-4LX Library"
  Device = UltiumLTO300, UltiumLTO301
  Changer Device = /dev/pass2
  Changer Command = "/usr/pbi/bacula-sd-amd64/share/bacula/mtx-changer %c %o %S %a %d"
                    # %c = changer device
                    # %o = command (unload|load|loaded|list|slots)
                    # %S = slot index (1-based)
                    # %a = archive device (i.e., /dev/sd* name for$
                    # %d = drive index (0-based)
}
Device {
  # IBM3361-4LX First Tape Drive
  Name           = UltiumLTO300
  Media Type     = LTO3
  Archive Device = /dev/sa0
  AutomaticMount = yes;
  AlwaysOpen     = yes;
  RemovableMedia = yes;
  Random Access = no;
  Autochanger = Yes
  Drive Index = 0;
  Alert Command = "sh -c '/usr/local/sbin/tapeinfo -f /dev/sa0 | /$

  # as recommended by btape
  Offline On Unmount = no
  Hardware End of Medium = no
  BSF at EOM             = yes
  Backward Space Record = no
  Fast Forward Space File = yes
  TWO EOF = yes
}
Device {
  # IBM 3361-4LX Second Tape Drive
  Name            = UltiumLTO301
  Media Type      = LTO3
  Archive Device  = /dev/sa1
  AutomaticMount  = yes;
  AlwaysOpen      = yes;
  RemovableMedia  = yes;
  Random Access = no;
  Autochanger = Yes
  Drive Index = 1;
  Alert Command = "sh -c '/usr/local/sbin/tapeinfo -f /dev/sa1 | /$
  
  # as recommended by btape
  Offline On Unmount = no
  Hardware End of Medium = no
  BSF at EOM             = yes
  Backward Space Record = no
  Fast Forward Space File = yes
  TWO EOF = yes
}
```

### Copy Configuration To Default Location ###

You could make a systemlink or copy this file over to the default location then you won't have to specify the btape -c command it will just auto use the default configuration file.

```
cp /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /usr/pbi/bacula-sd-amd64/etc/bacula/bacula-sd.conf 
 
 The complete path from outside the jail is /mnt/<dataSet>/jails/bacula-sd_1/usr/pbi/bacula-sd-amd64/etc/bacula/bacula-sd.conf
```

or systemlink

```
ln -s /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /usr/pbi/bacula-sd-amd64/etc/bacula/bacula-sd.conf 
```

### SCSI Tape Error list ###

```
Sense Key (Hex)	Meaning
00	No Sense
01	Recovered Error
02	Not Ready
03	Medium Error
04	Hardware Error
05	Illegal Request
06	Unit Attention
07	Data Protected
08	Blank Check
0B	Aborted Command
OD	Volume Overflow
OE	Miscompare


To get a description of the error, determine the hex values of bytes 02 (Sense Key), 12 (ASC), and 13 (ASCO) from the summary report, then locate those values in below Figure 62. 

Figure 62. Sense Key Information for the Tape Library 


Sense Key
(Hex)	ASC (Hex)	ASCQ (Hex)	Description of Error
02	04	O1	Initialization in progress
02	04	81	Unit off-line
02	04	83	Not ready; front door open
04	08	01	SCSI hardware does not respond
04	15	81	Pick error
04	15	83	Put error
04	15	84	Mechanical problem: Stall while picking from drive
04	3B	82	Cannot close drive door
04	40	82	Flash memory checksum error
04	40	90	Normal force position overflow
04	40	A1	X-axis stuck
04	40	A2	X-axis home failure
04	40	A3	X-axis move time-out
04	40	A4	X-axis controller failure, wrap error
04	40	A7	Motor controller reset failure
04	40	A8	X-axis servo busy bit set
04	40	B1	Rack stuck
04	40	B2	Rack home failure
04	40	B3	Rack move time-out
04	40	B4	Rack controller failure, wrap error
04	40	B6	Rack home with cartridge failure
04	40	B8	Rack servo busy bit set
04	40	C1	Z-axis stuck
04	40	C2	Normal force home failure
04	40	C3	Z-axis move time-out
04	40	C4	Z-axis controller failure wrap error
04	40	C8	Z-axis servo busy bit set
04	40	CA	Read cartridge labels time-out
04	40	E3	Motion control drivers hot
04	44	00	Internal hardware error
04	80	17	Bar code retries exceeded limits
04	84	00	Internal software error
05	1A	00	Parameter list length error
05	20	00	Invalid command operation code
05	21	01	Invalid element address
05	24	00	Invalid field in CDB
05	25	00	Unsupported logical unit
05	26	00	Invalid field in parameter list
05	26	02	Parameter value invalid
05	3B	0D	Medium destination element full
05	3B	0E	Medium source element empty
05	3B	80	User intervention required
05	3B	83	Drive indicates handle is not ready to operate
05	3B	84	Destination drive door is closed
05	3B	85	Destination cannot be cartridge handler
05	3B	86	Source cannot be cartridge handler
05	3B	87	Data cartridge stuck in drive
05	3D	00	Invalid bits in identify message
05	53	02	Medium removal prevented
05	80	03	No source magazine
05	80	04	No destination magazine
05	80	05	No source drive
05	80	06	No destination drive
06	29	00	Power-on reset or bus device reset occurred
06	2A	01	Mode parameters changed
06	3F	01	Microcode has been changed
OB	3F	80	Flash firmware upgrade error: Unable to erase
OB	3F	81	Write firmware, incomplete code data
OB	3F	84	Flash firmware upgrade error: Unable to program
0B	3F	86	firmware upgrade error: Flash
checksum error
```


Ignore BareOS stuff for now... to be continued.



```
bareos client was installed                                                     
                                                                                
1) Sample files are installed in /usr/local/etc/bareos/bareos-fd.d/ and         
   /usr/local/etc/bareos/bconsole.d/                                            
                                                                                
2) Add bareos_fd_enable="YES" to /etc/rc.conf.                                  
                                                                                
3) If you want to retain old configuration scheme, you must add the following   
   to /etc/rc.conf                                                              
   
  bareos_fd_config="/usr/local/etc/bareos/bareos-fd.conf"                       
                                                                         
################################################################################
Message from compat7x-amd64-7.4.704000.201310.1:                                
******************************************************************************* 
*                                                                             * 
* Do not forget to add COMPAT_FREEBSD7 into                                   * 
* your kernel configuration (enabled by default).                             * 
*                                                                             * 
* To configure and recompile your kernel see:                                 * 
* http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/kernelconfig.html * 
*                                                                             * 
******************************************************************************* 
```
