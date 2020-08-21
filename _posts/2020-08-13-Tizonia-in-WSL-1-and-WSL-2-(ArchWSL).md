---
layout: post
title: Tizonia in WSL 1 and WSL 2 (ArchWSL)
---

### Windows 10 WSL 1 and 2

```
Tested on WSL V1:
ver
Microsoft Windows [Version 10.0.18363.815] (WSL V1)
Working...
```

```
Tested on WSL V2:

ver
Microsoft Windows [Version 10.0.18941.1001]
Working...

WSL V2 requires the Virtual Machine Platform

Start ->Turn Windows features on or off -> Check Virtual Machine Platform

Convert your ArchWSL build by typing this command in the regular Windows Command Prompt window (Not ArchWSL console window):

wsl -l -v
  NAME    STATE           VERSION
* Arch    Running         1

wsl --set-version arch 2
Conversion in progress, this may take a few minutes...
For information on key differences with WSL 2 please visit https://aka.ms/wsl2
Conversion complete.

Note: You can go back by changing 2 to a 1 again with the same command.

wsl -l -v
  NAME    STATE           VERSION
* Arch    Running         2

or make it the default so all builds use WSL2:

wsl --set-default-version 2
```

### How to check your WSL Version ( Blurb from here with edits below: https://askubuntu.com/questions/1177729/wsl-am-i-running-version-1-or-version-2 ) 

```
At a Windows Command Prompt, run ver. Is the next-to-last numeric group version 18917 or higher? If so, go on to step 2. If not, you have version 1. This illustrates the result when the OS is Build 16299:

Version 16299

Open Windows PowerShell or CMD and enter the command wsl -l -v

wsl help info will show.

If version 2 is installed properly, you will see the version number.

wsl -l -v
  NAME    STATE           VERSION
* Arch    Running         2

If you don't see a version number, or if you see an error message (Thank you, Cornea Valentin) you have version 1. Uninstall it then reinstall it as per https://scotch.io/bar-talk/trying-the-new-wsl-2-its-fast-windows-subsystem-for-linux

Why is this relevant?

WSL 1 was based on Microsoft's Linux-compatible kernel interface, a compatibility translation layer with no Linux kernel code.

WSL 2 was redesigned with a Linux kernel running in a lightweight VM environment, and innovators have found many more things they can do with WSL 2.
```

### Installing WSL

A requirement for Version 1 and 2:

Start ->Turn Windows features on or off -> Check Windows Subsystem for Linux

A requirement for Version 2:

Start ->Turn Windows features on or off -> Check Virtual Machine Platform

If you see any network UAC warnings in Windows make sure to accept them during this process... otherwise... you know... no network... (Cortana Joke)

Make a folder on C:\

```
mkdir C:\WSL
```

This is where we are going to put our ArchWSL build.

### Install ArchWSL

https://github.com/yuk7/ArchWSL/releases

https://github.com/yuk7/ArchWSL/releases/download/20.4.3.0/Arch.zip

Extract Arch.zip -> C:\WSL\Arch\

Run 

```
C:\WSL\Arch\Arch.exe
```

### Install Windows Pulse Audio

https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/

http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip

Extract pulseaudio-1.1.zip to C:\WSL\pulseaudio

Edit 

```
C:\WSL\pulseaudio\etc\pulse\default.pa
```

Change line 61 to:

WSL V1

```
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
```

WSL V2

```
load-module module-native-protocol-tcp auth-ip-acl=172.16.0.0/12 auth-anonymous=1
```

Edit

```
C:\WSL\pulseaudio\etc\pulse\daemon.conf
```

Change line 39 to:

```
exit-idle-time = -1
```

Optional: daemonize = yes (See if it works first before you do this.)

Right-click and run as administrator: 

```
C:\WSL\pulseaudio\bin\pulseaudio.exe
```

You will get a Windows Defender Firewall has blocked some features of this app etc.

Check Private networks, such as my home or work network.
Check Public networks, such as those in airports and coffee shops (not recommended because these networks often have little or no security).

Click Allow access.

You will see these errors in the console window for pulseaudio which you seem to be able to ignore.

```
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
W: [(null)] pulsecore/core.c: failed to allocate shared memory pool. Falling back to a normal memory pool.
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
W: [(null)] pulsecore/core-util.c: Secure directory creation not supported on Win32.
E: [(null)] daemon/main.c: Failed to load directory.
```

### Start ArchWSL

Run Arch.exe again.

In the Arch console window complete the following...

Change root password

```
passwd
```

Add the wheel group for sudo.

```
EDITOR=nano visudo
```

Uncomment this line.

```
%wheel ALL=(ALL) ALL
```

Add a new user to the wheel group for sudo.

```
useradd -m -G wheel -s /bin/bash someusername
```

Change the password of the user.

```
passwd someusername
```

Close the Arch.exe console and reopen it in command prompt with your new user account. You only have to run this command one time. After that, you can just click on your Arch.exe and it will default to this account.

```
Arch.exe config --default-user someusername
```

Load pacman keys.

```
sudo pacman-key --init
sudo pacman-key --populate
```

Update system with pacman.

Warning!: If you get prompted to replace fakeroot-tcp with fakeroot because of conflict DO NOT DO SO!!! type n. Otherwise, you will have fun manually recompiling fakeroot-tcp to work again as you won't be able to install anything. Which I believe happens with installing base-devel below.

It might be best to add fakeroot to the pacman ignore list.

Edit 

/etc/pacman.conf

```
# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
 #IgnorePkg =
 IgnorePkg = fakeroot
 #IgnoreGroup =
```

For fun uncomment and add ILoveCandy

```
Color
ILoveCandy
TotalDownload
```

Windows Terminal:
https://www.microsoft.com/store/productId/9N0DX20HK701

If you added fakeroot to the IgnorePkg list above you don't need the --ignore=fakeroot on your pacman commands below.

The default mirror in the package seemed to be super slow sometimes dropping out so do this if you want to fix that. Change the Country Name with your own.

```
sudo pacman -Sy curl pacman-contrib

Backup your mirror file.

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

Local Way.

Uncomment your country.

sudo awk '/^## Country Name$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 1);}' /etc/pacman.d/mirrorlist.backup

Generate a new list.

sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

Online Way.

cd /etc/pacman.d
sudo curl -s "https://www.archlinux.org/mirrorlist/?country=US&country=CA&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
```

Update all current system packages.

