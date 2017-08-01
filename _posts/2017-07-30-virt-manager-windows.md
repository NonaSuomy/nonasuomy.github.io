---
layout: post
title: Arch Linux Infrastructure - Virt-Manager - CYGWin + Windows
---

# CYGWIN + Virt-Manager #

This is to run virt-manager on a windows box metal, instead of using X11 forwarding to a remote window of it.

Download: [https://www.cygwin.com/setup-x86_64.exe](https://www.cygwin.com/setup-x86_64.exe)

Install cygwin.

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

Run startxwin in cygwin.

Run lxterminal from the "x applications menu on :0" (Taskbar beside the clock CYGWIN logo)

Type ```virt-manager --no-fork```

Wait for virt-manager to load...

Add a Hypervisor connection: ```File => Add Connection...```

Click Connect To Remote Host Checkmark.

Type in the IP address to the Hypervisor in the Hostname box.

Click Connect.

Look in the LXTerminal window, it should be waiting for you to type your hypervisor password.

You should now see your VM's load.

Or run in cmd/batch file to start x11


x11start.bat
```
C:\cygwin64\bin\run.exe /usr/bin/bash.exe -l -c /usr/bin/startxwin
```

Make a file C:\cygwin64\home\<USERNAME>\.startxwinrc

.startxwinrc
```
lxterminal
```

When X11 Loads it will also run a terminal which you then can just type:

```
virt-manager --no-fork
```

**Note:** *After you click your virtual machine pay attention to the terminal window as you will have to type your hypervisor password there.*

## Manual Run ##

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
