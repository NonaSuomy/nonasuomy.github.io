---
layout: post
title: Arch Linux Infrastructure - Virt-Manager - CYGWin + Windows
---

# CYGWIN + Virt-Manager #

This is to run virt-manager on a windows box metal, instead of using X11 forwarding to a remote window of it.

Download: [https://www.cygwin.com/setup-x86_64.exe](https://www.cygwin.com/setup-x86_64.exe)

Install virt-manager.

Install x11 (I just install the full x11 pack).
 xorg-server
 xinit

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