```
sudo pacman -Syu --ignore=fakeroot
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
:: Starting full system upgrade...
resolving dependencies...
looking for conflicting packages...

Packages (42) acl-2.2.53-3  archlinux-keyring-20200422-1  argon2-20190702-3  attr-2.4.48-3
              ca-certificates-mozilla-3.52-1  cryptsetup-2.3.2-2  curl-7.70.0-1  device-mapper-2.02.187-2
              e2fsprogs-1.45.6-2  filesystem-2020.05.07-1  gawk-5.1.0-1  gettext-0.20.2-1  glib2-2.64.2-1
              gnutls-3.6.13-2  gpgme-1.13.1-5  iana-etc-20200428-1  icu-67.1-1  iproute2-5.6.0-1  json-c-0.14-4
              keyutils-1.6.1-4  libffi-3.3-3  libnftnl-1.1.6-1  libp11-kit-0.23.20-5  libsasl-2.1.27-3
              libsecret-0.20.3-1  libtirpc-1.2.6-1  libutil-linux-2.35.1-2  libxml2-2.9.10-2  licenses-20200427-1
              nano-4.9.2-1  nettle-3.6-1  openssl-1.1.1.g-1  p11-kit-0.23.20-5  pacman-5.2.1-5
              pacman-mirrorlist-20200411-1  systemd-245.5-2  systemd-libs-245.5-2  systemd-sysvcompat-245.5-2
              tzdata-2020a-1  util-linux-2.35.1-2  vim-8.2.0717-2  vim-runtime-8.2.0717-2

Total Download Size:    50.35 MiB
Total Installed Size:  194.05 MiB
Net Upgrade Size:        0.61 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 iana-etc-20200428-1-any                     387.8 KiB  45.1 KiB/s 00:09 [########################################] 100%
 filesystem-2020.05.07-1-x86_64               29.2 KiB  47.2 KiB/s 00:01 [########################################] 100%
 tzdata-2020a-1-x86_64                       366.5 KiB   113 KiB/s 00:03 [########################################] 100%
 attr-2.4.48-3-x86_64                         69.0 KiB   300 KiB/s 00:00 [########################################] 100%
 acl-2.2.53-3-x86_64                         136.6 KiB   198 KiB/s 00:01 [########################################] 100%
 archlinux-keyring-20200422-1-any            890.6 KiB  68.7 KiB/s 00:13 [########################################] 100%
 argon2-20190702-3-x86_64                     33.1 KiB  60.1 KiB/s 00:01 [########################################] 100%
 systemd-libs-245.5-2-x86_64                 505.1 KiB   101 KiB/s 00:05 [########################################] 100%
 libffi-3.3-3-x86_64                          37.9 KiB   758 KiB/s 00:00 [########################################] 100%
 libp11-kit-0.23.20-5-x86_64                 472.3 KiB  95.4 KiB/s 00:05 [########################################] 100%
 openssl-1.1.1.g-1-x86_64                      3.6 MiB   169 KiB/s 00:22 [########################################] 100%
 p11-kit-0.23.20-5-x86_64                    137.3 KiB   205 KiB/s 00:01 [########################################] 100%
 ca-certificates-mozilla-3.52-1-x86_64       336.7 KiB   111 KiB/s 00:03 [########################################] 100%
 device-mapper-2.02.187-2-x86_64             291.6 KiB   188 KiB/s 00:02 [########################################] 100%
 libutil-linux-2.35.1-2-x86_64               408.8 KiB  93.3 KiB/s 00:04 [########################################] 100%
 json-c-0.14-4-x86_64                         52.8 KiB  85.1 KiB/s 00:01 [########################################] 100%
 cryptsetup-2.3.2-2-x86_64                   541.8 KiB   155 KiB/s 00:03 [########################################] 100%
 e2fsprogs-1.45.6-2-x86_64                  1195.7 KiB  82.9 KiB/s 00:14 [########################################] 100%
 keyutils-1.6.1-4-x86_64                      90.8 KiB  52.5 KiB/s 00:02 [########################################] 100%
 libsasl-2.1.27-3-x86_64                     146.1 KiB  80.3 KiB/s 00:02 [########################################] 100%
 curl-7.70.0-1-x86_64                       1024.5 KiB  81.6 KiB/s 00:13 [########################################] 100%
 gawk-5.1.0-1-x86_64                        1139.2 KiB   123 KiB/s 00:09 [########################################] 100%
 glib2-2.64.2-1-x86_64                         2.8 MiB   109 KiB/s 00:26 [########################################] 100%
 icu-67.1-1-x86_64                            10.4 MiB  79.5 KiB/s 02:14 [########################################] 100%
 gettext-0.20.2-1-x86_64                       2.0 MiB   162 KiB/s 00:13 [########################################] 100%
 nettle-3.6-1-x86_64                         405.2 KiB   101 KiB/s 00:04 [########################################] 100%
 gnutls-3.6.13-2-x86_64                        2.7 MiB  81.7 KiB/s 00:34 [########################################] 100%
 libsecret-0.20.3-1-x86_64                   236.8 KiB   173 KiB/s 00:01 [########################################] 100%
 gpgme-1.13.1-5-x86_64                       437.1 KiB   132 KiB/s 00:03 [########################################] 100%
 libnftnl-1.1.6-1-x86_64                      70.1 KiB   195 KiB/s 00:00 [########################################] 100%
 iproute2-5.6.0-1-x86_64                     923.7 KiB   106 KiB/s 00:09 [########################################] 100%
 libtirpc-1.2.6-1-x86_64                     177.2 KiB   148 KiB/s 00:01 [########################################] 100%
 licenses-20200427-1-any                      69.6 KiB   166 KiB/s 00:00 [########################################] 100%
 nano-4.9.2-1-x86_64                         548.3 KiB   148 KiB/s 00:04 [########################################] 100%
 pacman-mirrorlist-20200411-1-any              6.2 KiB  0.00   B/s 00:00 [########################################] 100%
 pacman-5.2.1-5-x86_64                       836.7 KiB  55.4 KiB/s 00:15 [########################################] 100%
 util-linux-2.35.1-2-x86_64                    2.4 MiB  95.3 KiB/s 00:26 [########################################] 100%
 systemd-245.5-2-x86_64                        5.6 MiB   101 KiB/s 00:56 [########################################] 100%
 systemd-sysvcompat-245.5-2-x86_64             8.2 KiB  0.00   B/s 00:00 [########################################] 100%
 libxml2-2.9.10-2-x86_64                    1335.6 KiB  84.0 KiB/s 00:16 [########################################] 100%
 vim-runtime-8.2.0717-2-x86_64                 6.3 MiB  88.8 KiB/s 01:12 [########################################] 100%
 vim-8.2.0717-2-x86_64                      1651.8 KiB  86.9 KiB/s 00:19 [########################################] 100%
(42/42) checking keys in keyring                                         [########################################] 100%
(42/42) checking package integrity                                       [########################################] 100%
(42/42) loading package files                                            [########################################] 100%
(42/42) checking for file conflicts                                      [########################################] 100%
(42/42) checking available disk space                                    [########################################] 100%
:: Processing package changes...
( 1/42) upgrading iana-etc                                               [########################################] 100%
( 2/42) upgrading filesystem                                             [########################################] 100%
warning: /etc/shadow installed as /etc/shadow.pacnew
( 3/42) upgrading tzdata                                                 [########################################] 100%
( 4/42) upgrading attr                                                   [########################################] 100%
( 5/42) upgrading acl                                                    [########################################] 100%
( 6/42) upgrading archlinux-keyring                                      [########################################] 100%
==> Appending keys from archlinux.gpg...
==> Locally signing trusted keys in keyring...
  -> Locally signing key D8AFDDA07A5B6EDFA7D8CCDAD6D055F927843F1C...
  -> Locally signing key DDB867B92AA789C165EEFA799B729B06A680C281...
  -> Locally signing key 91FFE0700E80619CEB73235CA88E23E377514E00...
  -> Locally signing key 0E8B644079F599DFC1DDC3973348882F6AC6A4C2...
  -> Locally signing key AB19265E5D7D20687D303246BA1DFB64FFF979E7...
==> Importing owner trust values...
==> Disabling revoked keys in keyring...
  -> Disabling key 8F76BEEA0289F9E1D3E229C05F946DED983D4366...
  -> Disabling key 63F395DE2D6398BBE458F281F2DBB4931985A992...
  -> Disabling key 50F33E2E5B0C3D900424ABE89BDCF497A4BBCC7F...
  -> Disabling key 27FFC4769E19F096D41D9265A04F9397CDFD6BB0...
  -> Disabling key 39F880E50E49A4D11341E8F939E4F17F295AFBF4...
  -> Disabling key 8840BD07FC24CB7CE394A07CCF7037A4F27FB7DA...
  -> Disabling key 5559BC1A32B8F76B3FCCD9555FA5E5544F010D48...
  -> Disabling key 0B20CA1931F5DA3A70D0F8D2EA6836E1AB441196...
  -> Disabling key 07DFD3A0BC213FA12EDC217559B3122E2FA915EC...
  -> Disabling key 4FCF887689C41B09506BE8D5F3E1D5C5D30DB0AD...
  -> Disabling key 5A2257D19FF7E1E0E415968CE62F853100F0D0F0...
  -> Disabling key D921CABED130A5690EF1896E81AF739EC0711BF1...
  -> Disabling key 7FA647CD89891DEDC060287BB9113D1ED21E1A55...
  -> Disabling key BC1FBE4D2826A0B51E47ED62E2539214C6C11350...
  -> Disabling key 4A8B17E20B88ACA61860009B5CED81B7C2E5C0D2...
  -> Disabling key 5696C003B0854206450C8E5BE613C09CB4440678...
  -> Disabling key 684148BB25B49E986A4944C55184252D824B18E8...
  -> Disabling key 8CF934E339CAD8ABF342E822E711306E3C4F88BC...
  -> Disabling key F5A361A3A13554B85E57DDDAAF7EF7873CFD4BB6...
  -> Disabling key 5E7585ADFF106BFFBBA319DC654B877A0864983E...
  -> Disabling key 65EEFE022108E2B708CBFCF7F9E712E59AF5F22A...
  -> Disabling key 40440DC037C05620984379A6761FAD69BA06C6A9...
  -> Disabling key 34C5D94FE7E7913E86DC427E7FB1A3800C84C0A5...
  -> Disabling key 81D7F8241DB38BC759C80FCE3A726C6170E80477...
  -> Disabling key E7210A59715F6940CF9A4E36A001876699AD6E84...
  -> Disabling key 5357F3B111688D88C1D88119FCF2CB179205AC90...
  -> Disabling key 4D913AECD81726D9A6C74F0ADA6426DD215B37AD...
  -> Disabling key FB871F0131FEA4FB5A9192B4C8880A6406361833...
  -> Disabling key 66BD74A036D522F51DD70A3C7F2A16726521E06D...
  -> Disabling key B1F2C889CB2CCB2ADA36D963097D629E437520BD...
  -> Disabling key 9515D8A8EAB88E49BB65EDBCE6B456CAF15447D5...
  -> Disabling key 76B4192E902C0A52642C63C273B8ED52F1D357C1...
  -> Disabling key 40776A5221EF5AD468A4906D42A1DB15EC133BAD...
  -> Disabling key D4DE5ABDE2A7287644EAC7E36D1A9E70E19DAA50...
  -> Disabling key 44D4A033AC140143927397D47EFD567D4C7EA887...
==> Updating trust database...
gpg: next trustdb check due at 2020-05-31
( 7/42) upgrading argon2                                                 [########################################] 100%
( 8/42) upgrading systemd-libs                                           [########################################] 100%
( 9/42) upgrading libffi                                                 [########################################] 100%
(10/42) upgrading libp11-kit                                             [########################################] 100%
(11/42) upgrading openssl                                                [########################################] 100%
(12/42) upgrading p11-kit                                                [########################################] 100%
(13/42) upgrading ca-certificates-mozilla                                [########################################] 100%
(14/42) upgrading device-mapper                                          [########################################] 100%
(15/42) upgrading libutil-linux                                          [########################################] 100%
(16/42) upgrading json-c                                                 [########################################] 100%
(17/42) upgrading cryptsetup                                             [########################################] 100%
(18/42) upgrading e2fsprogs                                              [########################################] 100%
(19/42) upgrading keyutils                                               [########################################] 100%
(20/42) upgrading libsasl                                                [########################################] 100%
(21/42) upgrading curl                                                   [########################################] 100%
(22/42) upgrading gawk                                                   [########################################] 100%
(23/42) upgrading glib2                                                  [########################################] 100%
(24/42) upgrading icu                                                    [########################################] 100%
(25/42) upgrading libxml2                                                [########################################] 100%
(26/42) upgrading gettext                                                [########################################] 100%
(27/42) upgrading nettle                                                 [########################################] 100%
(28/42) upgrading gnutls                                                 [########################################] 100%
(29/42) upgrading libsecret                                              [########################################] 100%
(30/42) upgrading gpgme                                                  [########################################] 100%
(31/42) upgrading libnftnl                                               [########################################] 100%
(32/42) upgrading iproute2                                               [########################################] 100%
(33/42) upgrading libtirpc                                               [########################################] 100%
(34/42) upgrading licenses                                               [########################################] 100%
(35/42) upgrading nano                                                   [########################################] 100%
(36/42) upgrading pacman-mirrorlist                                      [########################################] 100%
warning: /etc/pacman.d/mirrorlist installed as /etc/pacman.d/mirrorlist.pacnew
(37/42) upgrading pacman                                                 [########################################] 100%
(38/42) upgrading util-linux                                             [########################################] 100%
(39/42) upgrading systemd                                                [########################################] 100%
(40/42) upgrading systemd-sysvcompat                                     [########################################] 100%
(41/42) upgrading vim-runtime                                            [########################################] 100%
(42/42) upgrading vim                                                    [########################################] 100%
:: Running post-transaction hooks...
( 1/10) Creating system user accounts...
( 2/10) Updating journal message catalog...
( 3/10) Reloading system manager configuration...
  Skipped: Current root is not booted.
( 4/10) Updating udev hardware database...
( 5/10) Applying kernel sysctl settings...
  Skipped: Current root is not booted.
( 6/10) Creating temporary files...
( 7/10) Reloading device manager configuration...
  Skipped: Device manager is not running.
( 8/10) Arming ConditionNeedsUpdate...
( 9/10) Reloading system bus configuration...
  Skipped: Current root is not booted.
(10/10) Rebuilding certificate stores...
```

