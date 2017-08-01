---
layout: post
title: Arch Linux Infrastructure - Virt-Manager - CYGWin + Windows
---

Guide to run virt-manager on a Windows box bare metal, instead of using X11 forwarding to a remote window of virt-manager.

# CYGWIN + Virt-Manager #

Download: [https://www.cygwin.com/setup-x86_64.exe](https://www.cygwin.com/setup-x86_64.exe)

Install Cygwin64.

The bare minimum packages required:

```
X11 => lxqt-openssh-askpass: LXQT SSH password dialog
Net => openssh: The OpenSSH server and client programs
Debug => python-gi-debuginfo: Debug info for python-gi
Python => python-gi-devel: Python GObject Introspection bindings
Python => python2-cairo: Python bindings to libcairo
Python => python2-cairo-devel: Python bindings to libcairo
Python => python3-cairo: Python bindings to libcairo
Python => python3-cairo-devel: Python bindings to libcairo
System => virt-manager: Virtualization manager
X11 => xinit: X.Org X server launcher
X11 => xlaunch: GUI tool for configuring and starting the XWin X server
X11 => xorg-server: X.Org X servers
```

Right click "Cygwin64 Terminal" run as administrator.

or

If you want Cygwin64 to always run as administrator right click the "Cygwin64 Terminal".

Click Properties.

Click Compatibility Tab.

Priviledge Level
 (Check) Run this program as an administrator

**Note:** *If it is disabled click "Change settings for all users" first.*

Then run "Cygwin64 Terminal".

Next create a system link to fix the broken link for askpass in virt-manager, virt-manager points to /usr/sbin/ssh-askpass, cygwin installs it to /bin/lxqt-openssh-askpass.

```
ln -s /bin/lxqt-openssh-askpass /usr/sbin/ssh-askpass
```

## Create A Batch File & Start virt-manager From GUI Icon With askpass ##

lxqt-openssh-askpass (password popup) instead of the terminal password entry below.

Make sure you followed the steps above to add the system link to fix askpass for virt-manager.

Create a batch file to start X11. 

**Note:** *You will see a tray icon next to the windows clock when it loads.*

x11start.bat
```
C:\cygwin64\bin\run.exe /usr/bin/bash.exe -l -c /usr/bin/startxwin
```

If the only reason you have Cygwin64 installed is to run virt-manager you can make it auto start when it runs X11.

Make a file C:\cygwin64\home\<USERNAME>\.startxwinrc

.startxwinrc
```
virt-manager
```

When X11 Loads it will also run virt-manager.

Otherwise run "Virtual Machine Manager" from the "x applications menu on :0" (Taskbar beside the clock CYGWIN logo)

Click ```System Tools => Virtual Machine Manager```

Wait for virt-manager to load...

Add a Hypervisor connection: ```File => Add Connection...```

Click Connect To Remote Host Checkmark.

Type in the IP address to the Hypervisor in the Hostname box.

Click Connect.

Then you should just have to click on your connection and type yes in askpass to add the ssh key and then type the password for the hypervisor into askpass.

## Start virt-manager From GUI Icon With No askpass ##

Run lxterminal from the "x applications menu on :0" (Taskbar beside the clock CYGWIN logo)

Type ```virt-manager --no-fork```

**Note:** *no-fork makes so you don't require the use of openssh-askpass*

Wait for virt-manager to load...

Add a Hypervisor connection: ```File => Add Connection...```

Click Connect To Remote Host Checkmark.

Type in the IP address to the Hypervisor in the Hostname box.

Click Connect.

Look in the LXTerminal window, it should be waiting for you to type your hypervisor password.

You should now see your VM's load.


## Start X11 & lxterminal From a batch file To Run virt-manager ##

Create a batch file to start X11. 

**Note:** *You will see a tray icon next to the windows clock when it loads.*

x11start.bat
```
C:\cygwin64\bin\run.exe /usr/bin/bash.exe -l -c /usr/bin/startxwin
```

Make a file C:\cygwin64\home\<USERNAME>\.startxwinrc

.startxwinrc
```
lxterminal
```

When X11 Loads it will also run lxterminal which you then can just type:

```
virt-manager --no-fork
```

**Note:** *After you click your virtual machine pay attention to the terminal window as you will have to type your hypervisor password there.*

or just ```virt-manager``` if you setup askpass properly above.

## Manual Run From Cygwin64 Terminal ##

If you don't want to configure stuff above just run it all manually.

Load X11 in the background, export x11's display to our current CLI, run virt-manager in that display.

```
startxwin >/dev/null 2>&1 &
export DISPLAY=:0.0
virt-manager --no-fork
```

**Example**

```
windowsuser@windowsbox ~
$ startxwin >/dev/null 2>&1 &
[1] 7840

windowsuser@windowsbox ~
$ export DISPLAY=:0.0

windowsuser@windowsbox ~
$ virt-manager --no-fork
root@10.0.1.10's password:
```

**Note:** *The password prompt will show up after you make a connection in the virt-manager window.*

or just ```virt-manager``` if you setup askpass properly above, which will fire off a GUI password box instead of using the terminal.
