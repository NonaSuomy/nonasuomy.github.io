---
layout: post
title: Arch Linux Infrastructure - Part 6b - Arch Linux Arduino Remote Upload
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutIoT.png "Arch Linux Arduino Remote Upload")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 04a - VM Arch Linux Router - Systemd-networkd](../Infrastructure-Part-4a)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 05a - Arch Linux Asterisk](../Arch-Linux-Asterisk)

[Part 06 - Automation Server - OpenHAB](../Infrastructure-Part-6)

[Part 06a - Automation Server - Home Assistant](../Infrastructure-Part-6a)

[Part 06b - Automation Server - Arduino Remote Upload](../Arch-Linux-Arduino-Remote-Upload) - You are here!

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - NFTables Transparent TOR Proxy / SSH / IRC](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)


# Arduino Remote Upload? #

This is how to upload sketches from a computer to an Arduino board attached to a remote Arch Linux host.

**Warning:** *I have yet to get this working in method 1 or 2 with Leonardo 32U4 as it disconnects and reconnects as a different device and not fast enough for the IDE to communicate before timing out.*

**Note:** *This may work on a UNO, haven't tested it yet*

**TL;DR** *Skip to Method 3 for something that works with the 32U4*

I attempted 3 methods here 

Failed Method 1: Arch/USBIP Server running on the Metal with another Arch/USBIP client attaching.

Failed Method 2: Arch VM Server with a QEMU Arch VM running on top, the Leonardo attached to it with the USB port added to the VM.

Working Method 3: XPRA Session sending the Arduino IDE window over X11.

## Method 1 ##

### Arch Linux Server ###

Install usbip on the server.

```
sudo pacman -S usbip
```

Load kernel modules usbip_host and usbip_core

usbip-host (stub driver) - A server side module which provides a USB device driver which can be bound to a physical USB device to make it exportable.

```
sudo modprobe usbip_core
sudo modprobe usbip_host
```

Make it persistent on boot.

/etc/modules-load.d/usbip.conf
```
usbip_core
usbip_host
```

Enable/Start usbipd

```
sudo systemctl enable usbipd
sudo systemctl start usbipd
```

List connected devices.

**Note:** *You cannot export a USB hub.*

```
usbip list -l
 - busid 1-1 (2341:8036)
   Arduino SA : Leonardo (CDC ACM, HID) (2341:8036)

 - busid 1-4 (0c45:64d2)
   Microdia : Integrated Webcam (0c45:64d2)

 - busid 1-6 (0403:6001)
   Future Technology Devices International, Ltd : FT232 Serial (UART) IC (0403:6001)

 - busid 3-1 (0bc2:ab34)
   Seagate RSS LLC : Backup Plus (0bc2:ab34)
```

Bind the Arduino.

```
usbip bind -b 1-1
usbip: info: bind device on busid 1-1: complete
```

Unbind the Arduino.

```
usbip unbind -b 1-1
```

To make the Arduino pconnect after disconnect/connect, make a udev rule.

/etc/udev/rules.d/91-usbip-server-tools.rules
```
# Auto bind any Leonardo device
SUBSYSTEM=="usb" ATTRS{idVendor}=="2341" ATTRS{idProduct}=="8036" RUN+="/usr/bin/usbip bind -b $kernel"
# Auto bind any FTDI device (well any product that includes an FTDI interface).
#SUBSYSTEM=="usb" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" RUN+="/usr/bin/usbip bind -b $kernel"
# Auto bind a USBTiny ISP
#SUBSYSTEM=="usb" ATTRS{idVendor}=="1781" ATTRS{idProduct}=="0c9f" RUN+="/usr/bin/usbip bind -b $kernel"
```

Unplug the arduino and replug it back in and you should see the message for usbip in dmesg auto map the Arduino.

```
dmesg
[177666.622130] usb 2-1: new full-speed USB device number 6 using xhci_hcd
[177666.765438] usb 2-1: New USB device found, idVendor=2341, idProduct=8036, bcdDevice= 1.00
[177666.765445] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[177666.765449] usb 2-1: Product: Arduino Leonardo
[177666.765453] usb 2-1: Manufacturer: Arduino LLC
[177666.767138] cdc_acm 2-1:1.0: ttyACM0: USB ACM device
[177666.775552] usbip-host 2-1: usbip-host: register new device (bus 2 dev 6)
```

