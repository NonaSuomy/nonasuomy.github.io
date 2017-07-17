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

### Test: Test (Single Files Write/Read) Again! ###

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

  Spool Directory = /usr/pbi/bacula-sd-amd64/share/bacula/spool
  Maximum Spool Size = 20 G
  Maximum File Size = 10 G
  Maximum Job Spool Size = 5G
  #Maximum Concurrent Jobs = 2

  Maximum block size = 131072
  #Maximum block size = 262144

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
  
  Spool Directory = /usr/pbi/bacula-sd-amd64/share/bacula/spool
  Maximum Spool Size = 20 G
  Maximum File Size = 10 G
  Maximum Job Spool Size = 5G
  #Maximum Concurrent Jobs = 2

  Maximum block size = 131072
  #Maximum block size = 262144  
  
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

### Test: Test (Single Files Write/Read) Again! ###

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
...
01:21:30 Flush block, write EOF
Wrote block=6470000, file,blk=418,6499 VolBytes=417,392,575,488 rate=49.90 MB/s
Wrote block=6475000, file,blk=418,11499 VolBytes=417,715,135,488 rate=49.90 MB/s
Wrote block=6480000, file,blk=419,999 VolBytes=418,037,695,488 rate=49.90 MB/s
Wrote block=6485000, file,blk=419,5999 VolBytes=418,360,255,488 rate=49.88 MB/s
Wrote block=6490000, file,blk=419,10999 VolBytes=418,682,815,488 rate=49.89 MB/s
Wrote block=6495000, file,blk=420,499 VolBytes=419,005,375,488 rate=49.88 MB/s
Wrote block=6500000, file,blk=420,5499 VolBytes=419,327,935,488 rate=49.87 MB/s
01:22:14 Flush block, write EOF
Wrote block=6505000, file,blk=420,10499 VolBytes=419,650,495,488 rate=49.88 MB/s
Wrote block=6510000, file,blk=420,15499 VolBytes=419,973,055,488 rate=49.90 MB/s
Wrote block=6515000, file,blk=421,4999 VolBytes=420,295,615,488 rate=49.88 MB/s
Wrote block=6520000, file,blk=421,9999 VolBytes=420,618,175,488 rate=49.88 MB/s
Wrote block=6525000, file,blk=421,14999 VolBytes=420,940,735,488 rate=49.89 MB/s
Wrote block=6530000, file,blk=422,4499 VolBytes=421,263,295,488 rate=49.88 MB/s
01:22:52 Flush block, write EOF
Wrote block=6535000, file,blk=422,9499 VolBytes=421,585,855,488 rate=49.89 MB/s
Wrote block=6540000, file,blk=422,14499 VolBytes=421,908,415,488 rate=49.88 MB/s
Wrote block=6545000, file,blk=423,3999 VolBytes=422,230,975,488 rate=49.87 MB/s
Wrote block=6550000, file,blk=423,8999 VolBytes=422,553,535,488 rate=49.89 MB/s
Wrote block=6555000, file,blk=423,13999 VolBytes=422,876,095,488 rate=49.90 MB/s
Wrote block=6560000, file,blk=424,3499 VolBytes=423,198,655,488 rate=49.88 MB/s
01:23:32 Flush block, write EOF
17-Jul 01:23 btape JobId 0: End of Volume "TestVolume1" at 424:7975 on device "UltiumLTO300" (/dev/sa0). Write of 64512 bytes got 0.
btape: btape.c:2714 Last block at: 424:7974 this_dev_block_num=7975
btape: btape.c:2749 End of tape 426:0. Volume Bytes=423,487,411,200. Write rate = 49.86 MB/s
17-Jul 01:23 btape JobId 0: End of medium on Volume "TestVolume1" Bytes=423,487,411,200 Blocks=6,564,475 at 17-Jul-2017 01:23.
17-Jul 01:23 btape JobId 0: 3307 Issuing autochanger "unload slot 1, drive 0" command.
17-Jul 01:24 btape JobId 0: 3304 Issuing autochanger "load slot 2, drive 0" command.
17-Jul 01:29 btape JobId 0: Fatal error: 3992 Bad autochanger "load slot 2, drive 0": ERR=Child died from signal 15: Termination.
Results=Program killed by Bacula (timeout)

btape: btape.c:3074 Autochanger returned: -1
Mount blank Volume on device "UltiumLTO300" (/dev/sa0) and press return when ready: 
btape: btape.c:3079 
Wrote Volume label for volume "TestVolume2".
btape: btape.c:2756 Cannot fixup device error. 
btape: btape.c:2286 Flush block failed.
btape: btape.c:2325 Not OK
btape: btape.c:2349 Job canceled.
btape: btape.c:2354 Error writing end session label. ERR=
Set ok=false after write_block_to_device.
Wrote End of Session label.
btape: btape.c:2389 Wrote state file last_block_num1=7974 last_block_num2=7974
btape: btape.c:2417 01:35:14: Error during test.
*

  Spool Data = yes
  Spool Attributes = yes


