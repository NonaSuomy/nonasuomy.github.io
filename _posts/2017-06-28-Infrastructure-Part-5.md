---
layout: post
title: Arch Linux Infrastructure - VoIP Server - Part 5 - VoIPServer
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVoIP.png "Infrastructure Switch")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router ](../Infrastructure-Part-5)

Part 05 - VoIP Server - You Are Here!

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - Underconstruction](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# VoIP Server Setup #

## Start i3-WM ##

```
startx
```

### Open Terminal (urxvt) ###

Alt + Enter

### Change Directory To Hypervisor Media Installs ###

```
cd /var/lib/libvirt/images/iso
```

### Download Install Media ###

### Find the latest version ### 

#### PIAF ####

**Note:** *This won't work for a UEFI install use manual install of Scientific Linux 7*

https://sourceforge.net/projects/pbxinaflash/files/

```
sudo wget https://downloads.sourceforge.net/project/pbxinaflash/IncrediblePBX13-12%20with%20Incredible%20PBX%20GUI/IncrediblePBX13.2.iso
```

#### Scientific Linux 7 ####

http://ftp1.scientificlinux.org/linux/scientific/7x/x86_64/iso/

```
sudo wget http://ftp1.scientificlinux.org/linux/scientific/7x/x86_64/iso/SL-7.3-x86_64-netinst.iso
```

### Verify Interfaces Have Been Created ###

Check that we have the interfaces brv500 and eno1.500 from the previous step setup (Voice VLAN). 

```
ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
3: brv500: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 9a:de:fd:00:4c:9c brd ff:ff:ff:ff:ff:ff
4: brv450: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether b2:40:b2:19:5d:b2 brd ff:ff:ff:ff:ff:ff
5: brv400: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 82:f9:79:52:52:f5 brd ff:ff:ff:ff:ff:ff
6: brv300: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ce:0c:c4:f6:9b:41 brd ff:ff:ff:ff:ff:ff
7: brv200: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 56:9c:3a:04:c4:f8 brd ff:ff:ff:ff:ff:ff
8: brv100: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ae:df:f9:a5:92:e9 brd ff:ff:ff:ff:ff:ff
9: eno1.200@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv200 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
10: eno1.300@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv300 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
11: eno1.400@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv400 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
12: eno1.500@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv500 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
13: eno1.450@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv450 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
14: eno1.100@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master brv100 state UP mode DEFAULT group default qlen 1000
    link/ether f0:1f:af:32:66:4f brd ff:ff:ff:ff:ff:ff
```

### Start virt-manager ###

```
sudo virt-manager
```

virt-manager should now be on screen...

You should be connected to your hypervisor.

Click File => New Virtual Machine

```
New VM
Create a new virtual machine
Step 1 of 5

Connection: QEMU/KVM

Choose how you would like to install the operating system
* Local install media (ISO image or CDROM)
* Network Install (HTTP,FTP, or NFS)
* Network Boot (PXE)
* Import existing disk image
```

Choose local install media and click Forward

```
New VM
Create a new virtual machine
Step 2 of 5

Locate your install media
* Use CDROM or DVD
  No device present
* Use ISO image:
  ComboBox V Browse...
Automatically detect operating system based on install media
OS type: -
Version: -
```

Click Browse

You should see the iso storage pool on the left, click it.

Then click your Scentific Linux 7 ISO.

Then click "Choose Volume".

Leave Automatically detect checked and click Forward.

```
New VM
Create a new virtual machine
Step 3 of 5

Choose Memory and CPU settings
Memory (RAM): 1024 - + MiB
CPUs: 1 - +
Up to 4 available
```

Click Forward

```
New VM
Create a new virtual machine
Step 4 of 5

Enable storage for this virtual machine
* Create a disk image for the virtual machine
  20.0 - + GiB
  1000 GiB available in the default location
* Select or create custom storage
  Manage...
```

Click Forward

```
New VM
Create a new virtual machine
Step 5 of 5

Ready to begin the installation
Name: VoIPServer
OS: Generic
Install: Local CDROM/ISO
Memory: 1024 MiB
CPUs: 1
Storage: 10.0 GiB /var/lib/libvirt/images/VirtualRouter.qcow2
X Customize configuration before install

Network selection
* Specify shared device name
  Bridge name: brv500
```

Click the checkmark on "Customize configuration before install".

Click the "Network selection" drop down arrow.

Click the Dropdown Box and select "Specify shared device name"

Bridge name: brv500

Click Finish

Now you should see the full virtual machine settings window.

```
VoIPServer on QEMU/KVM
Begin Installation    Cancel Installaion

Overview
CPUs
Memory
Boot Options
IDE Disk 1
IDE CDROM 1
NIC :fe:ed:50
Mouse
Display Spice
Sound: ich6
Console
Channel spice
Video QXL
Controller USB
USB Redirector 1
USB Redirector 2

Add Hardware

Basic Details
   Name: VoIPServre
   UUID: xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   Status: Shutoff (Shut Down)
   Title:
   Description:
Hypervisor Details
   Hypervisor: KVM
   Achitecture: x86_64
   Emulator: /usr/sbin/qemu-system-x86_64
   Firmware: UEFI x86_64: /usr/share/ovmf/ovmf_code_x64.bin
   Chipset: i440FX
   
Cancel Apply
```

Click Firmware change BIOS to UEFI x86_64: /usr/share/ovmf/ovmf_code_x64.bin

**Note:** *You only get one chance to change this Firmware field, it will go readonly after you Begin the Installaion.*

Click on CPUs at the left.

```
CPUs
  Logical host CPUs: 4
  Current allocation: 1 - +
  Maximum allocation: 1 - +
Configuration
  X Copy host CPU configuration
v Topology
  Manually set CPU topology
  Sockets: 1 - +
  Cores: 1 - +
  Threads: 1 - +
```

Click the Copy host CPU configuration check box.

Click on Boot Options

```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE CDROM 1
  X IDE Disk 1
  NIC :fe:ed:50
  ...
V Direct kernel boot
  Enable direct kernel boot
  Kernel path:
  Initrd path:
  Kernel args:
```

Click on IDE CDROM 1

```
Virual Disk
  Sorce path: - Connect
  Device type: IDE CDROM 1
  Storage size: -
  Readonly: X
  Shareable:
V Advanced options
  Disk bus: IDE
  Serial number:
  Storage format: raw
V Performance options
  Cache mode: Hypervisor default
  IO mode: Hypervisor default
```

Click on Connect

```
Choose Media
Choose Source Device or File
  X ISO Image Location
    Location: Browse
  CD-ROM or DVD
    Device Media: No device present
```

Click on Browse

```
Choose Storage Volume

default
Filesystem Directory

iso
Filesystem Directory 

Size: 145.24 GiB Free / 140.32 GiB in Use
Location: /var/lib/libvirt/images/iso

Volumes + @ X

Volumes                                   Size         Format
archlinux-2017.06.01-x86_64.iso           488.00 MiB   iso
IncrediblePBX13.2.iso                     849.00 MiB   iso
OPNsense-17.1.4-OpenSSL-cdrom-amd64.iso   858.43 MiB   iso
pfSense-CE-2.3.4-RELEASE-amd64.iso        626.79 MiB   iso
```

Click on Scientific Linux iso then click Choose Volume

Click OK

```
Virual Disk
  Sorce path: /var/lib/libvirt/images/iso/SL-7.3-x86_64-netinst.iso  Disconnect
  Device type: IDE CDROM 1
  Storage size: 858.43 MiB
  Readonly: X
  Shareable:
```

Make sure the IDE CDROM 1 is at the top of the Boot device order.

Click on NIC :xx:xx:50

```
Virtual Network Interface
Network source: Specify shared device name
                Bridge name: brv500
Device model: virtio
MAC address: X 42:de:ad:fe:ed:50
```

Click Apply.

We just setup this virtual machine interface so that is uses the Voice VLAN bridge setup prior.

Click on Display Spice

```
Spice Server
  Type: Spice server
  Listen type: Address
  Address: Hypervisor default
  Port: X Auto
  Password: 
  Keymap:
```

Change to VNC server

```
VNC Server
  Type: VNC server
  Listen type: Address
  Address: All interfaces
  Port: X Auto
  Password: 
  Keymap:
```

Click Apply.

Finally click "Begin Installation" at the top left.

After the VM boots ...

Click your language preference.

Click Continue.

Under System click Network & Host Name.

Click Ethernet (eth0) ON.

Host name: voipserv.localdomain click apply.

Click Done.

Click Software Selection Minimal install.

Click Done.

Under System click Installation Destination.

Select your vitual disk ATA QEMU HARDDISK.

Leave Automatically configure partitioning.

Click Done.

Click Begin Installation.

Under User Settings click Root Password.

Set your root password.

Click Done.

Click User Creation.

Setup a regular user with administration permissions checked.

Wait for install to finish...

Click Reboot.

The machine will power off.

Click the Light Bulb (Show virtual hardware details).

Click on "Boot Options" and change the order "IDE Disk 1" to be first and Disconnect the "IDE CDROM 1" mounted iso.
 
```
Autostart
  X Start virtual machine on host boot up
Boot device order
  X Enable boot menu
  X IDE Disk 1
  X IDE CDROM 1
  NIC :fe:ed:50
  ...
```
Click Apply.

Click IDE CDROM 1.

```
Virtual Disk
   Source path: /var/lib/libvirt/images/iso/SL-7.3-x86_64-netinst.iso   Disconnect
```

Click Disconnect.

Click Show the graphical console.

Click Play button "Power on the virtual machine" again.

You will now be at the login console.

```
Scientific Linux 7.3 (Nitrogen)
Kernel 3.10.0-514.26.1.e17.x86_64 on an x86_64

voipserv login:
```

Type root and the password you setup in the install process.

```
voipserv login: root
Password: PlebMast0r
[root@voipserv ~]#
```

### Install some tools and updates/patch ###

```
setenforce 0
yum -y install net-tools nano wget tar
yum -y upgrade --skip-broken

# decipher your server's IP address
ifconfig

# patch grub and ignore errors if your server doesn't use it
sed -i 's|quiet|quiet net.ifnames=0 biosdevdame=0|' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# for older CentOS/SL 6.7 platforms, perform 3 steps below:
#wget http://incrediblepbx.com/update-kernel-devel
#chmod +x update-kernel-devel
#./update-kernel-devel

reboot
```

### Install IncrediblePBX13 ###

```
cd /root
wget http://incrediblepbx.com/incrediblepbx13-12.2-centos.tar.gz
tar zxvf incrediblepbx*
./create-swapfile-DO
./IncrediblePBX*
```

The Incredible PBX installer runs unattended so find something to do for the next 30-60 minutes unless you just like watching over 1000 packages install. When the installation is complete, reboot your server and log back in as root. You should be greeted by something like the status of the major apps as well as your free RAM and DISK space and IP.

**Note:** *I did two installs on SL73 and with both none of the commands were there below, asterisk -rvvvvvvv wasn' t there, couldn't access the WebGUI, Ran the installer a second time  ```./IncrediblePBX*``` then it downloaded even more stuff and finally I saw it compiling asterisk and then everything seemed to work.

After installation completes you should get some text that says so then asks you to hit enter to reboot if everything went well.

```
This update utility goes to IncrediblePBX.com to retrieve the latest updates.
We test updates before release, but NO WARRANTY EXPRESS OR IMPLIED IS PROVIDED.
The first 10 updates are free. Calendar year update license is $20 per machine.
To sign up and make payment using a credit card, go to: http://nerd.bz/QwQkYO
 
To proceed solely at your own risk, press Enter. Otherwise, Ctrl-C to abort.
```

Push Enter, more stuff will update and install.

```
WARNING: Always run Incredible PBX behind a secure hardware-based firewall.
root@voipserv:~ $
```

Type: ls

```
ls
add-fqdn            del-acct          incrediblefax11.sh                    knock.FAQ        odbcinst.ini          smsblaster                           status7               update-speeddial
add-ip              DMI               incrediblepbx13-12.2-centos.tar.gz    licenses.sh      perl5                 smsdictator                          timezone-setup        upgrade-asterisk13-to-current-rhel
admin-pw-change     favicon.ico       IncrediblePBX13-12R.sh                logos-b-gone     pptp-install          smslist.txt                          tm4                   upgrade-asterisk13-to-current-ubuntu
avantfax-pw-change  GPG-patch         incrediblepbx-install-log-phase1.txt  neorouter-login  pygooglevoice         smsmsg.txt                           tm4-update            webmin-1.791-1.noarch.rpm
COPYING             iaxmodem-restart  incrediblerestore                     odbc-gen.sh      res_odbc_custom.conf  spandsp-0.0.6-35.1.x86_64.rpm        update-IncrediblePBX  wolfram
create-swapfile-DO  incrediblebackup  ipchecker                             odbc.ini         smsblast              spandsp-devel-0.0.6-35.1.x86_64.rpm  update-passwords
```

You should see a lot more files in the /root folder now like above.

### Finalization ###

Make your root password very secure: 

```
passwd
Changing password for user root.
New password:  PlebMast0r
Retype new password:  PlebMast0r
passwd: all authentication tokens updated successfully.
```

Create admin password for GUI access: 

```
/root/admin-pw-change
This script changes your admin password for FreePBX 2.11 access.
 
Enter new admin password (MAKE IT SECURE!!):  PlebMast0r2

admin password will be changed to:  PlebMast0r2
Press ENTER key to continue or Ctrl-C to abort...

Done. Use browser to access FreePBX at http://
```

Set your correct time zone: 

```
/root/timezone-setup
Please identify a location so that time zone rules can be set correctly.
Please select a continent or ocean.
1) Africa	     4) Arctic Ocean	 7) Australia	    10) Pacific Ocean
2) Americas	     5) Asia		 8) Europe
3) Antarctica	     6) Atlantic Ocean	 9) Indian Ocean
#?
Please select a country.
 1) Anguilla		  19) Dominican Republic    37) Peru
 2) Antigua & Barbuda	  20) Ecuador		    38) Puerto Rico
 3) Argentina		  21) El Salvador	    39) St Barthelemy
 4) Aruba		  22) French Guiana	    40) St Kitts & Nevis
 5) Bahamas		  23) Greenland		    41) St Lucia
 6) Barbados		  24) Grenada		    42) St Maarten (Dutch)
 7) Belize		  25) Guadeloupe	    43) St Martin (French)
 8) Bolivia		  26) Guatemala		    44) St Pierre & Miquelon
 9) Brazil		  27) Guyana		    45) St Vincent
10) Canada		  28) Haiti		    46) Suriname
11) Caribbean NL	  29) Honduras		    47) Trinidad & Tobago
12) Cayman Islands	  30) Jamaica		    48) Turks & Caicos Is
13) Chile		  31) Martinique	    49) United States
14) Colombia		  32) Mexico		    50) Uruguay
15) Costa Rica		  33) Montserrat	    51) Venezuela
16) Cuba		  34) Nicaragua		    52) Virgin Islands (UK)
17) Curaçao		  35) Panama		    53) Virgin Islands (US)
18) Dominica		  36) Paraguay
#? 
Please select one of the following time zone regions.
 1) Newfoundland; Labrador (southeast)	15) Central - NU (Resolute)
 2) Atlantic - NS (most areas); PE	16) Central - NU (central)
 3) Atlantic - NS (Cape Breton)		17) CST - SK (most areas)
 4) Atlantic - New Brunswick		18) CST - SK (midwest)
 5) Atlantic - Labrador (most areas)	19) Mountain - AB; BC (E); SK (W)
 6) AST - QC (Lower North Shore)	20) Mountain - NU (west)
 7) Eastern - ON, QC (most areas)	21) Mountain - NT (central)
 8) Eastern - ON, QC (no DST 1967-73)	22) Mountain - NT (west)
 9) Eastern - ON (Thunder Bay)		23) MST - BC (Creston)
10) Eastern - NU (most east areas)	24) MST - BC (Dawson Cr, Ft St John)
11) Eastern - NU (Pangnirtung)		25) MST - BC (Ft Nelson)
12) EST - ON (Atikokan); NU (Coral H)	26) Pacific - BC (most areas)
13) Central - ON (west); Manitoba	27) Pacific - Yukon (south)
14) Central - ON (Rainy R, Ft Frances)	28) Pacific - Yukon (north)
#? 

The following information has been given:

	Americas
	

Therefore TZ='Americas' will be used.
Local time is now:	
Universal Time is now:	
Is the above information OK?
1) Yes
2) No
#? 1
Updating time zone to Americas for your server...
Restarting Apache...
Redirecting to /bin/systemctl restart  httpd.service
Done.
```

Create admin password for web apps: 

```
htpasswd /etc/pbx/wwwpasswd admin
New password:  PlebMast0r3
Re-type new password:  PlebMast0r3
Updating password for user admin
```

Make a copy of your Knock codes: 

```
cat /root/knock.FAQ
Knock ports for access to xxx.xxx.xxx.xxx set to TCP: 1337 1338 1339
UPnP activation attempted for UDP 5060 and your knock ports above.
To enable knockd on your server, issue the following commands:
  chkconfig --level 2345 knockd on
  service knockd start
To enable remote access, issue these commands from any remote server:
nmap -p 1337 xxx.xxx.xxx.xxx && nmap -p 1338 xxx.xxx.xxx.xxx && nmap -p 1339 xxx.xxx.xxx.xxx
Or install iOS PortKnock or Android DroidKnocker on remote device.
```

Decipher IP address and other info about your server: 

```
status

Incredible PBX 13-12.3 for Sci Linux v.7/64

Asterisk: UP          Apache: UP          MariaDB: UP
SendMail: UP        IPtables: UP         SSH: UP
LAN port: UP        Fail2Ban: UP         Webmin: UP

RAM: 144M    Sci Linux v.7/64    Disk: 8.8G

Asterisk 13.13.1      Incredible GUI 12.0.39

Private IP: 192.168.1.106

Public IP: XXX.XXX.XXX.XXX

System Time: Thu Jun 29 2017
```

Open a web browser, we installed chromium and firefox so pick your poison and enter http://192.168.1.106

Click the User/Admin switch at the bottom left to Admin then click Incredible PBX Administration.

Then click Incredible PBX Administration again and login with your admin set password above.

You should now be in and looking at Welcome to Incredible PBX screen with status boxes of your PBX box.

From here it's up to you what you want to do with the box.

### These are items I setup ###

#### OSS End Point Manager ####

This will manage the configuration and firmware of our Hardware VoIP Sets.

Click Admin => Module Admin top left.

Click "Check Online" button.

Scroll down the list to 

```
Connectivity

 Custom Contexts Stable Not Installed (Available online: 2.11.0.1)  
 DAHDi Config Stable Schmooze Com Inc GPLv3+ Not Installed (Available online: 2.11.52)  
 Digium Phones Config 2.11.2.3 Stable Digium GPLv2 Enabled; Not available online  
 Google Voice/Chan Motif 12.0.4 Stable Schmooze Com Inc GPLv3+ Enabled and up to date  
 OSS PBX End Point Manager Stable GPLv2+ Not Installed (Available online: 2.11.9)  
 WebRTC Phone 12.0.2 Stable Schmooze Com Inc GPLv3+ Enabled; Not available online  
```

Click on OSS PBX End Point Manager

```
Info
Changelog
Previous
License:	GPLv2+
Description:	OSS PBX End Point Manager is the free supported PBX Endpoint Manager for FreePBX. It is ***NOT*** supported by Schmoozecom. If you are looking for a supported endpoint manager please look into the Commercial Endpoint Manager by Schmoozecom, INC. The front end gui is hosted at: https://github.com/FreePBX/endpointman The backend configurator is hosted at: https://github.com/provisioner/Provisioner Pull Requests can be made to either of these and are encouraged.
More info:	Get help for OSS PBX End Point Manager
Track:	Stable
Action:	No Action Download and Install
```

Click Download and Install toggle button.

Click "Process" button on the top right.

```
Module Administration
Please confirm the following actions:

Upgrades, installs, enables and disables:

OSS PBX End Point Manager 2.11.9 will be downloaded and installed and switched to the stable track
```

Click Confirm.

```
Status
close
Please wait while module actions are performed

Upgrading endpointman to 2.11.9 from track stable
Downloading endpointman 365823 of 365823 (100%)

Installing endpointman
Untarring..Done
Endpoint Manager Installer
Creating Phone Modules Directory
Moving Auto Provisioner Class
Creating temp folder
Creating Brand List Table
Creating Line List Table
Creating Global Variables Table
Locating NMAP + ARP + ASTERISK Executables
Inserting data into the global vars Table
Creating mac list Table
Creating model List Table
Creating oui List Table
Creating product List Table
Creating Template List Table
Create Custom Configs Table
Creating symlink to web provisioner
Update Version Number to 2.11.9
Generating CSS...Done
endpointman installed successfully
```

Click Return.

Click Apply Config highlighted Red at the top.

Click Connectivity

Click OSS Endpoint Addvanced Settings

```
End Point Configuration Manager
Advanced Settings
Settings

OUI Manager

Product Configuration Editor

Import/Export My Devices List

Package Import/Export

IP address of phone server: 10.0.5.254 Determine for me
Configuration Type: File (TFTP/FTP)	
Global Final Config & Firmware Directory: /tftpboot/

Time

Time Zone (like England/London): Americas
Time Server (NTP Server): 10.0.5.1	

Local Paths

Note: Used for searching for phones:
NMAP executable path: /usr/bin/nmap
Note: Used for adding phones:
ARP executable path: /usr/sbin/arp
Note: Used for rebooting phones:
Asterisk executable path: /usr/sbin/asterisk

Web Directories

Package Server:	http://mirror.freepbx.org/provisioner/v3/

Experimental

Note: Voicemail recording module, allows users to edit specific settings that you define:
(Checkmark) Enable FreePBX ARI Module (What?)	
Enable Debug Mode 	
Disable Tooltips 	
Allow Duplicate Extensions 	
Allow Saving Over Default Configuration Files 	
Note: If you haven't setup the tftp server yet check this box before hitting update globals:
Disable TFTP Server Check 	
Disable Configuration File Backups 	
(Checkmark) Use GITHUB Live Repo (Requires git to be installed) 	
GIT Branch: Master

Update Globals
```

#### Setup ####

```
IP address of phone server:: 
```

Click Determine for me or set your VoIPServer IP:  10.0.5.254

Configuration Type: File (TFTP/FTP)	
Global Final Config & Firmware Directory: /tftpboot/

Fix your Timezone to where ever you are.

```
Time Zone (like England/London)
```

Time Server (NTP Server): 10.0.5.1

I set my time server to the virtual router so everything is in sync with it.

Note: Voicemail recording module, allows users to edit specific settings that you define:

Make sure nmap is installed, all the other tools should be default installed (arp,asterisk)

Just type ```nmap``` in the VoIP Server console and see if it shows up otherwise:

```
yum install nmap
```

Note: Voicemail recording module, allows users to edit specific settings that you define:

(Checkmark) Enable FreePBX ARI Module (What?)

Note: If you haven't setup the tftp server yet check this box before hitting update globals:

Disable TFTP Server Check (Note: I never checked this but the creator said it causes apache to lockup if you don't and after you reboot it will be checked if you dont have tftp setup maybe because tftp was already installed.)

(Checkmark) Use GITHUB Live Repo (Requires git to be installed) 	

GIT Branch: Master

You may see this warning at the top of the window:

```
Configuration Directory is not a directory or does not exist! Please change the location here: Here
```

we need to go make this directory.

Go to the terminal of the phone server and type

```
mkdir /tftpboot
```

Click refresh on the webpage and now you should see this warning.


```
Configuration Directory is not writable!
Please change the location: Here
Or run this command on SSH: 'chown -hR root:asterisk /tftpboot/' then 'chmod g+w /tftpboot/'
 ```

So do what it says

```
chown -hR root:asterisk /tftpboot/
chmod g+w /tftpboot/
```

Edit the TFTP configuration file.

Change server_args to -s /tftpboot

Change disable to no

```
nano /etc/xinetd.d/tftp

# default: off
# description: The tftp server serves files using the trivial file transfer \
#	protocol.  The tftp protocol is often used to boot diskless \
#	workstations, download configuration files to network-aware printers, \
#	and to start the installation process for some operating systems.
service tftp
{
        socket_type      = dgram
        protocol         = udp
        wait             = yes
        user             = root
        server           = /usr/sbin/in.tftpd
        server_args      = -s /tftpboot
        disable          = no
        per_source       = 11
        cps              = 100 2
        flags            = IPv4
}
```

Restart TFTP Service.

```
service xinetd restart
```

Create a test file to download.

```
echo "Test123" > /tftpboot/test.txt
```

Install TFTP Client

```
yum install tftp
```

Test TFTP Server

```
cd
tftp 192.168.1.106
tftp> get test.txt
tftp> quit
cat test.txt
test123
```

Refresh page again and the warnings should now be gone.

We're going to setup FTP as well for the Polycom Phonesets.

Back to the console of the VoIP Server.

```
nano /etc/vsftpd/vsftpd.conf

# Example config file /etc/vsftpd/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
# Allow anonymous FTP? (Beware - allowed by default if you comment this out).
anonymous_enable=NO
#
# Uncomment this to allow local users to log in.
local_enable=YES
#
# Uncomment this to enable any form of FTP write command.
write_enable=NO
#
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
local_umask=022
#
# Uncomment this to allow the anonymous FTP user to upload files. This only
# has an effect if the above global write enable is activated. Also, you will
# obviously need to create a directory writable by the FTP user.
#anon_upload_enable=YES
#
# Uncomment this if you want the anonymous FTP user to be able to create
# new directories.
#anon_mkdir_write_enable=YES
#
# Activate directory messages - messages given to remote users when they
# go into a certain directory.
dirmessage_enable=YES
#
# The target log file can be vsftpd_log_file or xferlog_file.
# This depends on setting xferlog_std_format parameter
xferlog_enable=YES
#
# Make sure PORT transfer connections originate from port 20 (ftp-data).
connect_from_port_20=YES
#
# If you want, you can arrange for uploaded anonymous files to be owned by
# a different user. Note! Using "root" for uploaded files is not
# recommended!
#chown_uploads=YES
#chown_username=whoever
#
# The name of log file when xferlog_enable=YES and xferlog_std_format=YES
# WARNING - changing this filename affects /etc/logrotate.d/vsftpd.log
xferlog_file=/var/log/xferlog
#
# Switches between logging into vsftpd_log_file and xferlog_file files.
# NO writes to vsftpd_log_file, YES to xferlog_file
xferlog_std_format=NO
#
# You may change the default value for timing out an idle session.
#idle_session_timeout=600
#
# You may change the default value for timing out a data connection.
#data_connection_timeout=120
#
# It is recommended that you define on your system a unique user which the
# ftp server can use as a totally isolated and unprivileged user.
#nopriv_user=ftpsecure
#
# Enable this and the server will recognise asynchronous ABOR requests. Not
# recommended for security (the code is non-trivial). Not enabling it,
# however, may confuse older FTP clients.
#async_abor_enable=YES
#
# By default the server will pretend to allow ASCII mode but in fact ignore
# the request. Turn on the below options to have the server actually do ASCII
# mangling on files when in ASCII mode.
# Beware that on some FTP servers, ASCII support allows a denial of service
# attack (DoS) via the command "SIZE /big/file" in ASCII mode. vsftpd
# predicted this attack and has always been safe, reporting the size of the
# raw file.
# ASCII mangling is a horrible feature of the protocol.
#ascii_upload_enable=YES
#ascii_download_enable=YES
#
# You may fully customise the login banner string:
#ftpd_banner=Welcome to blah FTP service.
#
# You may specify a file of disallowed anonymous e-mail addresses. Apparently
# useful for combatting certain DoS attacks.
#deny_email_enable=YES
# (default follows)
#banned_email_file=/etc/vsftpd/banned_emails
#
# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().
chroot_local_user=YES
chroot_list_enable=YES
# (default follows)
chroot_list_file=/etc/vsftpd/chroot_list
#
# You may activate the "-R" option to the builtin ls. This is disabled by
# default to avoid remote users being able to cause excessive I/O on large
# sites. However, some broken FTP clients such as "ncftp" and "mirror" assume
# the presence of the "-R" option, so there is a strong case for enabling it.
#ls_recurse_enable=YES
#
# When "listen" directive is enabled, vsftpd runs in standalone mode and
# listens on IPv4 sockets. This directive cannot be used in conjunction
# with the listen_ipv6 directive.
listen=YES
#
# This directive enables listening on IPv6 sockets. To listen on IPv4 and IPv6
# sockets, you must run two copies of vsftpd with two configuration files.
# Make sure, that one of the listen options is commented !!
#listen_ipv6=YES

pam_service_name=vsftpd
userlist_enable=YES
userlist_deny=NO
tcp_wrappers=YES
#hide_file=*
```

mkdir /var/ftp/sip - Make the FTP directory for the user.
chown asterisk:asterisk /var/ftp/sip - Make asterisk the owner and group of the folder.
useradd - Add a user.
-G asterisk - Set user into asterisk group.
-d /var/ftp/sip - Set user directory to the FTP directory.
/bin/false - Disable login for this user.
PlcmSpIp - Default username for the phones FTP account.

```
mkdir /var/ftp/sip
chown -R asterisk:asterisk /var/ftp/sip
chmod -R 0755 /var/ftp/sip
useradd -G asterisk -d /var/ftp/sip -s /bin/false PlcmSpIp
passwd PlcmSpIp
```

Show results.

```
cat /etc/passwd
PlcmSpIp:x:501:501::/var/ftp/sip:/bin/false
groups PlcmSpIp
PlcmSpIp : PlcmSpIp
chkconfig vsftpd on
service vsftpd start
nano /var/log/xferlog
:/var/www/html/admin/modules/_ep_phone_modules/endpoint
chown -R asterisk. SomeCustom.jpg
chown -R asterisk. SomeCustom.wav
/var/www/html/admin/modules/_ep_phone_modules/endpoint/overrides
```

Click Update Globals button.

**Note:** *If you get in the webGUI "Local TFTP Server is not correctly configured" you probably didn't restart the service or have a typo in the config try again.*

##### Grab VoIP Hardware Firmware #####

Click Connectivity menu at the top.

Click OSS Endpoint Package Manager.

Click Check For Updates.

Install the phone firmware you own, were going to install Cisco and Polycom.

```
Install Polycom

Status Please Wait

Downloading Brand JSON.....Done!
Downloading Brand Package...Done!
Checking MD5sum of Package....Done!
Extracting Tarball........Done!
Appears to be a valid Provisioner.net JSON file.....Continuing
Creating Directory Structure for Brand 'Polycom' and Moving Files ...................................................................................................................................................................................................................................................................................................................................... Done!
Updating Polycom brand data..........
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Done!
Removing Temporary Files..............Done!
Return
```

Click Return.

```
Install Cisco

Status Please Wait

Downloading Brand JSON.....Done!
Downloading Brand Package...Done!
Checking MD5sum of Package....Done!
Extracting Tarball........Done!
Appears to be a valid Provisioner.net JSON file.....Continuing
Creating Directory Structure for Brand 'Cisco/Linksys' and Moving Files ..................................................................................................... Done!
Updating Cisco/Linksys brand data..........
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Updating Family Lines.................
--Updating Model Lines................
Done!
Removing Temporary Files..............Done!

Return
```

Click Return.

Click Enable next to all the phone models you have.

Click Install Firmware if the option exist for the phones.

Optional: Click Show/Hide Brands/Models Tab and hide all the brands you have never seen before.

##### OUI Manager #####

Add the first 6 hex values of your phones MAC address if not already there.


##### OSS Endpoint Device List #####

Automatically add devices.

Click Search on Serach or new devices in netmask 10.0.5.254/24 whatever IP range you have check use nmap.

```
 Search Search for new devices in netmask: 10.0.5.254/24 X(Use NMAP)
```

Now you should see your phone sets listed under "Unmanaged Extensions".

Click on the checkboxes next to you phonesets and then click "Add Selected Phones".

Otherwise...

Manual add a device.

```
MAC Address	Brand	Model of Phone	Line	Extension Number	Template		
 	
0004f2xxxxxx     Polycom  Soundpoint IP 670  1   701 --- 701  Custom...
 				
 
 Add	 Reset
```

Click Add.

Then change the phones models to the correct models.

Try to reboot phones from OSS options.

Polycom sets add this file if you can't get DHCP Options working.

```
sudo nano /var/www/html/ucs.xml

<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<PHONE_IMAGES>
  <REVISION ID="">
    <PHONE_IMAGE>
      <VERSION>4.0.11.0583</VERSION>
      <PATH>http://10.10.10.254/firmware/</PATH>
    </PHONE_IMAGE>
  </REVISION>
</PHONE_IMAGES>
```

Customize ringtones, backgrounds, voicemail, vm ext

Click Edit File Configurations for: $mac.cfg

File Configuration Editor For: $mac.cfg

```
<?xml version="1.0" standalone="yes"?> 
<!-- Default Master SIP Configuration File--> 
<!-- $RCSfile: 000000000000.cfg,v $ $Revision: 1.14.22.4 $ --> 
<!--
#################PROVISIONER.NET#################
# This Configuration file was generated from the Provisioner.net Library by {$provisioner_processor_info}
# Generated on: {$provisioner_generated_timestamp}
# 
#
# Provisioner Information Follows:
# Brand Revision Timestamp: {$provisioner_brand_timestamp}
# Family Revision Timestamp: {$provisioner_family_timestamp}
#
##################################################
-->
<APPLICATION
	APP_FILE_PATH="sip.ld"
	CONFIG_FILES="{$createdFiles}" 
	MISC_FILES="" 
	LOG_FILE_DIRECTORY="/logs" 
	OVERRIDES_DIRECTORY="/overrides" 
	CONTACTS_DIRECTORY="/contacts" 
	LICENSE_DIRECTORY="/licenses"> 
</APPLICATION>
<PHONE_CONFIG>	
  <ALL
    msg.mwi.1.subscribe="701"
    msg.mwi.1.callBack="*97"
    msg.mwi.1.callBackMode="contact"
    sampled_audio saf.1="" saf.2="ALongTimeAgo8.wav" saf.3="Warble.wav" saf.4="SoundPointIPWelcome.wav" saf.5="LoudRing.wav" saf.6="" saf.7="" saf.8="" saf.9="" saf.10="" saf.11="" saf.12="" saf.13="" saf.14="" saf.15="" saf.16="" saf.17="" saf.18="" saf.19="" saf.20="" saf.21="" saf.22="" saf.23="" saf.24=""
    np.normal.ringing.calls.tonePattern="ringer15"
    up.backlight.timeout="10"
    upgrade.custom.server.url="http://10.10.10.254/ucs.xml"
  />
</PHONE_CONFIG>
```

Then you should see a custom config in the drop down.

Select Alternative File Configurations for overrides/$mac.cfg <phonemac_randomnumber>

Click Edit File Configurations for: overrides/$mac-phone.cfg 

File Configuration Editor For: $mac-phone.cfg

```
<?xml version="1.0" standalone="yes"?>
<!--
#################PROVISIONER.NET#################
# This Configuration file was generated from the Provisioner.net Library by {$provisioner_processor_info}
# Generated on: {$provisioner_generated_timestamp}
# 
# Provisioner Information Follows:
# Brand Revision Timestamp: {$provisioner_brand_timestamp}
# Family Revision Timestamp: {$provisioner_family_timestamp}
#
##################################################
-->
<PHONE_CONFIG>	
  <ALL
    msg.mwi.1.subscribe="701"
    msg.mwi.1.callBack="*97"
    msg.mwi.1.callBackMode="contact"
    sampled_audio saf.1="" saf.2="ALongTimeAgo8.wav" saf.3="Warble.wav" saf.4="SoundPointIPWelcome.wav" saf.5="LoudRing.wav" saf.6="" saf.7="" saf.8="" saf.9="" saf.10="" saf.11="" saf.12="" saf.13="" saf.14="" saf.15="" saf.16="" saf.17="" saf.18="" saf.19="" saf.20="" saf.21="" saf.22="" saf.23="" saf.24=""
    np.normal.ringing.calls.tonePattern="ringer15"
    up.backlight.timeout="10"
    upgrade.custom.server.url="http://10.10.10.254/ucs.xml"
  />
</PHONE_CONFIG>
```

Then you should see a custom config in the drop down.

Select Alternative File Configurations for overrides/$mac-phone.cfg <phonemac_randomnumber>

### No OSS Endpoint Manager ###

Dump the latest and greatest firmware from here into the ftp folder /var/ftp/sip/ or web folder /var/www/html/firmware/.
The dhcp option 160 points to the ftp for firmware, refer back to the virtual router documentation for that, pointing to usc.xml uses the web folder for updating firmware.

```
cd /var/ftp/sip
```

http://support.polycom.com/content/support/North_America/USA/en/support/voice/soundpoint_ip/soundpoint_ip670.html

Grab Polycom UC Software 4.0.12 for VVX Business Media Phones and SoundStructure [Split] or newer.

```
sudo wget http://downloads.polycom.com/voice/voip/uc/Polycom-UC-Software-4-0-12-rts12-release-sig-split.zip
unzip Polycom-UC-Software-4-0-12-rts12-release-sig-split.zip
```

There's some sample backgrounds and ringtones in this package as well as the firmware.

**Note:** *Polycom sets look in the sip.var file for the version number to update to.*

If you don't want to deal with OSS Endpoint, just toss this configuration file in your ftp folder.

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PHONE_CONFIG>
  <PHONE_LOCAL
    bg.hiRes.color.selection="3,6"
    feature.urlDialing.enabled="0"
    np.normal.ringing.calls.tonePattern="ringer15"
    tcpIpApp.sntp.address="10.0.5.1"
    tcpIpApp.sntp.gmtOffset="-18000"
    up.backlight.onIntensity="0"
    up.backlight.timeout="5"
    upgrade.custom.server.url="http://10.10.10.254/ucs.xml"
    bg.hiRes.color.bm.6.name="BravestWarrior.jpg"
    msg.mwi.1.callBack="*97"
    msg.mwi.1.callBackMode="contact"
    msg.mwi.1.subscribe="701"
    reg.1.address="701"
    reg.1.auth.userId="701"
    reg.1.displayName="Den 701"
    reg.1.label="701"
    reg.1.auth.password="GenericPlebz&lotPassword01"
    saf.1="ALongTimeAgo8.wav"
    saf.2="Warble.wav"
    saf.3="SoundPointIPWelcome.wav"
    saf.4="LoudRing.wav"
    voIpProt.server.1.address="10.10.10.254"
    voIpProt.server.1.expires="600"
  />
</PHONE_CONFIG>
```

###### Custom Backgrounds ######

Here's a quick sample ringtone and background directory: [customize](../customize)

yum install imagemagick

```
mogrify -resize 50% *.png      # keep image aspect ratio
mogrify -resize 320x160 *.png  # keep image aspect ratio
mogrify -resize 320x160! *.png # don't keep image aspect ratio
mogrify -resize x160 *.png     # don't keep image aspect ratio
mogrify -resize 320x *.png     # don't keep image aspect ratio
```

Polycom phones do not support progressive or multiscan JPEG images. Phones
running SIP 3.2.x or earlier cannot display JPEG images with .jpe or .jfif extensions.
To use this type of image, change the extension to .jpg.

SoundPoint IP 550, 560, 650, and 670 320 x 160 pixels

SoundPoint IP 550, 560, 650, and 670 only support jpg & bmp not png.

Larger images will be cropped smaller images will be centered with a colour background.

```
Phone model Optimal idle display  Image Size (In Pixels)  Color Depth
SoundPoint IP 32x/33x             87 x 11 pixels           monochrome (1-bit)
SoundPoint IP 430                 94 x 23 pixels           monochrome
SoundPoint IP 450                 170 x 73 pixels          4-bit grayscale or monochrome
SoundPoint IP 550/560/650         213 x 111 pixels         4-bit grayscale or monochrome
SoundPoint IP 670                 213 x 111 pixels         12-bit color
SoundStation IP 5000/6000         240 x 32 pixels          32-bit grayscale or monochrome
SoundStation IP 7000              255 x 75 pixels          32-bit grayscale or monochrome
```

All phones on a network will use the 000000000000.cfg master configuration file
unless the <ethernet-address>.cfg master configuration file associated with their
ethernet address exists on the network. If you would like a phone to use the
000000000000.cfg file, be sure that the associated <ethernet-address>.cfg file
does not exist on the provisioning server.

```
sudo nano /var/ftp/sip/000000000000.cfg

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PHONE_CONFIG>
  <PHONE_LOCAL
    up.backlight.onIntensity="0"
    up.backlight.timeout="5"
    bg.hiRes.color.selection="3,6"
    bg.hiRes.color.bm.6.name="BravestWarrior.jpg"
  />
</PHONE_CONFIG>
```

This turns the phones backlight off and timesout at 5 seconds, Sets the default background to slot 6 which slot 6 is defined to BravestWarrior.jpg. 

###### Custom Audio (Ringtones) ######

You can add custom ringtones to your phone, and you can apply custom ringtones to specific contacts or phone lines. The phones support the following .wav file formats: G.711u-law, G.711a-law, G.722, G.729AB, Lin16, and iLBC.

Audio files should have a .wav extension name. It will be stored in the phone's flash memory and a copy will be made to the provisioning server. If you select a URL, the phone will download the audio file from that URL. You can save a maximum of 24 audio files or until the phone runs out of memory.

You can set a custom ringtone as the welcome sound in the Welcome Sound drop down box and for incoming calls using the Ring Type drop down box. To apply custom ringtones to specific contacts, on your phone, go to Menu > Features > Contact Directory, select a contact, press the Edit soft key, and choose Ring Type.

To apply a custom ringtone to a line, on your phone, go to Utilities > Soft Key & Line Key Configuration, select the line you wish to apply the custom ringtone to, and choose a ringtone type using the Edit Speed Dial Contact options.

Note: If you configure an unsupported audio file, the phone will use the default ringtone.

For ringtones it seems to work well when using ftp. You can edit the ipmid.conf sampled_audio section as follows: <sampled_audio saf.1="" saf.2="ringtone/ringtone1.wav" . . .

Documents state you should use the following formats: "mono 8 kHz G.711 A-Law L16/160008 (16-bit, 16 kHz sampling rate, mono)

To get the file format correct, use SOX:

```
sox original1.wav -V AlongTimeAgo.wav -e mu-law -c1 -t .wav -r 8000 -U /var/ftp/sip/ALongTimeAgo8.wav resample
```

Sample ringtone config.

```
sudo nano /var/ftp/sip/000000000000.cfg

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PHONE_CONFIG>
  <PHONE_LOCAL
    np.normal.ringing.calls.tonePattern="ringer15"
    saf.1=""
    saf.2="ALongTimeAgo8.wav"
    saf.3="Warble.wav"
    saf.4="SoundPointIPWelcome.wav"
    saf.5="LoudRing.wav"
  />
</PHONE_CONFIG>
```
**Note:** *saf.1="" seems to overlap with existing tone 14 and won't upload to phone?...*

This says choose ringer 15th in the list where the custom ringtones start to be the default ringtone.

**Note:** *Increase your logging level to see if there are errors on the audio file format.*

Trim can trim off and shorten audio from the audio file to make a suitable ring tone sized sample.

Syntax : sox old.wav new.wav trim [SECOND TO START] [SECONDS DURATION].

SECOND TO START – Starting point in the voice file.
SECONDS DURATION – Duration of voice file to remove.

The command below will extract first 10 seconds from input.wav and stored it in output.wav

```
sox input.wav output.wav trim 0 10
```

###### If you want to convert an MP3 with sox for a ringtone you have to rebuild it with MP3 support. ######

Installing SoX with MP3 Support on Scientific Linux or how to fix error: sox formats: no handler for file extension "mp3"

```
Default SoX installation from yum doesn’t have mp3 handler:

AUDIO FILE FORMATS: 8svx aif aifc aiff aiffc al amb au avr caf cdda cdr cvs cvsd dat dvms f4 f8 fap flac fssd gsm hcom htk ima ircam la lpc lpc10 lu mat mat4 mat5 maud nist ogg paf prc pvf raw s1 s2 s3 s4 sb sd2 sds sf sl smp snd sndfile sndr sndt sou sox sph sw txw u1 u2 u3 u4 ub ul uw vms voc vorbis vox w64 wav wavpcm wv wve xa xi
PLAYLIST FORMATS: m3u pls
AUDIO DEVICE DRIVERS: alsa ao oss ossdsp
If you already have SoX installed form yum you need remove it:

# yum remove sox

You will need to install the rpmforge repo.

Then install gcc-c++ libmad libmad-devel libid3tag libid3tag-devel lame lame-devel flac-devel libvorbis-devel packages:

# yum install gcc-c++ libmad libmad-devel libid3tag libid3tag-devel lame lame-devel flac-devel libvorbis-devel

Create /usr/local/src/SoX directory, download, extract sox from sources:

# mkdir /usr/local/src/SoX
# cd /usr/local/src/SoX/
# wget http://softlayer-dal.dl.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz
# tar xvfz sox-14.4.2.tar.gz
# cd sox-14.4.2
# ./configure

After running ./configure you should see in output:

OPTIONAL FILE FORMATS
amrnb.....................no
amrwb.....................no
flac......................yes
gsm.......................yes (in-tree)
lpc10.....................yes (in-tree)
mp2/mp3...................yes
id3tag....................yes  
lame......................yes 
lame id3tag...............yes
dlopen lame...............no
mad.......................yes
dlopen mad................no
twolame...................no
oggvorbis.................yes
opus......................no
sndfile...................no
wavpack...................no
Finlay run:

# make -s
# make install
That’s it. Now your new compiled sox with mp3 support in /usr/local/bin/ folder.

You can add /usr/local/sbin to the PATH:

# export PATH=$PATH:/usr/local/bin
```

#### Google Voice Trunk ####

I've tried 3 ways here and only the first way worked.

##### Way 1 - Less Secure *Worked* #####

Less secure apps [page](https://myaccount.google.com/lesssecureapps)

Turn ON Allow less secure apps.

```
Allow less secure apps: ON
Some apps and devices use less secure sign-in technology, which could leave your account vulnerable. You can turn off access for these apps (which we recommend) or choose to use them despite the risks.
```

Setup a [Google Voice Account](https://accounts.google.com/signin/v2/identifier?service=grandcentral&passive=1209600&continue=https%3A%2F%2Fwww.google.com%2Fvoice%2F&followup=https%3A%2F%2Fwww.google.com%2Fvoice%2F&ltmpl=open&flowName=GlifWebSignIn&flowEntry=ServiceLogin).

IMPORTANT: Be sure to enable the Google Chat option as one of your phone destinations in Settings, Voice Setting, Phones. That’s the destination we need for The Incredible PBX to work its magic! Otherwise, all inbound and outbound calls will fail. If you don’t see this option, you may need to call up Gmail and enable Google Chat there first. Then go back to the Google Voice Settings.

While you’re still in [Google Voice](http://google.com/voice) Settings, click on the Calls tab. Make sure your settings match these:

Click the menu at the left and then click Legacy Google Voice to see these exact options other wise guess at the new options, basically all there.

###### Legacy Google Voice ######

```
Call Screening – OFF
Call Presentation – OFF
Caller ID (In) – Display Caller’s Number
Caller ID (Out) – Don’t Change Anything
Do Not Disturb – OFF
Call Options (Enable Recording) – OFF
Global Spam Filtering – ON
```

###### Current Google Voice ######

```
Can't find options for Call Presentaion, Caller ID (In), Caller ID (Out)

Phone numbers
  Do not disurb
    Turn off message forwarding and send calls to voicemail - Off
Calls
  Screen Calls
    Hear a caller's name when you pick up - Off
  Incoming call options
    Record call (4), Switch linked phone (*), Start conference call (5) - Off
Security
  Filter spam
    Calls, messages, and voicemail - On
```

Legacy

```
Click Save Changes once you adjust your settings. Under the Voicemail tab, plug in your email address so you get notified of new voicemails. 
```

Current

```
Voicemail
  Get voicemail via email
    someone@gmail.com - On
```

Down the road, receipt of a Google Voice voicemail will be a big hint that something has come unglued on your PBX.

One final word of caution is in order regardless of your choice of providers: Do NOT use special characters in any provider passwords, or nothing will work!

Now you’re ready to set up your Google Voice trunk in FreePBX. After logging into FreePBX with your browser, click the Connectivity tab and choose Google Voice/Motif. To Add a new Google Voice account, just fill out the form. Do NOT check the third box or incoming calls will never ring!

```
Google Voice [Motif]

Typical Settings

Google Voice Username: blah@gmail.com
Google Voice Password: blahbers1010
Google Voice Phone Number: 9361234567
Add Trunk: X
Add Outbound Routes: X
Send Unanswered to GoogleVoice Voicemail: Not Checked

Advanced Settings

None At This Time

Submit
```

Click Submit.

IMPORTANT LAST STEP: Google Voice will not work unless you restart Asterisk from the Linux command line at this juncture. Using SSH, log into your server as root and issue the following command.

```
amportal restart.
```

If you have trouble getting Google Voice to work (especially if you have previously used your Google Voice account from a different IP address), try this [Google Voice Reset Procedure](https://accounts.google.com/DisplayUnlockCaptcha). It usually fixes connectivity problems. If it still doesn’t work, enable [Less Secure Apps using this Google tool] (https://www.google.com/settings/security/lesssecureapps).

#### Way 2 - Google OAUTH Script ####

Go to [Google Developer Console](https://console.developers.google.com/apis/) and register a new project. 

In the top menu bar there is a down arrow to create more projects, click it.
```
|||     Google APIs   V  <=== Dropdown
```

Click the + at the right

Or click this link [New Project](https://console.developers.google.com/projectcreate?previousPage=%2Fapis%2Fcredentials%3Fproject&organizationId=0)

```
New Project

You have 10 projects remaining in your quota. Learn more.
Project name 

My Project
Your project ID will be random-name-xxxxxx  Edit
 Create  Cancel
```

Choose a name for your project and click Create button.

Click Credentials on left then click "Create credentials"  on the right.

```
Click OAuth client ID
Requests user consent so your app can access the user's data
```

To create an OAuth client ID, you must first set a product name on the consent screen [Button](https://console.developers.google.com/apis/credentials/consent?createClient)

Click the button.

```
Product name shown to users 
SomeCreativeName
```

Click Save.

Click "Other" for Application type.

```
Name
AnotherCreativeName
```
You will now have your OAuth client ID and client secret.

```
Here is your client ID
<clientID>
Here is your client secret
<Secret>
```

Copy client ID and Client Secret. Replace in script the below.

https://gist.github.com/NonaSuomy/a62a9a125d61fc5df748066961702ac6

Run the script with init option and when prompted for code, switch to a web browser and paste the link in clipboard, copy code and paste back in console.

Script uses xclip to copy url in into copy/paste buffer (Not actually required, will just complain).

```
yum install xclip
```

Run script.

```
sh gistfile1.sh init
https://accounts.google.com/ServiceLogin?passive=...etc
```

It will hopefully spit out a large URL, paste it into your web browser of choice.

```
Google

AnotherCreativeNameGV would like to:
View your email address	Click for more information
More info	View your basic profile info	Click for more information
More info	View and send chat messages	Click for more information

By clicking Allow, you allow this app and Google to use your information in accordance with their respective terms of service and privacy policies. You can change this and other Account Permissions at any time.

Deny Allow
```

Click Allow

```
Please copy this code, switch to your application and paste it there:
<KEY>
````

Copy the key from the web browser and paste it into the console.

```
Code? <KEY>
Done
```

 Client refresh token will be saved in .gvauth folder. Use this refresh token as your google voice password in Asterisk.
 
 ```
cat /root/.gvauth/default.refresh_token
<refreshtoken>
```

Copy refresh token and paste it in your Motif field called refresh token in Google Voice PIAF GUI settings.

Click Connectivity ==> Google Voice (Motif)

```
Google Voice [Motif]

Typical Settings

Google Voice Username: blah@gmail.com
Google Voice Refresh Token: <refreshtoken>
Google Voice Phone Number: 9361234567
Add Trunk: X
Add Outbound Routes: X
Send Unanswered to GoogleVoice Voicemail: Not Checked

Advanced Settings

None At This Time

Submit
```

Click your account made on the right.

**Error:** *This module requires Asterisk chan_motif & res_xmpp to be installed and loaded*

Go to the VoIP Server console and type.

```
amportal restart
```

#### Way 3 Google OAUTH No Script ####

Go to [Google Developer Console](https://console.developers.google.com/apis/) and register a new project. 

In the top menu bar there is a down arrow to create more projects, click it.
```
|||     Google APIs   V  <=== Dropdown
```

Click the + at the right

Or click this link [New Project](https://console.developers.google.com/projectcreate?previousPage=%2Fapis%2Fcredentials%3Fproject&organizationId=0)

```
New Project

You have 10 projects remaining in your quota. Learn more.
Project name 

My Project
Your project ID will be random-name-xxxxxx  Edit
 Create  Cancel
```

Choose a name for your project and click Create button.

Click Credentials on left then click "Create credentials"  on the right.

```
Click OAuth client ID
Requests user consent so your app can access the user's data
```

To create an OAuth client ID, you must first set a product name on the consent screen [Button](https://console.developers.google.com/apis/credentials/consent?createClient)

Click the button.

```
Product name shown to users 
SomeCreativeName
```

Click Save.

Click "Web application" for Application type.

```
Name
AnotherCreativeName

Authorized JavaScript origins
For use with requests from a browser. This is the origin URI of the client application. It can't contain a wildcard (http://*.example.com) or a path (http://example.com/subdir). If you're using a nonstandard port, you must include it in the origin URI.

Leave blank...

Authorized redirect URIs
For use with requests from a web server. This is the path in your application that users are redirected to after they have authenticated with Google. The path will be appended with the authorization code for access. Must have a protocol. Cannot contain URL fragments or relative paths. Cannot be a public IP address.

https://developers.google.com/oauthplayground
```

You will now have your OAuth client ID and client secret.

```
Here is your client ID
<clientID>
Here is your client secret
<Secret>
```

Copy client ID and Client Secret. 

Copy client ID and Client Secret. Replace in script the below.

Go to this site [Google Devoloper OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)

Top right click the Gear icon.

```
OAuth 2.0 configuration

OAuth flow: Server-side

OAuth endpoints: Google

Authorization endpoint:  https://accounts.google.com/o/oauth2/v2/auth

Token endpoint:  https://www.googleapis.com/oauth2/v4/token

Access token location: Authorization header w/ Bearer prefix

Access type: Offline

Force prompt: Consent Screen
 
(Check) Use your own OAuth credentials

You will need to list the URL https://developers.google.com/oauthplayground as a valid redirect URI in your Google APIs Console's project. Then enter the client ID and secret assigned to a web application on your project below:

OAuth Client ID:  <Client ID we got from the last step>.apps.googleusercontent.com

OAuth Client secret:  <Client secret we got from the last step>

Note: Your credentials will be sent to our server as we need to proxy the request. Your credentials will not be logged.

Close
```

After entering the Client ID and Client secret.

Click close.

At the left hand menu...

##### Step 1 Select & authorize APIs ##### 

```
Step 1 Select & authorize APIs

Select the scope for the APIs you would like to access or input your own OAuth scopes below. Then click the "Authorize APIs" button.

Input your own scopes: https://www.googleapis.com/auth/googletalk Auhorize APIs
```

Do not pick anything from the list click on the entry box at the bottom of the list and type

```
https://www.googleapis.com/auth/googletalk
```

Click "Authorize APIs" button.

```
Google

Choose an account
to continue to SomeCreativeNameApp

someone@gmail.com

Use another account
```

Click your google voice account email address under Choose an account or type it in with "Use another account".

```
Google

Hi someone
  someone@gmail.com
  
SomeCreativeNameApp wants to
  View and send chat messages
  
Allow SomeCreativeNameApp to do this?
By clicking Allow, you allow this app to use your information in accordance to their terms of service and privacy policies. You can remove this or any other app connected to your account in My Account

Cancel Allow
```

Click Allow.

Now Step 2 Loads

##### Step 2 Exchange authorization code for tokens #####

```
Step 2 Exchange authorization code for tokens
Once you got the Authorization Code from Step 1 click the Exchange authorization code for tokens button, you will get a refresh and an access token which is required to access OAuth protected resources.

Authorization code:  <Auth Code Key>

Exchange authorization code for tokens

Refresh token:  Refresh token

Access token:  Access token

Refresh access token

(Unchecked) Auto-refresh the token before it expires.

The access token will expire in seconds.

The access token has expired.

Note: The OAuth Playground does not store refresh tokens, but as refresh tokens never expire, user should go to their Google Account Authorized Access page if they would like to manually revoke them.
```

Click "Exchange authorization code for tokens"

Step 2 will generate some numbers and collapse, open up Step 2 again and copy the Refresh token.

```
Refresh token: <RefreshToken>

Access token:  <AccessToken>

(Unchecked) Auto-refresh the token before it expires.

The access token will expire in 3236 seconds.

Note: The OAuth Playground does not store refresh tokens, but as refresh tokens never expire, user should go to their Google Account Authorized Access page if they would like to manually revoke them.
```

Copy refresh token and paste it in your Motif field called refresh token in Google Voice PIAF GUI settings.

**Note:** *If you only have a password field you probably didn't choose OAuth2 when you installed PIAF.*

Click Connectivity ==> Google Voice (Motif)

```
Google Voice [Motif]

Typical Settings

Google Voice Username: blah@gmail.com
Google Voice Refresh Token: <refreshtoken>
Google Voice Phone Number: 9361234567
Add Trunk: X
Add Outbound Routes: X
Send Unanswered to GoogleVoice Voicemail: Not Checked

Advanced Settings

None At This Time

Submit
```

Click your account made on the right.

**Error:** *This module requires Asterisk chan_motif & res_xmpp to be installed and loaded*

Go to the VoIP Server console and type.

```
amportal restart
```

**Note:** *I have yet to get OAuth2 methods working. Good Luck!*

##### Error for OAuth2 Methods #####

```
[2017-06-30 00:09:54] NOTICE[9606]: res_xmpp.c:3890 fetch_access_token: access Token : (null)
[2017-06-30 00:09:54] WARNING[9606]: res_xmpp.c:3766 xmpp_client_receive: Parsing failure: Hook returned an error.
[2017-06-30 00:09:54] WARNING[9606]: res_xmpp.c:3763 xmpp_client_receive: Parsing failure: Invalid XML.
[2017-06-30 00:09:54] WARNING[9606]: res_xmpp.c:3830 xmpp_client_thread: JABBER: socket read error
[2017-06-30 00:09:54] NOTICE[9606]: res_xmpp.c:3639 xmpp_client_reconnect: Connecting to client token :  <RefreshTokenHere>
[2017-06-30 00:09:54] NOTICE[9606]: res_xmpp.c:3877 fetch_access_token: Command CURL(https://www.googleapis.com/oauth2/v3/token,client_id=<ClientIDhere>.apps.googleusercontent.com&client_secret=<SecretHere>&refresh_token=<RefreshTokenHere>&grant_type=refresh_token)
[2017-06-30 00:09:54] NOTICE[9606]: res_xmpp.c:3881 fetch_access_token: Command status : {
 "error": "unauthorized_client",
 "error_description": "Unauthorized"
} 
```

#### VoIP.ms Trunk ####

Click Connectivity => Trunks

Edit Trunk

General Settings

```
Trunk Name: VoIPms
Outbound CallerID: <TenDigitPhone#>
CID Options: Allow any CID	
```

Outgoing Settings

PEER Details

```
username=<6DigitUser#>
type=peer
trustrpid=yes
sendrpid=yes
secret=<password>
qualify=yes
nat=yes&force_rport,comedia
insecure=port,invite
host=atlanta1.voip.ms
fromuser=
disallow=all
context=from-trunk
canreinvite=nonat
allow=ulaw
```

Incoming Settings

Register String

```
<6DigitUser#>:<password>@atlanta1.voip.ms:5060
```

### Ring Group ###

Click Applications => Ring Groups.

Click Add Ring Group.

```
Ring All Phones (600)

Edit Ring Group

Group Description: Ring All Phones
Ring Strategy: ringall
Ring Time (max 300 sec): 20

Extension List:	
701
702
703
704
705
706
707

Extension Quick Pick: (pick extension)
Announcement: None
Play Music On Hold? Ring
CID Name Prefix:	
Alert Info:	
Ignore CF Settings:	
Skip Busy Agent:	
Enable Call Pickup:	
Confirm Calls:	
Remote Announce: Default
Too-Late Announce: Default

Change External CID Configuration

Mode: Default	
Fixed CID Value:	

Call Recording

Record Calls: Dont Care

Destination if no answer: Extensions <701> Den
```

### Inbound Routes ###

Click Connectivity => Inbound Routes.

Click Add Incoming Route.

```
Route: CatchAll

Edit Incoming Route

Description: CatchAll
DID Number:	
CallerID Number:	
CID Priority Route:	

Options

Alert Info:	
CID name prefix:	
Music On Hold:	Default
Signal RINGING:	
Reject Reverse Charges:	
Pause Before Answer:	

Privacy

Privacy Manager: No

Call Recording

Note that the meaning of these options has changed. Please read the wiki for futher information on these changes.

Call Recording:	Don't Care

Fax Detect

Detect Faxes:	No
Set Destination

Ring Groups
Ring All Phones <600>

Submit    Clear Destination & Submit
```

### Outbound Routes ###

Click Connectivity => Outbound Routes.

You should see the google trunk here we made earlier that's all we need.

```
usergmailcom etc...
```

### CID Superfecta ###

#### KODI Notification ####

### Setup VoiceMail On A Single Extension ###

Setup VoiceMail on the extension you set your ring group to end on.

Click Applications => Extensions.

```
Voicemail

Status: Enabled
Voicemail Password: 888
Require From Same Extension: no
Email Address: user@domain.com
Pager Email Address:	
Email Attachment: yes
Play CID: no
Play Envelope: no
Delete Voicemail: no
VM Options:
VM Context: default
```

[Part 06 - Automation Server](../Infrastructure-Part-6)

VM Guest Automation Server: OpenHAB
 
VM Guest TOR Server: TOR (Remote)
 
VM Guest Fileserver: FreeNAS or ETC.