In dmesg for disconnecting it will show the message below. The device number changes every time as to why we use this method with udev so it will auto map the change.

```
[177663.570267] usbip-host 2-1: USB disconnect, device number 5
```

After udev and usbipd are running automatically bind devices (through the udev rule) to USB/IP on coldplug (startup).
(Not sure if this is required or works...)

```
udevadm trigger -action="add" -subsystem-match="usb"
```

## On Arch Linux Workstation ##

Install usbip.

```
sudo pacman -S usbip
```

Load the VHCI kernel module.

usbip-vhci - A client side kernel module which provides a virtual USB Host Controller and allows to import a USB device from a remote machine.

```
sudo modprobe vhci-hcd
```

Persistent after reboot vhci_hcd.

/etc/modules-load.d/usbip.conf
```
vhci_hcd
```

List devices available on the server.

```
usbip list -r <Server IP Address>
Exportable USB devices
======================
 - 10.0.10.5
        1-1: Arduino SA : Leonardo (CDC ACM, HID) (2341:8036)
           : /sys/devices/pci0000:00/0000:00:14.0/usb1/1-1
           : Miscellaneous Device / ? / Interface Association (ef/02/01)
```

Attach the Arduino having the busid 1-1.

```
usbip attach -r 10.0.10.5 -b 1-1
```

Or run a service for it to auto connect.

Auto attach method tests.

```
usbip attach -r 10.0.10.5 -b $(usbip list -r 10.0.10.5 | grep 2341:8036 | awk -F ":" '{print $1}' | sed s/' '//g | grep -v "^$")

usbip detach -p $(usbip port | grep "Port in Use" | awk -F ":" '{print $1}' | sed s/'Port '//g | grep -v "^$")
```

Make a Systemd Service and a script.

```
mkdir -p /var/spool/usbip
sudo chmod 755 /var/spool/usbip
mkdir -p /opt/usbip
```

**Script**

/opt/usbip/usbip-bind.sh
```
#!/bin/bash
# This attaches & removes the Arduino non-stop.
# /usr/lib/systemd/system/usbip-bind.service

SPOOL=/var/spool/usbip/attach

if [[ $1 == "-q" ]]
then
  exec &>/dev/null
fi

touch $SPOOL

while [[ -e $SPOOL ]]
do
  usbiplistdevice="$(/usr/bin/usbip list -r 10.0.10.2 | grep 2341:8036 | awk -F ":" '{print $1}' | sed s/' '//g | grep -v "^$")"
  /usr/bin/usbip attach -r 10.0.10.2 -b "$usbiplistdevice"
  sleep 10
done

usbipunbind="$(/usr/bin/usbip port | grep "Port in Use" | awk -F ":" '{print $1}' | sed s/'Port '//g | grep -v "^$")"
/usr/bin/usbip detach -p "$usbipunbind"

exit 0
```

**Service**

/etc/systemd/system/usbip-bind.service
```
[Unit]
Description=USB-IP Attach - Detach
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/opt/usbip/usbip-bind.sh -q
ExecStop=/bin/rm /var/spool/usbip/attach  ;  /bin/bash -c "while [[ -d /proc/"$MAINPID" ]]; do sleep 1; done"

[Install]
WantedBy=multi-user.target
```

Check out lsusb

```
lsusb
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 002: ID 2341:8036 Arduino SA Leonardo (CDC ACM, HID)
```

Disconnecting Devices

A device can be disconnected only after detaching it on the client.

List attached devices.

```
sudo usbip port

Imported USB devices
====================
Port 00: <Port in Use> at Full Speed(12Mbps)
       Validity Sensors, Inc. : VFS495 Fingerprint Reader (138a:003f)
       3-1 -> usbip://localhost:3240/1-8
           -> remote bus/dev 001/004
```

Detach the device from the client.

```
usbip detach -p <Port Number>
```

Unbind the device on the server.

```
usbip unbind -b <busid>
```

**Note:** *USB/IP by default requires port 3240 to be open. If a firewall is running, make sure that this port is open.*