Add some more packages to our ArchWSL build.

Make note of the line after the command ":: fakeroot is in IgnorePkg/IgnoreGroup. Install anyway? [Y/n] n" <= PRESS NO!

```
sudo pacman -S base-devel wget tmux pkg-config intltool libtool libsndfile json-c git ffmpeg --ignore=fakeroot

:: fakeroot is in IgnorePkg/IgnoreGroup. Install anyway? [Y/n] n
:: There are 23 members in group base-devel:
:: Repository core
   1) autoconf  2) automake  3) binutils  4) bison  5) file  6) findutils  7) flex  8) gawk  9) gcc  10) gettext
   11) grep  12) groff  13) gzip  14) libtool  15) m4  16) make  17) pacman  18) patch  19) pkgconf  20) sed  21) sudo
   22) texinfo  23) which

Enter a selection (default=all):
warning: file-5.38-3 is up to date -- reinstalling
warning: findutils-4.7.0-2 is up to date -- reinstalling
warning: gawk-5.1.0-1 is up to date -- reinstalling
warning: gettext-0.20.2-1 is up to date -- reinstalling
warning: grep-3.4-1 is up to date -- reinstalling
warning: gzip-1.10-3 is up to date -- reinstalling
warning: pacman-5.2.1-5 is up to date -- reinstalling
warning: sed-4.8-1 is up to date -- reinstalling
warning: sudo-1.8.31.p1-1 is up to date -- reinstalling
warning: json-c-0.14-4 is up to date -- reinstalling
resolving dependencies...
looking for conflicting packages...
warning: dependency cycle detected:
warning: harfbuzz will be installed before its freetype2 dependency
warning: dependency cycle detected:
warning: mesa will be installed before its libglvnd dependency

Packages (145) alsa-lib-1.2.2-1  alsa-topology-conf-1.2.2-2  alsa-ucm-conf-1.2.2-1  aom-1.0.0.errata1+avif-1
               dav1d-0.6.0-1  diffutils-3.7-3  elfutils-0.178-2  flac-1.3.3-1  fontconfig-2:2.13.91+24+g75eadca-2
               freetype2-2.10.2-1  fribidi-1.0.9-1  gc-8.0.4-3  giflib-5.2.1-1  graphite-1:1.3.14-1  gsm-1.0.19-1
               guile-2.2.6-2  harfbuzz-2.6.6-1  hicolor-icon-theme-0.17-2  jack-0.125.0-9  l-smash-2.14.5-2
               lame-3.100-2  lcms2-2.9-2  libass-0.14.0-2  libasyncns-0.8+3+g68cd5af-2  libavc1394-0.5.4-4
               libbluray-1.2.0-3  libdrm-2.4.101-1  libedit-20191231_3.1-1  libevent-2.1.11-5  libglvnd-1.3.1-1
               libibus-1.5.22-1  libice-1.0.10-2  libiec61883-1.2.0-5  libjpeg-turbo-2.0.4-1  libmfx-20.1.1-1
               libmicrohttpd-0.9.70-3  libmodplug-0.8.9.0-2  libmpc-1.1.0-2  libogg-1.3.4-2  libomxil-bellagio-0.9.3-2
               libpciaccess-0.16-1  libpng-1.6.37-1  libpulse-13.0-3  libraw1394-2.1.2-2  libsamplerate-0.1.9-3
               libsm-1.2.3-2  libsoxr-0.1.3-2  libssh-0.9.4-1  libtheora-1.1.1-4  libtiff-4.1.0-1  libunwind-1.3.1-1
               libutempter-1.1.6-3  libva-2.7.1-1  libvdpau-1.4-1  libvorbis-1.3.6-1  libvpx-1.8.2-1  libwebp-1.1.0-1
               libx11-1.6.9-6  libxau-1.0.9-2  libxcb-1.14-1  libxcursor-1.2.0-1  libxdamage-1.1.5-2  libxdmcp-1.1.3-2
               libxext-1.3.4-2  libxfixes-5.0.3-3  libxi-1.7.10-2  libxrender-0.9.10-3  libxshmfence-1.3-2
               libxtst-1.2.3-3  libxv-1.0.11-3  libxxf86vm-1.1.4-3  llvm-libs-10.0.0-1  lm_sensors-3.6.0-1
               mesa-20.0.6-2  opencore-amr-0.1.5-3  openjpeg2-2.3.1-1  opus-1.3.1-1  perl-clone-0.45-1
               perl-encode-locale-1.05-5  perl-error-0.17029-1  perl-file-listing-6.04-6  perl-html-parser-3.72-8
               perl-html-tagset-3.20-8  perl-http-cookies-6.08-1  perl-http-daemon-6.06-1  perl-http-date-6.05-1
               perl-http-message-6.24-1  perl-http-negotiate-6.01-6  perl-io-html-1.001-5  perl-libwww-6.44-1
               perl-lwp-mediatypes-6.02-6  perl-mailtools-2.21-2  perl-net-http-6.19-2  perl-timedate-2.32-1
               perl-try-tiny-0.30-3  perl-uri-1.76-2  perl-www-robotrules-6.02-6  perl-xml-parser-2.46-1  sdl2-2.0.12-1
               speex-1.2.0-2  speexdsp-1.2.0-1  srt-1.4.1-1  sysfsutils-2.1.0-11  v4l-utils-1.18.1-1  vid.stab-1.1-2
               vmaf-1.5.1-1  vulkan-icd-loader-1.2.140-1  wayland-1.18.0-2  x264-3:0.159.r2999.296494a-1  x265-3.3-1
               xcb-proto-1.14-1  xorgproto-2020.1-1  xvidcore-1.3.7-1  zita-alsa-pcmi-0.3.2-2  zita-resampler-1.6.2-2
               autoconf-2.69-7  automake-1.16.2-1  binutils-2.34-2  bison-3.5.4-1  ffmpeg-1:4.2.2-8  file-5.38-3
               findutils-4.7.0-2  flex-2.6.4-3  gawk-5.1.0-1  gcc-9.3.0-1  gettext-0.20.2-1  git-2.26.2-1  grep-3.4-1
               groff-1.22.4-3  gzip-1.10-3  intltool-0.51.0-4  json-c-0.14-4  libsndfile-1.0.28-3
               libtool-2.4.6+42+gb88cebd5-12  m4-1.4.18-3  make-4.3-3  pacman-5.2.1-5  patch-2.7.6-8  pkgconf-1.6.3-4
               sed-4.8-1  sudo-1.8.31.p1-1  texinfo-6.7-3  tmux-3.1_b-1  wget-1.20.3-3  which-2.21-5

Total Download Size:   139.47 MiB
Total Installed Size:  714.23 MiB
Net Upgrade Size:      687.41 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 m4-1.4.18-3-x86_64                          169.4 KiB   207 KiB/s 00:01 [########################################] 100%
 diffutils-3.7-3-x86_64                      324.1 KiB  76.4 KiB/s 00:04 [########################################] 100%
 autoconf-2.69-7-any                         591.2 KiB   224 KiB/s 00:03 [########################################] 100%
 automake-1.16.2-1-any                       603.4 KiB   116 KiB/s 00:05 [########################################] 100%
 libmicrohttpd-0.9.70-3-x86_64               202.8 KiB  99.4 KiB/s 00:02 [########################################] 100%
 findutils-4.7.0-2-x86_64                    454.6 KiB  79.6 KiB/s 00:06 [########################################] 100%
 elfutils-0.178-2-x86_64                     599.7 KiB   216 KiB/s 00:03 [########################################] 100%
 binutils-2.34-2-x86_64                        5.2 MiB   131 KiB/s 00:41 [########################################] 100%
 bison-3.5.4-1-x86_64                        678.4 KiB   133 KiB/s 00:05 [########################################] 100%
 file-5.38-3-x86_64                          314.2 KiB   383 KiB/s 00:01 [########################################] 100%
 flex-2.6.4-3-x86_64                         297.2 KiB   278 KiB/s 00:01 [########################################] 100%
 libmpc-1.1.0-2-x86_64                        65.1 KiB   542 KiB/s 00:00 [########################################] 100%
 gcc-9.3.0-1-x86_64                           29.8 MiB   139 KiB/s 03:41 [########################################] 100%
 grep-3.4-1-x86_64                           204.2 KiB   125 KiB/s 00:02 [########################################] 100%
 groff-1.22.4-3-x86_64                      2044.3 KiB   132 KiB/s 00:16 [########################################] 100%
 gzip-1.10-3-x86_64                           77.8 KiB  70.1 KiB/s 00:01 [########################################] 100%
 libtool-2.4.6+42+gb88cebd5-12-x86_64        407.4 KiB   134 KiB/s 00:03 [########################################] 100%
 texinfo-6.7-3-x86_64                       1397.6 KiB   129 KiB/s 00:11 [########################################] 100%
 make-4.3-3-x86_64                           481.6 KiB   194 KiB/s 00:02 [########################################] 100%
 patch-2.7.6-8-x86_64                         92.5 KiB   289 KiB/s 00:00 [########################################] 100%
 pkgconf-1.6.3-4-x86_64                       58.7 KiB   150 KiB/s 00:00 [########################################] 100%
 sed-4.8-1-x86_64                            237.9 KiB  57.3 KiB/s 00:04 [########################################] 100%
 sudo-1.8.31.p1-1-x86_64                     870.0 KiB  83.3 KiB/s 00:10 [########################################] 100%
 which-2.21-5-x86_64                          15.8 KiB  0.00   B/s 00:00 [########################################] 100%
 libevent-2.1.11-5-x86_64                    244.8 KiB  95.3 KiB/s 00:03 [########################################] 100%
 libedit-20191231_3.1-1-x86_64               106.9 KiB  81.0 KiB/s 00:01 [########################################] 100%
 sysfsutils-2.1.0-11-x86_64                   31.1 KiB   311 KiB/s 00:00 [########################################] 100%
 gc-8.0.4-3-x86_64                           221.1 KiB  91.7 KiB/s 00:02 [########################################] 100%
 guile-2.2.6-2-x86_64                          6.4 MiB   119 KiB/s 00:55 [########################################] 100%
 wget-1.20.3-3-x86_64                        722.2 KiB   110 KiB/s 00:07 [########################################] 100%
 libutempter-1.1.6-3-x86_64                    8.1 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-encode-locale-1.05-5-any                10.8 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-timedate-2.32-1-any                     36.4 KiB  20.9 KiB/s 00:02 [########################################] 100%
 perl-http-date-6.05-1-any                     9.5 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-file-listing-6.04-6-any                  8.3 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-html-tagset-3.20-8-any                  10.9 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-html-parser-3.72-8-x86_64               79.4 KiB   153 KiB/s 00:01 [########################################] 100%
 perl-clone-0.45-1-x86_64                     10.4 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-io-html-1.001-5-any                     13.4 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-lwp-mediatypes-6.02-6-any               18.6 KiB   103 KiB/s 00:00 [########################################] 100%
 perl-uri-1.76-2-any                          77.3 KiB  73.6 KiB/s 00:01 [########################################] 100%
 perl-http-message-6.24-1-any                 75.9 KiB  52.0 KiB/s 00:01 [########################################] 100%
 perl-http-cookies-6.08-1-any                 21.7 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-http-daemon-6.06-1-any                  18.6 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-http-negotiate-6.01-6-any               12.1 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-net-http-6.19-2-any                     22.7 KiB   568 KiB/s 00:00 [########################################] 100%
 perl-try-tiny-0.30-3-any                     18.4 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-www-robotrules-6.02-6-any               12.2 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-libwww-6.44-1-any                      138.2 KiB  98.7 KiB/s 00:01 [########################################] 100%
 perl-xml-parser-2.46-1-x86_64               164.7 KiB  63.1 KiB/s 00:03 [########################################] 100%
 intltool-0.51.0-4-any                        40.8 KiB   120 KiB/s 00:00 [########################################] 100%
 libogg-1.3.4-2-x86_64                       201.6 KiB  66.3 KiB/s 00:03 [########################################] 100%
 flac-1.3.3-1-x86_64                         270.8 KiB  63.7 KiB/s 00:04 [########################################] 100%
 libvorbis-1.3.6-1-x86_64                    294.1 KiB  72.1 KiB/s 00:04 [########################################] 100%
 libsndfile-1.0.28-3-x86_64                  344.9 KiB   122 KiB/s 00:03 [########################################] 100%
 perl-error-0.17029-1-any                     22.3 KiB  0.00   B/s 00:00 [########################################] 100%
 perl-mailtools-2.21-2-any                    62.1 KiB  36.9 KiB/s 00:02 [########################################] 100%
 git-2.26.2-1-x86_64                           6.2 MiB   105 KiB/s 01:01 [########################################] 100%
 alsa-topology-conf-1.2.2-2-any                8.2 KiB  0.00   B/s 00:00 [########################################] 100%
 alsa-ucm-conf-1.2.2-1-any                    28.9 KiB  0.00   B/s 00:00 [########################################] 100%
 alsa-lib-1.2.2-1-x86_64                     454.0 KiB   185 KiB/s 00:02 [########################################] 100%
 aom-1.0.0.errata1+avif-1-x86_64               2.6 MiB   416 KiB/s 00:06 [########################################] 100%
 libpng-1.6.37-1-x86_64                      237.5 KiB   354 KiB/s 00:01 [########################################] 100%
 graphite-1:1.3.14-1-x86_64                  224.5 KiB   308 KiB/s 00:01 [########################################] 100%
 harfbuzz-2.6.6-1-x86_64                     895.7 KiB   243 KiB/s 00:04 [########################################] 100%
 freetype2-2.10.2-1-x86_64                   497.9 KiB   169 KiB/s 00:03 [########################################] 100%
 fontconfig-2:2.13.91+24+g75eadca-2-x86_64   895.9 KiB  72.0 KiB/s 00:12 [########################################] 100%
 fribidi-1.0.9-1-x86_64                       42.2 KiB   264 KiB/s 00:00 [########################################] 100%
 gsm-1.0.19-1-x86_64                          37.3 KiB   177 KiB/s 00:00 [########################################] 100%
 libsamplerate-0.1.9-3-x86_64               1378.0 KiB  59.0 KiB/s 00:23 [########################################] 100%
 zita-alsa-pcmi-0.3.2-2-x86_64                19.2 KiB  0.00   B/s 00:00 [########################################] 100%
 zita-resampler-1.6.2-2-x86_64               115.3 KiB   288 KiB/s 00:00 [########################################] 100%
 jack-0.125.0-9-x86_64                       386.4 KiB  59.3 KiB/s 00:07 [########################################] 100%
 lame-3.100-2-x86_64                         256.5 KiB  59.6 KiB/s 00:04 [########################################] 100%
 libass-0.14.0-2-x86_64                      100.3 KiB   150 KiB/s 00:01 [########################################] 100%
 libraw1394-2.1.2-2-x86_64                    44.4 KiB   135 KiB/s 00:00 [########################################] 100%
 libavc1394-0.5.4-4-x86_64                    32.6 KiB   125 KiB/s 00:00 [########################################] 100%
 libbluray-1.2.0-3-x86_64                    866.3 KiB  86.9 KiB/s 00:10 [########################################] 100%
 vulkan-icd-loader-1.2.140-1-x86_64          112.5 KiB  44.8 KiB/s 00:03 [########################################] 100%
 dav1d-0.6.0-1-x86_64                        371.2 KiB   158 KiB/s 00:02 [########################################] 100%
 libpciaccess-0.16-1-x86_64                   20.0 KiB  0.00   B/s 00:00 [########################################] 100%
 libdrm-2.4.101-1-x86_64                     262.7 KiB   123 KiB/s 00:02 [########################################] 100%
 libiec61883-1.2.0-5-x86_64                   31.1 KiB   194 KiB/s 00:00 [########################################] 100%
 libmodplug-0.8.9.0-2-x86_64                 152.3 KiB   145 KiB/s 00:01 [########################################] 100%
 libomxil-bellagio-0.9.3-2-x86_64            116.8 KiB  50.3 KiB/s 00:02 [########################################] 100%
 libasyncns-0.8+3+g68cd5af-2-x86_64           15.8 KiB  0.00   B/s 00:00 [########################################] 100%
 xcb-proto-1.14-1-any                        108.9 KiB  74.6 KiB/s 00:01 [########################################] 100%
 libxdmcp-1.1.3-2-x86_64                      25.7 KiB   321 KiB/s 00:00 [########################################] 100%
 libxau-1.0.9-2-x86_64                        10.5 KiB  0.00   B/s 00:00 [########################################] 100%
 libxcb-1.14-1-x86_64                        999.8 KiB  58.5 KiB/s 00:17 [########################################] 100%
 xorgproto-2020.1-1-any                      237.9 KiB   108 KiB/s 00:02 [########################################] 100%
 libx11-1.6.9-6-x86_64                      2028.1 KiB  67.4 KiB/s 00:30 [########################################] 100%
 libxext-1.3.4-2-x86_64                      103.4 KiB   220 KiB/s 00:00 [########################################] 100%
 libxi-1.7.10-2-x86_64                       145.8 KiB   247 KiB/s 00:01 [########################################] 100%
 libxfixes-5.0.3-3-x86_64                     12.7 KiB  0.00   B/s 00:00 [########################################] 100%
 libxtst-1.2.3-3-x86_64                       28.1 KiB   256 KiB/s 00:00 [########################################] 100%
 libice-1.0.10-2-x86_64                       74.3 KiB   124 KiB/s 00:01 [########################################] 100%
 libsm-1.2.3-2-x86_64                         45.5 KiB  85.9 KiB/s 00:01 [########################################] 100%
 libpulse-13.0-3-x86_64                      393.3 KiB  73.1 KiB/s 00:05 [########################################] 100%
 libsoxr-0.1.3-2-x86_64                      126.6 KiB   144 KiB/s 00:01 [########################################] 100%
 libssh-0.9.4-1-x86_64                       193.2 KiB   203 KiB/s 00:01 [########################################] 100%
 libtheora-1.1.1-4-x86_64                    272.8 KiB   144 KiB/s 00:02 [########################################] 100%
 wayland-1.18.0-2-x86_64                     130.2 KiB   117 KiB/s 00:01 [########################################] 100%
 libxxf86vm-1.1.4-3-x86_64                    15.0 KiB  0.00   B/s 00:00 [########################################] 100%
 libxdamage-1.1.5-2-x86_64                     6.8 KiB  0.00   B/s 00:00 [########################################] 100%
 libxshmfence-1.3-2-x86_64                     5.7 KiB  0.00   B/s 00:00 [########################################] 100%
 libunwind-1.3.1-1-x86_64                    108.6 KiB   170 KiB/s 00:01 [########################################] 100%
 llvm-libs-10.0.0-1-x86_64                    21.3 MiB   215 KiB/s 01:41 [########################################] 100%
 lm_sensors-3.6.0-1-x86_64                   128.0 KiB   225 KiB/s 00:01 [########################################] 100%
 mesa-20.0.6-2-x86_64                         13.1 MiB   121 KiB/s 01:51 [########################################] 100%
 libglvnd-1.3.1-1-x86_64                     370.7 KiB  65.5 KiB/s 00:06 [########################################] 100%
 libva-2.7.1-1-x86_64                        162.1 KiB   128 KiB/s 00:01 [########################################] 100%
 libvdpau-1.4-1-x86_64                        60.6 KiB   196 KiB/s 00:00 [########################################] 100%
 vid.stab-1.1-2-x86_64                        46.8 KiB   312 KiB/s 00:00 [########################################] 100%
 libvpx-1.8.2-1-x86_64                      1217.6 KiB  84.8 KiB/s 00:14 [########################################] 100%
 libjpeg-turbo-2.0.4-1-x86_64                449.5 KiB  55.4 KiB/s 00:08 [########################################] 100%
 libtiff-4.1.0-1-x86_64                      816.3 KiB  69.2 KiB/s 00:12 [########################################] 100%
 giflib-5.2.1-1-x86_64                        69.0 KiB   126 KiB/s 00:01 [########################################] 100%
 libwebp-1.1.0-1-x86_64                      336.9 KiB   142 KiB/s 00:02 [########################################] 100%
 l-smash-2.14.5-2-x86_64                     313.7 KiB   135 KiB/s 00:02 [########################################] 100%
 x264-3:0.159.r2999.296494a-1-x86_64         718.8 KiB   250 KiB/s 00:03 [########################################] 100%
 x265-3.3-1-x86_64                          1593.2 KiB  87.2 KiB/s 00:18 [########################################] 100%
 libxv-1.0.11-3-x86_64                        34.6 KiB   247 KiB/s 00:00 [########################################] 100%
 xvidcore-1.3.7-1-x86_64                     202.3 KiB   102 KiB/s 00:02 [########################################] 100%
 opencore-amr-0.1.5-3-x86_64                 132.6 KiB  77.6 KiB/s 00:02 [########################################] 100%
 lcms2-2.9-2-x86_64                          186.6 KiB   124 KiB/s 00:02 [########################################] 100%
 openjpeg2-2.3.1-1-x86_64                    879.2 KiB   127 KiB/s 00:07 [########################################] 100%
 opus-1.3.1-1-x86_64                         368.6 KiB   183 KiB/s 00:02 [########################################] 100%
 libxrender-0.9.10-3-x86_64                   23.9 KiB  0.00   B/s 00:00 [########################################] 100%
 libxcursor-1.2.0-1-x86_64                    27.7 KiB  0.00   B/s 00:00 [########################################] 100%
 libibus-1.5.22-1-x86_64                       7.0 MiB   201 KiB/s 00:36 [########################################] 100%
 sdl2-2.0.12-1-x86_64                        687.1 KiB   164 KiB/s 00:04 [########################################] 100%
 speexdsp-1.2.0-1-x86_64                     448.2 KiB   110 KiB/s 00:04 [########################################] 100%
 speex-1.2.0-2-x86_64                        477.6 KiB   146 KiB/s 00:03 [########################################] 100%
 srt-1.4.1-1-x86_64                          911.3 KiB  59.4 KiB/s 00:15 [########################################] 100%
 hicolor-icon-theme-0.17-2-any                10.2 KiB  0.00   B/s 00:00 [########################################] 100%
 v4l-utils-1.18.1-1-x86_64                  1265.3 KiB   106 KiB/s 00:12 [########################################] 100%
 ffmpeg-1:4.2.2-8-x86_64                       9.5 MiB  90.4 KiB/s 01:48 [########################################] 100%
 tmux-3.1_b-1-x86_64                         318.0 KiB   206 KiB/s 00:02 [########################################] 100%
 libmfx-20.1.1-1-x86_64                       51.7 KiB   167 KiB/s 00:00 [########################################] 100%
 vmaf-1.5.1-1-x86_64                         707.7 KiB   142 KiB/s 00:05 [########################################] 100%
(145/145) checking keys in keyring                                       [########################################] 100%
(145/145) checking package integrity                                     [########################################] 100%
(145/145) loading package files                                          [########################################] 100%
(145/145) checking for file conflicts                                    [########################################] 100%
(145/145) checking available disk space                                  [########################################] 100%
:: Processing package changes...
(  1/145) reinstalling gawk                                              [########################################] 100%
(  2/145) installing m4                                                  [########################################] 100%
(  3/145) installing diffutils                                           [########################################] 100%
(  4/145) installing autoconf                                            [########################################] 100%
(  5/145) installing automake                                            [########################################] 100%
(  6/145) installing libmicrohttpd                                       [########################################] 100%
(  7/145) reinstalling findutils                                         [########################################] 100%
(  8/145) installing elfutils                                            [########################################] 100%
(  9/145) installing binutils                                            [########################################] 100%
( 10/145) installing bison                                               [########################################] 100%
( 11/145) reinstalling file                                              [########################################] 100%
( 12/145) installing flex                                                [########################################] 100%
( 13/145) installing libmpc                                              [########################################] 100%
( 14/145) installing gcc                                                 [########################################] 100%
Optional dependencies for gcc
    lib32-gcc-libs: for generating code for 32-bit ABI
( 15/145) reinstalling gettext                                           [########################################] 100%
( 16/145) reinstalling grep                                              [########################################] 100%
( 17/145) installing groff                                               [########################################] 100%
Optional dependencies for groff
    netpbm: for use together with man -H command interaction in browsers
    psutils: for use together with man -H command interaction in browsers
    libxaw: for gxditview
    perl-file-homedir: for use with glilypond
( 18/145) reinstalling gzip                                              [########################################] 100%
( 19/145) installing libtool                                             [########################################] 100%
( 20/145) installing texinfo                                             [########################################] 100%
( 21/145) installing gc                                                  [########################################] 100%
( 22/145) installing guile                                               [########################################] 100%
( 23/145) installing make                                                [########################################] 100%
( 24/145) reinstalling pacman                                            [########################################] 100%
( 25/145) installing patch                                               [########################################] 100%
Optional dependencies for patch
    ed: for patch -e functionality
( 26/145) installing pkgconf                                             [########################################] 100%
( 27/145) reinstalling sed                                               [########################################] 100%
( 28/145) reinstalling sudo                                              [########################################] 100%
( 29/145) installing which                                               [########################################] 100%
( 30/145) installing wget                                                [########################################] 100%
Optional dependencies for wget
    ca-certificates: HTTPS downloads [installed]
( 31/145) installing libevent                                            [########################################] 100%
Optional dependencies for libevent
    python: to use event_rpcgen.py
( 32/145) installing libutempter                                         [########################################] 100%
( 33/145) installing tmux                                                [########################################] 100%
( 34/145) installing perl-encode-locale                                  [########################################] 100%
( 35/145) installing perl-timedate                                       [########################################] 100%
( 36/145) installing perl-http-date                                      [########################################] 100%
( 37/145) installing perl-file-listing                                   [########################################] 100%
( 38/145) installing perl-html-tagset                                    [########################################] 100%
( 39/145) installing perl-html-parser                                    [########################################] 100%
( 40/145) installing perl-clone                                          [########################################] 100%
( 41/145) installing perl-io-html                                        [########################################] 100%
( 42/145) installing perl-lwp-mediatypes                                 [########################################] 100%
( 43/145) installing perl-uri                                            [########################################] 100%
( 44/145) installing perl-http-message                                   [########################################] 100%
( 45/145) installing perl-http-cookies                                   [########################################] 100%
( 46/145) installing perl-http-daemon                                    [########################################] 100%
( 47/145) installing perl-http-negotiate                                 [########################################] 100%
( 48/145) installing perl-net-http                                       [########################################] 100%
( 49/145) installing perl-try-tiny                                       [########################################] 100%
( 50/145) installing perl-www-robotrules                                 [########################################] 100%
( 51/145) installing perl-libwww                                         [########################################] 100%
Optional dependencies for perl-libwww
    perl-lwp-protocol-https: for https:// url schemes
( 52/145) installing perl-xml-parser                                     [########################################] 100%
( 53/145) installing intltool                                            [########################################] 100%
( 54/145) installing libogg                                              [########################################] 100%
( 55/145) installing flac                                                [########################################] 100%
( 56/145) installing libvorbis                                           [########################################] 100%
( 57/145) installing libsndfile                                          [########################################] 100%
Optional dependencies for libsndfile
    alsa-lib: for sndfile-play [pending]
( 58/145) reinstalling json-c                                            [########################################] 100%
( 59/145) installing perl-error                                          [########################################] 100%
( 60/145) installing perl-mailtools                                      [########################################] 100%
( 61/145) installing git                                                 [########################################] 100%
Optional dependencies for git
    tk: gitk and git gui
    perl-libwww: git svn [installed]
    perl-term-readkey: git svn and interactive.singlekey setting
    perl-mime-tools: git send-email
    perl-net-smtp-ssl: git send-email TLS support
    perl-authen-sasl: git send-email TLS support
    perl-mediawiki-api: git mediawiki support
    perl-datetime-format-iso8601: git mediawiki support
    perl-lwp-protocol-https: git mediawiki https support
    perl-cgi: gitweb (web interface) support
    python: git svn & git p4
    subversion: git svn
    org.freedesktop.secrets: keyring credential helper
    libsecret: libsecret credential helper [installed]
( 62/145) installing alsa-topology-conf                                  [########################################] 100%
( 63/145) installing alsa-ucm-conf                                       [########################################] 100%
( 64/145) installing alsa-lib                                            [########################################] 100%
( 65/145) installing aom                                                 [########################################] 100%
( 66/145) installing libpng                                              [########################################] 100%
( 67/145) installing graphite                                            [########################################] 100%
( 68/145) installing harfbuzz                                            [########################################] 100%
Optional dependencies for harfbuzz
    cairo: hb-view program
( 69/145) installing freetype2                                           [########################################] 100%
( 70/145) installing fontconfig                                          [########################################] 100%

  Fontconfig configuration is done via /etc/fonts/conf.avail and conf.d.
  Read /etc/fonts/conf.d/README for more information.

  Configuration via /etc/fonts/local.conf is still possible,
  but is no longer recommended for options available in conf.avail.

  Main systemwide configuration should be done by symlinks
  (especially for autohinting, sub-pixel and lcdfilter):

  cd /etc/fonts/conf.d
  ln -s ../conf.avail/XX-foo.conf

  Check also https://wiki.archlinux.org/index.php/Font_Configuration
  and https://wiki.archlinux.org/index.php/Fonts.

Rebuilding fontconfig cache... done.
( 71/145) installing fribidi                                             [########################################] 100%
( 72/145) installing gsm                                                 [########################################] 100%
( 73/145) installing libsamplerate                                       [########################################] 100%
Optional dependencies for libsamplerate
    libsndfile.so: for sndfile-resample [installed]
( 74/145) installing zita-alsa-pcmi                                      [########################################] 100%
( 75/145) installing zita-resampler                                      [########################################] 100%
Optional dependencies for zita-resampler
    libsndfile: for zresample and zretune [installed]
( 76/145) installing jack                                                [########################################] 100%
Optional dependencies for jack
    celt: NetJACK driver
    libffado: FireWire support
    realtime-privileges: Acquire realtime privileges
( 77/145) installing lame                                                [########################################] 100%
( 78/145) installing libass                                              [########################################] 100%
( 79/145) installing libraw1394                                          [########################################] 100%
( 80/145) installing libavc1394                                          [########################################] 100%
( 81/145) installing libbluray                                           [########################################] 100%
Optional dependencies for libbluray
    java-runtime: BD-J library
( 82/145) installing vulkan-icd-loader                                   [########################################] 100%
Optional dependencies for vulkan-icd-loader
    vulkan-driver: packaged vulkan driver
( 83/145) installing dav1d                                               [########################################] 100%
( 84/145) installing libpciaccess                                        [########################################] 100%
( 85/145) installing libdrm                                              [########################################] 100%
( 86/145) installing libiec61883                                         [########################################] 100%
( 87/145) installing libmfx                                              [########################################] 100%
( 88/145) installing libmodplug                                          [########################################] 100%
( 89/145) installing libomxil-bellagio                                   [########################################] 100%
( 90/145) installing libasyncns                                          [########################################] 100%
( 91/145) installing xcb-proto                                           [########################################] 100%
( 92/145) installing libxdmcp                                            [########################################] 100%
( 93/145) installing libxau                                              [########################################] 100%
( 94/145) installing libxcb                                              [########################################] 100%
( 95/145) installing xorgproto                                           [########################################] 100%
( 96/145) installing libx11                                              [########################################] 100%
( 97/145) installing libxext                                             [########################################] 100%
( 98/145) installing libxi                                               [########################################] 100%
( 99/145) installing libxfixes                                           [########################################] 100%
(100/145) installing libxtst                                             [########################################] 100%
(101/145) installing libice                                              [########################################] 100%
(102/145) installing libsm                                               [########################################] 100%
(103/145) installing libpulse                                            [########################################] 100%
(104/145) installing libsoxr                                             [########################################] 100%
(105/145) installing libssh                                              [########################################] 100%
(106/145) installing libtheora                                           [########################################] 100%
(107/145) installing wayland                                             [########################################] 100%
(108/145) installing libxxf86vm                                          [########################################] 100%
(109/145) installing libxdamage                                          [########################################] 100%
(110/145) installing libxshmfence                                        [########################################] 100%
(111/145) installing libunwind                                           [########################################] 100%
(112/145) installing libedit                                             [########################################] 100%
(113/145) installing llvm-libs                                           [########################################] 100%
(114/145) installing lm_sensors                                          [########################################] 100%
Optional dependencies for lm_sensors
    rrdtool: for logging with sensord
(115/145) installing mesa                                                [########################################] 100%
Optional dependencies for mesa
    opengl-man-pages: for the OpenGL API man pages
    mesa-vdpau: for accelerated video playback
    libva-mesa-driver: for accelerated video playback
(116/145) installing libglvnd                                            [########################################] 100%
(117/145) installing libva                                               [########################################] 100%
Optional dependencies for libva
    intel-media-driver: backend for Intel GPUs (>= Broadwell)
    libva-vdpau-driver: backend for Nvidia and AMD GPUs
    libva-intel-driver: backend for Intel GPUs (<= Haswell)
(118/145) installing libvdpau                                            [########################################] 100%
(119/145) installing vid.stab                                            [########################################] 100%
(120/145) installing libvpx                                              [########################################] 100%
(121/145) installing libjpeg-turbo                                       [########################################] 100%
(122/145) installing libtiff                                             [########################################] 100%
Optional dependencies for libtiff
    freeglut: for using tiffgt
(123/145) installing giflib                                              [########################################] 100%
(124/145) installing libwebp                                             [########################################] 100%
Optional dependencies for libwebp
    freeglut: vwebp viewer
(125/145) installing l-smash                                             [########################################] 100%
(126/145) installing x264                                                [########################################] 100%
(127/145) installing x265                                                [########################################] 100%
(128/145) installing libxv                                               [########################################] 100%
(129/145) installing xvidcore                                            [########################################] 100%
(130/145) installing opencore-amr                                        [########################################] 100%
(131/145) installing lcms2                                               [########################################] 100%
(132/145) installing openjpeg2                                           [########################################] 100%
(133/145) installing opus                                                [########################################] 100%
(134/145) installing libxrender                                          [########################################] 100%
(135/145) installing libxcursor                                          [########################################] 100%
Optional dependencies for libxcursor
    gnome-themes-standard: fallback icon theme
(136/145) installing libibus                                             [########################################] 100%
(137/145) installing sdl2                                                [########################################] 100%
Optional dependencies for sdl2
    alsa-lib: ALSA audio driver [installed]
    libpulse: PulseAudio audio driver [installed]
    jack: JACK audio driver [installed]
(138/145) installing speexdsp                                            [########################################] 100%
(139/145) installing speex                                               [########################################] 100%
(140/145) installing srt                                                 [########################################] 100%
(141/145) installing hicolor-icon-theme                                  [########################################] 100%
(142/145) installing sysfsutils                                          [########################################] 100%
(143/145) installing v4l-utils                                           [########################################] 100%
Optional dependencies for v4l-utils
    qt5-base: for qv4l2
    alsa-lib: for qv4l2 [installed]
(144/145) installing vmaf                                                [########################################] 100%
(145/145) installing ffmpeg                                              [########################################] 100%
Optional dependencies for ffmpeg
    intel-media-sdk: Intel QuickSync support
    ladspa: LADSPA filters
    nvidia-utils: Nvidia NVDEC/NVENC support
:: Running post-transaction hooks...
(1/7) Creating system user accounts...
(2/7) Reloading system manager configuration...
  Skipped: Current root is not booted.
(3/7) Creating temporary files...
(4/7) Reloading device manager configuration...
  Skipped: Device manager is not running.
(5/7) Arming ConditionNeedsUpdate...
(6/7) Warn about old perl modules
(7/7) Updating the info directory file...
```

