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

IP address of phone server:	
 Determine for me
Configuration Type	
Global Final Config & Firmware Directory	
/tftpboot/
Time

Time Zone (like England/London)	
Time Server (NTP Server)	
Local Paths

NMAP executable path:	
/usr/bin/nmap
ARP executable path:	
/usr/sbin/arp
Asterisk executable path:	
/usr/sbin/asterisk
Web Directories

Package Server:	
http://mirror.freepbx.org/provisioner/v3/
Experimental

Enable FreePBX ARI Module (What?)	
Enable Debug Mode 	
Disable Tooltips 	
Allow Duplicate Extensions 	
Allow Saving Over Default Configuration Files 	
Disable TFTP Server Check 	
Disable Configuration File Backups 	
Use GITHUB Live Repo (Requires git to be installed) 	
 Update Globals
```

You will see this warning at the top of the window, 

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
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
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

```
IP address of phone server:: 
```

Click Determine for me.

Fix your Timezone.

```
Time Zone (like England/London)
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

Optional: Click Show/Hide Brands/Models Tab and hide all the brands you have never seen before.

##### OSS Endpoint Device List #####

Automatically add devices.

Click Search on Serach or new devices in netmask xxx.xxx.xxx.xxx/24 whatever IP range you have.

```
 Search Search for new devices in netmask  192.168.1.108/24 X (Use NMAP)
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

Script uses xclip to copy url in into copy/paste buffer.

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



#### VoIP.ms Trunk ####



[Part 06 - Automation Server](../Infrastructure-Part-6)

VM Guest Automation Server: OpenHAB
 
VM Guest TOR Server: TOR (Remote)
 
VM Guest Fileserver: FreeNAS or ETC.
