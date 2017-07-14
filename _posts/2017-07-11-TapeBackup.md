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

Hit the website http://<FreenasIP>

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
     3                  nextcloud_2                   /mnt/HQ/jails/nextcloud_1
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

If your autochanger is missing and alls you see is the tape drives rescan the scsi bus or just reboot the FreeNAS box.

**Note:** *Tape unit should be powered up before FreeNAS box.*

```
camcontrol rescan all
```

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

```
mtx -f /dev/pass2 status                                                                                       
  Storage Changer /dev/pass2:2 Drives, 38 Slots ( 36 Import/Export )                                                                
Data Transfer Element 0:Empty                                                                                                       
Data Transfer Element 1:Empty                                                                                                       
      Storage Element 1:Empty                                                                                                       
      Storage Element 2:Empty                                                                                                       
      Storage Element 3 IMPORT/EXPORT:Full :VolumeTag=UN0101L3                                                                      
      Storage Element 4 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 5 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 6 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 7 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 8 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 9 IMPORT/EXPORT:Empty                                                                                         
      Storage Element 10 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 11 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 12 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 13 IMPORT/EXPORT:Full :VolumeTag=UN0102L3                                                                     
      Storage Element 14 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 15 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 16 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 17 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 18 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 19 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 20 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 21 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 22 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 23 IMPORT/EXPORT:Full                                                                                         
      Storage Element 24 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 25 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 26 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 27 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 28 IMPORT/EXPORT:Empty                                                                                        
      Storage Element 29 IMPORT/EXPORT:Full :VolumeTag=UN0103L3                                                                     
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
mtx -f /dev/pass2 load 13 0                                                                                    
Loading media from Storage Element 13 into drive 0...done
mtx -f /dev/pass2 load 29 1                                                                                    
Loading media from Storage Element 13 into drive 1...done 
```

### Write Test To Tape ###

First load a tape into both drives.

```
mtx -f /dev/pass2 load 13 0
mtx -f /dev/pass2 load 29 1
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
chio move drive 0 slot 0
```

**mtx**

```
mtx -f /dev/pass2 unload 13 0
Unloading drive 0 into Storage Element 13...done
```

### Move Tapes Between Slots ###

**chio**

```
chio move slot 0 slot 14
```

**mtx**

mtx -f <sg device> transfer <source slot> <destination slot>

```
mtx -f /dev/pass2 transfer 13 2
mtx -f /dev/pass2 status
```

Add the tape autochanger to the bacula configuration.

```
nano /mnt/HQ/jails/bacula-sd_2/usr/pbi/bacula-sd-amd64/etc/bacula-sd.9103.conf

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
  Changer Command = "/usr/local/bacula/sbin/mtx-changer %c %o %S %a %d"
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