Make a code directory in your home folder to spam packages into.

```
cd
mkdir code
cd code
```

Git YAY! I would normally suggest installing all packages manually like below with "makepkg -si" without "YAY" but it makes it quicker for this instance to grab all the working dependencies from AUR for you that go with the packages you require but it is never recommended to use it.

```
git clone https://aur.archlinux.org/yay.git
cd yay 
makepkg -si
cd ..
```

### Git pulseaudio, edit and compile.

```
git clone git://anongit.freedesktop.org/pulseaudio/pulseaudio
cd pulseaudio/src/pulsecore/
```

### Edit

pulseaudio/src/pulsecore/mutex-posix.c

under:

```
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
```

Add a line 24ish:

```
#undef HAVE_PTHREAD_PRIO_INHERIT
```

Save file and exit editor.

```
cd ../..
```

Edit bootstrap.sh

The final lines around 45 to look like this:

```
if test "x$NOCONFIGURE" = "x"; then
    CFLAGS="$CFLAGS -g -O0" ./configure --disable-bluez4 --disable-bluez5 --disable-rpath --disable-asyncns --disable-udev --disable-systemd-daemon --without-caps --enable-force-preopen "$@" && \
        make clean
fi
```

Save and exit editor.

### Compile pulseaudio

```
./bootstrap.sh
make
sudo make install
```