```

Failure... I didn't have a tape in hand slot 2

Changed a few settings (spool settings above as well)

```
btape -c /usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf /dev/sa0
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
every 322 MB, and write an EOF every 10.73 G.  If you have
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
02:05:26 Begin writing Bacula records to first tape ...
Wrote block=5000, file,blk=1,4999 VolBytes=655,228,928 rate=54.60 MB/s
Wrote block=10000, file,blk=1,9999 VolBytes=1,310,588,928 rate=62.40 MB/s
Wrote block=15000, file,blk=1,14999 VolBytes=1,965,948,928 rate=59.57 MB/s
Wrote block=20000, file,blk=1,19999 VolBytes=2,621,308,928 rate=59.57 MB/s
Wrote block=25000, file,blk=1,24999 VolBytes=3,276,668,928 rate=61.82 MB/s
Wrote block=30000, file,blk=1,29999 VolBytes=3,932,028,928 rate=61.43 MB/s
Wrote block=35000, file,blk=1,34999 VolBytes=4,587,388,928 rate=62.84 MB/s
Wrote block=40000, file,blk=1,39999 VolBytes=5,242,748,928 rate=63.16 MB/s
Wrote block=45000, file,blk=1,44999 VolBytes=5,898,108,928 rate=64.10 MB/s
Wrote block=50000, file,blk=1,49999 VolBytes=6,553,468,928 rate=64.24 MB/s
Wrote block=55000, file,blk=1,54999 VolBytes=7,208,828,928 rate=64.94 MB/s
Wrote block=60000, file,blk=1,59999 VolBytes=7,864,188,928 rate=64.46 MB/s
Wrote block=65000, file,blk=1,64999 VolBytes=8,519,548,928 rate=64.54 MB/s
Wrote block=70000, file,blk=1,69999 VolBytes=9,174,908,928 rate=65.07 MB/s
Wrote block=75000, file,blk=1,74999 VolBytes=9,830,268,928 rate=64.67 MB/s
Wrote block=80000, file,blk=1,79999 VolBytes=10,485,628,928 rate=63.93 MB/s
Wrote block=85000, file,blk=2,3080 VolBytes=11,140,988,928 rate=62.58 MB/s
Wrote block=90000, file,blk=2,8080 VolBytes=11,796,348,928 rate=62.08 MB/s
Wrote block=95000, file,blk=2,13080 VolBytes=12,451,708,928 rate=61.94 MB/s
Wrote block=100000, file,blk=2,18080 VolBytes=13,107,068,928 rate=62.11 MB/s
Wrote block=105000, file,blk=2,23080 VolBytes=13,762,428,928 rate=62.55 MB/s
Wrote block=110000, file,blk=2,28080 VolBytes=14,417,788,928 rate=62.68 MB/s
Wrote block=115000, file,blk=2,33080 VolBytes=15,073,148,928 rate=62.54 MB/s
Wrote block=120000, file,blk=2,38080 VolBytes=15,728,508,928 rate=62.91 MB/s
Wrote block=125000, file,blk=2,43080 VolBytes=16,383,868,928 rate=63.25 MB/s
Wrote block=130000, file,blk=2,48080 VolBytes=17,039,228,928 rate=63.57 MB/s
Wrote block=135000, file,blk=2,53080 VolBytes=17,694,588,928 rate=63.87 MB/s
Wrote block=140000, file,blk=2,58080 VolBytes=18,349,948,928 rate=63.93 MB/s
Wrote block=145000, file,blk=2,63080 VolBytes=19,005,308,928 rate=64.20 MB/s
Wrote block=150000, file,blk=2,68080 VolBytes=19,660,668,928 rate=64.04 MB/s
Wrote block=155000, file,blk=2,73080 VolBytes=20,316,028,928 rate=64.29 MB/s
Wrote block=160000, file,blk=2,78080 VolBytes=20,971,388,928 rate=64.32 MB/s
Wrote block=165000, file,blk=3,1161 VolBytes=21,626,748,928 rate=63.98 MB/s
Wrote block=170000, file,blk=3,6161 VolBytes=22,282,108,928 rate=63.66 MB/s
Wrote block=175000, file,blk=3,11161 VolBytes=22,937,468,928 rate=63.89 MB/s
Wrote block=180000, file,blk=3,16161 VolBytes=23,592,828,928 rate=64.11 MB/s
Wrote block=185000, file,blk=3,21161 VolBytes=24,248,188,928 rate=64.14 MB/s
Wrote block=190000, file,blk=3,26161 VolBytes=24,903,548,928 rate=64.35 MB/s
Wrote block=195000, file,blk=3,31161 VolBytes=25,558,908,928 rate=64.05 MB/s
Wrote block=200000, file,blk=3,36161 VolBytes=26,214,268,928 rate=63.93 MB/s
Wrote block=205000, file,blk=3,41161 VolBytes=26,869,628,928 rate=64.12 MB/s
Wrote block=210000, file,blk=3,46161 VolBytes=27,524,988,928 rate=64.31 MB/s
Wrote block=215000, file,blk=3,51161 VolBytes=28,180,348,928 rate=64.48 MB/s
Wrote block=220000, file,blk=3,56161 VolBytes=28,835,708,928 rate=64.50 MB/s
Wrote block=225000, file,blk=3,61161 VolBytes=29,491,068,928 rate=63.97 MB/s
Wrote block=230000, file,blk=3,66161 VolBytes=30,146,428,928 rate=64.14 MB/s
Wrote block=235000, file,blk=3,71161 VolBytes=30,801,788,928 rate=64.17 MB/s
Wrote block=240000, file,blk=3,76161 VolBytes=31,457,148,928 rate=64.32 MB/s
Wrote block=245000, file,blk=3,81161 VolBytes=32,112,508,928 rate=64.48 MB/s
Wrote block=250000, file,blk=4,4242 VolBytes=32,767,868,928 rate=63.50 MB/s
Wrote block=255000, file,blk=4,9242 VolBytes=33,423,228,928 rate=63.78 MB/s
Wrote block=260000, file,blk=4,14242 VolBytes=34,078,588,928 rate=63.69 MB/s
Wrote block=265000, file,blk=4,19242 VolBytes=34,733,948,928 rate=63.38 MB/s
Wrote block=270000, file,blk=4,24242 VolBytes=35,389,308,928 rate=63.64 MB/s
Wrote block=275000, file,blk=4,29242 VolBytes=36,044,668,928 rate=63.57 MB/s
Wrote block=280000, file,blk=4,34242 VolBytes=36,700,028,928 rate=63.49 MB/s
Wrote block=285000, file,blk=4,39242 VolBytes=37,355,388,928 rate=63.52 MB/s
Wrote block=290000, file,blk=4,44242 VolBytes=38,010,748,928 rate=63.66 MB/s
Wrote block=295000, file,blk=4,49242 VolBytes=38,666,108,928 rate=63.80 MB/s
Wrote block=300000, file,blk=4,54242 VolBytes=39,321,468,928 rate=63.73 MB/s
Wrote block=305000, file,blk=4,59242 VolBytes=39,976,828,928 rate=63.75 MB/s
Wrote block=310000, file,blk=4,64242 VolBytes=40,632,188,928 rate=63.58 MB/s
Wrote block=315000, file,blk=4,69242 VolBytes=41,287,548,928 rate=63.81 MB/s
Wrote block=320000, file,blk=4,74242 VolBytes=41,942,908,928 rate=63.74 MB/s
Wrote block=325000, file,blk=4,79242 VolBytes=42,598,268,928 rate=63.76 MB/s
02:16:40 Flush block, write EOF
Wrote block=330000, file,blk=5,2323 VolBytes=43,253,628,928 rate=63.60 MB/s
Wrote block=335000, file,blk=5,7323 VolBytes=43,908,988,928 rate=63.72 MB/s
Wrote block=340000, file,blk=5,12323 VolBytes=44,564,348,928 rate=63.84 MB/s
Wrote block=345000, file,blk=5,17323 VolBytes=45,219,708,928 rate=63.86 MB/s
Wrote block=350000, file,blk=5,22323 VolBytes=45,875,068,928 rate=63.98 MB/s
Wrote block=355000, file,blk=5,27323 VolBytes=46,530,428,928 rate=64.09 MB/s
Wrote block=360000, file,blk=5,32323 VolBytes=47,185,788,928 rate=64.19 MB/s
Wrote block=365000, file,blk=5,37323 VolBytes=47,841,148,928 rate=64.21 MB/s
Wrote block=370000, file,blk=5,42323 VolBytes=48,496,508,928 rate=64.23 MB/s
Wrote block=375000, file,blk=5,47323 VolBytes=49,151,868,928 rate=64.08 MB/s
Wrote block=380000, file,blk=5,52323 VolBytes=49,807,228,928 rate=64.01 MB/s
Wrote block=385000, file,blk=5,57323 VolBytes=50,462,588,928 rate=63.79 MB/s
Wrote block=390000, file,blk=5,62323 VolBytes=51,117,948,928 rate=63.73 MB/s
Wrote block=395000, file,blk=5,67323 VolBytes=51,773,308,928 rate=63.83 MB/s
Wrote block=400000, file,blk=5,72323 VolBytes=52,428,668,928 rate=63.70 MB/s
Wrote block=405000, file,blk=5,77323 VolBytes=53,084,028,928 rate=63.80 MB/s
Wrote block=410000, file,blk=6,404 VolBytes=53,739,388,928 rate=63.44 MB/s
Wrote block=415000, file,blk=6,5404 VolBytes=54,394,748,928 rate=63.24 MB/s
Wrote block=420000, file,blk=6,10404 VolBytes=55,050,108,928 rate=63.27 MB/s
Wrote block=425000, file,blk=6,15404 VolBytes=55,705,468,928 rate=63.37 MB/s
Wrote block=430000, file,blk=6,20404 VolBytes=56,360,828,928 rate=63.25 MB/s
Wrote block=435000, file,blk=6,25404 VolBytes=57,016,188,928 rate=63.21 MB/s
Wrote block=440000, file,blk=6,30404 VolBytes=57,671,548,928 rate=63.30 MB/s
Wrote block=445000, file,blk=6,35404 VolBytes=58,326,908,928 rate=63.05 MB/s
Wrote block=450000, file,blk=6,40404 VolBytes=58,982,268,928 rate=63.08 MB/s
Wrote block=455000, file,blk=6,45404 VolBytes=59,637,628,928 rate=63.17 MB/s
Wrote block=460000, file,blk=6,50404 VolBytes=60,292,988,928 rate=63.20 MB/s
Wrote block=465000, file,blk=6,55404 VolBytes=60,948,348,928 rate=63.35 MB/s
Wrote block=470000, file,blk=6,60404 VolBytes=61,603,708,928 rate=63.44 MB/s
Wrote block=475000, file,blk=6,65404 VolBytes=62,259,068,928 rate=63.46 MB/s
Wrote block=480000, file,blk=6,70404 VolBytes=62,914,428,928 rate=63.54 MB/s
Wrote block=485000, file,blk=6,75404 VolBytes=63,569,788,928 rate=63.63 MB/s
Wrote block=490000, file,blk=6,80404 VolBytes=64,225,148,928 rate=63.52 MB/s
Wrote block=495000, file,blk=7,3485 VolBytes=64,880,508,928 rate=63.29 MB/s
Wrote block=500000, file,blk=7,8485 VolBytes=65,535,868,928 rate=63.38 MB/s
Wrote block=505000, file,blk=7,13485 VolBytes=66,191,228,928 rate=63.46 MB/s
Wrote block=510000, file,blk=7,18485 VolBytes=66,846,588,928 rate=63.48 MB/s
Wrote block=515000, file,blk=7,23485 VolBytes=67,501,948,928 rate=63.50 MB/s
Wrote block=520000, file,blk=7,28485 VolBytes=68,157,308,928 rate=63.34 MB/s
Wrote block=525000, file,blk=7,33485 VolBytes=68,812,668,928 rate=63.24 MB/s
Wrote block=530000, file,blk=7,38485 VolBytes=69,468,028,928 rate=63.32 MB/s
Wrote block=535000, file,blk=7,43485 VolBytes=70,123,388,928 rate=63.28 MB/s
Wrote block=540000, file,blk=7,48485 VolBytes=70,778,748,928 rate=63.30 MB/s
Wrote block=545000, file,blk=7,53485 VolBytes=71,434,108,928 rate=63.21 MB/s
Wrote block=550000, file,blk=7,58485 VolBytes=72,089,468,928 rate=63.34 MB/s
Wrote block=555000, file,blk=7,63485 VolBytes=72,744,828,928 rate=63.31 MB/s
Wrote block=560000, file,blk=7,68485 VolBytes=73,400,188,928 rate=63.27 MB/s
Wrote block=565000, file,blk=7,73485 VolBytes=74,055,548,928 rate=63.29 MB/s
Wrote block=570000, file,blk=7,78485 VolBytes=74,710,908,928 rate=63.36 MB/s
Wrote block=575000, file,blk=8,1566 VolBytes=75,366,268,928 rate=63.27 MB/s
Wrote block=580000, file,blk=8,6566 VolBytes=76,021,628,928 rate=63.19 MB/s
Wrote block=585000, file,blk=8,11566 VolBytes=76,676,988,928 rate=63.26 MB/s
Wrote block=590000, file,blk=8,16566 VolBytes=77,332,348,928 rate=63.23 MB/s
Wrote block=595000, file,blk=8,21566 VolBytes=77,987,708,928 rate=63.14 MB/s
Wrote block=600000, file,blk=8,26566 VolBytes=78,643,068,928 rate=63.16 MB/s
Wrote block=605000, file,blk=8,31566 VolBytes=79,298,428,928 rate=63.08 MB/s
Wrote block=610000, file,blk=8,36566 VolBytes=79,953,788,928 rate=63.20 MB/s
Wrote block=615000, file,blk=8,41566 VolBytes=80,609,148,928 rate=63.17 MB/s
Wrote block=620000, file,blk=8,46566 VolBytes=81,264,508,928 rate=63.14 MB/s
Wrote block=625000, file,blk=8,51566 VolBytes=81,919,868,928 rate=63.16 MB/s
Wrote block=630000, file,blk=8,56566 VolBytes=82,575,228,928 rate=63.22 MB/s
Wrote block=635000, file,blk=8,61566 VolBytes=83,230,588,928 rate=63.24 MB/s
Wrote block=640000, file,blk=8,66566 VolBytes=83,885,948,928 rate=63.21 MB/s
Wrote block=645000, file,blk=8,71566 VolBytes=84,541,308,928 rate=63.27 MB/s
Wrote block=650000, file,blk=8,76566 VolBytes=85,196,668,928 rate=63.34 MB/s
Wrote block=655000, file,blk=8,81566 VolBytes=85,852,028,928 rate=63.35 MB/s
02:28:03 Flush block, write EOF
Wrote block=660000, file,blk=9,4647 VolBytes=86,507,388,928 rate=63.28 MB/s
Wrote block=665000, file,blk=9,9647 VolBytes=87,162,748,928 rate=63.34 MB/s
Wrote block=670000, file,blk=9,14647 VolBytes=87,818,108,928 rate=63.36 MB/s
Wrote block=675000, file,blk=9,19647 VolBytes=88,473,468,928 rate=63.42 MB/s
Wrote block=680000, file,blk=9,24647 VolBytes=89,128,828,928 rate=63.43 MB/s
Wrote block=685000, file,blk=9,29647 VolBytes=89,784,188,928 rate=63.49 MB/s
Wrote block=690000, file,blk=9,34647 VolBytes=90,439,548,928 rate=63.46 MB/s
Wrote block=695000, file,blk=9,39647 VolBytes=91,094,908,928 rate=63.48 MB/s
Wrote block=700000, file,blk=9,44647 VolBytes=91,750,268,928 rate=63.53 MB/s
Wrote block=705000, file,blk=9,49647 VolBytes=92,405,628,928 rate=63.59 MB/s
Wrote block=710000, file,blk=9,54647 VolBytes=93,060,988,928 rate=63.65 MB/s
Wrote block=715000, file,blk=9,59647 VolBytes=93,716,348,928 rate=63.66 MB/s
Wrote block=720000, file,blk=9,64647 VolBytes=94,371,708,928 rate=63.72 MB/s
Wrote block=725000, file,blk=9,69647 VolBytes=95,027,068,928 rate=63.64 MB/s
Wrote block=730000, file,blk=9,74647 VolBytes=95,682,428,928 rate=63.74 MB/s
Wrote block=735000, file,blk=9,79647 VolBytes=96,337,788,928 rate=63.71 MB/s
Wrote block=740000, file,blk=10,2728 VolBytes=96,993,148,928 rate=63.56 MB/s
Wrote block=745000, file,blk=10,7728 VolBytes=97,648,508,928 rate=63.61 MB/s
Wrote block=750000, file,blk=10,12728 VolBytes=98,303,868,928 rate=63.54 MB/s
Wrote block=755000, file,blk=10,17728 VolBytes=98,959,228,928 rate=63.51 MB/s
Wrote block=760000, file,blk=10,22728 VolBytes=99,614,588,928 rate=63.57 MB/s
Wrote block=765000, file,blk=10,27728 VolBytes=100,269,948,928 rate=63.62 MB/s
Wrote block=770000, file,blk=10,32728 VolBytes=100,925,308,928 rate=63.63 MB/s
Wrote block=775000, file,blk=10,37728 VolBytes=101,580,668,928 rate=63.68 MB/s
Wrote block=780000, file,blk=10,42728 VolBytes=102,236,028,928 rate=63.69 MB/s
Wrote block=785000, file,blk=10,47728 VolBytes=102,891,388,928 rate=63.78 MB/s
Wrote block=790000, file,blk=10,52728 VolBytes=103,546,748,928 rate=63.72 MB/s
Wrote block=795000, file,blk=10,57728 VolBytes=104,202,108,928 rate=63.69 MB/s
Wrote block=800000, file,blk=10,62728 VolBytes=104,857,468,928 rate=63.74 MB/s
Wrote block=805000, file,blk=10,67728 VolBytes=105,512,828,928 rate=63.79 MB/s
Wrote block=810000, file,blk=10,72728 VolBytes=106,168,188,928 rate=63.84 MB/s
Wrote block=815000, file,blk=10,77728 VolBytes=106,823,548,928 rate=63.69 MB/s
Wrote block=820000, file,blk=11,809 VolBytes=107,478,908,928 rate=63.63 MB/s
Wrote block=825000, file,blk=11,5809 VolBytes=108,134,268,928 rate=63.68 MB/s
Wrote block=830000, file,blk=11,10809 VolBytes=108,789,628,928 rate=63.69 MB/s
Wrote block=835000, file,blk=11,15809 VolBytes=109,444,988,928 rate=63.74 MB/s
Wrote block=840000, file,blk=11,20809 VolBytes=110,100,348,928 rate=63.75 MB/s
Wrote block=845000, file,blk=11,25809 VolBytes=110,755,708,928 rate=63.79 MB/s
Wrote block=850000, file,blk=11,30809 VolBytes=111,411,068,928 rate=63.77 MB/s
Wrote block=855000, file,blk=11,35809 VolBytes=112,066,428,928 rate=63.74 MB/s
Wrote block=860000, file,blk=11,40809 VolBytes=112,721,788,928 rate=63.82 MB/s
Wrote block=865000, file,blk=11,45809 VolBytes=113,377,148,928 rate=63.80 MB/s
Wrote block=870000, file,blk=11,50809 VolBytes=114,032,508,928 rate=63.81 MB/s
Wrote block=875000, file,blk=11,55809 VolBytes=114,687,868,928 rate=63.85 MB/s
Wrote block=880000, file,blk=11,60809 VolBytes=115,343,228,928 rate=63.90 MB/s
Wrote block=885000, file,blk=11,65809 VolBytes=115,998,588,928 rate=63.87 MB/s
Wrote block=890000, file,blk=11,70809 VolBytes=116,653,948,928 rate=63.88 MB/s
Wrote block=895000, file,blk=11,75809 VolBytes=117,309,308,928 rate=63.92 MB/s
Wrote block=900000, file,blk=11,80809 VolBytes=117,964,668,928 rate=63.93 MB/s
Wrote block=905000, file,blk=12,3890 VolBytes=118,620,028,928 rate=63.80 MB/s
Wrote block=910000, file,blk=12,8890 VolBytes=119,275,388,928 rate=63.85 MB/s
Wrote block=915000, file,blk=12,13890 VolBytes=119,930,748,928 rate=63.89 MB/s
Wrote block=920000, file,blk=12,18890 VolBytes=120,586,108,928 rate=63.93 MB/s
Wrote block=925000, file,blk=12,23890 VolBytes=121,241,468,928 rate=63.94 MB/s
Wrote block=930000, file,blk=12,28890 VolBytes=121,896,828,928 rate=63.88 MB/s
Wrote block=935000, file,blk=12,33890 VolBytes=122,552,188,928 rate=63.86 MB/s
Wrote block=940000, file,blk=12,38890 VolBytes=123,207,548,928 rate=63.90 MB/s
Wrote block=945000, file,blk=12,43890 VolBytes=123,862,908,928 rate=63.94 MB/s
Wrote block=950000, file,blk=12,48890 VolBytes=124,518,268,928 rate=63.95 MB/s
Wrote block=955000, file,blk=12,53890 VolBytes=125,173,628,928 rate=63.99 MB/s
Wrote block=960000, file,blk=12,58890 VolBytes=125,828,988,928 rate=63.87 MB/s
Wrote block=965000, file,blk=12,63890 VolBytes=126,484,348,928 rate=63.91 MB/s
Wrote block=970000, file,blk=12,68890 VolBytes=127,139,708,928 rate=63.85 MB/s
Wrote block=975000, file,blk=12,73890 VolBytes=127,795,068,928 rate=63.83 MB/s
Wrote block=980000, file,blk=12,78890 VolBytes=128,450,428,928 rate=63.84 MB/s
02:39:04 Flush block, write EOF
Wrote block=985000, file,blk=13,1971 VolBytes=129,105,788,928 rate=63.81 MB/s
Wrote block=990000, file,blk=13,6971 VolBytes=129,761,148,928 rate=63.85 MB/s
Wrote block=995000, file,blk=13,11971 VolBytes=130,416,508,928 rate=63.83 MB/s
Wrote block=1000000, file,blk=13,16971 VolBytes=131,071,868,928 rate=63.78 MB/s
Wrote block=1005000, file,blk=13,21971 VolBytes=131,727,228,928 rate=63.75 MB/s
Wrote block=1010000, file,blk=13,26971 VolBytes=132,382,588,928 rate=63.79 MB/s
Wrote block=1015000, file,blk=13,31971 VolBytes=133,037,948,928 rate=63.83 MB/s
Wrote block=1020000, file,blk=13,36971 VolBytes=133,693,308,928 rate=63.84 MB/s
Wrote block=1025000, file,blk=13,41971 VolBytes=134,348,668,928 rate=63.88 MB/s
Wrote block=1030000, file,blk=13,46971 VolBytes=135,004,028,928 rate=63.92 MB/s
Wrote block=1035000, file,blk=13,51971 VolBytes=135,659,388,928 rate=63.89 MB/s
Wrote block=1040000, file,blk=13,56971 VolBytes=136,314,748,928 rate=63.90 MB/s
Wrote block=1045000, file,blk=13,61971 VolBytes=136,970,108,928 rate=63.94 MB/s
Wrote block=1050000, file,blk=13,66971 VolBytes=137,625,468,928 rate=63.98 MB/s
Wrote block=1055000, file,blk=13,71971 VolBytes=138,280,828,928 rate=64.01 MB/s
Wrote block=1060000, file,blk=13,76971 VolBytes=138,936,188,928 rate=64.05 MB/s
Wrote block=1065000, file,blk=14,52 VolBytes=139,591,548,928 rate=64.06 MB/s
Wrote block=1070000, file,blk=14,5052 VolBytes=140,246,908,928 rate=64.03 MB/s
Wrote block=1075000, file,blk=14,10052 VolBytes=140,902,268,928 rate=64.04 MB/s
Wrote block=1080000, file,blk=14,15052 VolBytes=141,557,628,928 rate=64.08 MB/s
Wrote block=1085000, file,blk=14,20052 VolBytes=142,212,988,928 rate=64.08 MB/s
Wrote block=1090000, file,blk=14,25052 VolBytes=142,868,348,928 rate=64.15 MB/s
Wrote block=1095000, file,blk=14,30052 VolBytes=143,523,708,928 rate=64.18 MB/s
Wrote block=1100000, file,blk=14,35052 VolBytes=144,179,068,928 rate=64.22 MB/s
Wrote block=1105000, file,blk=14,40052 VolBytes=144,834,428,928 rate=64.22 MB/s
Wrote block=1110000, file,blk=14,45052 VolBytes=145,489,788,928 rate=64.12 MB/s
Wrote block=1115000, file,blk=14,50052 VolBytes=146,145,148,928 rate=64.12 MB/s
Wrote block=1120000, file,blk=14,55052 VolBytes=146,800,508,928 rate=64.18 MB/s
Wrote block=1125000, file,blk=14,60052 VolBytes=147,455,868,928 rate=64.13 MB/s
Wrote block=1130000, file,blk=14,65052 VolBytes=148,111,228,928 rate=64.08 MB/s
Wrote block=1135000, file,blk=14,70052 VolBytes=148,766,588,928 rate=64.04 MB/s
Wrote block=1140000, file,blk=14,75052 VolBytes=149,421,948,928 rate=64.07 MB/s
Wrote block=1145000, file,blk=14,80052 VolBytes=150,077,308,928 rate=64.05 MB/s
Wrote block=1150000, file,blk=15,3133 VolBytes=150,732,668,928 rate=63.92 MB/s
Wrote block=1155000, file,blk=15,8133 VolBytes=151,388,028,928 rate=63.90 MB/s
Wrote block=1160000, file,blk=15,13133 VolBytes=152,043,388,928 rate=63.93 MB/s
Wrote block=1165000, file,blk=15,18133 VolBytes=152,698,748,928 rate=63.97 MB/s
Wrote block=1170000, file,blk=15,23133 VolBytes=153,354,108,928 rate=63.97 MB/s
Wrote block=1175000, file,blk=15,28133 VolBytes=154,009,468,928 rate=64.01 MB/s
Wrote block=1180000, file,blk=15,33133 VolBytes=154,664,828,928 rate=63.99 MB/s
Wrote block=1185000, file,blk=15,38133 VolBytes=155,320,188,928 rate=64.02 MB/s
Wrote block=1190000, file,blk=15,43133 VolBytes=155,975,548,928 rate=64.05 MB/s
Wrote block=1195000, file,blk=15,48133 VolBytes=156,630,908,928 rate=64.00 MB/s
Wrote block=1200000, file,blk=15,53133 VolBytes=157,286,268,928 rate=63.96 MB/s
Wrote block=1205000, file,blk=15,58133 VolBytes=157,941,628,928 rate=63.99 MB/s
Wrote block=1210000, file,blk=15,63133 VolBytes=158,596,988,928 rate=63.97 MB/s
Wrote block=1215000, file,blk=15,68133 VolBytes=159,252,348,928 rate=63.93 MB/s
Wrote block=1220000, file,blk=15,73133 VolBytes=159,907,708,928 rate=63.96 MB/s
Wrote block=1225000, file,blk=15,78133 VolBytes=160,563,068,928 rate=63.96 MB/s
Wrote block=1230000, file,blk=16,1214 VolBytes=161,218,428,928 rate=63.95 MB/s
Wrote block=1235000, file,blk=16,6214 VolBytes=161,873,788,928 rate=63.90 MB/s
Wrote block=1240000, file,blk=16,11214 VolBytes=162,529,148,928 rate=63.91 MB/s
Wrote block=1245000, file,blk=16,16214 VolBytes=163,184,508,928 rate=63.94 MB/s
Wrote block=1250000, file,blk=16,21214 VolBytes=163,839,868,928 rate=63.97 MB/s
Wrote block=1255000, file,blk=16,26214 VolBytes=164,495,228,928 rate=63.95 MB/s
Wrote block=1260000, file,blk=16,31214 VolBytes=165,150,588,928 rate=63.91 MB/s
Wrote block=1265000, file,blk=16,36214 VolBytes=165,805,948,928 rate=63.82 MB/s
Wrote block=1270000, file,blk=16,41214 VolBytes=166,461,308,928 rate=63.85 MB/s
Wrote block=1275000, file,blk=16,46214 VolBytes=167,116,668,928 rate=63.83 MB/s
Wrote block=1280000, file,blk=16,51214 VolBytes=167,772,028,928 rate=63.84 MB/s
Wrote block=1285000, file,blk=16,56214 VolBytes=168,427,388,928 rate=63.87 MB/s
Wrote block=1290000, file,blk=16,61214 VolBytes=169,082,748,928 rate=63.90 MB/s
Wrote block=1295000, file,blk=16,66214 VolBytes=169,738,108,928 rate=63.85 MB/s
Wrote block=1300000, file,blk=16,71214 VolBytes=170,393,468,928 rate=63.84 MB/s
Wrote block=1305000, file,blk=16,76214 VolBytes=171,048,828,928 rate=63.87 MB/s
Wrote block=1310000, file,blk=16,81214 VolBytes=171,704,188,928 rate=63.87 MB/s
02:50:16 Flush block, write EOF
Wrote block=1315000, file,blk=17,4295 VolBytes=172,359,548,928 rate=63.78 MB/s
Wrote block=1320000, file,blk=17,9295 VolBytes=173,014,908,928 rate=63.79 MB/s
Wrote block=1325000, file,blk=17,14295 VolBytes=173,670,268,928 rate=63.82 MB/s
Wrote block=1330000, file,blk=17,19295 VolBytes=174,325,628,928 rate=63.80 MB/s
Wrote block=1335000, file,blk=17,24295 VolBytes=174,980,988,928 rate=63.83 MB/s
Wrote block=1340000, file,blk=17,29295 VolBytes=175,636,348,928 rate=63.86 MB/s
Wrote block=1345000, file,blk=17,34295 VolBytes=176,291,708,928 rate=63.87 MB/s
Wrote block=1350000, file,blk=17,39295 VolBytes=176,947,068,928 rate=63.90 MB/s
Wrote block=1355000, file,blk=17,44295 VolBytes=177,602,428,928 rate=63.93 MB/s
Wrote block=1360000, file,blk=17,49295 VolBytes=178,257,788,928 rate=63.96 MB/s
Wrote block=1365000, file,blk=17,54295 VolBytes=178,913,148,928 rate=63.96 MB/s
Wrote block=1370000, file,blk=17,59295 VolBytes=179,568,508,928 rate=63.99 MB/s
Wrote block=1375000, file,blk=17,64295 VolBytes=180,223,868,928 rate=63.99 MB/s
Wrote block=1380000, file,blk=17,69295 VolBytes=180,879,228,928 rate=64.02 MB/s
Wrote block=1385000, file,blk=17,74295 VolBytes=181,534,588,928 rate=64.05 MB/s
Wrote block=1390000, file,blk=17,79295 VolBytes=182,189,948,928 rate=64.03 MB/s
Wrote block=1395000, file,blk=18,2376 VolBytes=182,845,308,928 rate=63.99 MB/s
Wrote block=1400000, file,blk=18,7376 VolBytes=183,500,668,928 rate=63.95 MB/s
Wrote block=1405000, file,blk=18,12376 VolBytes=184,156,028,928 rate=63.89 MB/s
Wrote block=1410000, file,blk=18,17376 VolBytes=184,811,388,928 rate=63.86 MB/s
Wrote block=1415000, file,blk=18,22376 VolBytes=185,466,748,928 rate=63.84 MB/s
Wrote block=1420000, file,blk=18,27376 VolBytes=186,122,108,928 rate=63.84 MB/s
Wrote block=1425000, file,blk=18,32376 VolBytes=186,777,468,928 rate=63.87 MB/s
Wrote block=1430000, file,blk=18,37376 VolBytes=187,432,828,928 rate=63.88 MB/s
Wrote block=1435000, file,blk=18,42376 VolBytes=188,088,188,928 rate=63.86 MB/s
Wrote block=1440000, file,blk=18,47376 VolBytes=188,743,548,928 rate=63.82 MB/s
Wrote block=1445000, file,blk=18,52376 VolBytes=189,398,908,928 rate=63.85 MB/s
Wrote block=1450000, file,blk=18,57376 VolBytes=190,054,268,928 rate=63.86 MB/s
Wrote block=1455000, file,blk=18,62376 VolBytes=190,709,628,928 rate=63.88 MB/s
Wrote block=1460000, file,blk=18,67376 VolBytes=191,364,988,928 rate=63.87 MB/s
Wrote block=1465000, file,blk=18,72376 VolBytes=192,020,348,928 rate=63.87 MB/s
Wrote block=1470000, file,blk=18,77376 VolBytes=192,675,708,928 rate=63.90 MB/s
Wrote block=1475000, file,blk=19,457 VolBytes=193,331,068,928 rate=63.86 MB/s
Wrote block=1480000, file,blk=19,5457 VolBytes=193,986,428,928 rate=63.85 MB/s
Wrote block=1485000, file,blk=19,10457 VolBytes=194,641,788,928 rate=63.85 MB/s
Wrote block=1490000, file,blk=19,15457 VolBytes=195,297,148,928 rate=63.88 MB/s
Wrote block=1495000, file,blk=19,20457 VolBytes=195,952,508,928 rate=63.91 MB/s
Wrote block=1500000, file,blk=19,25457 VolBytes=196,607,868,928 rate=63.93 MB/s
Wrote block=1505000, file,blk=19,30457 VolBytes=197,263,228,928 rate=63.90 MB/s
Wrote block=1510000, file,blk=19,35457 VolBytes=197,918,588,928 rate=63.94 MB/s
Wrote block=1515000, file,blk=19,40457 VolBytes=198,573,948,928 rate=63.91 MB/s
Wrote block=1520000, file,blk=19,45457 VolBytes=199,229,308,928 rate=63.89 MB/s
Wrote block=1525000, file,blk=19,50457 VolBytes=199,884,668,928 rate=63.92 MB/s
Wrote block=1530000, file,blk=19,55457 VolBytes=200,540,028,928 rate=63.94 MB/s
Wrote block=1535000, file,blk=19,60457 VolBytes=201,195,388,928 rate=63.95 MB/s
Wrote block=1540000, file,blk=19,65457 VolBytes=201,850,748,928 rate=63.97 MB/s
Wrote block=1545000, file,blk=19,70457 VolBytes=202,506,108,928 rate=64.00 MB/s
Wrote block=1550000, file,blk=19,75457 VolBytes=203,161,468,928 rate=63.92 MB/s
Wrote block=1555000, file,blk=19,80457 VolBytes=203,816,828,928 rate=63.95 MB/s
Wrote block=1560000, file,blk=20,3538 VolBytes=204,472,188,928 rate=63.91 MB/s
Wrote block=1565000, file,blk=20,8538 VolBytes=205,127,548,928 rate=63.94 MB/s
Wrote block=1570000, file,blk=20,13538 VolBytes=205,782,908,928 rate=63.92 MB/s
Wrote block=1575000, file,blk=20,18538 VolBytes=206,438,268,928 rate=63.91 MB/s
Wrote block=1580000, file,blk=20,23538 VolBytes=207,093,628,928 rate=63.93 MB/s
Wrote block=1585000, file,blk=20,28538 VolBytes=207,748,988,928 rate=63.96 MB/s
Wrote block=1590000, file,blk=20,33538 VolBytes=208,404,348,928 rate=63.90 MB/s
Wrote block=1595000, file,blk=20,38538 VolBytes=209,059,708,928 rate=63.89 MB/s
Wrote block=1600000, file,blk=20,43538 VolBytes=209,715,068,928 rate=63.85 MB/s
Wrote block=1605000, file,blk=20,48538 VolBytes=210,370,428,928 rate=63.84 MB/s
Wrote block=1610000, file,blk=20,53538 VolBytes=211,025,788,928 rate=63.85 MB/s
Wrote block=1615000, file,blk=20,58538 VolBytes=211,681,148,928 rate=63.89 MB/s
Wrote block=1620000, file,blk=20,63538 VolBytes=212,336,508,928 rate=63.89 MB/s
Wrote block=1625000, file,blk=20,68538 VolBytes=212,991,868,928 rate=63.71 MB/s
Wrote block=1630000, file,blk=20,73538 VolBytes=213,647,228,928 rate=63.75 MB/s
Wrote block=1635000, file,blk=20,78538 VolBytes=214,302,588,928 rate=63.78 MB/s
03:01:31 Flush block, write EOF
Wrote block=1640000, file,blk=21,1619 VolBytes=214,957,948,928 rate=63.78 MB/s
Wrote block=1645000, file,blk=21,6619 VolBytes=215,613,308,928 rate=63.75 MB/s
Wrote block=1650000, file,blk=21,11619 VolBytes=216,268,668,928 rate=63.73 MB/s
Wrote block=1655000, file,blk=21,16619 VolBytes=216,924,028,928 rate=63.72 MB/s
Wrote block=1660000, file,blk=21,21619 VolBytes=217,579,388,928 rate=63.73 MB/s
Wrote block=1665000, file,blk=21,26619 VolBytes=218,234,748,928 rate=63.75 MB/s
Wrote block=1670000, file,blk=21,31619 VolBytes=218,890,108,928 rate=63.77 MB/s
Wrote block=1675000, file,blk=21,36619 VolBytes=219,545,468,928 rate=63.80 MB/s
Wrote block=1680000, file,blk=21,41619 VolBytes=220,200,828,928 rate=63.82 MB/s
Wrote block=1685000, file,blk=21,46619 VolBytes=220,856,188,928 rate=63.84 MB/s
Wrote block=1690000, file,blk=21,51619 VolBytes=221,511,548,928 rate=63.85 MB/s
Wrote block=1695000, file,blk=21,56619 VolBytes=222,166,908,928 rate=63.84 MB/s
Wrote block=1700000, file,blk=21,61619 VolBytes=222,822,268,928 rate=63.86 MB/s
Wrote block=1705000, file,blk=21,66619 VolBytes=223,477,628,928 rate=63.83 MB/s
Wrote block=1710000, file,blk=21,71619 VolBytes=224,132,988,928 rate=63.81 MB/s
Wrote block=1715000, file,blk=21,76619 VolBytes=224,788,348,928 rate=63.84 MB/s
Wrote block=1720000, file,blk=21,81619 VolBytes=225,443,708,928 rate=63.84 MB/s
Wrote block=1725000, file,blk=22,4700 VolBytes=226,099,068,928 rate=63.77 MB/s
Wrote block=1730000, file,blk=22,9700 VolBytes=226,754,428,928 rate=63.80 MB/s
Wrote block=1735000, file,blk=22,14700 VolBytes=227,409,788,928 rate=63.80 MB/s
Wrote block=1740000, file,blk=22,19700 VolBytes=228,065,148,928 rate=63.83 MB/s
Wrote block=1745000, file,blk=22,24700 VolBytes=228,720,508,928 rate=63.79 MB/s
Wrote block=1750000, file,blk=22,29700 VolBytes=229,375,868,928 rate=63.83 MB/s
Wrote block=1755000, file,blk=22,34700 VolBytes=230,031,228,928 rate=63.86 MB/s
Wrote block=1760000, file,blk=22,39700 VolBytes=230,686,588,928 rate=63.86 MB/s
Wrote block=1765000, file,blk=22,44700 VolBytes=231,341,948,928 rate=63.85 MB/s
Wrote block=1770000, file,blk=22,49700 VolBytes=231,997,308,928 rate=63.84 MB/s
Wrote block=1775000, file,blk=22,54700 VolBytes=232,652,668,928 rate=63.81 MB/s
Wrote block=1780000, file,blk=22,59700 VolBytes=233,308,028,928 rate=63.79 MB/s
Wrote block=1785000, file,blk=22,64700 VolBytes=233,963,388,928 rate=63.81 MB/s
Wrote block=1790000, file,blk=22,69700 VolBytes=234,618,748,928 rate=63.78 MB/s
Wrote block=1795000, file,blk=22,74700 VolBytes=235,274,108,928 rate=63.77 MB/s
Wrote block=1800000, file,blk=22,79700 VolBytes=235,929,468,928 rate=63.74 MB/s
Wrote block=1805000, file,blk=23,2781 VolBytes=236,584,828,928 rate=63.66 MB/s
Wrote block=1810000, file,blk=23,7781 VolBytes=237,240,188,928 rate=63.68 MB/s
Wrote block=1815000, file,blk=23,12781 VolBytes=237,895,548,928 rate=63.71 MB/s
Wrote block=1820000, file,blk=23,17781 VolBytes=238,550,908,928 rate=63.73 MB/s
Wrote block=1825000, file,blk=23,22781 VolBytes=239,206,268,928 rate=63.73 MB/s
Wrote block=1830000, file,blk=23,27781 VolBytes=239,861,628,928 rate=63.75 MB/s
Wrote block=1835000, file,blk=23,32781 VolBytes=240,516,988,928 rate=63.78 MB/s
Wrote block=1840000, file,blk=23,37781 VolBytes=241,172,348,928 rate=63.80 MB/s
Wrote block=1845000, file,blk=23,42781 VolBytes=241,827,708,928 rate=63.73 MB/s
Wrote block=1850000, file,blk=23,47781 VolBytes=242,483,068,928 rate=63.76 MB/s
Wrote block=1855000, file,blk=23,52781 VolBytes=243,138,428,928 rate=63.74 MB/s
Wrote block=1860000, file,blk=23,57781 VolBytes=243,793,788,928 rate=63.72 MB/s
Wrote block=1865000, file,blk=23,62781 VolBytes=244,449,148,928 rate=63.70 MB/s
Wrote block=1870000, file,blk=23,67781 VolBytes=245,104,508,928 rate=63.71 MB/s
Wrote block=1875000, file,blk=23,72781 VolBytes=245,759,868,928 rate=63.75 MB/s
Wrote block=1880000, file,blk=23,77781 VolBytes=246,415,228,928 rate=63.75 MB/s
Wrote block=1885000, file,blk=24,862 VolBytes=247,070,588,928 rate=63.72 MB/s
Wrote block=1890000, file,blk=24,5862 VolBytes=247,725,948,928 rate=63.65 MB/s
Wrote block=1895000, file,blk=24,10862 VolBytes=248,381,308,928 rate=63.67 MB/s
Wrote block=1900000, file,blk=24,15862 VolBytes=249,036,668,928 rate=63.69 MB/s
Wrote block=1905000, file,blk=24,20862 VolBytes=249,692,028,928 rate=63.64 MB/s
Wrote block=1910000, file,blk=24,25862 VolBytes=250,347,388,928 rate=63.68 MB/s
Wrote block=1915000, file,blk=24,30862 VolBytes=251,002,748,928 rate=63.67 MB/s
Wrote block=1920000, file,blk=24,35862 VolBytes=251,658,108,928 rate=63.66 MB/s
Wrote block=1925000, file,blk=24,40862 VolBytes=252,313,468,928 rate=63.68 MB/s
Wrote block=1930000, file,blk=24,45862 VolBytes=252,968,828,928 rate=63.70 MB/s
Wrote block=1935000, file,blk=24,50862 VolBytes=253,624,188,928 rate=63.67 MB/s
Wrote block=1940000, file,blk=24,55862 VolBytes=254,279,548,928 rate=63.66 MB/s
Wrote block=1945000, file,blk=24,60862 VolBytes=254,934,908,928 rate=63.67 MB/s
Wrote block=1950000, file,blk=24,65862 VolBytes=255,590,268,928 rate=63.69 MB/s
Wrote block=1955000, file,blk=24,70862 VolBytes=256,245,628,928 rate=63.69 MB/s
Wrote block=1960000, file,blk=24,75862 VolBytes=256,900,988,928 rate=63.71 MB/s
Wrote block=1965000, file,blk=24,80862 VolBytes=257,556,348,928 rate=63.75 MB/s
03:12:50 Flush block, write EOF
Wrote block=1970000, file,blk=25,3943 VolBytes=258,211,708,928 rate=63.72 MB/s
Wrote block=1975000, file,blk=25,8943 VolBytes=258,867,068,928 rate=63.72 MB/s
Wrote block=1980000, file,blk=25,13943 VolBytes=259,522,428,928 rate=63.71 MB/s
Wrote block=1985000, file,blk=25,18943 VolBytes=260,177,788,928 rate=63.69 MB/s
Wrote block=1990000, file,blk=25,23943 VolBytes=260,833,148,928 rate=63.64 MB/s
Wrote block=1995000, file,blk=25,28943 VolBytes=261,488,508,928 rate=63.66 MB/s
Wrote block=2000000, file,blk=25,33943 VolBytes=262,143,868,928 rate=63.67 MB/s
Wrote block=2005000, file,blk=25,38943 VolBytes=262,799,228,928 rate=63.69 MB/s
Wrote block=2010000, file,blk=25,43943 VolBytes=263,454,588,928 rate=63.66 MB/s
Wrote block=2015000, file,blk=25,48943 VolBytes=264,109,948,928 rate=63.68 MB/s
Wrote block=2020000, file,blk=25,53943 VolBytes=264,765,308,928 rate=63.66 MB/s
Wrote block=2025000, file,blk=25,58943 VolBytes=265,420,668,928 rate=63.68 MB/s
Wrote block=2030000, file,blk=25,63943 VolBytes=266,076,028,928 rate=63.62 MB/s
Wrote block=2035000, file,blk=25,68943 VolBytes=266,731,388,928 rate=63.65 MB/s
Wrote block=2040000, file,blk=25,73943 VolBytes=267,386,748,928 rate=63.63 MB/s
Wrote block=2045000, file,blk=25,78943 VolBytes=268,042,108,928 rate=63.62 MB/s
Wrote block=2050000, file,blk=26,2024 VolBytes=268,697,468,928 rate=63.59 MB/s
Wrote block=2055000, file,blk=26,7024 VolBytes=269,352,828,928 rate=63.58 MB/s
Wrote block=2060000, file,blk=26,12024 VolBytes=270,008,188,928 rate=63.59 MB/s
Wrote block=2065000, file,blk=26,17024 VolBytes=270,663,548,928 rate=63.53 MB/s
Wrote block=2070000, file,blk=26,22024 VolBytes=271,318,908,928 rate=63.55 MB/s
Wrote block=2075000, file,blk=26,27024 VolBytes=271,974,268,928 rate=63.57 MB/s
Wrote block=2080000, file,blk=26,32024 VolBytes=272,629,628,928 rate=63.59 MB/s
Wrote block=2085000, file,blk=26,37024 VolBytes=273,284,988,928 rate=63.59 MB/s
Wrote block=2090000, file,blk=26,42024 VolBytes=273,940,348,928 rate=63.57 MB/s
Wrote block=2095000, file,blk=26,47024 VolBytes=274,595,708,928 rate=63.60 MB/s
Wrote block=2100000, file,blk=26,52024 VolBytes=275,251,068,928 rate=63.58 MB/s
Wrote block=2105000, file,blk=26,57024 VolBytes=275,906,428,928 rate=63.55 MB/s
Wrote block=2110000, file,blk=26,62024 VolBytes=276,561,788,928 rate=63.54 MB/s
Wrote block=2115000, file,blk=26,67024 VolBytes=277,217,148,928 rate=63.56 MB/s
Wrote block=2120000, file,blk=26,72024 VolBytes=277,872,508,928 rate=63.57 MB/s
Wrote block=2125000, file,blk=26,77024 VolBytes=278,527,868,928 rate=63.59 MB/s
Wrote block=2130000, file,blk=27,105 VolBytes=279,183,228,928 rate=63.55 MB/s
Wrote block=2135000, file,blk=27,5105 VolBytes=279,838,588,928 rate=63.55 MB/s
Wrote block=2140000, file,blk=27,10105 VolBytes=280,493,948,928 rate=63.54 MB/s
Wrote block=2145000, file,blk=27,15105 VolBytes=281,149,308,928 rate=63.56 MB/s
Wrote block=2150000, file,blk=27,20105 VolBytes=281,804,668,928 rate=63.54 MB/s
Wrote block=2155000, file,blk=27,25105 VolBytes=282,460,028,928 rate=63.53 MB/s
Wrote block=2160000, file,blk=27,30105 VolBytes=283,115,388,928 rate=63.55 MB/s
Wrote block=2165000, file,blk=27,35105 VolBytes=283,770,748,928 rate=63.52 MB/s
Wrote block=2170000, file,blk=27,40105 VolBytes=284,426,108,928 rate=63.51 MB/s
Wrote block=2175000, file,blk=27,45105 VolBytes=285,081,468,928 rate=63.53 MB/s
Wrote block=2180000, file,blk=27,50105 VolBytes=285,736,828,928 rate=63.53 MB/s
Wrote block=2185000, file,blk=27,55105 VolBytes=286,392,188,928 rate=63.55 MB/s
Wrote block=2190000, file,blk=27,60105 VolBytes=287,047,548,928 rate=63.57 MB/s
Wrote block=2195000, file,blk=27,65105 VolBytes=287,702,908,928 rate=63.59 MB/s
Wrote block=2200000, file,blk=27,70105 VolBytes=288,358,268,928 rate=63.61 MB/s
Wrote block=2205000, file,blk=27,75105 VolBytes=289,013,628,928 rate=63.61 MB/s
Wrote block=2210000, file,blk=27,80105 VolBytes=289,668,988,928 rate=63.60 MB/s
Wrote block=2215000, file,blk=28,3186 VolBytes=290,324,348,928 rate=63.50 MB/s
Wrote block=2220000, file,blk=28,8186 VolBytes=290,979,708,928 rate=63.51 MB/s
Wrote block=2225000, file,blk=28,13186 VolBytes=291,635,068,928 rate=63.53 MB/s
Wrote block=2230000, file,blk=28,18186 VolBytes=292,290,428,928 rate=63.51 MB/s
Wrote block=2235000, file,blk=28,23186 VolBytes=292,945,788,928 rate=63.53 MB/s
Wrote block=2240000, file,blk=28,28186 VolBytes=293,601,148,928 rate=63.50 MB/s
Wrote block=2245000, file,blk=28,33186 VolBytes=294,256,508,928 rate=63.52 MB/s
Wrote block=2250000, file,blk=28,38186 VolBytes=294,911,868,928 rate=63.54 MB/s
Wrote block=2255000, file,blk=28,43186 VolBytes=295,567,228,928 rate=63.56 MB/s
Wrote block=2260000, file,blk=28,48186 VolBytes=296,222,588,928 rate=63.56 MB/s
Wrote block=2265000, file,blk=28,53186 VolBytes=296,877,948,928 rate=63.58 MB/s
Wrote block=2270000, file,blk=28,58186 VolBytes=297,533,308,928 rate=63.60 MB/s
Wrote block=2275000, file,blk=28,63186 VolBytes=298,188,668,928 rate=63.62 MB/s
Wrote block=2280000, file,blk=28,68186 VolBytes=298,844,028,928 rate=63.63 MB/s
Wrote block=2285000, file,blk=28,73186 VolBytes=299,499,388,928 rate=63.62 MB/s
Wrote block=2290000, file,blk=28,78186 VolBytes=300,154,748,928 rate=63.63 MB/s
03:24:11 Flush block, write EOF
Wrote block=2295000, file,blk=29,1267 VolBytes=300,810,108,928 rate=63.60 MB/s
Wrote block=2300000, file,blk=29,6267 VolBytes=301,465,468,928 rate=63.58 MB/s
Wrote block=2305000, file,blk=29,11267 VolBytes=302,120,828,928 rate=63.60 MB/s
Wrote block=2310000, file,blk=29,16267 VolBytes=302,776,188,928 rate=63.58 MB/s
Wrote block=2315000, file,blk=29,21267 VolBytes=303,431,548,928 rate=63.57 MB/s
Wrote block=2320000, file,blk=29,26267 VolBytes=304,086,908,928 rate=63.57 MB/s
Wrote block=2325000, file,blk=29,31267 VolBytes=304,742,268,928 rate=63.59 MB/s
Wrote block=2330000, file,blk=29,36267 VolBytes=305,397,628,928 rate=63.57 MB/s
Wrote block=2335000, file,blk=29,41267 VolBytes=306,052,988,928 rate=63.57 MB/s
Wrote block=2340000, file,blk=29,46267 VolBytes=306,708,348,928 rate=63.57 MB/s
Wrote block=2345000, file,blk=29,51267 VolBytes=307,363,708,928 rate=63.59 MB/s
Wrote block=2350000, file,blk=29,56267 VolBytes=308,019,068,928 rate=63.61 MB/s
Wrote block=2355000, file,blk=29,61267 VolBytes=308,674,428,928 rate=63.63 MB/s
Wrote block=2360000, file,blk=29,66267 VolBytes=309,329,788,928 rate=63.60 MB/s
Wrote block=2365000, file,blk=29,71267 VolBytes=309,985,148,928 rate=63.62 MB/s
Wrote block=2370000, file,blk=29,76267 VolBytes=310,640,508,928 rate=63.64 MB/s
Wrote block=2375000, file,blk=29,81267 VolBytes=311,295,868,928 rate=63.64 MB/s
Wrote block=2380000, file,blk=30,4348 VolBytes=311,951,228,928 rate=63.59 MB/s
Wrote block=2385000, file,blk=30,9348 VolBytes=312,606,588,928 rate=63.60 MB/s
Wrote block=2390000, file,blk=30,14348 VolBytes=313,261,948,928 rate=63.59 MB/s
Wrote block=2395000, file,blk=30,19348 VolBytes=313,917,308,928 rate=63.58 MB/s
Wrote block=2400000, file,blk=30,24348 VolBytes=314,572,668,928 rate=63.58 MB/s
Wrote block=2405000, file,blk=30,29348 VolBytes=315,228,028,928 rate=63.60 MB/s
Wrote block=2410000, file,blk=30,34348 VolBytes=315,883,388,928 rate=63.62 MB/s
Wrote block=2415000, file,blk=30,39348 VolBytes=316,538,748,928 rate=63.63 MB/s
Wrote block=2420000, file,blk=30,44348 VolBytes=317,194,108,928 rate=63.65 MB/s
Wrote block=2425000, file,blk=30,49348 VolBytes=317,849,468,928 rate=63.65 MB/s
Wrote block=2430000, file,blk=30,54348 VolBytes=318,504,828,928 rate=63.67 MB/s
Wrote block=2435000, file,blk=30,59348 VolBytes=319,160,188,928 rate=63.56 MB/s
Wrote block=2440000, file,blk=30,64348 VolBytes=319,815,548,928 rate=63.58 MB/s
Wrote block=2445000, file,blk=30,69348 VolBytes=320,470,908,928 rate=63.59 MB/s
Wrote block=2450000, file,blk=30,74348 VolBytes=321,126,268,928 rate=63.57 MB/s
Wrote block=2455000, file,blk=30,79348 VolBytes=321,781,628,928 rate=63.58 MB/s
Wrote block=2460000, file,blk=31,2429 VolBytes=322,436,988,928 rate=63.52 MB/s
Wrote block=2465000, file,blk=31,7429 VolBytes=323,092,348,928 rate=63.53 MB/s
Wrote block=2470000, file,blk=31,12429 VolBytes=323,747,708,928 rate=63.51 MB/s
Wrote block=2475000, file,blk=31,17429 VolBytes=324,403,068,928 rate=63.50 MB/s
Wrote block=2480000, file,blk=31,22429 VolBytes=325,058,428,928 rate=63.48 MB/s
Wrote block=2485000, file,blk=31,27429 VolBytes=325,713,788,928 rate=63.50 MB/s
Wrote block=2490000, file,blk=31,32429 VolBytes=326,369,148,928 rate=63.49 MB/s
Wrote block=2495000, file,blk=31,37429 VolBytes=327,024,508,928 rate=63.47 MB/s
Wrote block=2500000, file,blk=31,42429 VolBytes=327,679,868,928 rate=63.46 MB/s
Wrote block=2505000, file,blk=31,47429 VolBytes=328,335,228,928 rate=63.45 MB/s
Wrote block=2510000, file,blk=31,52429 VolBytes=328,990,588,928 rate=63.47 MB/s
Wrote block=2515000, file,blk=31,57429 VolBytes=329,645,948,928 rate=63.47 MB/s
Wrote block=2520000, file,blk=31,62429 VolBytes=330,301,308,928 rate=63.49 MB/s
Wrote block=2525000, file,blk=31,67429 VolBytes=330,956,668,928 rate=63.49 MB/s
Wrote block=2530000, file,blk=31,72429 VolBytes=331,612,028,928 rate=63.51 MB/s
Wrote block=2535000, file,blk=31,77429 VolBytes=332,267,388,928 rate=63.50 MB/s
Wrote block=2540000, file,blk=32,510 VolBytes=332,922,748,928 rate=63.47 MB/s
Wrote block=2545000, file,blk=32,5510 VolBytes=333,578,108,928 rate=63.45 MB/s
Wrote block=2550000, file,blk=32,10510 VolBytes=334,233,468,928 rate=63.45 MB/s
Wrote block=2555000, file,blk=32,15510 VolBytes=334,888,828,928 rate=63.43 MB/s
Wrote block=2560000, file,blk=32,20510 VolBytes=335,544,188,928 rate=63.45 MB/s
Wrote block=2565000, file,blk=32,25510 VolBytes=336,199,548,928 rate=63.46 MB/s
Wrote block=2570000, file,blk=32,30510 VolBytes=336,854,908,928 rate=63.48 MB/s
Wrote block=2575000, file,blk=32,35510 VolBytes=337,510,268,928 rate=63.48 MB/s
Wrote block=2580000, file,blk=32,40510 VolBytes=338,165,628,928 rate=63.44 MB/s
Wrote block=2585000, file,blk=32,45510 VolBytes=338,820,988,928 rate=63.46 MB/s
Wrote block=2590000, file,blk=32,50510 VolBytes=339,476,348,928 rate=63.46 MB/s
Wrote block=2595000, file,blk=32,55510 VolBytes=340,131,708,928 rate=63.48 MB/s
Wrote block=2600000, file,blk=32,60510 VolBytes=340,787,068,928 rate=63.46 MB/s
Wrote block=2605000, file,blk=32,65510 VolBytes=341,442,428,928 rate=63.45 MB/s
Wrote block=2610000, file,blk=32,70510 VolBytes=342,097,788,928 rate=63.46 MB/s
Wrote block=2615000, file,blk=32,75510 VolBytes=342,753,148,928 rate=63.47 MB/s
Wrote block=2620000, file,blk=32,80510 VolBytes=343,408,508,928 rate=63.46 MB/s
03:35:41 Flush block, write EOF
Wrote block=2625000, file,blk=33,3591 VolBytes=344,063,868,928 rate=63.41 MB/s
Wrote block=2630000, file,blk=33,8591 VolBytes=344,719,228,928 rate=63.42 MB/s
Wrote block=2635000, file,blk=33,13591 VolBytes=345,374,588,928 rate=63.42 MB/s
Wrote block=2640000, file,blk=33,18591 VolBytes=346,029,948,928 rate=63.44 MB/s
Wrote block=2645000, file,blk=33,23591 VolBytes=346,685,308,928 rate=63.42 MB/s
Wrote block=2650000, file,blk=33,28591 VolBytes=347,340,668,928 rate=63.44 MB/s
Wrote block=2655000, file,blk=33,33591 VolBytes=347,996,028,928 rate=63.43 MB/s
Wrote block=2660000, file,blk=33,38591 VolBytes=348,651,388,928 rate=63.44 MB/s
Wrote block=2665000, file,blk=33,43591 VolBytes=349,306,748,928 rate=63.46 MB/s
Wrote block=2670000, file,blk=33,48591 VolBytes=349,962,108,928 rate=63.46 MB/s
Wrote block=2675000, file,blk=33,53591 VolBytes=350,617,468,928 rate=63.48 MB/s
Wrote block=2680000, file,blk=33,58591 VolBytes=351,272,828,928 rate=63.46 MB/s
Wrote block=2685000, file,blk=33,63591 VolBytes=351,928,188,928 rate=63.49 MB/s
Wrote block=2690000, file,blk=33,68591 VolBytes=352,583,548,928 rate=63.47 MB/s
Wrote block=2695000, file,blk=33,73591 VolBytes=353,238,908,928 rate=63.48 MB/s
Wrote block=2700000, file,blk=33,78591 VolBytes=353,894,268,928 rate=63.49 MB/s
Wrote block=2705000, file,blk=34,1672 VolBytes=354,549,628,928 rate=63.48 MB/s
Wrote block=2710000, file,blk=34,6672 VolBytes=355,204,988,928 rate=63.46 MB/s
Wrote block=2715000, file,blk=34,11672 VolBytes=355,860,348,928 rate=63.47 MB/s
Wrote block=2720000, file,blk=34,16672 VolBytes=356,515,708,928 rate=63.48 MB/s
Wrote block=2725000, file,blk=34,21672 VolBytes=357,171,068,928 rate=63.47 MB/s
Wrote block=2730000, file,blk=34,26672 VolBytes=357,826,428,928 rate=63.48 MB/s
Wrote block=2735000, file,blk=34,31672 VolBytes=358,481,788,928 rate=63.50 MB/s
Wrote block=2740000, file,blk=34,36672 VolBytes=359,137,148,928 rate=63.48 MB/s
Wrote block=2745000, file,blk=34,41672 VolBytes=359,792,508,928 rate=63.50 MB/s
Wrote block=2750000, file,blk=34,46672 VolBytes=360,447,868,928 rate=63.49 MB/s
Wrote block=2755000, file,blk=34,51672 VolBytes=361,103,228,928 rate=63.50 MB/s
Wrote block=2760000, file,blk=34,56672 VolBytes=361,758,588,928 rate=63.52 MB/s
Wrote block=2765000, file,blk=34,61672 VolBytes=362,413,948,928 rate=63.52 MB/s
Wrote block=2770000, file,blk=34,66672 VolBytes=363,069,308,928 rate=63.54 MB/s
Wrote block=2775000, file,blk=34,71672 VolBytes=363,724,668,928 rate=63.55 MB/s
Wrote block=2780000, file,blk=34,76672 VolBytes=364,380,028,928 rate=63.56 MB/s
Wrote block=2785000, file,blk=34,81672 VolBytes=365,035,388,928 rate=63.58 MB/s
Wrote block=2790000, file,blk=35,4753 VolBytes=365,690,748,928 rate=63.56 MB/s
Wrote block=2795000, file,blk=35,9753 VolBytes=366,346,108,928 rate=63.56 MB/s
Wrote block=2800000, file,blk=35,14753 VolBytes=367,001,468,928 rate=63.56 MB/s
Wrote block=2805000, file,blk=35,19753 VolBytes=367,656,828,928 rate=63.55 MB/s
Wrote block=2810000, file,blk=35,24753 VolBytes=368,312,188,928 rate=63.53 MB/s
Wrote block=2815000, file,blk=35,29753 VolBytes=368,967,548,928 rate=63.54 MB/s
Wrote block=2820000, file,blk=35,34753 VolBytes=369,622,908,928 rate=63.55 MB/s
Wrote block=2825000, file,blk=35,39753 VolBytes=370,278,268,928 rate=63.56 MB/s
Wrote block=2830000, file,blk=35,44753 VolBytes=370,933,628,928 rate=63.55 MB/s
Wrote block=2835000, file,blk=35,49753 VolBytes=371,588,988,928 rate=63.57 MB/s
Wrote block=2840000, file,blk=35,54753 VolBytes=372,244,348,928 rate=63.57 MB/s
Wrote block=2845000, file,blk=35,59753 VolBytes=372,899,708,928 rate=63.59 MB/s
Wrote block=2850000, file,blk=35,64753 VolBytes=373,555,068,928 rate=63.59 MB/s
Wrote block=2855000, file,blk=35,69753 VolBytes=374,210,428,928 rate=63.60 MB/s
Wrote block=2860000, file,blk=35,74753 VolBytes=374,865,788,928 rate=63.62 MB/s
Wrote block=2865000, file,blk=35,79753 VolBytes=375,521,148,928 rate=63.63 MB/s
Wrote block=2870000, file,blk=36,2834 VolBytes=376,176,508,928 rate=63.61 MB/s
Wrote block=2875000, file,blk=36,7834 VolBytes=376,831,868,928 rate=63.58 MB/s
Wrote block=2880000, file,blk=36,12834 VolBytes=377,487,228,928 rate=63.58 MB/s
Wrote block=2885000, file,blk=36,17834 VolBytes=378,142,588,928 rate=63.58 MB/s
Wrote block=2890000, file,blk=36,22834 VolBytes=378,797,948,928 rate=63.59 MB/s
Wrote block=2895000, file,blk=36,27834 VolBytes=379,453,308,928 rate=63.58 MB/s
Wrote block=2900000, file,blk=36,32834 VolBytes=380,108,668,928 rate=63.57 MB/s
Wrote block=2905000, file,blk=36,37834 VolBytes=380,764,028,928 rate=63.55 MB/s
Wrote block=2910000, file,blk=36,42834 VolBytes=381,419,388,928 rate=63.54 MB/s
Wrote block=2915000, file,blk=36,47834 VolBytes=382,074,748,928 rate=63.56 MB/s
Wrote block=2920000, file,blk=36,52834 VolBytes=382,730,108,928 rate=63.54 MB/s
Wrote block=2925000, file,blk=36,57834 VolBytes=383,385,468,928 rate=63.55 MB/s
Wrote block=2930000, file,blk=36,62834 VolBytes=384,040,828,928 rate=63.55 MB/s
Wrote block=2935000, file,blk=36,67834 VolBytes=384,696,188,928 rate=63.55 MB/s
Wrote block=2940000, file,blk=36,72834 VolBytes=385,351,548,928 rate=63.56 MB/s
Wrote block=2945000, file,blk=36,77834 VolBytes=386,006,908,928 rate=63.57 MB/s
03:46:50 Flush block, write EOF
Wrote block=2950000, file,blk=37,915 VolBytes=386,662,268,928 rate=63.52 MB/s
Wrote block=2955000, file,blk=37,5915 VolBytes=387,317,628,928 rate=63.49 MB/s
Wrote block=2960000, file,blk=37,10915 VolBytes=387,972,988,928 rate=63.50 MB/s
Wrote block=2965000, file,blk=37,15915 VolBytes=388,628,348,928 rate=63.51 MB/s
Wrote block=2970000, file,blk=37,20915 VolBytes=389,283,708,928 rate=63.52 MB/s
Wrote block=2975000, file,blk=37,25915 VolBytes=389,939,068,928 rate=63.48 MB/s
Wrote block=2980000, file,blk=37,30915 VolBytes=390,594,428,928 rate=63.50 MB/s
Wrote block=2985000, file,blk=37,35915 VolBytes=391,249,788,928 rate=63.49 MB/s
Wrote block=2990000, file,blk=37,40915 VolBytes=391,905,148,928 rate=63.49 MB/s
Wrote block=2995000, file,blk=37,45915 VolBytes=392,560,508,928 rate=63.51 MB/s
Wrote block=3000000, file,blk=37,50915 VolBytes=393,215,868,928 rate=63.52 MB/s
Wrote block=3005000, file,blk=37,55915 VolBytes=393,871,228,928 rate=63.53 MB/s
Wrote block=3010000, file,blk=37,60915 VolBytes=394,526,588,928 rate=63.55 MB/s
Wrote block=3015000, file,blk=37,65915 VolBytes=395,181,948,928 rate=63.55 MB/s
Wrote block=3020000, file,blk=37,70915 VolBytes=395,837,308,928 rate=63.54 MB/s
Wrote block=3025000, file,blk=37,75915 VolBytes=396,492,668,928 rate=63.53 MB/s
Wrote block=3030000, file,blk=37,80915 VolBytes=397,148,028,928 rate=63.53 MB/s
Wrote block=3035000, file,blk=38,3996 VolBytes=397,803,388,928 rate=63.49 MB/s
Wrote block=3040000, file,blk=38,8996 VolBytes=398,458,748,928 rate=63.47 MB/s
Wrote block=3045000, file,blk=38,13996 VolBytes=399,114,108,928 rate=63.46 MB/s
Wrote block=3050000, file,blk=38,18996 VolBytes=399,769,468,928 rate=63.47 MB/s
Wrote block=3055000, file,blk=38,23996 VolBytes=400,424,828,928 rate=63.48 MB/s
Wrote block=3060000, file,blk=38,28996 VolBytes=401,080,188,928 rate=63.50 MB/s
Wrote block=3065000, file,blk=38,33996 VolBytes=401,735,548,928 rate=63.48 MB/s
Wrote block=3070000, file,blk=38,38996 VolBytes=402,390,908,928 rate=63.47 MB/s
Wrote block=3075000, file,blk=38,43996 VolBytes=403,046,268,928 rate=63.48 MB/s
Wrote block=3080000, file,blk=38,48996 VolBytes=403,701,628,928 rate=63.49 MB/s
Wrote block=3085000, file,blk=38,53996 VolBytes=404,356,988,928 rate=63.49 MB/s
Wrote block=3090000, file,blk=38,58996 VolBytes=405,012,348,928 rate=63.49 MB/s
Wrote block=3095000, file,blk=38,63996 VolBytes=405,667,708,928 rate=63.45 MB/s
Wrote block=3100000, file,blk=38,68996 VolBytes=406,323,068,928 rate=63.44 MB/s
Wrote block=3105000, file,blk=38,73996 VolBytes=406,978,428,928 rate=63.45 MB/s
Wrote block=3110000, file,blk=38,78996 VolBytes=407,633,788,928 rate=63.46 MB/s
Wrote block=3115000, file,blk=39,2077 VolBytes=408,289,148,928 rate=63.41 MB/s
Wrote block=3120000, file,blk=39,7077 VolBytes=408,944,508,928 rate=63.43 MB/s
Wrote block=3125000, file,blk=39,12077 VolBytes=409,599,868,928 rate=63.44 MB/s
Wrote block=3130000, file,blk=39,17077 VolBytes=410,255,228,928 rate=63.45 MB/s
Wrote block=3135000, file,blk=39,22077 VolBytes=410,910,588,928 rate=63.46 MB/s
Wrote block=3140000, file,blk=39,27077 VolBytes=411,565,948,928 rate=63.47 MB/s
Wrote block=3145000, file,blk=39,32077 VolBytes=412,221,308,928 rate=63.48 MB/s
Wrote block=3150000, file,blk=39,37077 VolBytes=412,876,668,928 rate=63.49 MB/s
Wrote block=3155000, file,blk=39,42077 VolBytes=413,532,028,928 rate=63.48 MB/s
Wrote block=3160000, file,blk=39,47077 VolBytes=414,187,388,928 rate=63.49 MB/s
Wrote block=3165000, file,blk=39,52077 VolBytes=414,842,748,928 rate=63.47 MB/s
Wrote block=3170000, file,blk=39,57077 VolBytes=415,498,108,928 rate=63.42 MB/s
Wrote block=3175000, file,blk=39,62077 VolBytes=416,153,468,928 rate=63.40 MB/s
Wrote block=3180000, file,blk=39,67077 VolBytes=416,808,828,928 rate=63.42 MB/s
Wrote block=3185000, file,blk=39,72077 VolBytes=417,464,188,928 rate=63.38 MB/s
Wrote block=3190000, file,blk=39,77077 VolBytes=418,119,548,928 rate=63.38 MB/s
Wrote block=3195000, file,blk=40,158 VolBytes=418,774,908,928 rate=63.38 MB/s
Wrote block=3200000, file,blk=40,5158 VolBytes=419,430,268,928 rate=63.34 MB/s
Wrote block=3205000, file,blk=40,10158 VolBytes=420,085,628,928 rate=63.33 MB/s
Wrote block=3210000, file,blk=40,15158 VolBytes=420,740,988,928 rate=63.34 MB/s
Wrote block=3215000, file,blk=40,20158 VolBytes=421,396,348,928 rate=63.33 MB/s
Wrote block=3220000, file,blk=40,25158 VolBytes=422,051,708,928 rate=63.34 MB/s
Wrote block=3225000, file,blk=40,30158 VolBytes=422,707,068,928 rate=63.35 MB/s
Wrote block=3230000, file,blk=40,35158 VolBytes=423,362,428,928 rate=63.36 MB/s
Wrote block=3235000, file,blk=40,40158 VolBytes=424,017,788,928 rate=63.38 MB/s
17-Jul 03:56 btape JobId 0: End of Volume "TestVolume1" at 40:42112 on device "UltiumLTO300" (/dev/sa0). Write of 131072 bytes got 0.
btape: btape.c:2714 Last block at: 40:42111 this_dev_block_num=42112
btape: btape.c:2749 End of tape 42:0. Volume Bytes=424,273,903,616. Write rate = 63.35 MB/s
17-Jul 03:57 btape JobId 0: End of medium on Volume "TestVolume1" Bytes=424,273,903,616 Blocks=3,236,953 at 17-Jul-2017 03:57.
17-Jul 03:57 btape JobId 0: 3307 Issuing autochanger "unload slot 1, drive 0" command.
17-Jul 03:57 btape JobId 0: 3304 Issuing autochanger "load slot 2, drive 0" command.
17-Jul 03:58 btape JobId 0: 3305 Autochanger "load slot 2, drive 0", status is OK.
Wrote Volume label for volume "TestVolume2".
17-Jul 03:58 btape JobId 0: Wrote label to prelabeled Volume "TestVolume2" on device "UltiumLTO300" (/dev/sa0)
17-Jul 03:58 btape JobId 0: New volume "TestVolume2" mounted on device "UltiumLTO300" (/dev/sa0) at 17-Jul-2017 03:58.
btape: btape.c:2320 Wrote 1000 blocks on second tape. Done.
Done writing 0 records ...
Wrote End of Session label.
btape: btape.c:2389 Wrote state file last_block_num1=42111 last_block_num2=1001
btape: btape.c:2407 

