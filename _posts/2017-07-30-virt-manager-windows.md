---
layout: post
title: Arch Linux Infrastructure - Virt-Manager - CYGWin + Windows
---

# CYGWIN + Virt-Manager #

Download: [https://www.cygwin.com/setup-x86_64.exe](https://www.cygwin.com/setup-x86_64.exe)

Install virt-manager

Install x11
 xorg-server
 xinit

run startxwin in cygwin.

run lxterminal from the x applications menu on :0 (Taskbar beside the clock CYGWIN logo)

Type ```virt-manager --no-fork```

Wait for virt-manager to load...

Add a Hypervisor connection: ```File => Add Connection...```

Click Connect To Remote Host Checkmark.

Type in the IP address to the Hypervisor in the Hostname box.

Click Connect.

Look in the LXTerminal window, it should be waiting for you to type your hypervisor password.

You should now see your VM's load.