Export Pulse Server.

WSL V1

```
export PULSE_SERVER=tcp:127.0.0.1
````

WSL V2

```
export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
```

Add export above to:

```
~/.bashrc
```

So it sticks on every console startup.

Test sound should hear static if your volume controls are up.

```
pacat < /dev/urandom
```

If you get this error (Which happens in WSL2):

```
Connection failure: Connection refused
pa_context_connect() failed: Connection refused
```

This is an issue with the Windows Pulseaudio ACL configuration for WSL2 you need to allow it's IP range of auth-ip-acl=172.16.0.0/12 as it will use a random IP address from that octet range. 

Check your WSL console IP

```
ip a show dev eth0
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:55:d8:4e brd ff:ff:ff:ff:ff:ff
    inet 172.20.184.10/16 brd 172.20.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fe55:d84e/64 scope link
       valid_lft forever preferred_lft forever
```

Edit C:\WSL\pulseaudio\etc\pulse\default.pa

```
load-module module-native-protocol-tcp auth-ip-acl=172.16.0.0/12 auth-anonymous=1
```

Edit your export command with (WSL2)

```
export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
```

Test an audio file.

```
cd
mkdir Music
cd Music
wget https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3
```

https://thesissahib.bandcamp.com/album/thesis-sahib-loved-ones
https://bandcamptomp3.com/
https://thesissahib.bandcamp.com/track/punk-rock-soccer-mom

```
ffplay -nodisp file_example_MP3_5MG.mp3
ffplay -nodisp Punk-Rock-Soccer-Mom.mp3
```

Hear audio? I hope so...

Install tizonia-all-git which will fail because the github to soundcloud has been abandoned :(

```
yay -Sy tizonia-all-git
```

You may or may not have to manually grab the dependencies and then edit tizonia makepkg to remove soundcloud as I did below which you can then install via pip if not skip this section and test Tizonia.

```
yay -Sy log4c
yay -Sy libspotify
yay -Sy python-pafy
yay -Sy python-gmusicapi
yay -Sy python-soundcloud
yay -Sy python-fuzzywuzzy
yay -Sy python-plexapi
yay -Sy python-pychromecast-git
yay -Sy python-setuptools
easy_install pip
pip install soundcloud
```

### Install Tizonia

```
git clone https://aur.archlinux.org/tizonia-all-git.git
cd tizonia-all-git
```

Edit PKGBUILD

Remove python-soundcloud from the list like this below.

```
    # AUR:
    'log4c'
    'libspotify'
    'python-pafy'
    'python-gmusicapi'
    'python-pychromecast-git'
    'python-plexapi'
    'python-fuzzywuzzy'
    'python-spotipy'