03:58:47 Done filling tapes at 0:1003. Now beginning re-read of first tape ...
btape: btape.c:2485 Enter do_unfill
17-Jul 03:58 btape JobId 0: 3307 Issuing autochanger "unload slot 2, drive 0" command.
17-Jul 03:59 btape JobId 0: 3304 Issuing autochanger "load slot 1, drive 0" command.
17-Jul 03:59 btape JobId 0: 3305 Autochanger "load slot 1, drive 0", status is OK.
17-Jul 03:59 btape JobId 0: Ready to read from volume "TestVolume1" on device "UltiumLTO300" (/dev/sa0).
Rewinding.
Reading the first 10000 records from 0:0.
10000 records read now at 1:2502
Reposition from 1:2502 to 40:42111
Reading block 42111.

The last block of the first tape matches.

17-Jul 04:01 btape JobId 0: 3307 Issuing autochanger "unload slot 1, drive 0" command.
17-Jul 04:02 btape JobId 0: 3304 Issuing autochanger "load slot 2, drive 0" command.
17-Jul 04:02 btape JobId 0: 3305 Autochanger "load slot 2, drive 0", status is OK.
17-Jul 04:02 btape JobId 0: Ready to read from volume "TestVolume2" on device "UltiumLTO300" (/dev/sa0).
Reposition from 0:0 to 0:1
Reading block 1.

The first block on the second tape matches.

Reposition from 0:2 to 0:1001
Reading block 1001.

The last block on the second tape matches. Test succeeded.

*
```

It worked, w00t!

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
