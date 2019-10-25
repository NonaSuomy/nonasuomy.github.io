---
layout: post
title: Arch Linux - XPRA
---

XPRA is a pretty smooth running app server for X11.

XPRA - X11 Persistent Remote Applications.

# XPRA #

Install XPRA.

```
sudo pacman -S xpra

resolving dependencies...
looking for conflicting packages...
Packages (26) blas-3.8.0-2  cblas-3.8.0-2  freeglut-3.2.1-1  glu-9.0.1-1
          	gtkglext-1.2.0-11  lapack-3.8.0-2  libglade-2.6.4-6
          	libimagequant-2.12.5-1  pangox-compat-0.0.2+2+gedb9e09-3
          	pygobject2-devel-2.28.7-2  pygtk-2.24.0-8  python-lz4-2.2.1-1
          	python-opengl-3.1.0-4  python2-2.7.16-1  python2-cairo-1.18.1-1
          	python2-future-0.17.1-1  python2-gobject2-2.28.7-2
          	python2-gtkglext-1.1.0-8  python2-lz4-2.2.1-1
          	python2-netifaces-0.10.9-1  python2-numpy-1.16.4-2
          	python2-opengl-3.1.0-4  python2-pillow-6.1.0-1
          	python2-rencode-1.0.6-1  xf86-video-dummy-0.3.8-3  xpra-2.5.1-1
Total Download Size:	27.05 MiB
Total Installed Size:  168.60 MiB
:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 python2-2.7.16-1-x86_64   11.7 MiB   219K/s 00:55 [----------------------]  43%
 libglade-2.6.4-6-x86_64   11.8 MiB   214K/s 00:57 [----------------------]  43%
 python2-cairo-1.18....	11.9 MiB   212K/s 00:57 [----------------------]  43%
 pygobject2-devel-2....	11.9 MiB   210K/s 00:58 [----------------------]  43%
 python2-gobject2-2....	12.1 MiB   211K/s 00:59 [----------------------]  44%
 pygtk-2.24.0-8-x86_64 	12.9 MiB   213K/s 01:02 [----------------------]  47%
 xf86-video-dummy-0....	12.9 MiB   210K/s 01:03 [----------------------]  47%
 blas-3.8.0-2-x86_64   	13.1 MiB   203K/s 01:06 [----------------------]  48%
 cblas-3.8.0-2-x86_64  	13.1 MiB   201K/s 01:07 [----------------------]  48%
 lapack-3.8.0-2-x86_64 	15.2 MiB   194K/s 01:20 [----------------------]  56%
 python2-numpy-1.16....	17.8 MiB   186K/s 01:38 [----------------------]  65%
 freeglut-3.2.1-1-x86_64   17.9 MiB   182K/s 01:40 [----------------------]  66%
 python2-opengl-3.1....	19.0 MiB   178K/s 01:49 [----------------------]  70%
 glu-9.0.1-1-x86_64    	19.2 MiB   177K/s 01:51 [----------------------]  70%
 pangox-compat-0.0.2...	19.2 MiB   176K/s 01:52 [----------------------]  70%
 gtkglext-1.2.0-11-x...	19.4 MiB   174K/s 01:54 [----------------------]  71%
 python-opengl-3.1.0...	20.6 MiB   174K/s 02:01 [----------------------]  76%
 libimagequant-2.12....	20.7 MiB   173K/s 02:02 [----------------------]  76%
 python2-pillow-6.1....	21.2 MiB   171K/s 02:07 [----------------------]  78%
 python2-future-0.17...	21.8 MiB   172K/s 02:10 [----------------------]  80%
 python2-lz4-2.2.1-1...	21.9 MiB   171K/s 02:11 [----------------------]  80%
 python2-netifaces-0...	21.9 MiB   170K/s 02:11 [----------------------]  80%
 python2-rencode-1.0...	21.9 MiB   170K/s 02:12 [----------------------]  80%
 python2-gtkglext-1....	21.9 MiB   169K/s 02:13 [----------------------]  81%
 python-lz4-2.2.1-1-...	22.0 MiB   168K/s 02:14 [----------------------]  81%
 xpra-2.5.1-1-x86_64   	27.1 MiB   175K/s 02:38 [----------------------] 100%
(26/26) checking keys in keyring               	[----------------------] 100%
(26/26) checking package integrity             	[----------------------] 100%
(26/26) loading package files                  	[----------------------] 100%
(26/26) checking for file conflicts            	[----------------------] 100%
(26/26) checking available disk space          	[----------------------] 100%
:: Processing package changes...
( 1/26) installing python2                     	[----------------------] 100%
Optional dependencies for python2
	tk: for IDLE
	python2-setuptools
	python2-pip
( 2/26) installing libglade                    	[----------------------] 100%
Optional dependencies for libglade
	python2: libglade-convert script [installed]
( 3/26) installing python2-cairo               	[----------------------] 100%
( 4/26) installing pygobject2-devel            	[----------------------] 100%
( 5/26) installing python2-gobject2            	[----------------------] 100%
( 6/26) installing pygtk                       	[----------------------] 100%
Optional dependencies for pygtk
	python2-numpy [pending]
( 7/26) installing libimagequant               	[----------------------] 100%
( 8/26) installing python2-pillow              	[----------------------] 100%
Optional dependencies for python2-pillow
	freetype2: for the ImageFont module [installed]
	libraqm: for complex text scripts
	libwebp: for webp images [installed]
	tk: for the ImageTK module
	python2-olefile: OLE2 file support
	python2-pyqt5: for the ImageQt module
( 9/26) installing python2-future              	[----------------------] 100%
Optional dependencies for python2-future
	python2-setuptools: futurize2 and pasteurize2 scripts
(10/26) installing python2-lz4                 	[----------------------] 100%
(11/26) installing xf86-video-dummy            	[----------------------] 100%
(12/26) installing python2-netifaces           	[----------------------] 100%
(13/26) installing blas                        	[----------------------] 100%
(14/26) installing cblas                       	[----------------------] 100%
(15/26) installing lapack                      	[----------------------] 100%
(16/26) installing python2-numpy               	[----------------------] 100%
Optional dependencies for python2-numpy
	openblas: faster linear algebra
(17/26) installing python2-rencode             	[----------------------] 100%
(18/26) installing freeglut                    	[----------------------] 100%
(19/26) installing python2-opengl              	[----------------------] 100%
(20/26) installing glu                         	[----------------------] 100%
(21/26) installing pangox-compat               	[----------------------] 100%
(22/26) installing gtkglext                    	[----------------------] 100%
(23/26) installing python2-gtkglext            	[----------------------] 100%
(24/26) installing python-lz4                  	[----------------------] 100%
(25/26) installing python-opengl               	[----------------------] 100%
(26/26) installing xpra                        	[----------------------] 100%
Optional dependencies for xpra
	x264: Codec [installed]
	python2-dbus: dbus features
	python2-pycups: Printing support
	python2-cryptography: Cryptography
	python-cryptography: Cryptography
	gst-python2: Sound Forwarding
	opencv: Webcam Capture
:: Running post-transaction hooks...
(1/8) Creating system user accounts...
(2/8) Reloading system manager configuration...
(3/8) Creating temporary files...
(4/8) Reloading device manager configuration...
(5/8) Arming ConditionNeedsUpdate...
(6/8) Reloading system bus configuration...
(7/8) Updating the desktop file MIME type cache...
(8/8) Updating the MIME type database...
```