```

Compile Tizonia

```
makepkg -si
```

Test Tizonia

```
tizonia http://vis.media-ice.musicradio.com/LBCUKMP3Low
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[http] [Connecting to radio station] : 'http://vis.media-ice.musicradio.com/LBCUKMP3Low'.
     Accept-Ranges : none
     Content-Type : audio/mpeg
     icy-br : 48
     ice-audio-info : ice-samplerate=44100;ice-bitrate=48;ice-channels=1
     icy-br : 48
     icy-description : LBC UK
     icy-genre : Talk
     icy-name : LBC UK
     icy-private : 0
     icy-pub : 1
     Server : Icecast 2.3.3-kh11
     Cache-Control : no-cache, no-store
     Pragma : no-cache
     Access-Control-Allow-Origin : *
     Access-Control-Allow-Headers : Origin, Accept, X-Requested-With, Content-Type
     Access-Control-Allow-Methods : GET, OPTIONS, HEAD
     Connection : close
     Expires : Mon, 26 Jul 1997 05:00:00 GMT
[http/mp3] [Connected] : 'http://vis.media-ice.musicradio.com/LBCUKMP3Low'.
     1 Ch, 44.1 KHz, 16:s:b

shared memfd open() failed: Function not implemented
     2 Ch, 44.1 KHz, 16:s:b
```

You will see errors like this which can be ignored if the sound is working. 

(In WSL 1, in version 2 I didn't see these errors)

```
shared memfd open() failed: Function not implemented
```

WSL 2

Local Media Test - Works!

```
tizonia $HOME/music --recurse --shuffle
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