Man Page: usbip
```
USBIP(8)	System Administration Utilities	USBIP(8)
NAME
usbip - manage USB/IP devices
SYNOPSIS
usbip [options] <command> <args>
DESCRIPTION
On a USB/IP server, devices can be listed, bound, and unbound using this program. On a USB/IP client, devices exported by USB/IP servers can be listed, attached and detached.
OPTIONS
--debug

Print debugging information.
--log

Log to syslog.
--tcp-port PORT

Connect to PORT on remote host (used for attach and list --remote).
COMMANDS
version

Show version and exit.
help [command]

Print the program help message, or help on a specific command, and then exit.
attach --remote=<host> --busid=<bus_id>

Attach a remote USB device.
detach --port=<port>

Detach an imported USB device.
bind --busid=<busid>

Make a device exportable.
unbind --busid=<busid>

Stop exporting a device so it can be used by a local driver.
list --remote=<host>

List USB devices exported by a remote host.
list --local

List local USB devices.
EXAMPLES
client:# usbip list --remote=server - List exportable usb devices on the server.
client:# usbip attach --remote=server --busid=1-2 - Connect the remote USB device.

client:# usbip detach --port=0 - Detach the usb device.
```

Man Page: usbipd
```
USBIPD(8)	System Administration Utilities	USBIPD(8)
NAME
usbipd - USB/IP server daemon
SYNOPSIS
usbipd [options]
DESCRIPTION
usbipd provides USB/IP clients access to exported USB devices.
Devices have to explicitly be exported using usbip bind before usbipd makes them available to other hosts.

The daemon accepts connections from USB/IP clients on TCP port 3240 by default.

OPTIONS
-4, --ipv4

Bind to IPv4. Default is both.
-6, --ipv6

Bind to IPv6. Default is both.
-D, --daemon

Run as a daemon process.
-d, --debug

Print debugging information.
-PFILE, --pid FILE

Write process id to FILE. 
If no FILE specified, use /var/run/usbipd.pid
-tPORT, --tcp-port PORT

Listen on TCP/IP port PORT.
-h, --help

Print the program help message and exit.
-v, --version

Show version.
LIMITATIONS
usbipd offers no authentication or authorization for USB/IP. Any USB/IP client can connect and use exported devices.
EXAMPLES
server:# modprobe usbip
server:# usbipd -D - Start usbip daemon.

server:# usbip list --local - List driver assignments for usb devices.

server:# usbip bind --busid=1-2 - Bind usbip-host.ko to the device of busid 1-2. - A usb device 1-2 is now exportable to other hosts! - Use 'usbip unbind --busid=1-2' when you want to shutdown exporting and use the device locally.
```

## Troubleshooting ##

*Trouble*

```
libusbip: error: udev_device_new_from_subsystem_sysname failed
usbip: error: open vhci_driver
```

*Shoot*

```
lsmod | grep vhci_hcd
```

Nothing shows up?

```
sudo modprobe vhci_hcd

lsmod | grep vhci_hcd
vhci_hcd               57344  0
usbip_core             36864  2 usbip_host,vhci_hcd
```

## Windows USBIP ##

Usbip for Windows (Never tested likely similar process).

https://sourceforge.net/projects/usbip/files/usbip_windows/

## Arduino IDE ##

Install Arduino IDE

```
sudo pacman -S arduino
```

or

https://www.arduino.cc/en/Main/Software

Add username to uucp and lock.

```
sudo usermod --append --groups uucp,lock username
```

Logout of your user account and back in for group settings to take effect.

The Lenardo attaches as ttyACM0 normally.

Select the correct /dev/ttyACM0 port in Arduino IDE.

Upload a sketch.

Failure: Programmer timeout waiting for port to reappear.

Same issue with the Online IDE ...

## Arduino Create Bridge ##

### Resources ###

https://create.arduino.cc/editor

### Dependencies ###

Install libappindicator-gtk3.

```
sudo pacman -S libappindicator-gtk3
```

Download the bleeding edge Agent.

```
wget http://downloads.arduino.cc/CreateBridge/staging/ArduinoCreateAgent-1.0-linux-x64-installer.run
sudo chmod +x ArduinoCreateAgent-1.0-linux-x64-installer.run
```

Install.

```
./ArduinoCreateAgent-1.0-linux-x64-installer.run
```



