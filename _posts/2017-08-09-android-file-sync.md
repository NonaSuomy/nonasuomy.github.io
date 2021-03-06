---
layout: post
title: Arch Linux Infrastructure - Backups - Android to NAS
---

[https://github.com/NonaSuomy/termuxrsyncauto](https://github.com/NonaSuomy/termuxrsyncauto)

```
https://termux.com/
https://play.google.com/store/apps/details?id=com.termux
apt update
apt upgrade
pkg install rsync
pkg install termux-api
pkg install jq
pkg install curl
pkg install wget
pkg install openssh
pkg install nano
```

https://github.com/termux/termux-api-package/tree/master/script

https://github.com/termux/termux-app/issues/61

https://github.com/st42/termux-sudo

Give storage permissions to termux for file copying to prevent permission denied errors.

```
termux-setup-storage
```

Test termux-api

WiFi Connected.

```
termux-wifi-connectioninfo
{
"bssid": "42:de:ad:fe:ed:10",
"frequency_mhz": 2447,
  "ip": "10.0.5.52",
  "link_speed_mbps": 58,
  "mac_address": "02:00:00:00:00:00",
  "network_id": 19,
  "rssi": -60,
  "ssid": "YOURSSID",
  "ssid_hidden": false,
  "supplicant_state": "COMPLETED"
}
```

WiFi Disconnected.

```
$ termux-wifi-connectioninfo
{
  "bssid": "00:00:00:00:00:00",
  "frequency_mhz": -1,
  "ip": "0.0.0.0",
  "link_speed_mbps": -1,
  "mac_address": "02:00:00:00:00:00",
  "network_id": -1,
  "rssi": -127,
  "ssid": "<unknown ssid>",
  "ssid_hidden": true,
  "supplicant_state": "DISCONNECTED"
}
```

Plugged In
 
```
termux-battery-status
{
  "health": "GOOD",
  "percentage": 100,
  "plugged": "PLUGGED_AC",
  "status": "FULL",
  "temperature": 34.79999923706055
}
```

Unplugged.
 
```
termux-battery-status
{
  "health": "GOOD",
  "percentage": 100,
  "plugged": "UNPLUGGED",
  "status": "DISCHARGING",
  "temperature": 34.70000076293945
}
```

Test termux-api commands and json query.

```
termux-battery-status | jq .plugged
termux-wifi-connectioninfo | jq .ssid
```

Generate ssh keys for script to logon to NAS.

```
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/data/data/com.termux/files/home/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /data/data/com.termux/files/home/.ssh/id_rsa.
Your public key has been saved in /data/data/com.termux/files/home/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:hash root@nasip
The key's randomart image is:
+---[RSA 2048]----+
|                 |
+----[SHA256]-----+

ssh-copy-id root@nasip
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/data/data/com.termux/files/home/.ssh/id_rsa.pub"
The authenticity of host 'nasip (nasip)' can't be established.
ECDSA key fingerprint is SHA256:key.
Are you sure you want to continue connecting (yes/no)? yes
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
expr: warning: '^ERROR: ': using '^' as the first character
of a basic regular expression is not portable; it is ignored
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@freenas's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@nasip'"
and check to make sure that only the key(s)you wanted were added.
```

Test connection...

```
$ ssh root@nasip
Last login: Sat Jul 22 22:49:15 2017 from 10.13.37.167
FreeBSD 11.0-STABLE (FreeNAS.amd64) #0 r313908+b3722b04944(freenas/11.0-stable): Sat Jul  1 02:44:49 UTC 2017

        FreeNAS (c) 2009-2017, The FreeNAS Development Team
        All rights reserved.
        FreeNAS is released under the modified BSD license.

        For more information, documentation, help or support, go here:
        http://freenas.org
Welcome to FreeNAS
root@nasip:~ # exit
logout
Connection to nasip closed.
```
 
Rsync nfo.

```
 -r, --recursive            ` recurse into directories
 -l, --links                 copy symlinks as symlinks
 -t, --times                 preserve modification times
 -D                          same as --devices --specials
 -v, --verbose               increase verbosity
--size-only                  skip files that match in size
--delete                     delete extraneous files from dest dirs
--dry-run                    Test do nothing else!
```

Scripting...

```
wget https://raw.githubusercontent.com/NonaSuomy/termuxrsyncauto/master/termuxrsyncauto.sh
nano -w termuxrsyncauto.sh
```

```
#!/data/data/com.termux/files/usr/bin/sh

# Configuration

myssid="YOURSSID"
servuser="useraccount"
servcon="nasIP"
servpath="/mnt/datastore001/Storage/user/mobile/"
filelst="rsyncfile.lst"
basedir="/"
perms="u=rwX,g=rX,o=rX"
rsyncopt="-rltDv --size-only"

# Configuration end

batstat=$(/data/data/com.termux/files/usr/libexec/termux-api BatteryStatus | jq .plugged)
wifistat=$(/data/data/com.termux/files/usr/libexec/termux-api WifiConnectionInfo | jq .supplicant_state)
wifissid=$(/data/data/com.termux/files/usr/libexec/termux-api WifiConnectionInfo | jq .ssid)

case "$batstat" in
  *AC*)
    echo "Plugged in!"
    case "$wifistat" in
      *"COMPLETED"*)
        echo "WiFi Connected"
        case "$wifissid" in
          *"$myssid"*)
            echo "Connected to $wifissid WiFi"
            ping -q -c1 $servcon > /dev/null 2>&1; pong=$?
            if [ $pong -eq 0 ]
            then
              echo "NAS On-Line"
              export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib 
              /data/data/com.termux/files/usr/bin/rsync \
              $rsyncopt \
              --chmod=$perms \
              --files-from=$filelst \
              -e "/data/data/com.termux/files/usr/bin/ssh -i /data/data/com.termux/files/home/.ssh/id_rsa -l $servuser" \
              $basedir $servuser@$servcon:$servpath
            else
              echo "NAS Off-Line"
            fi
             ;;
          *)
            echo "Not connected to your WiFi."
          ;;
        esac
        ;;
      *)
        echo "WiFi Not Connected."
      ;;
    esac
    ;;
  *)
    echo "Unplugged!"
  ;;