Playlist length: 1. File extensions in playlist: .mp3
[mp3] [decode] : '/home/nonasuomy/music/file_example_MP3_5MG.mp3'.
   Impact Moderato, Kevin MacLeod
     Album : YouTube Audio Library
     Duration : 2m:12s
     Size : 5 MiB
     Genre : Cinematic
     2 Ch, 44.1 KHz, 320 Kbps, 16:s:l

   0%   10   20   30   40   50   60   70   80   90   100%
0s |----|----|----|----|----|----|----|----|----|----| 2m:12s
                                             1m:47s
```

Shoutcast Client Test - Works!

```
tizonia http://vis.media-ice.musicradio.com/LBCUKMP3Low
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[http] [Connecting to radio station] : 'http://vis.media-ice.musicradio.com/LBCUKMP3Low'.
     Accept-Ranges : none
     Content-Type : audio/mpeg
     icy-br : 48
     ice-audio-info : ice-samplerate=44100;ice-bitrate=48;ice-channels=1
     icy-br : 48
     icy-description : LBC UK
     icy-genre : Talk
     icy-name : LBC UK
     icy-private : 0
     icy-pub : 1
     Server : Icecast 2.3.3-kh11
     Cache-Control : no-cache, no-store
     Pragma : no-cache
     Access-Control-Allow-Origin : *
     Access-Control-Allow-Headers : Origin, Accept, X-Requested-With, Content-Type
     Access-Control-Allow-Methods : GET, OPTIONS, HEAD
     Connection : close
     Expires : Mon, 26 Jul 1997 05:00:00 GMT
[http/mp3] [Connected] : 'http://vis.media-ice.musicradio.com/LBCUKMP3Low'.
     1 Ch, 44.1 KHz, 16:s:b

     2 Ch, 44.1 KHz, 16:s:b
```

SoundCloud Test - Working!

```
tizonia --soundcloud-creator "thesis sahib"
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[SoundCloud] [Connecting] : 'SoundCloudOAuthToken'.
[SoundCloud] [Track] 'Ink Or Paint'.
[SoundCloud] [Track] 'Tin Man's Shoes'.
[SoundCloud] [Track] 'The Map'.
[SoundCloud] [Track] 'The BUtcher's Daughter'.
[SoundCloud] [Track] 'Serious Fun'.
[SoundCloud] [Track] 'Plastic Spoons'.
[SoundCloud] [Track] 'On The Road To Rotting'.
[SoundCloud] [Track] 'Inside Voices'.
[SoundCloud] [Track] 'Again And The Guilty Man'.
[SoundCloud] [Track] 'I'll Ride Away'.
[SoundCloud] [Track] 'The Old Future'.
[SoundCloud] [Track] 'Automobile'.
[SoundCloud] [Track] 'Tin Man's Shoes'.
[SoundCloud] [Track] 'New Same Old'.
[SoundCloud] [Track] 'Man'.
[SoundCloud] [Track] 'Different Fire: produced by Thesis Sahib'.
[SoundCloud] [Track] 'Flesh Baron: Thesis Sahib produced by Funken'.
[SoundCloud] [Track] 'I Could Talk Fast But Instead: Produced by Thesis Sahib'.
[SoundCloud] [Track] 'By Design: Thesis Sahib produced by Middle Sex Wrestling Team'.
[SoundCloud] [Track] 'Every Last Word'.
[SoundCloud] [Track] 'What are the chances circuit bent sound sculpture 2010'.
[SoundCloud] [Tracks in queue] '21'.
[SoundCloud] [Connected] : 'thesis sahib'.
   Ink Or Paint : Thesis Sahib
     Duration : 2m:54s
     Likes count : 0
     Permalink : https://soundcloud.com/thesis-sahib/04-ink-or-paint
     License : all-rights-reserved
     Audio Stream : 128 kbit/s, 44100 Hz
     MPEG Layer : III, w/o CRC
     Mode : joint (MS/intensity) stereo, no emphasis
     2 Ch, 44.1 KHz, 16:s:b


   0%   10   20   30   40   50   60   70   80   90   100%
0s |----|----|----|----|----|----|----|----|----|----| 2m:54s
      04s
```

Spotify Test - It seems like it loads information don't have a premium account to test further.

```
tizonia --spotify-artist 'enya'
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[Spotify] [Connecting] : 'nonasuomy'.
INFO:root:
INFO:root:_remove_explicit_tracks : DISALLOW - tracks before 0
INFO:root:arg : enya
[Spotify] [Artist search] 'enya'.
DEBUG:urllib3.connectionpool:Starting new HTTPS connection (1): accounts.spotify.com:443
DEBUG:urllib3.connectionpool:https://accounts.spotify.com:443 "POST /api/token HTTP/1.1" 200 None
More stuff...
[Spotify] [Cache]: '/var/tmp/tizonia-nonasuomy-spotify-nonasuomy'
[Spotify] [FATAL] Login attempt failed. Bad user name or password.

tizonia exiting (OMX_ErrorInsufficientResources).

 [OMX.Aratelia.audio_source.spotify.pcm:port:0]
 [OMX_ErrorInsufficientResources]
```

YouTube Test - Python Error!

```
tizonia --youtube-audio-stream v2AC41dglnM
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[Youtube] [Connecting] : 'v2AC41dglnM'.
Traceback (most recent call last):
  File "<string>", line 4, in <module>
ValueError

Python modules 'pafy', 'youtube-dl', 'joblib' or 'fuzzywuzzy' not found.
Please make sure these are installed correctly.

tizonia exiting (OMX_ErrorInsufficientResources).

 [OMX.Aratelia.audio_source.http:port:0]
 [OMX_ErrorInsufficientResources]
```

TuneIn Test - Python Error!

```
tizonia --tunein-trending 'heart UK'
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

Traceback (most recent call last):
  File "<string>", line 4, in <module>
ValueError

Python modules 'joblib' or 'fuzzywuzzy' not found.
Please make sure these are installed correctly.

tizonia exiting (OMX_ErrorInsufficientResources).

 [OMX.Aratelia.audio_source.http:port:0]
 [OMX_ErrorInsufficientResources]
```

Check if installed...

```
python -c "help('modules');" | grep pafy
_multiprocessing    decimal             pafy                tizplexproxy
```

```
python -c "help('modules');" | grep fuzzywuzzy
_strptime           fuzzywuzzy          pychromecast        warnings
```

```
python -c "help('modules');"

Please wait a moment while I gather a list of all available modules...

Cryptodome          antigravity         imaplib             setuptools
Levenshtein         appdirs             imghdr              shelve
__future__          argparse            imp                 shlex
_abc                array               importlib           shutil
_ast                ast                 inspect             signal
_asyncio            asynchat            io                  simplejson
_bisect             asyncio             ipaddress           site
_blake2             asyncore            itertools           six
_bootlocale         atexit              json                smtpd
_bz2                audioop             keyword             smtplib
_codecs             base64              lib2to3             sndhdr
_codecs_cn          bdb                 libmount            socket
_codecs_hk          binascii            libxml2             socketserver
_codecs_iso2022     binhex              libxml2mod          soundcloud
_codecs_jp          bisect              linecache           soupsieve
_codecs_kr          bs4                 locale              spotipy
_codecs_tw          builtins            logging             spwd
_collections        bz2                 lxml                sqlite3
_collections_abc    cProfile            lzma                sre_compile
_compat_pickle      calendar            mailbox             sre_constants
_compression        cgi                 mailcap             sre_parse
_contextvars        cgitb               marshal             ssl
_crypt              chardet             math                stat
_csv                chunk               mechanicalsoup      statistics
_ctypes             cmath               mimetypes           string
_ctypes_test        cmd                 mmap                stringprep
_curses             code                mock                struct
_curses_panel       codecs              modulefinder        subprocess
_datetime           codeop              monotonic           sunau
_dbm                collections         multiprocessing     symbol
_decimal            colorsys            mutagen             symtable
_dummy_thread       compileall          netifaces           sys
_elementtree        concurrent          netrc               sysconfig
_functools          configparser        nis                 syslog
_gdbm               contextlib          nntplib             tabnanny
_hashlib            contextvars         ntpath              tarfile
_heapq              copy                nturl2path          telnetlib
_imp                copyreg             numbers             tempfile
_io                 crypt               oauth2client        termios
_json               csv                 opcode              textwrap
_locale             ctypes              operator            this
_lsprof             curses              optparse            threading
_lzma               dataclasses         ordered_set         time
_markupbase         datetime            os                  timeit
_md5                dateutil            ossaudiodev         tizchromecastproxy
_multibytecodec     dbm                 packaging           tizgmusicproxy
_multiprocessing    decimal             pafy                tizplexproxy
_opcode             decorator           parser              tizsoundcloudproxy
_operator           difflib             pathlib             tizspotifyproxy
_osx_support        dis                 pbr                 tiztuneinproxy
_pickle             distutils           pdb                 tizyoutubeproxy
_posixshmem         dns                 pickle              tkinter
_posixsubprocess    doctest             pickletools         token
_py_abc             drv_libxml2         pipes               tokenize
_pydecimal          dummy_threading     pkg_resources       tqdm
_pyio               easy_install        pkgutil             trace
_queue              email               platform            traceback
_random             encodings           plexapi             tracemalloc
_sha1               ensurepip           plistlib            tty
_sha256             enum                poplib              turtle
_sha3               errno               posix               turtledemo
_sha512             eventlet            posixpath           types
_signal             faulthandler        pprint              typing
_sitebuiltins       fcntl               proboscis           unicodedata
_socket             filecmp             profile             unittest
_sqlite3            fileinput           pstats              urllib
_sre                fnmatch             pty                 urllib3
_ssl                formatter           pwd                 uu
_stat               fractions           py_compile          uuid
_statistics         ftplib              pyasn1              validictory
_string             functools           pyasn1_modules      venv
_strptime           fuzzywuzzy          pychromecast        warnings
_struct             gc                  pyclbr              wave
_symtable           genericpath         pydoc               weakref
_sysconfigdata__linux_x86_64-linux-gnu getopt              pydoc_data          webbrowser
_testbuffer         getpass             pyexpat             websocket
_testcapi           gettext             pyparsing           wsgiref
_testimportmultiple glob                queue               xcbgen
_testinternalcapi   gmusicapi           quopri              xdrlib
_testmultiphase     gpsoauth            random              xml
_thread             greenlet            re                  xmlrpc
_threading_local    grp                 readline            xxlimited
_tkinter            gzip                reprlib             xxsubtype
_tracemalloc        hashlib             requests            youtube_dl
_uuid               heapq               resource            zeroconf
_warnings           hmac                rlcompleter         zipapp
_weakref            html                rsa                 zipfile
_weakrefset         http                runpy               zipimport
_xxsubinterpreters  httplib2            sched               zlib
_xxtestfuzz         idlelib             secrets
abc                 idna                select
aifc                ifaddr              selectors