Install optional dependencies for xpra.

```
sudo pacman -Sy opencv python-cryptography python2-cryptography python2-pycups python2-dbus gst-python2 gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer-vaapi python2-paramiko  python2-xdg
```

Load kernel module for uinput and install python package.

```
sudo modprobe uinput
git clone https://aur.archlinux.org/python2-uinput.git
cd python2-uinput
makepkg -si
```

Could not open playback device error troubleshooting.

```
Setting pipeline to PAUSED ...
AL lib: (EE) ALCplaybackAlsa_open: Could not open playback device 'default': No such file or directory
Pipeline is PREROLLING ...
WARNING: from element /GstPipeline:pipeline0/GstAutoAudioSink:autoaudiosink0: Failed to connect: Connection refused
Additional debug info:
../gst-plugins-good/ext/pulse/pulsesink.c(614): gst_pulseringbuffer_open_device (): /GstPulseSink:autoaudiosink0-actual-sink-pulse
```
Add the localhost 127.0.0.1 to default.pa

/etc/pulse/default.pa
```
### Network access (may be configured with paprefs, so leave this commented
### here if you plan to use paprefs)
#load-module module-esound-protocol-tcp
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
#load-module module-zeroconf-publish
```

Start pulseaudio

```
pulseaudio --start
```