esac
```

Backup Folder/File List

```
nano -w rsyncfile.lst
```

```
/storage/emulated/0/DCIM
/storage/emulated/0/Documents
/storage/emulated/0/Download
/storage/emulated/0/Movies
/storage/emulated/0/Pictures
/storage/emulated/0/SoundRecorder
/storage/4242-FFFF/sdbackup
```

Device folder structure for testing

```
/storage/emulated/0/

Alarms                          SoundRecorder
AndroIRC                        TWRP
Android                         ViPER4Android
ArduinoDroid                    Ringtones
DCIM                            backups
Download                        Podcasts
MEGA                            data
Movies                          Pictures
Music                           report
Notifications                   storage       

/storage/4242-FFFF/,

Android
Downloads
Hangouts
ROM Tools
Recordings
default.profile_backup
picsbackupdups
pics
```

Test it out!

```
sudo chmod 755 termuxrsyncauto.sh
sudo ./termuxrsyncauto.sh
```

If your not rooted and didn't install sudo, just use sh.

You will get a permission denied warning from the basedir / but then when it starts reading the files you have access to it should start working.

```
sh termuxrsyncauto.sh
```

Testing...

```
Plugged in!
WiFi Connected
Connected to "YOURSSID" WiFi
NAS On-Line
sending incremental file list

sent 39,610 bytes  received 364 bytes  15,989.60 bytes/sec                                        total size is 12,356,571,115  speedup is 309,115.20
```

Looks good, files showed up on the NAS.

To be continued (busybox - crond,crontab).