Enter any module name to get more help.  Or, type "modules spam" to search
for modules whose name or summary contains the string "spam".
```

Fixed errors above via pip upgrade.

```
sudo easy_install pip
sudo -H pip install --upgrade wheel gmusicapi soundcloud youtube-dl pafy pycountry titlecase pychromecast fuzzywuzzy eventlet
```

This upgrade errors excluded above:

```
sudo -H pip install --upgrade plexapi
Collecting plexapi
  Using cached PlexAPI-3.6.0.tar.gz (87 kB)
Requirement already satisfied, skipping upgrade: requests in /usr/lib/python3.8/site-packages (from plexapi) (2.23.0)
Requirement already satisfied, skipping upgrade: chardet>=3.0.2 in /usr/lib/python3.8/site-packages (from requests->plexapi) (3.0.4)
Requirement already satisfied, skipping upgrade: idna>=2.5 in /usr/lib/python3.8/site-packages (from requests->plexapi) (2.9)
Requirement already satisfied, skipping upgrade: urllib3>=1.21.1 in /usr/lib/python3.8/site-packages (from requests->plexapi) (1.25.9)
Building wheels for collected packages: plexapi
  Building wheel for plexapi (setup.py) ... done
  Created wheel for plexapi: filename=PlexAPI-3.6.0-py3-none-any.whl size=99232 sha256=653f600a8739943356731e98c9d8ec3d836b61ab24d24f112806ffbaa60532cd
  Stored in directory: /root/.cache/pip/wheels/9e/1c/43/3477665e2761b6ebda046f86624043ef241a89980798718b64
Successfully built plexapi
Installing collected packages: plexapi
  Attempting uninstall: plexapi
    Found existing installation: PlexAPI 3.4.0
ERROR: Cannot uninstall 'PlexAPI'. It is a distutils installed project and thus we cannot accurately determine which files belong to it which would lead to only a partial uninstall.
```

Grab plexapi from AUR:

```
yay -Sy python-plexapi
```

After update pip will say it is now the current version.

```
sudo -H pip install --upgrade plexapi
Requirement already up-to-date: plexapi in /usr/lib/python3.8/site-packages (3.6.0)
```

YouTube Test - Working!

```
tizonia --youtube-audio-stream v2AC41dglnM
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[Youtube] [Connecting] : 'v2AC41dglnM'.
[YouTube] [Audio strean] : 'v2AC41dglnM'.
[YouTube] [Stream] 'AC/DC - Thunderstruck (Official Video)' [webm].
[YouTube] [Stream] 'AC/DC - Thunderstruck (Official Video)'.
[YouTube] [Streams in queue] '1'.
[Youtube] [Connected] : 'v2AC41dglnM'.
   acdcVEVO : AC/DC - Thunderstruck (Official Video)
     Stream # : 1 of 1
     YouTube Id : v2AC41dglnM
     Duration : 04m:52s
     File Format : webm
     Bitrate : 160k
     Size : 4 MiB
     View Count : 729691664
     Description : Official music video for “Thunderstruck” by AC/DCListen to AC/DC: https://ACDC.lnk.to/listenYD Subscribe to A
     Published : 2012-11-07 15:15:10Z
     Opus Stream : 2 Ch, 48000 Hz
     2 Ch, 48 KHz, 16:s:l


   0%   10   20   30   40   50   60   70   80   90   100%
0s |----|----|----|----|----|----|----|----|----|----| 4m:52s
                 1m:14s
```

TuneIn Test - Working!

```
tizonia --tunein-trending 'heart UK'
tizonia 0.21.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[TuneIn] [TuneIn 'trending' category search] : 'heart UK'.
[TuneIn] [trending] Filtering results: 'heart UK'.
[TuneIn] [station] 'BBC Radio 4' [Best of Today] (mp3, 128kbps, reliability: 97%).
[TuneIn] [station] 'RTÉ Radio 1' [RTÉ Radio 1 features News...] (mp3, 96kbps, reliability: 97%).
[TuneIn] [station] 'LBC London' [Nick Ferrari - The Whole Show] (mp3, 128kbps, reliability: 97%).
[TuneIn] [station] 'BBC Radio 2' [The Zoe Ball Breakfast Show] (mp3, 128kbps, reliability: 99%).
[TuneIn] [station] 'Today FM' [The Ian Dempsey Breakfast Show] (mp3, 96kbps, reliability: 100%).
[TuneIn] [station] 'Newstalk' [Highlights from Newstalk Breakfast] (mp3, 96kbps, reliability: 100%).
[TuneIn] [station] 'Joy FM' [Joy FM News] (mp3, 96kbps, reliability: 98%).
[TuneIn] [station] 'talkSPORT' [What Real Sport Sounds Like] (mp3, 32kbps, reliability: 99%).
[TuneIn] [station] 'BBC Radio 5 live' [5 Live Breakfast] (mp3, 128kbps, reliability: 100%).
[TuneIn] [station] 'BBC Radio 6 Music' [Chris Hawkins] (mp3, 128kbps, reliability: 96%).
[TuneIn] [station] 'BBC World Service News' [Newsday] (mp3, 48kbps, reliability: 90%).
[TuneIn] [station] 'Lincs FM' [Joseph Begley] (mp3, 32kbps, reliability: 87%).
[TuneIn] [station] 'BBC Radio 1' [Radio 1 Breakfast Best Bits with Greg James] (mp3, 128kbps, reliability: 97%).
[TuneIn] [station] 'Citi FM' [Citi Breakfast News] (mp3, 64kbps, reliability: 94%).
[TuneIn] [station] 'RTÉ 2fm' [Music, gossip, pop...] (mp3, 96kbps, reliability: 87%).
[TuneIn] [station] 'triple j' [Alex Lahey - You Don't Think You Like People Like Me] (mp3, 96kbps, reliability: 94%).
[TuneIn] [station] 'Radio National' [ABC News (Australia)] (mp3, 64kbps, reliability: 95%).
[TuneIn] [station] 'ABC NewsRadio' [ABC News Radio] (mp3, 96kbps, reliability: 53%).
[TuneIn] [station] 'Neat 100.9 FM' [Neat FM] (mp3, 64kbps, reliability: 99%).
[TuneIn] [station] 'ABC Radio Melbourne' [Drive (ABC Melbourne)] (mp3, 64kbps, reliability: 93%).
[TuneIn] [station] 'Radio Essex' [Cardi B / Bruno Mars - Please Me] (mp3, 160kbps, reliability: 77%).
[TuneIn] [station] 'Jazz24 - KNKX-HD2' [World Class Jazz] (mp3, 128kbps, reliability: 98%).
[TuneIn] [station] 'WBUR-FM' [BBC News] (mp3, 48kbps, reliability: 97%).
[TuneIn] [station] 'RTÉ Lyric FM' [RTÉ lyric fm is largely...] (mp3, 96kbps, reliability: 90%).
[TuneIn] [station] 'Classic Hits Ireland' [PJ and Jim] (mp3, 128kbps, reliability: 98%).
[TuneIn] [station] 'CLASSIC FM 97.3' [The station that plays every song you know] (mp3, 192kbps, reliability: 94%).
[TuneIn] [station] 'WWOZ' [Contemporary Jazz] (mp3, 128kbps, reliability: 98%).
[TuneIn] [station] '100hitz - Hot Hitz' [Kelly Clarkson - I Dare You] (mp3, 128kbps, reliability: 88%).
[TuneIn] [station] 'WAMU' [We're live, we're local, and we're Washington's NPR station.] (mp3, 32kbps, reliability: 66%).
[TuneIn] [Items in queue] '29'.
[TuneIn] Playing 'BBC Radio 4'.
[Tunein] [Connecting] : ''.
[Tunein] [Connected] : 'trending'.
   Station : BBC Radio 4
     Item # : 1 of 29
     Description : Best of Today
     Type : station
     Format : mp3
     Bitrate : 128
     Reliability : 97
     Streaming URL : http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p?s=1589429391&e=1589443791&h=9d51d27f0c08045ca14d4587
     Thumbnail URL : http://cdn-radiotime-logos.tunein.com/s25419q.png
     2 Ch, 44.1 KHz, 16:s:b

     2 Ch, 48 KHz, 16:s:b
```

### Development Branch

Warning remove prior builds otherwise compile will fail.

```
yay -R tizonia-all-git
```

```
cd ~/code
mkdir tizoniadev
git clone --single-branch --branch develop https://github.com/tizonia/tizonia-openmax-il
cd tizonia-openmax-il

export SAMUFLAGS=-j4
CFLAGS='-O2 -s -DNDEBUG'
CXXFLAGS='-O2 -s -DNDEBUG -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security'
```

Dependencies.

```
yay -Sy log4c
yay -Sy libspotify
yay -Sy python-pafy
yay -Sy python-gmusicapi
yay -Sy python-pychromecast-git
yay -Sy python-plexapi
yay -Sy fuzzywuzzy
yay -Sy spotipy

sudo pacman -Sy git boost check meson samurai libmad taglib mediainfo sdl sqlite lame faad2 libcurl-gnutils libvpx mpg123 opusfile libfishsound liboggz youtube-dl libpulse boost-libs hicolor-icon-theme python-eventlet python-levenshtein --ignore=fakeroot
```

Compile.

```
arch-meson build
samu -v -C build
sudo samu -C build install
```

iHeart Testing - Working!

```
tizonia --iheart-search trance
tizonia 0.22.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

[iHeart] [iHeart search] : 'trance'.
[iHeart] [station] [#1] 'Trancid' [Non-stop Trance and Progressive 24/7] (Digital, states/US-NAT).
[iHeart] [Stations in queue] '1'.
[iHeart] [Streaming] : 'trance'.
   Station : Trancid  (1 of 1)
     Description : Non-stop Trance and Progressive 24/7
     City : Digital
     State : states/US-NAT
     Encoding : audio/aac
     Website : www.trancidradio.com
     Streaming URL : https://stream.revma.ihrhls.com/zc5144
     Thumbnail URL : http://i.iheart.com/v3/re/assets/images/5144.png
     2 Ch, 44.1 KHz, 16:s:l
```

Woo hoo!

Good luck.

Note: Directions should generally be the same for all other WSL distros with the change-up of package managers and package names. 