```

INFO[0000] Version:1.0.317-dev                          
INFO[0000] Hostname: Unknown                            
INFO[0000] Garbage collection is on using Standard mode, meaning we just let Golang determine when to garbage collect. 
INFO[0000] You specified a serial port regular expression filter: usb|acm|com 
INFO[0000] Your serial ports:                           
INFO[0000] 	{/dev/ttyACM0    0x8036 0x2341  false}      
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /                         --> main.homeHandler (2 handlers)
[GIN-debug] GET    /certificate.crt          --> main.certHandler (2 handlers)
[GIN-debug] DELETE /certificate.crt          --> main.deleteCertHandler (2 handlers)
[GIN-debug] POST   /upload                   --> main.uploadHandler (2 handlers)
[GIN-debug] GET    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] POST   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WS     /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WSS    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] GET    /info                     --> main.infoHandler (2 handlers)
[GIN-debug] POST   /killbrowser              --> main.killBrowserHandler (2 handlers)
[GIN-debug] POST   /pause                    --> main.pauseHandler (2 handlers)
[GIN-debug] POST   /update                   --> main.updateHandler (2 handlers)
[GIN-debug] GET    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] POST   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PUT    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PATCH  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] HEAD   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] OPTIONS /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] DELETE /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] CONNECT /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] TRACE  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8991

(Arduino_Create_Bridge:24604): libappindicator-WARNING **: 05:13:32.271: Unable to get the session bus: Error spawning command line “dbus-launch --autolaunch=76ce0443e11c4cf1a6d8e7b4d561b35f --binary-syntax --close-stderr”: Child process exited with code 1

(Arduino_Create_Bridge:24604): LIBDBUSMENU-GLIB-WARNING **: 05:13:32.271: Unable to get session bus: Error spawning command line “dbus-launch --autolaunch=76ce0443e11c4cf1a6d8e7b4d561b35f --binary-syntax --close-stderr”: Child process exited with code 1
INFO[0000] Version:1.0.317-dev                          
INFO[0000] Hostname: Unknown                            
INFO[0000] Garbage collection is on using Standard mode, meaning we just let Golang determine when to garbage collect. 
INFO[0000] You specified a serial port regular expression filter: usb|acm|com 
INFO[0000] Your serial ports:                           
INFO[0000] 	{/dev/ttyACM0    0x8036 0x2341  false}      
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /                         --> main.homeHandler (2 handlers)
[GIN-debug] GET    /certificate.crt          --> main.certHandler (2 handlers)
[GIN-debug] DELETE /certificate.crt          --> main.deleteCertHandler (2 handlers)
[GIN-debug] POST   /upload                   --> main.uploadHandler (2 handlers)
[GIN-debug] GET    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] POST   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WS     /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WSS    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] GET    /info                     --> main.infoHandler (2 handlers)
[GIN-debug] POST   /killbrowser              --> main.killBrowserHandler (2 handlers)
[GIN-debug] POST   /pause                    --> main.pauseHandler (2 handlers)
[GIN-debug] POST   /update                   --> main.updateHandler (2 handlers)
[GIN-debug] GET    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] POST   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PUT    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PATCH  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] HEAD   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] OPTIONS /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] DELETE /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] CONNECT /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] TRACE  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8991
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8991
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8992
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8992
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8992: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8992: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8993

(Arduino_Create_Bridge:25055): libappindicator-WARNING **: 05:13:34.451: Unable to get the session bus: Error spawning command line “dbus-launch --autolaunch=76ce0443e11c4cf1a6d8e7b4d561b35f --binary-syntax --close-stderr”: Child process exited with code 1

(Arduino_Create_Bridge:25055): LIBDBUSMENU-GLIB-WARNING **: 05:13:34.451: Unable to get session bus: Error spawning command line “dbus-launch --autolaunch=76ce0443e11c4cf1a6d8e7b4d561b35f --binary-syntax --close-stderr”: Child process exited with code 1
INFO[0002]  id=ng4U4V6R req=HEAD /v2/pkgs/tools/installed from=127.0.0.1 
INFO[0002]  id=ng4U4V6R status=200 bytes=119 time=333.018µ
```

Ignore the MDNS errors of address already in use etc not required for what we're doing.

**Note:** *1.1 (1.0.XXLowerVersion) is the official release. 1.0 (1.0.HigherVersion-dev) is the dev latest release above.*

Start the Arduino_Create_Bridge