Add username to xpra group.

```
sudo gpasswd -a username xpra
```

## Server Configuration ##

/etc/conf.d/xpra
```
username=:42
```

Fix printing / mdns warnings, enable starting new commands and start an xterm window.

/etc/xpra/xpra.conf
```
start-new-commands            = yes
printing                      = no
mdns                          = no
start                         = xterm
```

Start xpra on boot with username.

/etc/systemd/system/xpra@.service
```
[Unit]
Description=xpra display
[Service]
Type=simple
User=%i
EnvironmentFile=/etc/conf.d/xpra
ExecStart=/usr/bin/xpra --no-daemon start ${%i}
[Install]
WantedBy=multi-user.target
```

Enable/Start systemd service.

```
sudo systemctl enable xpra@username
sudo systemctl start xpra@username
```

Check for warnings or errors in Journal.

```
sudo journalctl -xe  
-- Subject: A start job for unit xpra@username.service has finished successfully
-- Defined-By: systemd
-- Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
--
-- A start job for unit xpra@username.service has finished successfully.
--
-- The job identifier is 1005.
 sudo[1548]: pam_unix(sudo:session): session closed for user root
 audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=xpra@username comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
 kernel: audit: type=1130 audit(1570654998.753:50): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=xpra@username comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
xpra[1553]: WARNING: low display number: 7
xpra[1553]:  You are attempting to run the xpra server
xpra[1553]:  against a low X11 display number: ':7'.
xpra[1553]:  This is generally not what you want.
xpra[1553]:  You should probably use a higher display number
xpra[1553]:  just to avoid any confusion and this warning message.
xpra[1553]: 2019-10-09 17:03:19,040 cannot use uinput for virtual devices:
xpra[1553]: 2019-10-09 17:03:19,040  [Errno 13] Failed to open the uinput device: Permission denied
xpra[1553]: X.Org X Server 1.20.5
xpra[1553]: X Protocol Version 11, Revision 0
xpra[1553]: Build Operating System: Linux Arch Linux
xpra[1553]: Current Operating System: Linux server001 5.3.5-arch1-1-ARCH #1 SMP PREEMPT Mon Oct 7 19:03:08 UTC 2019 x86_64
xpra[1553]: Kernel command line: initrd=\initramfs-linux.img root=/dev/vda3 rw
xpra[1553]: Build Date: 30 June 2019  09:52:01AM
xpra[1553]:
xpra[1553]: Current version of pixman: 0.38.4
xpra[1553]:     	Before reporting problems, check http://wiki.x.org
xpra[1553]:     	to make sure that you have the latest version.
xpra[1553]: Markers: (--) probed, (**) from config file, (==) default setting,
xpra[1553]:     	(++) from command line, (!!) notice, (II) informational,
xpra[1553]:     	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
xpra[1553]: (++) Log file: "/run/user/1000/xpra/Xorg.:7.log", Time: Wed Oct  9 17:03:19 2019
xpra[1553]: (++) Using config file: "/etc/xpra/xorg.conf"
xpra[1553]: (==) Using system config directory "/usr/share/X11/xorg.conf.d"
xpra[1553]: 2019-10-09 17:03:22,684 Warning: some of the sockets are in an unknown state:
xpra[1553]: 2019-10-09 17:03:22,684  /run/user/1000/xpra/server001-7
xpra[1553]: 2019-10-09 17:03:22,685  please wait as we allow the socket probing to timeout
xpra[1553]: 2019-10-09 17:03:28,741 created unix domain socket: /run/user/1000/xpra/server001-7
xpra[1553]: 2019-10-09 17:03:28,745 created unix domain socket: /run/xpra/server001-7
xpra[1553]: 2019-10-09 17:03:28,805 pointer device emulation using XTest
xpra[1553]: 2019-10-09 17:03:28,818 serving html content from: /usr/share/xpra/www
```

## XPRA Client Arch Linux ##

Install XPRA on the client machine.

```
sudo pacman -S xpra
```

Attach XPRA client to XPRA server with SSH.

```
xpra attach --ssh="ssh -p 22" ssh:10.0.10.15
```

## XPRA Client Windows ##

Download the windows client.

https://xpra.org/trac/wiki/Download


Unfinished Section...

Installer for OpenSSL error.
https://slproweb.com/products/Win32OpenSSL.html