```
~/ArduinoCreateAgent-1.0/Arduino_Create_Bridge_cli                                                        

INFO[0000] Version:1.0.317-dev                          
INFO[0000] Hostname: Unknown                            
INFO[0000] Garbage collection is on using Standard mode, meaning we just let Golang determine when to garbage collect. 
INFO[0000] You specified a serial port regular expression filter: usb|acm|com 
INFO[0000] Your serial ports:                           
INFO[0000] 	{/dev/ttyACM0    0x8036 0x2341  false}      
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /                         --> main.homeHandler (2 handlers)
[GIN-debug] GET    /certificate.crt          --> main.certHandler (2 handlers)
[GIN-debug] DELETE /certificate.crt          --> main.deleteCertHandler (2 handlers)
[GIN-debug] POST   /upload                   --> main.uploadHandler (2 handlers)
[GIN-debug] GET    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] POST   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WS     /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WSS    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] GET    /info                     --> main.infoHandler (2 handlers)
[GIN-debug] POST   /killbrowser              --> main.killBrowserHandler (2 handlers)
[GIN-debug] POST   /pause                    --> main.pauseHandler (2 handlers)
[GIN-debug] POST   /update                   --> main.updateHandler (2 handlers)
[GIN-debug] GET    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] POST   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PUT    /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] PATCH  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] HEAD   /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] OPTIONS /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] DELETE /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] CONNECT /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] TRACE  /v2/*path                 --> github.com/arduino/arduino-create-agent/vendor/github.com/gin-gonic/gin.WrapH.func1 (2 handlers)
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8991
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8991
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8992
http: TLS handshake error from 127.0.0.1:37244: tls: first record does not look like a TLS handshake
http: TLS handshake error from 127.0.0.1:37262: tls: first record does not look like a TLS handshake
INFO[0000]  id=EOr2PMct req=HEAD /v2/pkgs/tools/installed from=127.0.0.1 
INFO[0000]  id=EOr2PMct status=200 bytes=3 time=325.191µs 
INFO[0000]  id=Q9y6oN74 req=HEAD /v2/pkgs/tools/installed from=127.0.0.1 
INFO[0000]  id=Q9y6oN74 status=200 bytes=3 time=93.226µs 
http: TLS handshake error from 127.0.0.1:37372: tls: first record does not look like a TLS handshake
INFO[0328]  id=SuF5O2cj req=HEAD /v2/pkgs/tools/installed from=127.0.0.1 
INFO[0328]  id=SuF5O2cj status=200 bytes=119 time=275.407µs
```

Then restart Chromium and all of a sudden you should see “Arduino " Connected! if you had the Arduino plugged in, w00t.

## Troubleshooting ##

**Trouble**

Problem running post-install step. Installation may not complete correctly
Error running /home/username/ArduinoCreateAgent-1.0/Arduino_Create_Bridge -generateCert=true: /home/username/ArduinoCreateAgent-1.0/Arduino_Create_Bridge: error while loading shared libraries: libappindicator3.so.1: cannot open shared object file: No such file or directory

**Shoot**

Install libappindicator-gtk3.

```
sudo pacman -S libappindicator-gtk3
```

**Trouble**

Problem running post-install step. Installation may not complete correctly
Error running /home/username/ArduinoCreateAgent-1.0/certmanager.sh /home/username/ArduinoCreateAgent-1.0/ca.cert.pem: Error creating textual authentication agent: Error opening current controlling terminal for the process (`/dev/tty'): No such device or address

**Shoot**

Run the ArduinoCreateAgent-1.0-linux-x64-installer.run from the console it will then ask for a password for you to type in.

**Trouble**

Problem running post-install step. Installation may not complete correctly
Error running /home/username/ArduinoCreateAgent-1.0/certmanager.sh /home/username/ArduinoCreateAgent-1.0/ca.cert.pem: polkit-agent-helper-1: error response to PolicyKit daemon: GDBus.Error:org.freedesktop.PolicyKit1.Error.Failed: No session for cookie
Error executing command as another user: Not authorized
This incident has been reported.

**Shoot**

Some stuff here: https://github.com/NixOS/nixpkgs/issues/18012 but forget it and just manually copy the cert.

Copy Cert & Update Trust

```
sudo cp ~/ArduinoCreateAgent-1.0/ca.cert.cer /usr/share/ca-certificates/trust-source/anchors/
sudo update-ca-trust
```

Then restart Arduino_Create_Bridge

```
ArduinoCreateAgent-1.0]$ sudo ./Arduino_Create_Bridge
```

Then restart Chromium and all of a sudden you should see “Arduino Connected!" if you had the Arduino plugged in, w00t.

**Trouble**

Can't find the cert to copy...

**Shoot**

You maybe installed the 1.1 release installer instead of the 1.0 debug installer.

## Method 2 ##

Attach usb to QEMU VM.

Open virt-manager and attach to your VM Host.

Click add hardware.

Click USB Host Device.

Click 002:008 Arduino SA Leonardo (CDC ACM, HID) etc.

Click Finish.

You should now see the Arduino under lsusb.

**Note:** *You can hot attach the usb device while the VM is running.*

Load the Arduino IDE and attempt programming.

Device disconnects and can't find a way to auto attach it again without going back and removing and adding the hardware again which by this time were already timed out in the IDE for programming.

Attempted to edit this file and recompile the Arduino IDE to extend the timeout with no luck maybe I didn't change the right values?

[SerialUploader.java#L213](https://github.com/arduino/Arduino/blob/master/arduino-core/src/cc/arduino/packages/uploaders/SerialUploader.java#L213)

[SerialUploader.java#L232](https://github.com/arduino/Arduino/blob/master/arduino-core/src/cc/arduino/packages/uploaders/SerialUploader.java#L232)

[SerialUploader.java#L269](https://github.com/arduino/Arduino/blob/master/arduino-core/src/cc/arduino/packages/uploaders/SerialUploader.java#L269)

I changed them to 20000, which seems to wait long enough to re-find the port but then gives a butterfly programmer error instead of the timeout.

```
sudo pacman -S ant gcc git make
mkdir code
cd ~/Code
git clone https://github.com/arduino/Arduino.git
```

Update to the latest sources with the git pull command if you want to compile on another occasion. 

```
git pull
```

Compile Arduino Sources

```
cd Arduino/build
ant dist
```

Enter build number (Just press enter).

```
[input] Enter version number: [1.8.10] < Just Press [Enter]
BUILD SUCCESSFUL
Total time: 1 minutes 5 seconds
```

## Method 3 - Worked ##

**Note:** *Make sure you remove all the things done in prior methods otherwise the device won’t show up in the Xpra streaming Arduino IDE session.*

Install XPRA on the Arch Server and just attach to device normally.

After the xterm terminal opens type “arduino” to load the IDE.

[Arch Linux XPRA](../Arch-Linux-XPRA)

**Trouble**

jre13-openjdk breaks crashes Arduino IDE on startup.

https://bugs.archlinux.org/task/64081

```
Picked up JAVA_TOOL_OPTIONS:
java.lang.ExceptionInInitializerError
	at processing.app.helpers.PreferencesMap.load(PreferencesMap.java:100)
	at processing.app.helpers.PreferencesMap.load(PreferencesMap.java:74)
	at processing.app.PreferencesData.init(PreferencesData.java:56)
	at processing.app.BaseNoGui.initParameters(BaseNoGui.java:835)
	at processing.app.Base.<init>(Base.java:213)
	at processing.app.Base.main(Base.java:151)
Caused by: java.lang.StringIndexOutOfBoundsException: begin 0, end 3, length 2
	at java.base/java.lang.String.checkBoundsBeginEnd(String.java:3720)
	at java.base/java.lang.String.substring(String.java:1909)
	at processing.app.legacy.PApplet.<clinit>(PApplet.java:38)
	... 6 more
```

**Shoot**

**Note:** *If you don’t have Java installed yet the Arduino package will ask you if you want jre11-openjdk installed pick that one to save the hassle.*

Install jre11-openjdk.

```
sudo pacman -S jre11-openjdk
```

Check installed Java environments.

```
archlinux-java status

Available Java environments:
java-11-openjdk
java-13-openjdk (default
```

Change Java Version.

```
sudo archlinux-java set java-11-openjdk
```

**Trouble**

Upload permission denied.

**Shoot**

You may have just resently added your user to the groups uucp and lock, you now need to restart the Xpra service and or add the xpra user to those groups.
