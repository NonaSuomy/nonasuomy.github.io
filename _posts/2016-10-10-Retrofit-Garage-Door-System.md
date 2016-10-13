---
layout: post
title: House Infrastructure - Retrofitting Garage Door System
---

Retrofitting Garage Door Automation

House Infrastructure

House Infrastructure
HARDWARE
Original Garage Door Manual PDF Google Drive Mirror
Garage Door Opener
Master List Build Of Materials
Microcontrollers
ESP8266 Senseless ASCII Art! ( I had some free time… )
W5500 Ethernet Network Modules
http://www.ebay.ca/itm/For-Arduino-W5500-Ethernet-Network-Modules-TCP-IP-51-STM32-SPI-Interface-/331829982337?hash=item4d429bb481:g:AxgAAOSwUUdXDVYX
Building The Hardware Modules
Relay Driver
Relay Driver BOM
Relay Driver Schematic
Relay
Transistor for Relay trigger
Schematic
PerfBoard Fritzing Relay Driver Layout
PerfBoard Relay Driver
Hardware Mounted
Hall Effect Sensor (Fully open / closed door state detection)
Hall Effect Sensor BOM
Voltage Divider Research (No longer required as the HEF allows 3.3V.)
ESP8266 Pin Tolerances Information
Testing HIGH/LOW State of ESP Pin and Distance of HEF
Schematic
Perfboard Fritzing Hall Effect Sensor Layout With Voltage Divider
Perfboard Fritzing Hall Effect Sensor Layout Without Voltage Divider
Perfboard Fritzing Hall Effect Sensor Layout With Ti DRV5023
Perfboard Hall Effect Sensor X 2
Mounted Hardware
Garage Door Tension Bar Encoder
Encoder / Debouncer BOM
Encoder Setup
Schematic
Perfboard Fritzing Encoder Debouncer Layout
Perfboard Encoder Debouncer
Hardware Mounted
Temperature / Humidity / Pressure
Temperature Sensor BOM
Datasheet
Schematic
Fritzing Perfboard Layout
Perfboard Layout
Hardware Mounted
PSU
PSU BOM
Schematic
Fritzing Layout of PSU
Perfboard Layout
Hardware Mounted
Master Board Breakout for Microcontrollers & Parts
Microcontroller Connector Board BOM
Perfboard Layout
Microcontroller Pinouts
Hardware Mounted
Full Setup of Mainboard
Fritzing Test Layout of The Parts
Full Perfboard Layout
Perfboard Layout
Header Labels
Module Labels
Building Prototype Holders For Sensors
SOFTWARE
Software Required
Tools
ArchLinux Server Setup (Hardware)
libvirt
QEMU-KVM
MQTT
OpenHab (VM Server)
Install openhab and addons
Edit the openhab.cfg with the MQTT settings.
(Optional) Avahi MQTT Broker Pointer
Install
Using Avahi
Hostname resolution
Additional info about mdns
Tools
Firewall
Obtaining IPv4LL IP address
Customizing Avahi
Adding Services
Modifying the service-types database
Getting the Sources
Modify the Sources
Build and Install the New Database
OpenHAB WebGUI Configuration
OpenHAB Custom Icons
Web GUI Output
OpenHab Mobile
Arduino Client for MQTT Install
Source Code for GDS
Programming Huzzah!
Garage Door Test 1
Calibration
Useless Stats
Full log below...
Old tests with push stuff before MQTT (NOT REQUIRED FOR ABOVE)
Arduino Code
Instapush Mobile App

HARDWARE

Original Garage Door Manual PDF Google Drive Mirror

https://drive.google.com/open?id=0B7_sv8oBzuGNalVpcDFJdXl4MGc
(Not exact Garage Door Opener but similar)

Garage Door Opener


                 Company: Stanley
                 Product: Stanley Door Systems
                Model NO: V2000
         Date YYYY/MM/DD: 1996/03/14
                     AMP: 7A
                   Volts: 120(115)VAC@60Hz Single Phase(1PH)
              Idle Watts: 3.1W
                     CSA: LR47799
       Expert Assistance: 1-800-253-3976
                          DOC/MDC 164 K1086 360.3566

CAUTION DISCONNECT FROM POWER SUPPLY BEFORE OPENING

WARNING RISK OF ENTRAPMENT

AFTER ADJUSTING EITHER THE FORCE OR LIMITS OF TRAVEL ADJUSTMENTS, INSURE THAT THE DOOR REVERSES ON A 1-½ INCH OBSTRUCTION (OR A 2 BY 4 BOARD LAID FLAT) ON THE FLOOR.




PUSHBUTTON BLACK        [Ground]
PUSHBUTTON RED          [+7.61V]
VACATION   GREEN        [+5V(4.98V)]
LIGHT      YELLOW       [+5V(4.98V)]
OBSTRUCTION SENSOR PLUG [+9.47V]

CODE SWITCH  [12345678910]

OPEN FORCE LOW/MED/HIGH  [¼ Turn]
FORCE ADJUSTMENTS
CLOSE FORCE LOW/MED/HIGH [¼ Turn]
360.3567D







Garage door button consumes 10mA while engaged @+7.62VDC

Directional ASCII Art Of Sprocket

(_^ OPEN  [CCW]   
^_) CLOSE [CW]

Master List Build Of Materials
Resistors / Capacitors / Diodes / ETC

Voltage Dividers (Not required anymore)
3 x 10K Ohm Resistors
3 x 33K Ohm Resistors

Relay Driver
1 x TSC-105L3H Relay
1 x 1N4001 (Back EF)
1 x 1K Ohm Resistor (Transistor Base)
1 x PNP Transistor P2N2222A
1 x 3 Pin Header Male
1 x 3 Pin Screw Terminal

Encoder Debouncer
4 x 10K Ohm Resistors
2 x 10 nf Ceramic Capacitors
1 x 3 Pin Header Male
1 x Encoder

Hall Effect Sensor
2 x Ti DRV5023BIQLPGM Hall Effect Switch
2 x 10K Ohm Resistor
2 x (103) 0.01μF Ceramic Capacitor
2 x 3 Pin Header Male

Temperature Sensor
1 x DHT22
1 x 100 nF Ceramic Capacitor
1 x 4.7K Ohm Resistor
1 x 3 Pin Header Male

Or

1 x BME280 Pressure Temperature Humidity

PSU
2 x 10 µF Electrolytic Capacitors
1 x 0.1 µF Ceramic Capacitor
1 x 1N4001
1 x Barrel Jack
1 x 3.3v Linear Regulator
1 x 2 Pin Header Male

Microcontroller Connector Board
2 x 12 Pin Female Headers
2 x 10 Pin Female Headers
4 x 3 Pin Female Headers
1 x 7 Pin Female Header
1 x 4 Pin Female Header
1 x 3 Pin Male Header

Wire

10M of Cat5e Solid Core Ethernet Cable

PCB

1 x Perfboard or Veroboard




Microcontrollers

ESP8266 Senseless ASCII Art! ( I had some free time… )

              VCC  G13 G12 G14 G16 EN ADC RST
                \_   |  |  |    /  /  /  _/
ESP8266 ESP-12-F  \  |  |  |   /  /  /  /  
                  8  7  6  5  4  3  2  1
NonaSuomy       ___________________________________________
               / (_)(_)(_)(_)(_)(_)(_)(_)                  /;
              /_    _____________________ _____________   //
       CS0--9/(_)  /FCC ID: 2ADUIE SP-12/|  /  _______/  //
    MISO--10/(_)  /MODEL     ESP8266MOD/ / /  /______   //
  GPIO9--11/(_)  /VENDOR    Ai-THINKER/ / /  _______/  //
GPIO10--12/(_)  /ISM+PA  2.4GHz+25dBm/ / /  /______   //
 MOSI--13/(_)  /_FCC____802/11b/g/n_/ / /  _______/  //
SCLK--14/(_)  |_____________________|/ _  /______   //
       / _  _  _  _  _  _  _  _       /_/   AI  /  //
      /_(_)(_)(_)(_)(_)(_)(_)(_)_______________/__//
      `-------------------------------------------'
        15 16 17 18 19 20 21 22
        _/  |  |  |  |  |  |  \_      ^
       /    |  |  |  |  |  |    \     |
      GND G15 G2 G0 G4 G5 RXD0 TXD0  LED

Currently using Adafruit Huzzah.

Top



Bottom



https://www.adafruit.com/products/2471
Price: USD $9.95 + Shipping

These may be cheaper for later projects.

Lua Nodemcu ESP-12F WIFI Network Development Board Module Based ESP8266

There are cheaper boards than this that look similar but pay attention to the antenna pattern. If it looks like an F at one end it’s the newer ESP-12F chipset. Other wise you will be buying the older chipset with less range and less stability.

Top



Bottom



http://www.ebay.ca/itm/Lua-Nodemcu-ESP-12F-WIFI-Network-Development-Board-Module-Based-ESP8266-/311641081905?hash=item488f418831:g:XAcAAOSw3YNXatWv

Price: USD $5.99



Or

Wemos

http://www.wemos.cc/Products/d1_mini.html
http://www.aliexpress.com/store/1331105

Price: USD $4.00 / piece
Shipping: USD $1.76

http://www.ebay.ca/itm/ESP-12-ESP8266-WeMos-D1-Mini-WIFI-4M-Bytes-Development-Board-Module-NodeMCU-Lua-/172173706364?hash=item28165a447c:g:JbwAAOSw-itXu~u1

Price: USD: $3.41




Or Ethernet (WIZNET)

Basically Arduino Leonardo + WIZNET W5500 Ethernet + Active POE + MicroSD <- Can’t use at same time as the wiznet :(

Note: I originally bought this board to make it into a thermostat but the Wiznet chip gets really hot which would throw off the Temperature settings. Maybe use it for the Master module to control all the house sensors.



Website: http://www.dfrobot.com/index.php?route=product/product&product_id=1286&search=DFR0342&description=true
Wiki:
http://www.dfrobot.com/wiki/index.php?title=W5500_Ethernet_with_POE_Mainboard_SKU:_DFR0342
Github: https://github.com/Wiznet/WIZ_Ethernet_Library (Not required, included in the Arduino Library if you use Ethernet2.h).

Price: USD $44.90

http://www.ebay.ca/itm/W5500-Ethernet-w-POE-Control-Board-Arduino-Compatible-DIYMaker-DFRobot-BOOOLE-/172188642629



Future Note: Was pondering about making all the microcontrollers just talk back to one network module i2c etc.

Enhancement V2 Pro Mini 16MHz 3.3V/5V adjustable MEGA328P Arduino-Compatible

http://www.ebay.ca/itm/Enhancement-Pro-Mini-3-3V-5V-adjustable-16M-MEGA328P-Arduino-pro-mini-compatible-/221030168024?hash=item33766cb5d8:m:m63KqOCzGHY5309JJlNjnng

Price: USD $1.93

Mirror Image Of EBAY Page


W5500 Ethernet Network Modules
http://www.ebay.ca/itm/For-Arduino-W5500-Ethernet-Network-Modules-TCP-IP-51-STM32-SPI-Interface-/331829982337?hash=item4d429bb481:g:AxgAAOSwUUdXDVYX

Price: USD $6.48

Building The Hardware Modules

Relay Driver

Relay Driver BOM

1 x TSC-105L3H Relay
1 x 1N4001 (Back EF)
1 x 1KOhm Resistor (Transistor Base)
1 x PNP Transistor P2N2222A
1 x 3 Pin Header Male
1 x 3 Pin Screw Terminal
1 x Perfboard

Relay Driver Schematic

Arduino (ESP8266) PIN = ESP8266 GPIO13, 5V means 3.3V for ESP8266.
     +3.3V (From PSU) = +3.3V PSU
	            GND = Ground
  Relay Normally Open = PUSHBUTTON RED [+7.61V] from Garage Door Opener.
         Relay Common = PUSHBUTTON BLACK [Ground]

Relay

TSC-105L3H Relay
Relay is rated for 5V or lowest 3.75V we’re running it at 3.3V and it seems to function ok for what is required.
Consumption: 0.02A
Sinks 0.01v while running in 3.3 => 3.2 while on.

TSC-105L3H,00 Relay 150mW 5VDC (Seems to be working with 3.3v)
http://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Data+Sheet%7FTSC_Series_relay_data_sheet_E%7F0411%7Fpdf%7FEnglish%7FENG_DS_TSC_Series_relay_data_sheet_E_0411.pdf%7F1-1419130-2
Google drive mirror of Datasheets
https://drive.google.com/open?id=0B7_sv8oBzuGNS09pdnkzQTFERVU
https://drive.google.com/open?id=0B7_sv8oBzuGNRDNtUW51UHFmM00
Alternative Datasheet
TSC-105L3H,00
http://www.farnell.com/datasheets/1717892.pdf
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNdlF1LW9CRVA2VFk

1N4001 Diode for relay Back EF / kickback
http://www.vishay.com/docs/88503/1n4001.pdf
Google drive mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNTDlqVmgwUkxhekk

Transistor for Relay trigger



PNP Transistor P2N2222A
http://www.onsemi.com/pub_link/Collateral/P2N2222A-D.PDF
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNRUhKemJkTXp0ZHM

Schematic



PerfBoard Fritzing Relay Driver Layout



PerfBoard Relay Driver



Hardware Mounted

<Insert Picture here>


Hall Effect Sensor (Fully open / closed door state detection)

Hall Effect Sensor BOM

2 x Ti DRV5023BIQLPGM Hall Effect Switch
2 x 10KOhm Resistor
2 x (103) 0.01μF Ceramic Capacitor
2 x 3 Pin Header Male
2 x Perfboard



DRV5023 Digital Switch Hall Effect Sensor  Rev. F

Part Number: DRV5023BIQLPGM
Sensitivity: BI: 14.5 / 6 mT
Temperature Range: Q: ±40 to 125°C
Package: LPG: 3-pin TO-92 (Through Hole)
Tape & Reel: M: 3000 pcs/box (ammo)

VCC 1: 2.5 to 38 V power supply pin. Bypass this pin to the GND pin with a 0.01-μF (minimum) ceramic capacitor rated for VCC
GND 2: Ground pin
OUT 3: Hall sensor open-drain output. The open drain requires a resistor pullup. (Used a 10KOhm


http://www.ti.com/product/drv5023
http://www.ti.com/lit/ds/symlink/drv5023.pdf
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNTER1anVITnh6M1k

SS49E Hall Effect Sensor
(Linear HEF which is not appropriate for what we're doing but it’s what I used for testing)
https://dscl.lcsr.jhu.edu/main/images/3/31/SS49e_Hall_Sensor_Datasheet.pdf
Google drive mirror of Datasheets
Honeywell
https://drive.google.com/open?id=0B7_sv8oBzuGNeVNaUzRMdDZEWlU
https://drive.google.com/open?id=0B7_sv8oBzuGNZ0o0NGk4Z3VpdlU
Knockoff
https://drive.google.com/open?id=0B7_sv8oBzuGNRExabEE3WEV2ekk

Voltage Divider Research (No longer required as the HEF allows 3.3V.)

Voltage divider calculators
https://en.wikipedia.org/wiki/Voltage_divider
http://www.learningaboutelectronics.com/Articles/Voltage-divider-calculator.php
http://www.raltron.com/cust/tools/voltage_divider.asp

Resistor colour code calculator
http://www.camradio.net/resistors.html

Voltage divider schematic, 5v Arduino to 3.3v ESP for example.



Use voltage divider above to bring down the 5V Hall Effect to 3.3V levels. Substitute 20K for 33K. We are using the SS49E Linear Hall Effect Sensor (HEF). Chart below to show the difference.
http://sensing.honeywell.com/index.php?ci_id=50359

Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNZ0o0NGk4Z3VpdlU
https://drive.google.com/open?id=0B7_sv8oBzuGNeVNaUzRMdDZEWlU

Arduino_TX Comes from Hall Effects sensor output.
ESP8266_RX go to ESP8266 pin 14 input.
GND to Ground.

Note: Found out this HEF works @3.3v so no need for the voltage divider. Interesting information none the less. Added the 3.3V without voltage divider to the table.

ESP8266 Pin Tolerances Information

http://download.arduino.org/products/UNOWIFI/0A-ESP8266-Datasheet-EN-v4.3.pdf
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNOVd1NmxXcG9CaGc

https://nurdspace.nl/ESP8266#Specifications
http://www.interfacebus.com/voltage_LV_threshold.html

Testing HIGH/LOW State of ESP Pin and Distance of HEF

Pin goes HIGH@~1.7VDC+ 1-2CM Distance.

Voltage divider tests with 33KOhm and 20KOhm resistors.
Field
3.3V
5V
3.3V (Voltage Divider 10KOhm/33KOhm)
 (Voltage Divider 10KOhm/20KOhm)
North
0.81V
0.85V
1.13V
0.99V
Idle
1.68V
2.46V
2.25V
1.97V
South
2.55V
4.19V
3.24V
2.89V

Schematic



Perfboard Fritzing Hall Effect Sensor Layout With Voltage Divider



Perfboard Fritzing Hall Effect Sensor Layout Without Voltage Divider



Perfboard Fritzing Hall Effect Sensor Layout With Ti DRV5023
10KOhm Resistor
(103) 0.01uF Ceramic Capacitor



Perfboard Hall Effect Sensor X 2



Mounted Hardware



Garage Door Tension Bar Encoder

Encoder / Debouncer BOM

4 x 10KOhm Resistors
2 x 10nf Ceramic Capacitors
1 x 3 Pin Header Male
1 x Rotary Encoder KAILH 11 EN971112R02
1 x Perfboard

Scavenged Computer Mouse Scroll Wheel Rotary Encoder.

Any 3 pin encoder should do the job though.

The nice thing about it, is that it will allow for a not so perfect TensionBar to spin around as the mouse allowed you to push it down to click a third button. Might help with wear and tear.




Found this datasheet on alibaba:

KAILH 	11 EN971112R02/EN981112R07 (E-Waste recycled from a scroll wheel mouse)

Encoder Setup

http://www.pjrc.com/teensy/td_libs_Encoder.html

PDF Mirror Of Website

https://drive.google.com/open?id=0B7_sv8oBzuGNWC1rTTdQSDNtRWc


This is the picture of a protoboard circuit from PJRC but they have no schematics on it.


I found this example of an encoder hookup, which I would guess, would be what PJRC is using.

https://hifiduino.wordpress.com/2010/10/21/arduino-code-for-buffalo-ii-dac-rotary-encoder-connections

PDF Mirror Of Website

https://drive.google.com/open?id=0B7_sv8oBzuGNRFlLak5mN0dDYXM


Schematic



Perfboard Fritzing Encoder Debouncer Layout



Perfboard Encoder Debouncer



Hardware Mounted

<Insert Picture Here>

Encoder seems to be operating more smoothly, with less miss reported values with debounce components added. This will probably help as well with addition of a long cable back to main board, as it’s pulling the lines high.

For sending encoder signal long distances maybe try a schmitt trigger someone suggested.
http://www.pcbheaven.com/wikipages/The_Schmitt_Trigger/

PDF Mirror Of Website

https://drive.google.com/open?id=0B7_sv8oBzuGNWks2Nkh0OFRHeFE
https://drive.google.com/open?id=0B7_sv8oBzuGNQkNEa25aQ1ljQXM

Temperature / Humidity / Pressure

Temperature Sensor BOM

1 x DHT22
1 x 100nF Ceramic Capacitor
1 x 4.7KOhm Resistor
1 x 3 Pin Header Male
1 x Perfboard

Or

1 x BME280 Pressure Temperature Humidity

Note: Temperature sensors DHT22 and BME280, one or the other, options in code. Code doesn’t fit on the standard arduino promini/leonardo if you use the BME280, use DHT22.

Adafruit BME280 I2C or SPI Temperature Humidity Pressure Sensor

https://www.adafruit.com/product/2652
PDF Mirror
https://drive.google.com/open?id=0B7_sv8oBzuGNX19kaDg1T3E2WkU
https://drive.google.com/open?id=0B7_sv8oBzuGNSUxpbTg0cS10LWc

Datasheet
https://cdn-shop.adafruit.com/product-files/2652/2652.pdf
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNOWVXa1N4Z3dvSUU

Or (Cheaper)

DHT22 temperature-humidity sensor + extras

https://www.adafruit.com/products/385
http://www.ebay.ca/itm/DHT22-AM2302-Digital-Temperature-and-Humidity-Sensor-Replace-SHT11-SHT15-MG1-/351492850240?hash=item51d69b4240:g:K68AAOSwfcVUH3FH

Price: USD $2.75


Datasheet

https://cdn-shop.adafruit.com/datasheets/Digital+humidity+and+temperature+sensor+AM2302.pdf
Google Drive Mirror of Datasheet
https://drive.google.com/open?id=0B7_sv8oBzuGNSHgySHFXendOTVE
Schematic


Fritzing Perfboard Layout




Perfboard Layout

<Insert Picture Here>

Hardware Mounted

<Insert Picture Here>

PSU

PSU BOM

2 x 10µF Electrolytic Capacitors
1 x 0.1µF Ceramic Capacitor
1 x 1N4001
1 x Barrel Jack
1 x 3.3v Linear Regulator
1 x 2 Pin Header Male
1 x Perfboard

Schematic



Fritzing Layout of PSU



Perfboard Layout

<Insert Picture Here>

Hardware Mounted

<Insert Picture Here>

Master Board Breakout for Microcontrollers & Parts

Microcontroller Connector Board BOM

2 x 12 Pin Female Headers
2 x 10 Pin Female Headers
4 x 3 Pin Female Headers
1 x 7 Pin Female Header
1 x 4 Pin Female Header
3 x 3 Pin Male Header
1 x Perfboard

Perfboard Layout



Microcontroller Pinouts



Hardware Mounted

<Insert Picture Here>

Full Setup of Mainboard

Fritzing Test Layout of The Parts
Full Perfboard Layout



Perfboard Layout

Front



Back



With Modules



Header Labels



Module Labels


Building Prototype Holders For Sensors

Hall Effect Holder

Encoder Holder

SOFTWARE
Software Required

ArchLinux https://www.archlinux.org/
Libvirt  https://wiki.archlinux.org/index.php/libvirt
QEMU-KVM https://wiki.archlinux.org/index.php/KVM
OpenHab http://www.openhab.org/
MQTT http://mqtt.org/
Avahi https://github.com/lathiat/avahi
Arduino Client for MQTT http://pubsubclient.knolleary.net/

Tools

MQTTlens https://chrome.google.com/webstore/detail/mqttlens/hemojaaeigabkbcookmlgmdigohjobjm?hl=en

ArchLinux Server Setup (Hardware)

https://wiki.archlinux.org/index.php/beginners'_guide

libvirt

https://wiki.archlinux.org/index.php/Libvirt

sudo pacman -S libvirt
sudo pacman -S virt-manager

QEMU-KVM

sudo pacman -S qemu

Setup the Virtual Machine Server quickly with virt-manager.

MQTT

Install MQTT broker (VMServer)

gpg --recv-keys 779B22DFB3E717B7
yaourt mosquitto

Configure Mosquitto

Create a system account and group.

sudo useradd -r -s /bin/false mosquitto

Copy configuration file from the example directory.

sudo cp /etc/mosquitto/mosquitto.conf.example /etc/mosquitto/mosquitto.conf

Open the configuration file.

sudo nano /etc/mosquitto/mosquitto.conf

# Config file for mosquitto
#
# See mosquitto.conf(5) for more information.
#
# Default values are shown, uncomment to change.
#
# Use the # character to indicate a comment, but only if it is the
# very first character on the line.

# =================================================================
# General configuration
# =================================================================

#... other stuff in between here ...

# Write process id to a file. Default is a blank string which means
# a pid file shouldn't be written.
# This should be set to /var/run/mosquitto.pid if mosquitto is
# being run automatically on boot with an init script and
# start-stop-daemon or similar.
pid_file /var/run/mosquitto.pid

# When run as root, drop privileges to this user and its primary
# group.
# Leave blank to stay as root, but this is not recommended.
# If run as a non-root user, this setting has no effect.
# Note that on Windows this has no effect and so mosquitto should
# be started by the user you wish it to run as.
user mosquitto

#... other stuff in between here ...

# =================================================================
# Default listener
# =================================================================
# IP address/hostname to bind the default listener to. If not
# given, the default listener will not be bound to a specific
# address and so will be accessible to all network interfaces.
# bind_address ip-address/host name
bind_address 192.168.1.42

# Port to use for the default listener.
port 1883

#... other stuff after here …

# =================================================================
# Security
# =================================================================

# If set, only clients that have a matching prefix on their
# clientid will be allowed to connect to the broker. By default,
# all clients may connect.
# For example, setting "secure-" here would mean a client "secure-
# client" could connect but another with clientid "mqtt" couldn't.
#clientid_prefixes

# Boolean value that determines whether clients that connect
# without providing a username are allowed to connect. If set to
# false then a password file should be created (see the
# password_file option) to control authenticated client access.
# Defaults to true.
allow_anonymous false

# In addition to the clientid_prefixes, allow_anonymous and TLS
# authentication options, username based authentication is also
# possible. The default support is described in "Default
# authentication and topic access control" below. The auth_plugin
# allows another authentication method to be used.
# Specify the path to the loadable plugin and see the
# "Authentication and topic access plugin options" section below.
#auth_plugin

# -----------------------------------------------------------------
# Default authentication and topic access control
# -----------------------------------------------------------------

# Control access to the broker using a password file. This file can be
# generated using the mosquitto_passwd utility. If TLS support is not compiled
# into mosquitto (it is recommended that TLS support should be included) then
# plain text passwords are used, in which case the file should be a text file
# with lines in the format:
# username:password
# The password (and colon) may be omitted if desired, although this
# offers very little in the way of security.
#
# See the TLS client require_certificate and use_identity_as_username options
# for alternative authentication options.
#password_file

# Access may also be controlled using a pre-shared-key file. This requires
# TLS-PSK support and a listener configured to use it. The file should be text
# lines in the format:
# identity:key
# The key should be in hexadecimal format without a leading "0x".
#psk_file

# Control access to topics on the broker using an access control list
# file. If this parameter is defined then only the topics listed will
# have access.
# If the first character of a line of the ACL file is a # it is treated as a
# comment.
# Topic access is added with lines of the format:
#
# topic [read|write|readwrite] <topic>
#
# The access type is controlled using "read", "write" or "readwrite". This
# parameter is optional (unless <topic> contains a space character) - if not
# given then the access is read/write.  <topic> can contain the + or #
# wildcards as in subscriptions.
#
# The first set of topics are applied to anonymous clients, assuming
# allow_anonymous is true. User specific topic ACLs are added after a
# user line as follows:
#
# user <username>
#
# The username referred to here is the same as in password_file. It is
# not the clientid.
#
#
# If is also possible to define ACLs based on pattern substitution within the
# topic. The patterns available for substitution are:
#
# %c to match the client id of the client
# %u to match the username of the client
#
# The substitution pattern must be the only text for that level of hierarchy.
#
# The form is the same as for the topic keyword, but using pattern as the
# keyword.
# Pattern ACLs apply to all users even if the "user" keyword has previously
# been given.
#
# If using bridges with usernames and ACLs, connection messages can be allowed
# with the following pattern:
# pattern write $SYS/broker/connection/%c/state
#
# pattern [read|write|readwrite] <topic>
#
# Example:
#
# pattern write sensor/%u/data
#
#acl_file

# -----------------------------------------------------------------
# Authentication and topic access plugin options
# -----------------------------------------------------------------

# If the auth_plugin option above is used, define options to pass to the
# plugin here as described by the plugin instructions. All options named
# using the format auth_opt_* will be passed to the plugin, for example:
#
# auth_opt_db_host
# auth_opt_db_port
# auth_opt_db_username
# auth_opt_db_password

#... other stuff after here …

Optionally change the default user, port and possibly other settings by uncommenting the relevant line and entering the relevant values.

sudo mosquitto_passwd -c /etc/mosquitto/passwd USERNAME

Enter your SUDO password, then the password you want for the Mosquitto user.

Enter Password: PASSWORD


Enable MQTT Broker and start it then check status for any issues.


sudo systemctl enable mosquitto
sudo systemctl start mosquitto
sudo systemctl status mosquitto

Subscribe to a topic with mosquitto_sub command.


-h Host, -p Port, -t Topic, -m Message

mosquitto_sub -h 192.168.1.42 -p 1883 -t home/garage/relay1

Publish a topic to a broker. (Publish means to send a message to the topic.)


-h Host, -p Port, -t Topic, -m Message

mosquitto_pub -h 192.168.1.42 -p 1883 -t home/garage/relay1 -m open sesame test message

OpenHab (VM Server)


Install openhab and addons

yaourt openhab-runtime
yaourt openhab-addons

This installs openhab to /opt/openhab-runtime

sudo mv /opt/openhab-runtime /opt/openhab

And /opt/openhab-addons so we have to copy the addons to the openhab-runtime directory so we can properly use MQTT add ons and other items of interest.

sudo cp /opt/openhab-addons/* /opt/openhab/addons/

Enable openhab server and start it then check status for any issues.


sudo systemctl enable openhab
sudo systemctl start openhab
sudo systemctl status openhab

Change the name of OpenHab default configuration file so it won’t get overwritten while updating.

sudo mv /opt/openhab/configuration/openhab_default.cfg /opt/openhab/configuration/openhab.cfg

Edit the openhab.cfg with the MQTT settings.

#######################################################################################
#####                       Transport configurations                              #####
#######################################################################################

################################# MQTT Transport ######################################
#
# Define your MQTT broker connections here for use in the MQTT Binding or MQTT
# Persistence bundles. Replace <broker> with a id you choose.
#

# URL to the MQTT broker, e.g. tcp://localhost:1883 or ssl://localhost:8883
mqtt:broker.url=tcp://192.168.1.42:1883

# Optional. Client id (max 23 chars) to use when connecting to the broker.
# If not provided a default one is generated.
mqtt:broker.clientId=openhab

# Optional. User id to authenticate with the broker.
mqtt:broker.user=USER

# Optional. Password to authenticate with the broker.
mqtt:broker.pwd=PASSWORD

# Optional. Set the quality of service level for sending messages to this broker.
# Possible values are 0 (Deliver at most once),1 (Deliver at least once) or 2
# (Deliver exactly once). Defaults to 0.
#mqtt:<broker>.qos=<qos>

# Optional. True or false. Defines if the broker should retain the messages sent to
# it. Defaults to false.
#mqtt:<broker>.retain=<retain>

# Optional. True or false. Defines if messages are published asynchronously or
# synchronously. Defaults to true.
#mqtt:<broker>.async=<async>

# Optional. Defines the last will and testament that is sent when this client goes offline
# Format: topic:message:qos:retained <br/>
#mqtt:<broker>.lwt=<last will definition>


(Optional) Avahi MQTT Broker Pointer

Install

https://wiki.archlinux.org/index.php/avahi

sudo pacman -S avahi
sudo pacman -S nss-mdns

sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon

Using Avahi
Hostname resolution
Avahi provides local hostname resolution using a "hostname.local" naming scheme. To enable it, install the nss-mdns package and start avahi-daemon.service.
Then, edit the file /etc/nsswitch.conf and change the line:
hosts: files dns myhostname


to:
hosts: files mdns_minimal [NOTFOUND=return] dns myhostname


Note: If you experience slowdowns in resolving .local hosts try to usemdns4_minimal instead of mdns_minimal.
Additional info about mdns
The mdns_minimal module handles queries for the .local TLD only. Note the [NOTFOUND=return], which specifies that if mdns_minimal cannot find *.local, it will not continue to search for it in dns, myhostname, etc. In case you have configured Avahi to use a different TLD, you should replace mdns_minimal [NOTFOUND=return] with the full mdns module. There also are IPv4-only and IPv6-only modules mdns[46](_minimal).
Tools
Avahi includes several utilities which help you discover the services running on a network. For example, run
$ avahi-browse -alr

Or just avahi-browse -a


to discover services in your network.
The Avahi Zeroconf Browser (avahi-discover – note that it needs avahi's optional dependencies pygtk and python2-dbus) shows the various services on your network. You can also browse SSH and VNC Servers using bssh and bvnc respectively.
There's a good list of software with Avahi support at their website:http://avahi.org/wiki/Avah4users
Firewall
Be sure to open UDP port 5353 if you're using iptables:
# iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT


If you're following the more-than-useful Simple stateful firewall format for your firewall:
# iptables -A UDP -p udp -m udp --dport 5353 -j ACCEPT


Obtaining IPv4LL IP address

By default, if you are getting IP using DHCP, you are using the dhcpcd package. It can attempt to obtain an IPv4LL address if it failed to get one via DHCP. By default this option is disabled. To enable it, comment noipv4ll string:
/etc/dhcpcd.conf
...
#noipv4ll
...
Alternatively, run avahi-autoipd:
# avahi-autoipd -D


Customizing Avahi

Adding Services

Avahi advertises the services whose *.service files are found in /etc/avahi/services. If you want to advertise a service for which there is no *.service file, it is very easy to create your own.
As an example, let's say you wanted to advertise Message Queuing Telemetry Transport (MQTT) service operating per http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/mqtt-v3.1.1.html on TCP port 1883 and 8883 secured which you are running on your server.

The first thing to do is to determine the <type>. man avahi.service indicates that the type should be "the DNS-SD service type for this service. e.g. '_http._tcp'". Since the
DNS-SD register was merged into the IANA register in 2010

mqtt        IBM MQ Telemetry Transport Broker
                AndySC <AndySC at uk.ibm.com>
                Protocol description: mqtt.org
                Defined TXT keys: topics=<open topic to subscribe to for information>, eg topic=/info

We can look for the service name on the
IANA register
Service Name
Port Number
Transport Protocol
Description
Assignee
Contact
Registration Date
Modification Date
Assignment Notes
mqtt
1883
tcp
Message Queuing Telemetry Transport Protocol
[OASIS]
[Robin_Cover]


2015-02-10


mqtt
1883
udp
Message Queuing Telemetry Transport Protocol
[OASIS]
[Robin_Cover]


2015-02-10


secure-mqtt
8883
tcp
Secure MQTT
[OASIS]
[Robin_Cover]
2008-02-27
2015-03-06


secure-mqtt
8883
udp
Secure MQTT
[OASIS]
[Robin_Cover]
2008-02-27
2015-03-06


mqtt




IBM MQ Telemetry Transport Broker
[AndySC]
[AndySC]




Defined TXT keys: topics=<open topic to subscribe to for information>, eg topic=/info

 or in /etc/services file. The service name shown there is mqtt. Since we're running MQTT on tcp, we now know the service is _mqtt._tcp and the port (per IANA and above info) is 1883 & Secured is 8883.
Our mosquitto.service file is thus:
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">

<!--
  This file is part of avahi.

  avahi is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation; either version 2 of the
  License, or (at your option) any later version.

  avahi is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with avahi; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
  02111-1307 USA.
-->

<!-- See avahi.service(5) for more information about this configuration file -->

<service-group>

  <name replace-wildcards="yes">%h</name>

  <service>
    <type>_mqtt._tcp</type>
    <port>1883</port>
  </service>

</service-group>


For more complicated scenarios, such as advertising services running on a different server, DNS subtypes and so on, consult man avahi.service.
Modifying the service-types database
As noted above, avahi comes with tools to browse advertised services. Both avahi-browse and avahi-discover use a database file to furnish descriptions of the relevant service. That database contains the names of many, but not all, services.
Sadly, it doesn't contain the MQTT service we just created. Thus avahi-browse -a would show the following ugly entry:
+ ens3 IPv4 automation001                                        _mqtt._tcp local


Getting the Sources
First, download the files build-db.in and service-types files from the service-type-database subdirectory in the the avahi github mirror to a build directory.
wget https://raw.githubusercontent.com/lathiat/avahi/master/service-type-database/build-db.in
wget https://raw.githubusercontent.com/lathiat/avahi/master/service-type-database/service-types


Modify the Sources
Second, create the following script:
nano avahichangetypedb.sh

#!/bin/bash
sed -e 's,@PYTHON\@,/usr/bin/python2.7,g' \
    -e 's,@DBM\@,gdbm,g' < build-db.in > build-db
chmod +x build-db


This mimics what the Makefile would do if one were building all of avahi. It creates a file named build-db.
$./avahichangetypedb.sh
$ ls
build-db build-db.in service-types avahichangetypedb.sh


Third, make the changes needed to add your new MQTT service to the service-types file. This file has one entry per line, with the entries in the format type:Human Readable Description. Note that the human readable description can contain spaces.
nano service-types
In our example, we add the following entry to the end of the file:
_mqtt._tcp:MQTT Broker


Build and Install the New Database
Now run the build-db python script (be sure to use python2, not python3). This will build the service-types.db file. Check to make sure it's been built and use gdbmtools to make sure the new database is loadable and contains the new entry:
$/usr/bin/python2.7 build-db
$ls
build-db build-db.in service-types service-types.db avahichangetypedb.sh
$gdbmtool service-types.db

Welcome to the gdbm tool.  Type ? for help.

gdbmtool>fetch _mqtt._tcp
MQTT Broker
gdbmtool>quit


Now copy the old database to a backup location, move the new database to the live directory and use avahi-browse database dump command to make sure avahi sees the new entry, note case matters for the grep:
$cp /usr/lib/avahi/service-types.db /backup-directory
$sudo cp /build-directory/service-types.db /usr/lib/avahi/service-types.db
$avahi-browse -b | grep MQTT
MQTT Broker


The entry in avahi-browse should now be:
+ ens3 IPv4 automation001                                        MQTT Broker local


OpenHAB WebGUI Configuration

Add and modify our Garage node and buttons

The sitemap config is what will get displayed to the user, were making a “Garage” node with a bunch of items we want to see under it, that go with our garage controller. The item=NAME is what links it inside the items config to the actual gears behind the scene eg. Switch NAME “Push Me” do some stuff here etc.

sudo nano /opt/openhab/configuration/sitemaps/home.sitemap

sitemap demo label="MY House"
{
	Frame label="Home" {
		Group item=gFF label="First Floor" icon="firstfloor"
		Group item=gGF label="Ground Floor" icon="groundfloor"
		/* Group item=gG label="Garage" icon="garage" */
		/* Frame { */
Text item gG label="gG label="Garage" icon="garage" {
	Text item=Weather_Temps
	Text item=Weather_Humis
	Text item=Weather_Baros
	Text item=Switch1
	Text item=Switch2
	Text item=Encoder mappings=[UP="Up", STOP="Stop", DOWN="Down"]
		Switch item=Relay1 mappings=[ON="Go!"]
	}
	Group item=gC label="Basement" icon="cellar"
	Group item=Outdoor icon="garden"
	}
}

The items configs are what makes the magic happen.

Note: The Less Than and Greater Than symbols in front of the MQTT commands are saying whether you want to Send or Receive information from the MQTT Broker.

sudo nano /opt/openhab/configuration/sitemaps/home.items

/* home.items */

dGroup All

/* Garage */
Group gG	(All)

Number Weather_Temps "Garage Temperature [%.1f °C]" <temperature> (gG) {mqtt="<[broker:hq/garage/temperature:state:default]"}
Number Weather_Humis "Garage Humidity [%.1f %%]" <temperature> (gG) {mqtt="<[broker:hq/garage/humidity:state:default]"}
Number Weather_Baros "Garage Barometer [%.1f hPa]" <temperature> (gG) {mqtt="<[broker:hq/garage/barometer:state:default]"}
Number Switch1 "Door Button Status [MAP(switchb.map):%d]" <garagedoor> (gG) {mqtt="<[broker:hq/garage/relay1:state:default]"}
Number Switch2 "Door Status [MAP(switchs.map):%d]" <garagedoor> (gG) {mqtt="<[broker:hq/garage/switch1:state:default]"}
Rollershutter Encoder "Door Encoder [%d %%]" <rollershutter> (gG) {mqtt=">[broker:hq/garage/cmd:command:*:default],<[broker:hq/garage/position:state:default]",autoupdate="false"}
Switch Relay1 "Garage Door" <garagedoor> (gG) {mqtt=">[broker:hq/garage/relay1:command:ON:1],>[broker:hq/garage/relay1:command:OFF:0]"}

The map configs are what allow us to rename conditions that come in to the OpenHAB server. For example, if the sensor sends a 1, we don’t want to show a 1 in the WebGUI. We want to show the word “ON” etc. Back in the items config above you will see the [MAP(mapname.map):%d] being used.

sudo nano /opt/openhab/configuration/transform/switchb.map

0=Idle
1=Pushed!
UNDEFINED=unknown
-=unknown

sudo nano /opt/openhab/configuration/transform/switchs.map

0=closed
1=open
UNDEFINED=unknown
-=unknown

OpenHAB Custom Icons

The “<humidity>” icon does not exist but you can add one and uploaded it to “/opt/openhab/webapps/images/humidity.png”.

Web GUI Output

http://192.168.1.42:8080/openhab.app?sitemap=demo

Note: I modified the WebGUI so that the Garage Door Go! Button and the Encoder % are on the same line, not shown below yet...

Garage Main Node


Inside Garage Main Node


OpenHab Mobile

Download app on mobile device.
https://play.google.com/store/apps/details?id=org.openhab.habdroid&hl=en
Source code here: https://github.com/openhab/openhab/wiki/HABDroid

Alternative Android Client https://github.com/igorgladkov/rotini/wiki/Release-Notes

OpenHAB is running in demo mode (Not connected to our OpenHAB server)
Change that by editing settings.


Set the OpenHAB URL.
Uncheck Demo Mode.
If you have your router configured to allow outside access, you can set the Remote URL as well.



Type the full (local) URL to the OpenHAB site IP & Port required.



It should now update with your OpenHAB Server setup.






Arduino Client for MQTT Install

yaourt arduino

Note: Currently version 1.6.5+ works with ESP8266, so you might have to download the newer version from the site. I would suggest installing the latest version from aur yaourt so it install all the dependencies for you, then you can just run the updated version from the TAR from arduino.cc.

https://downloads.arduino.cc/arduino-1.6.9-linux64.tar.xz

Source Code for GDS

https://codebender.cc/sketch:354004
or
https://create.arduino.cc/editor/NonaSuomy/328479eb-790a-4a45-8659-ffa29d713058

                           ^=== These will always be more up to date than below…
look here

{% github_sample_ref /NonaSuomy/nonasuomy.github.io/blob/989237901cb873f96df12be48cbf1239be496bd7/README.md %}
{% highlight ruby %}
{% github_sample /NonaSuomy/nonasuomy.github.io/blob/989237901cb873f96df12be48cbf1239be496bd7/README.md 0 5 %}
{% endhighlight %}


/*               VCC  G13 G12 G14 G16 EN ADC RST
 *                 \_   |  |  |    /  /  /  _/
 * ESP8266 ESP-12-F  \  |  |  |   /  /  /  /  
 *                   8  7  6  5  4  3  2  1
 * NonaSuomy       ___________________________________________
 *                / (_)(_)(_)(_)(_)(_)(_)(_)                  /;
 *               /_    _____________________ _____________   //
 *        CS0--9/(_)  /FCC ID: 2ADUIE SP-12/|  /  _______/  //
 *     MISO--10/(_)  /MODEL     ESP8266MOD/ / /  /______   //
 *   GPIO9--11/(_)  /VENDOR    Ai-THINKER/ / /  _______/  //
 * GPIO10--12/(_)  /ISM+PA  2.4GHz+25dBm/ / /  /______   //
 *  MOSI--13/(_)  /_FCC____802/11b/g/n_/ / /  _______/  //
 * SCLK--14/(_)  |_____________________|/ _  /______   //
 *        / _  _  _  _  _  _  _  _       /_/   AI  /  //
 *       /_(_)(_)(_)(_)(_)(_)(_)(_)_______________/__//
 *       `-------------------------------------------'
 *         15 16 17 18 19 20 21 22
 *         _/  |  |  |  |  |  |  \_      ^
 *        /    |  |  |  |  |  |    \     |
 *       GND G15 G2 G0 G4 G5 RXD0 TXD0  LED
 *
 * Name: Garage Door System
 * User: NonaSuomy
 * Date: 20160630
 * Desc: Garage door talks to OpenHab via MQTT with Adafruit Huzzah(ESP8266).
 * Link: https://codebender.cc/sketch:348727
 *
 * Future note to self: Lookup reconnect function. See the 'mqtt_reconnect_nonblocking'
 * example for how to achieve the same result without blocking the main loop.
 *
 * Install the ESP8266 board, (using Arduino 1.6.9) Currently 2.3.0
 * Website: http://esp8266.github.io/Arduino/versions/2.2.0
 * Github: https://github.com/esp8266/Arduino (Not required included in the Arduino Board Manager).
 *
 * Add the following 3rd party board under "File -> Preferences -> Additional Boards Manager URLs":
 * http://arduino.esp8266.com/stable/package_esp8266com_index.json
 *
 * Open the "Tools -> Board -> Board Manager" and click install for the ESP8266"
 *
 * Select the model of ESP8266 in "Tools -> Board"
 *
 * Install PubSubClient Library for MQTT (Currently using build for Mosquitto 3.1.1 (2.6.0)).
 * Website: http://pubsubclient.knolleary.net
 * Github: https://github.com/knolleary/pubsubclient (Not required, included in the Arduino Library Manager)
 * Arduino: Add the library under "Sketch => Include Library => Manage Libraries => PubSubClient by Nick O'Leary => Install".
 *
 * Install Encoder Library (Currently using build for 1.4.1).
 * Website: http://www.pjrc.com/teensy/td_libs_Encoder.html
 * Github: https://github.com/PaulStoffregen/Encoder (Not required, included in the Arduino Library Manager).
 * Arduino: Add the library under "Sketch => Include Library => Manage Libraries => Encoder by Paul Stoffregen => Install".
 *
 * Install Adafruit Unified Sensor Library (Currently using version 1.0.2).
 * Website: https://learn.adafruit.com/using-the-adafruit-unified-sensor-driver/introduction
 * Github: https://github.com/adafruit/Adafruit_Sensor (Not required, included in the Arduino Library Manager).
 * Arduino: Add the library under "Sketch => Include Library => Manage Libraries => Adafruit Unified Sensor by Adafruit => Install".
 *
 * Install Adafruit BME280 Library (Currently using version 1.0.4).
 * Website: https://learn.adafruit.com/adafruit-bme280-humidity-barometric-pressure-temperature-sensor-breakout/wiring-and-test
 * Github: https://github.com/adafruit/Adafruit_BME280_Library (Not required, included in the Arduino Library Manager).
 * Arduino: Add the library under "Sketch => Include Library => Manage Libraries => Adafruit BME280 by Adafruit => Install".
 *
 * AND OR
 *
 * Install DHT22 Library (Currently using version 1.2.3).
 * Website: https://learn.adafruit.com/dht
 * Github: https://github.com/adafruit/DHT-sensor-library (Not required, included in the Arduino Library Manager).
 * Arduino: Add the library under "Sketch => Include Library => Manage Libraries => DHT sensor library by Adafruit => Install".
 *
 * Use the Ethernet2 built-in library for WIZNET as it supports the DFRobot's DFR0342 board without modification.
 * Website: http://www.dfrobot.com/wiki/index.php?title=W5500_Ethernet_with_POE_Mainboard_SKU:_DFR0342
 * Github: https://github.com/Wiznet/WIZ_Ethernet_Library (Not required, included in the Arduino Library).
 * Arduino: This library is already included in ArduinoIDE 1.6.9+ no need to install anything. */

// Comment this out to disable serial debug print.
#define DEBUG

// Choose your weather sensor.
#define DHTSEN // Pick DHT22.sensor.
//#define BME280 // Pick BME280 sensor.

// Enable Encoder for Tension Bar.
#define ENCOPT

// Choose board.
//#define ESP8266
#define WIZNET

//Uncomment STATIC in the below if you want to use static IP settings (We use DHCP MAC Reserve).
#define DHCP // This is probably not required, defaults to DHCP if you don't define the IP.
//#define STATIC
//#define WIFISTATIC

// Uncomment this to enable MQTT.
#define MQTT

#ifdef DEBUG
  //#include "DebugUtils.h" // Debug Serial Print.
  int baud = 9600; //74880,115200;
#endif
#ifdef ESP8266
  #include <ESP8266WiFi.h> // ESP8266 library 2.3.0.
#endif
#ifdef WIZNET
  #include <SPI.h>
  #include <Ethernet.h>
#endif
#ifdef MQTT
#include <PubSubClient.h> // MQTT library 2.6.0.
#endif
#ifdef ENCOPT
  #include <Encoder.h> // Encoder library 1.4.1.
#endif
#include <Adafruit_Sensor.h> // Adafruit Sensor library 1.0.2.
#ifdef BME280
  #include <Adafruit_BME280.h> // Adafruit BME280 library 1.0.4.
  #include <Wire.h> // Wire library for defining I2C pins.
  #include <SPI.h> // Required by the BME library even though were not using SPI :S.
#endif
#ifdef DHTSEN
  #include <DHT.h> // DHT22 Temperature Sensor library.
#endif
/* Adafruit Huzzah ESP8266
   Warning: Do not use Pin 16, it pulses high/low during boot for anything that cannot take the pulse.
   (Like the relay, the garage door would open ever time it had a power reset).
   https://github.com/nodemcu/nodemcu-firmware/issues/421

   Maximum current drawn per pin is 12mA

   The ESP8266 requires 3.3V power voltage and peaks at 500mA or so of current for
   small periods of time. You'll want to assume the ESP8266 can draw up to 250mA
   so budget accordingly. To make it easier to power, Adafruit put a high-current-capable
   3.3V voltage regulator on the board. It can take 3.4-6V in but you should stick
   to 4-6V since the ESP8288 has high current usage when wifi is on.

V+ & VBat: Two inputs for the regulator, both have schottky diodes so you can connect both at different voltages and the regulator will simply power from the higher voltage. The V+ pin is also on the FTDI/serial header at the bottom edge.
   GPIO00: Does not have an internal pullup, and is also connected to both a mini tactile switch and red LED. This pin is used by the ESP8266 to determine when to boot into the bootloader. If the pin is held low during power-up it will start bootloading! That said, you can always use it as an output, and blink the red LED.
   GPIO02: Used to detect boot-mode. It also is connected to the blue LED that is near the WiFi antenna. It has a pullup resistor connected to it, and you can use it as any output (like #0) and blink the blue LED.
   GPIO04: Good for general use, also has an interrupt on it.
   GPIO05: Good for general use, also has an interrupt on it.
   GPIO12: Good for general use.
   GPIO13: Good for general use.
   GPIO14: Good for general use.
   GPIO15: Used to detect boot-mode. It has a pulldown resistor connected to it, make sure this pin isn't pulled high on startup. You can always just use it as an output.
   GPIO16: Can be used to wake up out of deep-sleep mode, you'll need to connect it to the RESET pin.
        A: Analog input pin called A. This pin has a ~1.0V maximum voltage, so if you have an analog voltage you want to read that is higher, it will have to be divided down to 0 - 1.0V range.
      LDO: Enable pin for the regulator. By default its pulled high, when connected to ground it will turn off the 3.3V regulator and is an easy way to cut power off to the whole setup. There is a 10K pullup is to whatever is greater, V+ or VBat.
      RST: Reset pin for the ESP8266, pulled high by default. When pulled down to ground momentarily it will reset the ESP8266 system. This pin is 5V compliant.
EN(CH_PD): Enable pin for the ESP8266, pulled high by default. When pulled down to ground momentarily it will reset the ESP8266 system. This pin is 3.3V logic only.
       3V: 3.3V output from the regulator available on this pin.
  RX & TX: Serial control and bootloading pins.
       TX: Output from the module and is 3.3V logic.
       RX: Input into the module and is 5V compliant (there is a level shifter on this pin).
*/
#ifdef ENCOPT
  #define ENCODER_A 4 // Garage door tension bar encoder pin A; Shows door percentage.
  #define ENCODER_B 5 // Garage door tension bar encoder pin B; Shows door percentage.
#endif
#ifdef WIZNET
  #define SS     10U    //D10----- SS
  #define RST    11U    //D11----- Reset
  #define DOOR1RELAY 13 // Garage door Open/Close switch.
  #define OPENHEF 12 // Garage door is Open sensor.
  #define CLOSEHEF 9 // Garage door is Closed sensor.
  #ifdef DHTSEN
    #define DHTTYPE DHT22 // Select DHT22 Model of DHT Sensors.
    #define DHTPIN  8 // DHT22 Sensor pin.
  #endif
#endif
#ifdef ESP8266
  #define DOOR1RELAY 13 // Garage door Open/Close switch.
  #define OPENHEF 12 // Garage door is Open sensor.
  #define CLOSEHEF 14 // Garage door is Closed sensor.
  #ifdef DHTSEN
    #define DHTTYPE DHT22 // Select DHT22 Model of DHT Sensors.
    #define DHTPIN  16 // DHT22 Sensor pin.
  #endif
#endif
#ifdef ENCOPT
  // Change these pin numbers to the pins connected to the encoder.
  // Best Performance: Both pins have interrupt capability
  // Good Performance: Only the first pin has interrupt capability
  // Low Performance:  Neither pin has interrupt capability
  // Avoid using pins with LEDs attached
  Encoder TBEnc(4, 5); // Tension Bar Encoder, Pins 4 & 5 have interrupts on the ESP8266 for Best Performance.
#endif

// Update these with values, suitable for your wifi network.
const char* ssid = "SSID"; // The name of your wifi ssid.
const char* password = "PASSWORD"; // The password of your wifi.

#ifdef WIZNET
  // Update this to either the MAC address found on the sticker on your Ethernet shield (newer shields)
  // or a different random hexadecimal value (change at least the last four bytes)
  byte mac[]    = {0xDE, 0xED, 0xBE, 0xEF, 0xFE, 0xED };
  //char macstr[] = "deadbeeffeed";
#endif

#ifdef STATIC
  // Static IP Values (I use DHCP reservation on the router, so this is not valid for me).
  //IPAddress mqttServer( 192, 168, 1, 42 );  // Hardcode of Mosquitto Broker IP on local intranet connected server.
  byte IP[]         = { 192, 168, 1, 100 };  // Hardcode for this esp8266 node.
  byte Netmask[]    = { 255, 255, 255, 0 }; // Local router nfo.
  byte Gateway[]    = { 192, 168, 1, 1 };   // Local router nfo.
#endif
#ifdef MQTT
  // Update these with values, suitable for your MQTT Broker.
  const char* mqtt_broker = "192.168.1.52"; // MQTT Broker IP address.
  const char* mqtt_user = "MQTTUSER"; // MQTT Broker user.
  const char* mqtt_pass = "MQTTPASS"; // MQTT Broker password.

  // MQTT connect counter to track if out of sync.
  long mqtt_connect_count = 0;
#endif
#ifdef ESP8266
  WiFiClient espClient; // Engage WiFiClient.
  #ifdef MQTT
    PubSubClient mqttclient(espClient); // Engage which connection we will use for MQTT Client.
  #endif
#endif
#ifdef WIZNET
  EthernetClient ethClient;
  #ifdef MQTT
    PubSubClient mqttclient(ethClient);
    //http://public.dhe.ibm.com/software/dw/cloud/cl-bluemix-arduino-iot2/MQTT_IOT_SENSORS.ino
  #endif
#endif
#ifdef MQTT
  // Setup MQTT Topics for publishing to.
  #define mast_topic "hq/garage/#"
  #define rel1_topic "hq/garage/relay1"
  #define swi1_topic "hq/garage/switch1"
  #define posi_topic "hq/garage/position"
  #define avai_topic "hq/garage/available"
  #define humi_topic "hq/garage/humidity"
  #define temp_topic "hq/garage/temperature"
  #define baro_topic "hq/garage/barometer"
#endif
#ifdef BME280
  // Setup Weather Sensor.
  Adafruit_BME280 bme; // I2C
#endif
#ifdef DHTSEN
  // Initialize DHT sensor
  // NOTE: For working with a faster than ATmega328p 16MHz Arduino chip, like an ESP8266,
  // you need to increase the threshold for cycle counts considered a 1 or 0.
  // You can do this by passing a 3rd parameter for this threshold.  It's a bit
  // of fiddling to find the right value, but in general the faster the CPU the
  // higher the value.  The default for a 16mhz AVR is a value of 6.  For an
  // Arduino Due that runs at 84MHz a value of 30 works.
  // This is for the ESP8266 processor on ESP-01 - See more at: http://www.esp8266.com/viewtopic.php?f=29&t=8746#sthash.5TIyxTYl.dpuf
  DHT dht(DHTPIN, DHTTYPE, 11); // 11 works fine for ESP8266
#endif
// Setup weather varables.
long lastMsg = 0;
long lastForceMsg = 0;
bool forceMsg = false;
float temp = 0.0;
float hum = 0.0;
float baro = 0.0;
float diff = 1.0;
#ifdef BME280
  // If you have more than one sensor, make each one a different number here.
  #define sensor_number "1"
  // Lookup for your altitude and fill in here, units hPa
  // Positive for altitude above sea level
#endif
#define baro_corr_hpa 34.5879 // = 298m above sea level
#ifdef ENCOPT
  // Setup encoder postion varable.
  long TBEncPos = -999;
  long TBEncLast;
  long TBEncOpen = 310;
  long TBEncClosed = 0;
  long TBEncPercent,TBEncPercLast;
#endif
// Setup non-blocking delay varables.
long millis_now;
long millis_prev1;
long millis_prev2;
long millis_prev3;

// Track switch open/close status so we don't spam MQTT Broker.
int swopenstat, swopenlast;  
int swclosestat, swcloselast;

// Setup Pins / Serial / WiFi / MQTT / etc.
void setup() {
  #ifdef WIZNET
    pinMode(SS, OUTPUT);
    pinMode(RST, OUTPUT);
    digitalWrite(SS, LOW);
    digitalWrite(RST,HIGH);  //Reset
    delay(200);
    digitalWrite(RST,LOW);
    delay(200);
    digitalWrite(RST,HIGH);  
    delay(200);              //Wait W5500
  #endif
  #ifdef DEBUG
    //Serial.begin(74880); // Enable arduino serial, 74880 is the boot baud of the ESP.
    Serial.begin(baud); // Enable arduino serial,115200 is the firmware baud after boot.
    while (!Serial) {
      ; // wait for serial port to connect. Needed for Leonardo only
    }
  #endif
  #ifdef ESP8266
    setup_wifi(); // Setup wifi function.
  #endif
  #ifdef WIZNET
    // Start the Ethernet connection:
    #ifdef DHCP
      if (Ethernet.begin(mac) == 0) {
        #ifdef DEBUG
          Serial.println("Failed to configure Ethernet using DHCP");
        #endif
        // no point in carrying on, so do nothing forevermore:
        for (;;)
          ;
      }
    #else
      Ethernet.begin(mac,IP);
    #endif

    #ifdef DEBUG
      // print your local IP address:
      Serial.print("My IP address: ");
      for (byte thisByte = 0; thisByte < 4; thisByte++) {
        // print the value of each byte of the IP address:
        Serial.print(Ethernet.localIP()[thisByte], DEC);
        Serial.print(".");
      }
      Serial.println();
    #endif
  #endif
  // Prepare GPIO12,GPIO13,GPIO14
  pinMode(DOOR1RELAY, OUTPUT); // Door Relay1 GPIO13.
  digitalWrite(DOOR1RELAY, LOW); // Door Relay1 GPIO13 start state LOW.
  pinMode(CLOSEHEF, INPUT); // Close Switch GPIO14.
  pinMode(OPENHEF, INPUT); // Open Switch GPIO12.
  //pinMode(BUILTIN_LED, OUTPUT);     // Initialize the BUILTIN_LED pin as an output GPIO00.
  #ifdef BME280
    // Set SDA and SDL ports (I2C) for BME280.
    // Wire.begin(SDA, SCL); //SDA to SDI on BME280, SDL to SCK on BME280.
    #ifdef ESP8266
      Wire.begin(0, 2);
    #else
      Wire.begin();
    #endif
  #endif
  // Start Weather Sensor
  #ifdef DHTSEN
    dht.begin(); // Start the DHT Sensor.
  #endif
  #ifdef BME280
    if (!bme.begin()) {
      #ifdef DEBUG
        Serial.println("Could not find a valid BME280 sensor, check wiring!");
      #endif
      while (1);
    }
  #endif
  #ifdef MQTT
    mqttclient.setServer(mqtt_broker, 1883); // Setup MQTT server and Port.
    mqttclient.setCallback(callback); // Setup callback to grab MQTT topics.
  #endif
}
void setup_ethernet() {
  //delay(10);
}
#ifdef ESP8266
  // Setup our WiFi connection.
  void setup_wifi() {
    delay(10);
    #ifdef DEBUG
      // Print the SSID name to serial monitor.
      Serial.println();
      Serial.print("Connecting to ");
      Serial.print(ssid);
    #endif
    // Connect to specified WiFi network.
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
      yield(); // Let the ESP8266 do other computations.
      delay(500);
      #ifdef DEBUG
        Serial.print("."); // Send dots to the serial monitor until connected.
      #endif
    }
    #ifdef DEBUG
      // Send the serial monitor that we are connected to WiFi.
      Serial.println("");
      Serial.println("WiFi connected.");
    #endif
    // For static IP settings (We use DHCP MAC Reserve).
    #ifdef WIFISTATIC
      WiFi.config(IPAddress(IP[0],IP[1],IP[2],IP[3] ),  
                  IPAddress(Gateway[0],Gateway[1],Gateway[2],Gateway[3] ),
                  IPAddress(Netmask[0],Netmask[1],Netmask[2],Netmask[3] ));
      WiFi.mode(WIFI_STA);
    #endif
    #ifdef DEBUG
      // Send serial monitor our IP address.
      Serial.print("IP address: ");
      Serial.println(WiFi.localIP());
      DEBUG_PRINT("Setup Finished...");
    #endif
  }
#endif
#ifdef MQTT
  // Grab content from MQTT broker, topic eg: "hq/garage/switch1"
  // payload will contain the values of the topics.
  // length will contain how long the string is.
  void callback(char* topic, byte* payload, unsigned int length) {
    #ifdef DEBUG
      // Send serial monitor the topic that arrived.
      Serial.print("Message arrived [");
      Serial.print(topic);
      Serial.print("] ");
      // Send serial monitor the topics values.
      for (int i = 0; i < length; i++) {
        Serial.print((char)payload[i]);
      }
      Serial.println();
    #endif
    #ifdef MQTT
      // Check for correct topic of relay1.
      if (String(topic) == rel1_topic) {
        // Switch on LED and fire off door1relay if "1" was received, stored in first array value of the payload.
        if ((char)payload[0] == '1') {
          // Turn the LED ON (Note that LOW is the voltage level
          // but actually the LED is on; this is because
          // it is active low on the Huzzah[ESP8266])
          //digitalWrite(BUILTIN_LED, LOW);
          // Trigger DOOR1Relay, wait 250ms then turn off relay.
          digitalWrite(DOOR1RELAY, 1); // Relay ON
          // DON'T send MQTT Broker relay status of 1 meaning ON, because OpenHab already sent this to the topic.
          delay(250); // Wait 250ms to emulate a human pushing the garage door button.
          // Turn the LED OFF by making the voltage HIGH, because of active LOW state.
          //digitalWrite(BUILTIN_LED, HIGH);
          digitalWrite(DOOR1RELAY, 0); // Relay OFF

          // Send MQTT Broker relay status of 0 meaning its off now.
          mqttclient.publish(rel1_topic, "0");
          #ifdef DEBUG
            Serial.println("MQTT Says, Relay triggered!");
          #endif
        }
      }
    #endif
    #ifdef MQTT
      // Check for correct topic of switch1 open.
      if (String(topic) == swi1_topic) {
        if ((char)payload[0] == '1') {
          #ifdef DEBUG
            // Send serial monitor switch status.
            Serial.println("MQTT Says, Open Switch Hit!");
          #endif
        } else {
          // Send serial monitor switch null status.
          #ifdef DEBUG
            Serial.println("MQTT Says, Close Switch Hit!");
            //Serial.println("Door closing...");
          #endif
        }
      }
      /*
      // Check for correct topic of switch1 close.
      if (String(topic) == swi1_topic) {
        if ((char)payload[0] == '0') {
          // Send serial monitor switch status.
          #ifdef DEBUG
            Serial.println("Close Switch Hit!");
          #endif
        } else {
          // Send serial monitor switch null status.
          #ifdef DEBUG
            //Serial.println("Door opening...");
          #endif
        }
      }
      */
    #endif
    #ifdef MQTT
      // Check for correct topic of temperature.
      if (String(topic) == temp_topic) {
        // Send serial monitor garage temperature.
        #ifdef DEBUG
          Serial.print("MQTT Says, Garage Temperature: ");
          Serial.print((char)payload[0]);
          Serial.print((char)payload[1]);
          Serial.print((char)payload[2]);
          Serial.print((char)payload[3]);
          Serial.println((char)payload[4]);
        #endif
      }
    #endif
    #ifdef MQTT
      // Check for correct topic of position from tension bar encoder.
      if (String(topic) == posi_topic) {
        // Send serial monitor garage temperature.
        #ifdef DEBUG
          Serial.print("MQTT Says, Garage Door Position: ");
          Serial.print((char)payload[0]);
          Serial.print((char)payload[1]);
          Serial.println((char)payload[2]);
        #endif
      }
    #endif
  }
#endif
#ifdef MQTT
  void reconnect() {
    //                      ( String id,     String willTopic,    uint8_t willQos, bool willRetain, String willMessage)
    //if (mqttClient.connect("espcli_garage",avai_topic,          0,               0,               "0")){
    // Loop until reconnected to MQTT Broker.
    while (!mqttclient.connected()) {
  	  #ifdef ESP8266
      yield(); // Let the ESP8266 do other computations.
      #endif
      #ifdef DEBUG
      Serial.println("Attempting MQTT Broker connection...");
      #endif
      // Attempt to connect and send MQTT Broker our module name were connecting with.
      // Note: You will see this name in the MQTT Broker log. "ESPGarage01"

      // If you do not want to use a username and password, change next line to
      // if (mqttclient.connect("ESPGarage01")) {
      if (mqttclient.connect("ESPGarage01", mqtt_user, mqtt_pass)) {
        #ifdef DEBUG
          Serial.print("Connected to the MQTT Broker: ");
          Serial.println(mqtt_broker);
        #endif
        // Once connected, publish to "available" topic that this module is online...
        mqttclient.publish("hq/garage/available", "1");
        // Re-subscribe to all topics under the garage topic.
        // Note: The pound(#) symbol, this is what subscribes to all topics under it (available,relay1,switch1,position,temp).
        mqttclient.subscribe(mast_topic);
      // Connection failed. Send the serial monitor the issue why. Wait 5 seconds and try again.
      } else {
        #ifdef DEBUG
          Serial.print("Failed, rc=");
          Serial.print(mqttclient.state());
          Serial.println(" trying again in 5 seconds...");
        #endif
        // Wait 5 seconds before retrying
        delay(5000);
      }
      #ifdef ESP8266
        yield(); // Let the ESP8266 do other computations.
      #endif
      mqtt_connect_count ++; // Tally up how many times we have retried to connect.
      if(mqtt_connect_count > 5){   //Something is out of sync somewhere... do a system reset.
        #ifdef DEBUG
          Serial.println("Hardware is out of sync... system is resetting..");
        #endif
        #ifdef ESP8266
          //WiFiClient.stop(); // Stop the WiFi connection.
          //WiFiClient.flush(); // flush all WiFi values.
          //WiFi.mode(WIFI_OFF); // Turn off the wifi module.
          //WiFi.disconnect(1); // Disconnect from the WiFi module.
          yield(); // Let the ESP8266 do other computations.
          //delay(5000); //Give the router time to recognize disconnected node.
          //ESP.restart(); // Restart the ESP8266.
        #endif
      }
    }
  }
#endif
// Check for Weather Sensor values change.
#ifdef BME280
  // BME280 uncomment this.
  bool checkBound(float newValue, float prevValue, float maxDiff) {
    return newValue < prevValue - maxDiff || newValue > prevValue + maxDiff;
  }
#endif
#ifdef DHTSEN
  // DHT22.
  bool checkBound(float newValue, float prevValue, float maxDiff) {
    return !isnan(newValue) &&
           (newValue < prevValue - maxDiff || newValue > prevValue + maxDiff);
  }
#endif

// Main programming loop.
void loop() {
  #ifdef ESP8266
    yield(); // Let the ESP8266 do other computations.
  #endif
  // check if module is not connected to MQTT server, if not reconnect.
  #ifdef MQTT
    if (!mqttclient.connected()) {
      reconnect();
    }
    // Call MQTT client loop.
    mqttclient.loop();
  #endif
  // Capture the current millis for non-blocking delay.
  millis_now = millis();
  #ifdef ENCOPT
    // Setup encoder and set current value to TBEncPos.
    long newTBEnc;
    newTBEnc = TBEnc.read();
    if (newTBEnc != TBEncPos) {
      #ifdef DEBUG
        Serial.print("TensionBarEncoder = ");
        Serial.print(newTBEnc);
        Serial.println();
      #endif
      TBEncPos = newTBEnc;
    }
  #endif
  // Check Encoder status every 2 seconds.
  if (millis_now > (millis_prev3 + 2000)) {  
    millis_prev3 = millis_now;
    #ifdef ENCOPT
      char TBEncoder[8];
      // Calculate the percentage of the door position.
      if (TBEncClosed != 0) {
        TBEncPercent = map(TBEncPos, TBEncOpen, TBEncClosed, 0, 100);
        itoa(TBEncPercent,TBEncoder,10); // Integer to string
        if (TBEncPercent != TBEncPercLast) {
          TBEncPercLast = TBEncPercent;
          #ifdef DEBUG
            Serial.print("TensionBarPercent = ");
            Serial.print(TBEncoder);
            Serial.println("%");
          #endif
        }
        // Prevent Topic Spamming (Check if encoder is same value).
        if (TBEncLast != TBEncPos) {
          TBEncLast = TBEncPos;
          #ifdef MQTT
            mqttclient.publish("hq/garage/position",TBEncoder);
          #endif
        }
      }
    #endif
  }

  // Check close switch status every 5 seconds.
  if (millis_now > (millis_prev1 + 5000)) {  
    millis_prev1 = millis_now;
    // Check if door switch closed is triggered.
    if (digitalRead(CLOSEHEF) == LOW) {
      swclosestat = 1;
      // Prevents spamming the MQTT Broker with publishes not needed.
      if (swclosestat != swcloselast) {
        swcloselast = swclosestat;
        #ifdef MQTT
          // Publish door status of Open to the MQTT Broker.
          mqttclient.publish("hq/garage/switch1", "1");
        #endif
        #ifdef ENCOPT
          //Serial.println("Reset TensionBar Encoder to Max Value.");
          //TBEnc.write(100);
          // Store final open position of encoder to calculate percentage.
          TBEncOpen = TBEncPos;
            #ifdef DEBUG
              Serial.print("Current Open Value: ");
              Serial.println(String(TBEncOpen));
            #endif
        #endif
      }
    } else {
      swclosestat = 0;
      // Prevents spamming the MQTT server with publishes not needed.
      if (swclosestat != swcloselast) {
        swcloselast = swclosestat;
        //#ifdef MQTT
          // Publish door status of Closed to the MQTT Broker.
          // Only required if you have one switch.
          //mqttclient.publish("hq/garage/switch1", "0");
        //#endif
        //#ifdef DEBUG
          //Serial.println("Reset Tension Bar Encoder to zero.");
        //#endif
        // Store final closed position of encoder to calculate percentage.
        //#ifdef ENCOPT
          //TBEncClosed = TBEncPos;
        //#endif
      }
    }
    // Comment this out if you only have one switch:
    // Check if door switch open is triggered.
    if (digitalRead(OPENHEF) == LOW) {
      swopenstat = 1;
      if (swopenstat != swopenlast) {
        swopenlast = swopenstat;
        #ifdef MQTT
          mqttclient.publish("hq/garage/switch1", "0");
        #endif
        #ifdef ENCOPT
          //TBEnc.write(310);
          if (TBEncPos < 0) {
            #ifdef DEBUG
              Serial.println("Reset TensionBar Encoder to zero.");
            #endif
            TBEnc.write(0);
          }
          TBEncClosed = TBEncPos;
          #ifdef DEBUG
            Serial.print("Current Closed Value: ");
            Serial.println(String(TBEncClosed));
          #endif
        #endif
      }
    } else {
      swopenstat = 0;
      if (swopenstat != swopenlast) {
        swopenlast = swopenstat;
        //#ifdef MQTT
          // Publish door status to the MQTT Broker.
          // Only required if you have one switch.
          //mqttclient.publish("hq/garage/switch1", "1");
        //#endif
      }
    }
  }
  // Send MQTT Broke that this module is still alive every 5 mins and check temperature.
  if (millis_now > (millis_prev2 + 300000)){ //5 min
    millis_prev2 = millis_now;
    #ifdef MQTT
      // Send alive message to MQTT Broker.
      mqttclient.publish("hq/garage/available","1");
    #endif
    // Check temperature
    #ifdef BME280
      // MQTT broker could go away and come back at any time
      // so doing a forced publish to make sure something shows up
      // within the first 5 minutes after a reset
      if (millis_now - lastForceMsg > 300000) {
        lastForceMsg = millis_now;
        forceMsg = true;
        #ifdef DEBUG
          Serial.println("Forcing publish every 5 minutes...");
        #endif
      }
      // Setup up weather floats
      float newTemp = bme.readTemperature();
      float newHum = bme.readHumidity();
      float newBaro = bme.readPressure() / 100.0F;
      // Make sure temperature is not the same as before and force message is true, print results.
      if (checkBound(newTemp, temp, diff) || forceMsg) {
        temp = newTemp;
        float temp_c=temp; // Celsius
        float temp_f=temp*1.8F+32.0F; // Fahrenheit
        #ifdef DEBUG
          Serial.print("New temperature:");
          Serial.print(String(temp_c) + " degC   ");
          Serial.println(String(temp_f) + " degF");
        #endif
        #ifdef MQTT
          // Send MQTT Broker Temperature data.
          mqttclient.publish(temp_topic, String(temp_c).c_str(), true);
          // We don't require imperial standards uncomment if you do..
          //mqttclient.publish(temperature_f_topic, String(temp_f).c_str(), true);
        #endif
      }
      // Check if humidity is different than before and forcemsg is true, print results.
      if (checkBound(newHum, hum, diff) || forceMsg) {
        hum = newHum;
        #ifdef DEBUG
          Serial.print("New humidity:");
          Serial.println(String(hum) + " %");
        #endif
        #ifdef MQTT
          // Send MQTT Broker humidity data.
          mqttclient.publish(humi_topic, String(hum).c_str(), true);
        #endif
      }
      // Check if barometer is different than before and forcemsg is true, print results.
      if (checkBound(newBaro, baro, diff) || forceMsg) {
        baro = newBaro;
        float baro_hpa=baro+baro_corr_hpa; // hPa corrected to sea level
        float baro_inhg=(baro+baro_corr_hpa)/33.8639F; // inHg corrected to sea level
        #ifdef DEBUG
          Serial.print("New barometer:");
          Serial.print(String(baro_hpa) + " hPa   ");
          Serial.println(String(baro_inhg) + " inHg");
        #endif
        #ifdef MQTT
          // Send MQTT Broker barometer data.
          mqttclient.publish(baro_topic, String(baro_hpa).c_str(), true);
          //mqttclient.publish(barometer_inhg_topic, String(baro_inhg).c_str(), true);
        #endif
      }
      // Untrigger the force data push.
      forceMsg = false;
    #endif

    #ifdef DHTSEN
      // Setup weather floats.
      float newTemp = dht.readTemperature();
      float newHum = dht.readHumidity();
      // Check temperature is different than last check.
      if (checkBound(newTemp, temp, diff)) {
        temp = newTemp;
        #ifdef DEBUG
          Serial.print("New temperature:");
          Serial.println(String(temp).c_str());
        #endif
        #ifdef MQTT
          mqttclient.publish(temp_topic, String(temp).c_str(), true);
        #endif
      }
      // Check humidity is different than last check.
      if (checkBound(newHum, hum, diff)) {
        hum = newHum;
        #ifdef DEBUG
          Serial.print("New humidity:");
          Serial.println(String(hum).c_str());
        #endif
        #ifdef MQTT
          mqttclient.publish(humi_topic, String(hum).c_str(), true);
        #endif
      }
    #endif
  }
}
`

Programming Huzzah!

Hold down the GPIO0 button, the red LED will be lit.
While holding down GPIO0, click the RESET button.
When you release the RESET button, the red LED will be lit dimly, this means it’s ready to bootload.
This is what a successful upload will look like:

Garage Door Test 1

Calibration





What you see below, is the garage door first opening to its Max Value hitting the limit switch (Hall effect sensor) and setting the max value for the Map function, The Map function will map our wild range of 0 to whatever to 0 to 100 values to send the MQTT Server for OpenHAB:


TensionBarEncoder = 307
TensionBarEncoder = 308
Open Switch Hit!
Current Open Value: 308
Message arrived [hq/garage/switch1] 1
Current Open Value: 307
Current Open Value: 306

After that we triggered the garage door to close again which it then hits the limit switch and stores its Min Value as you can see below it goes past 0 into negative territory, we don’t want to send that to our OpenHAB MQTT server so we first check if less than zero if so reset our encoder to zero and then send the server the response:

TensionBarEncoder = 1
TensionBarEncoder = 0
TensionBarEncoder = -1
TensionBarEncoder = -2
TensionBarEncoder = -3
TensionBarEncoder = -4
TensionBarEncoder = -5
TensionBarEncoder = -6
Close Switch Hit!
Message arrived [hq/garage/switch1] 0
Reset TensionBar Encoder to zero.
Current Closed Value: 100%
Message arrived [hq/garage/position] 100
TensionBarEncoder = 0
TensionBarEncoder = 1

Calibration Completed Running with it...

You can see above, now that the Current Closed Value is set and calibrated. The ESP8266 can start outputting its open/close percentages.

TensionBarEncoder = 26
Garage Door Position: 89%
Message arrived [hq/garage/position] 89
TensionBarEncoder = 27

TensionBarEncoder = 66
Garage Door Position: 77%
Message arrived [hq/garage/position] 77
TensionBarEncoder = 67

TensionBarEncoder = 110
Garage Door Position: 63%
Message arrived [hq/garage/position] 63
TensionBarEncoder = 111

TensionBarEncoder = 156
Garage Door Position: 48%
Message arrived [hq/garage/position] 48
TensionBarEncoder = 157

TensionBarEncoder = 196
Garage Door Position: 35%
Message arrived [hq/garage/position] 35
TensionBarEncoder = 197

TensionBarEncoder = 246
Garage Door Position: 19%
Message arrived [hq/garage/position] 19
TensionBarEncoder = 247

TensionBarEncoder = 296
Garage Door Position: 3%
Message arrived [hq/garage/position] 3
TensionBarEncoder = 297

TensionBarEncoder = 308
Garage Door Position: 0%
Message arrived [hq/garage/position] 0

The ESP8266 only checks the percentage every 2 seconds so it doesn’t spam the MQTT server with constant updates.

Useless Stats

2 Seconds per publish X 9 publishes to the MQTT server, maybe around ~18 seconds to open and close,.

Distance of Chain Travel Open/Close: 2 Meters 31 Centimeters (7 feet 6 15/16 inches).
231cm / 18s = 12.83cm/s (Not accurately timed).

I later on used a stopwatch and it took ~15 seconds to open/close, close enough!

There is also a BME280 attached to the board via i2c checking for environment stats and a ping to the MQTT Broker to tell it that the board is online:

Publishing every 5 minutes…

Message arrived [hq/garage/available] 1

New temperature: 27.75 degC   81.95 degF
New humidity: 54.12 %
New barometer: 1017.89 hPa   30.06 inHg
Garage Temperature: 27.75
Message arrived [hq/garage/temperature] 27.75
Message arrived [hq/garage/humidity] 54.12
Message arrived [hq/garage/barometer] 1017.89


Full log below...

Note: I’m holding the encoder against the Tension Bar temporarily for the test before mounting it on, as to why you may see the encoder steps jump back and forth, I moved my hand a bit during testing.

Serial Monitor:

<Start of Serial Monitor>
Connecting to SSID......
WiFi connected.
IP address: 10.0.0.81
Attempting MQTT Broker connection...
Connected to the MQTT Broker: 10.0.0.42

Garage Temperature: 25.24
Message arrived [hq/garage/temperature] 25.24
Message arrived [hq/garage/humidity] 51.93
Message arrived [hq/garage/barometer] 1018.05
TensionBarEncoder = 0
TensionBarEncoder = 1
TensionBarEncoder = 2
TensionBarEncoder = 3
TensionBarEncoder = 4
TensionBarEncoder = 3
TensionBarEncoder = 4
TensionBarEncoder = 5
TensionBarEncoder = 6
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 9
TensionBarEncoder = 10
TensionBarEncoder = 11
TensionBarEncoder = 10
TensionBarEncoder = 11
TensionBarEncoder = 12
TensionBarEncoder = 13
TensionBarEncoder = 14
TensionBarEncoder = 15
TensionBarEncoder = 16
TensionBarEncoder = 15
TensionBarEncoder = 16
TensionBarEncoder = 17
TensionBarEncoder = 18
TensionBarEncoder = 19
TensionBarEncoder = 20
TensionBarEncoder = 19
TensionBarEncoder = 20
TensionBarEncoder = 21
TensionBarEncoder = 22
TensionBarEncoder = 23
TensionBarEncoder = 24
TensionBarEncoder = 25
TensionBarEncoder = 26
TensionBarEncoder = 27
TensionBarEncoder = 26
TensionBarEncoder = 27
TensionBarEncoder = 28
TensionBarEncoder = 29
TensionBarEncoder = 30
TensionBarEncoder = 31
TensionBarEncoder = 30
TensionBarEncoder = 31
TensionBarEncoder = 32
TensionBarEncoder = 33
TensionBarEncoder = 34
TensionBarEncoder = 35
TensionBarEncoder = 36
TensionBarEncoder = 37
TensionBarEncoder = 38
TensionBarEncoder = 39
TensionBarEncoder = 40
TensionBarEncoder = 41
TensionBarEncoder = 42
TensionBarEncoder = 43
TensionBarEncoder = 44
TensionBarEncoder = 43
TensionBarEncoder = 44
TensionBarEncoder = 45
TensionBarEncoder = 46
TensionBarEncoder = 47
TensionBarEncoder = 48
TensionBarEncoder = 49
TensionBarEncoder = 50
TensionBarEncoder = 51
TensionBarEncoder = 52
TensionBarEncoder = 53
TensionBarEncoder = 54
TensionBarEncoder = 55
TensionBarEncoder = 56
TensionBarEncoder = 55
TensionBarEncoder = 56
TensionBarEncoder = 57
TensionBarEncoder = 58
TensionBarEncoder = 59
TensionBarEncoder = 60
TensionBarEncoder = 61
TensionBarEncoder = 62
TensionBarEncoder = 63
TensionBarEncoder = 64
TensionBarEncoder = 65
TensionBarEncoder = 66
TensionBarEncoder = 67
TensionBarEncoder = 66
TensionBarEncoder = 67
TensionBarEncoder = 68
TensionBarEncoder = 67
TensionBarEncoder = 68
TensionBarEncoder = 67
TensionBarEncoder = 68
TensionBarEncoder = 69
TensionBarEncoder = 70
TensionBarEncoder = 71
TensionBarEncoder = 72
TensionBarEncoder = 71
TensionBarEncoder = 72
TensionBarEncoder = 73
TensionBarEncoder = 74
TensionBarEncoder = 75
TensionBarEncoder = 76
TensionBarEncoder = 77
TensionBarEncoder = 78
TensionBarEncoder = 79
TensionBarEncoder = 80
TensionBarEncoder = 81
TensionBarEncoder = 82
TensionBarEncoder = 83
TensionBarEncoder = 84
TensionBarEncoder = 85
TensionBarEncoder = 86
TensionBarEncoder = 87
TensionBarEncoder = 88
TensionBarEncoder = 89
TensionBarEncoder = 90
TensionBarEncoder = 91
TensionBarEncoder = 92
TensionBarEncoder = 93
TensionBarEncoder = 94
TensionBarEncoder = 95
TensionBarEncoder = 96
TensionBarEncoder = 97
TensionBarEncoder = 98
TensionBarEncoder = 99
TensionBarEncoder = 100
TensionBarEncoder = 101
TensionBarEncoder = 102
TensionBarEncoder = 103
TensionBarEncoder = 104
TensionBarEncoder = 103
TensionBarEncoder = 104
TensionBarEncoder = 105
TensionBarEncoder = 106
TensionBarEncoder = 107
TensionBarEncoder = 108
TensionBarEncoder = 107
TensionBarEncoder = 108
TensionBarEncoder = 109
TensionBarEncoder = 110
TensionBarEncoder = 111
TensionBarEncoder = 112
TensionBarEncoder = 113
TensionBarEncoder = 114
TensionBarEncoder = 115
TensionBarEncoder = 116
TensionBarEncoder = 117
TensionBarEncoder = 118
TensionBarEncoder = 119
TensionBarEncoder = 120
TensionBarEncoder = 121
TensionBarEncoder = 122
TensionBarEncoder = 123
TensionBarEncoder = 124
TensionBarEncoder = 125
TensionBarEncoder = 126
TensionBarEncoder = 127
TensionBarEncoder = 126
TensionBarEncoder = 127
TensionBarEncoder = 128
TensionBarEncoder = 129
TensionBarEncoder = 130
TensionBarEncoder = 131
TensionBarEncoder = 132
TensionBarEncoder = 133
TensionBarEncoder = 134
TensionBarEncoder = 135
TensionBarEncoder = 136
TensionBarEncoder = 137
TensionBarEncoder = 138
TensionBarEncoder = 139
TensionBarEncoder = 138
TensionBarEncoder = 139
TensionBarEncoder = 140
TensionBarEncoder = 141
TensionBarEncoder = 142
TensionBarEncoder = 143
TensionBarEncoder = 144
TensionBarEncoder = 145
TensionBarEncoder = 146
TensionBarEncoder = 147
TensionBarEncoder = 148
TensionBarEncoder = 149
TensionBarEncoder = 150
TensionBarEncoder = 151
TensionBarEncoder = 152
TensionBarEncoder = 153
TensionBarEncoder = 154
TensionBarEncoder = 155
TensionBarEncoder = 156
TensionBarEncoder = 157
TensionBarEncoder = 158
TensionBarEncoder = 159
TensionBarEncoder = 160
TensionBarEncoder = 161
TensionBarEncoder = 162
TensionBarEncoder = 163
TensionBarEncoder = 164
TensionBarEncoder = 163
TensionBarEncoder = 164
TensionBarEncoder = 165
TensionBarEncoder = 166
TensionBarEncoder = 167
TensionBarEncoder = 168
TensionBarEncoder = 169
TensionBarEncoder = 170
TensionBarEncoder = 171
TensionBarEncoder = 172
TensionBarEncoder = 173
TensionBarEncoder = 174
TensionBarEncoder = 175
TensionBarEncoder = 176
TensionBarEncoder = 177
TensionBarEncoder = 178
TensionBarEncoder = 179
TensionBarEncoder = 178
TensionBarEncoder = 179
TensionBarEncoder = 180
TensionBarEncoder = 181
TensionBarEncoder = 182
TensionBarEncoder = 183
TensionBarEncoder = 184
TensionBarEncoder = 185
TensionBarEncoder = 186
TensionBarEncoder = 187
TensionBarEncoder = 188
TensionBarEncoder = 189
TensionBarEncoder = 190
TensionBarEncoder = 191
TensionBarEncoder = 192
TensionBarEncoder = 191
TensionBarEncoder = 192
TensionBarEncoder = 193
TensionBarEncoder = 194
TensionBarEncoder = 195
TensionBarEncoder = 196
TensionBarEncoder = 195
TensionBarEncoder = 196
TensionBarEncoder = 197
TensionBarEncoder = 198
TensionBarEncoder = 199
TensionBarEncoder = 200
TensionBarEncoder = 199
TensionBarEncoder = 200
TensionBarEncoder = 201
TensionBarEncoder = 202
TensionBarEncoder = 203
TensionBarEncoder = 204
TensionBarEncoder = 203
TensionBarEncoder = 204
TensionBarEncoder = 205
TensionBarEncoder = 206
TensionBarEncoder = 207
TensionBarEncoder = 208
TensionBarEncoder = 209
TensionBarEncoder = 210
TensionBarEncoder = 211
TensionBarEncoder = 210
TensionBarEncoder = 211
TensionBarEncoder = 212
TensionBarEncoder = 211
TensionBarEncoder = 212
TensionBarEncoder = 211
TensionBarEncoder = 212
TensionBarEncoder = 213
TensionBarEncoder = 214
TensionBarEncoder = 215
TensionBarEncoder = 216
TensionBarEncoder = 217
TensionBarEncoder = 218
TensionBarEncoder = 219
TensionBarEncoder = 220
TensionBarEncoder = 221
TensionBarEncoder = 222
TensionBarEncoder = 223
TensionBarEncoder = 224
TensionBarEncoder = 225
TensionBarEncoder = 226
TensionBarEncoder = 225
TensionBarEncoder = 226
TensionBarEncoder = 227
TensionBarEncoder = 228
TensionBarEncoder = 229
TensionBarEncoder = 230
TensionBarEncoder = 231
TensionBarEncoder = 232
TensionBarEncoder = 233
TensionBarEncoder = 234
TensionBarEncoder = 235
TensionBarEncoder = 236
TensionBarEncoder = 237
TensionBarEncoder = 238
TensionBarEncoder = 239
TensionBarEncoder = 240
TensionBarEncoder = 241
TensionBarEncoder = 242
TensionBarEncoder = 243
TensionBarEncoder = 244
TensionBarEncoder = 243
TensionBarEncoder = 244
TensionBarEncoder = 245
TensionBarEncoder = 246
TensionBarEncoder = 247
TensionBarEncoder = 248
TensionBarEncoder = 249
TensionBarEncoder = 250
TensionBarEncoder = 251
TensionBarEncoder = 252
TensionBarEncoder = 253
TensionBarEncoder = 254
TensionBarEncoder = 255
TensionBarEncoder = 256
TensionBarEncoder = 257
TensionBarEncoder = 258
TensionBarEncoder = 259
TensionBarEncoder = 260
TensionBarEncoder = 259
TensionBarEncoder = 260
TensionBarEncoder = 261
TensionBarEncoder = 262
TensionBarEncoder = 263
TensionBarEncoder = 264
TensionBarEncoder = 265
TensionBarEncoder = 266
TensionBarEncoder = 267
TensionBarEncoder = 268
TensionBarEncoder = 269
TensionBarEncoder = 270
TensionBarEncoder = 271
TensionBarEncoder = 272
TensionBarEncoder = 273
TensionBarEncoder = 274
TensionBarEncoder = 273
TensionBarEncoder = 274
TensionBarEncoder = 275
TensionBarEncoder = 276
TensionBarEncoder = 277
TensionBarEncoder = 278
TensionBarEncoder = 279
TensionBarEncoder = 280
TensionBarEncoder = 281
TensionBarEncoder = 282
TensionBarEncoder = 281
TensionBarEncoder = 282
TensionBarEncoder = 283
TensionBarEncoder = 284
TensionBarEncoder = 285
TensionBarEncoder = 286
TensionBarEncoder = 287
TensionBarEncoder = 288
TensionBarEncoder = 289
TensionBarEncoder = 290
TensionBarEncoder = 291
TensionBarEncoder = 292
TensionBarEncoder = 291
TensionBarEncoder = 292
TensionBarEncoder = 293
TensionBarEncoder = 294
TensionBarEncoder = 295
TensionBarEncoder = 296
TensionBarEncoder = 295
TensionBarEncoder = 296
TensionBarEncoder = 297
TensionBarEncoder = 298
TensionBarEncoder = 299
TensionBarEncoder = 300
TensionBarEncoder = 299
TensionBarEncoder = 300
TensionBarEncoder = 301
TensionBarEncoder = 302
TensionBarEncoder = 303
TensionBarEncoder = 304
TensionBarEncoder = 305
TensionBarEncoder = 306
TensionBarEncoder = 307
TensionBarEncoder = 308
TensionBarEncoder = 309
TensionBarEncoder = 310
TensionBarEncoder = 311
TensionBarEncoder = 312
TensionBarEncoder = 313
TensionBarEncoder = 314
TensionBarEncoder = 315
TensionBarEncoder = 316
TensionBarEncoder = 315
TensionBarEncoder = 314
TensionBarEncoder = 313
TensionBarEncoder = 314
TensionBarEncoder = 313
TensionBarEncoder = 314
TensionBarEncoder = 313
TensionBarEncoder = 312
TensionBarEncoder = 311
TensionBarEncoder = 310
TensionBarEncoder = 309
TensionBarEncoder = 308
Open Switch Hit!
Current Open Value: 308
Message arrived [hq/garage/switch1] 1
TensionBarEncoder = 309
TensionBarEncoder = 308
TensionBarEncoder = 307
TensionBarEncoder = 306
TensionBarEncoder = 305
TensionBarEncoder = 306
TensionBarEncoder = 305
TensionBarEncoder = 304
TensionBarEncoder = 303
TensionBarEncoder = 302
TensionBarEncoder = 301
TensionBarEncoder = 300
TensionBarEncoder = 299
TensionBarEncoder = 298
TensionBarEncoder = 297
TensionBarEncoder = 298
TensionBarEncoder = 297
TensionBarEncoder = 296
TensionBarEncoder = 295
TensionBarEncoder = 294
TensionBarEncoder = 293
TensionBarEncoder = 292
TensionBarEncoder = 291
TensionBarEncoder = 290
TensionBarEncoder = 289
TensionBarEncoder = 290
TensionBarEncoder = 289
TensionBarEncoder = 290
TensionBarEncoder = 289
TensionBarEncoder = 288
TensionBarEncoder = 287
TensionBarEncoder = 286
TensionBarEncoder = 285
TensionBarEncoder = 284
TensionBarEncoder = 283
TensionBarEncoder = 282
TensionBarEncoder = 281
TensionBarEncoder = 280
TensionBarEncoder = 281
TensionBarEncoder = 280
TensionBarEncoder = 279
TensionBarEncoder = 278
TensionBarEncoder = 277
TensionBarEncoder = 276
TensionBarEncoder = 275
TensionBarEncoder = 274
TensionBarEncoder = 273
TensionBarEncoder = 274
TensionBarEncoder = 273
TensionBarEncoder = 272
TensionBarEncoder = 271
TensionBarEncoder = 270
TensionBarEncoder = 269
TensionBarEncoder = 268
TensionBarEncoder = 269
TensionBarEncoder = 268
TensionBarEncoder = 267
TensionBarEncoder = 266
TensionBarEncoder = 265
TensionBarEncoder = 266
TensionBarEncoder = 265
TensionBarEncoder = 264
TensionBarEncoder = 263
TensionBarEncoder = 262
TensionBarEncoder = 261
TensionBarEncoder = 260
TensionBarEncoder = 259
TensionBarEncoder = 258
TensionBarEncoder = 257
TensionBarEncoder = 258
TensionBarEncoder = 257
TensionBarEncoder = 256
TensionBarEncoder = 255
TensionBarEncoder = 254
TensionBarEncoder = 253
TensionBarEncoder = 252
TensionBarEncoder = 251
TensionBarEncoder = 250
TensionBarEncoder = 249
TensionBarEncoder = 248
TensionBarEncoder = 247
TensionBarEncoder = 246
TensionBarEncoder = 245
TensionBarEncoder = 244
TensionBarEncoder = 243
TensionBarEncoder = 242
TensionBarEncoder = 241
TensionBarEncoder = 242
TensionBarEncoder = 241
TensionBarEncoder = 240
TensionBarEncoder = 239
TensionBarEncoder = 238
TensionBarEncoder = 237
TensionBarEncoder = 236
TensionBarEncoder = 235
TensionBarEncoder = 234
TensionBarEncoder = 233
TensionBarEncoder = 232
TensionBarEncoder = 231
TensionBarEncoder = 230
TensionBarEncoder = 229
TensionBarEncoder = 228
TensionBarEncoder = 227
TensionBarEncoder = 226
TensionBarEncoder = 225
TensionBarEncoder = 224
TensionBarEncoder = 223
TensionBarEncoder = 222
TensionBarEncoder = 221
TensionBarEncoder = 220
TensionBarEncoder = 219
TensionBarEncoder = 218
TensionBarEncoder = 217
TensionBarEncoder = 216
TensionBarEncoder = 215
TensionBarEncoder = 214
TensionBarEncoder = 213
TensionBarEncoder = 212
TensionBarEncoder = 211
TensionBarEncoder = 210
TensionBarEncoder = 209
TensionBarEncoder = 208
TensionBarEncoder = 207
TensionBarEncoder = 206
TensionBarEncoder = 205
TensionBarEncoder = 204
TensionBarEncoder = 203
TensionBarEncoder = 202
TensionBarEncoder = 201
TensionBarEncoder = 200
TensionBarEncoder = 199
TensionBarEncoder = 198
TensionBarEncoder = 197
TensionBarEncoder = 196
TensionBarEncoder = 195
TensionBarEncoder = 194
TensionBarEncoder = 193
TensionBarEncoder = 192
TensionBarEncoder = 191
TensionBarEncoder = 190
TensionBarEncoder = 189
TensionBarEncoder = 188
TensionBarEncoder = 187
TensionBarEncoder = 186
TensionBarEncoder = 185
TensionBarEncoder = 186
TensionBarEncoder = 185
TensionBarEncoder = 184
TensionBarEncoder = 183
TensionBarEncoder = 182
TensionBarEncoder = 181
TensionBarEncoder = 180
TensionBarEncoder = 179
TensionBarEncoder = 178
TensionBarEncoder = 177
TensionBarEncoder = 176
TensionBarEncoder = 175
TensionBarEncoder = 174
TensionBarEncoder = 173
TensionBarEncoder = 172
TensionBarEncoder = 171
TensionBarEncoder = 170
TensionBarEncoder = 169
TensionBarEncoder = 168
TensionBarEncoder = 167
TensionBarEncoder = 166
TensionBarEncoder = 165
TensionBarEncoder = 164
TensionBarEncoder = 163
TensionBarEncoder = 162
TensionBarEncoder = 161
TensionBarEncoder = 160
TensionBarEncoder = 159
TensionBarEncoder = 158
TensionBarEncoder = 157
TensionBarEncoder = 156
TensionBarEncoder = 155
TensionBarEncoder = 156
TensionBarEncoder = 155
TensionBarEncoder = 156
TensionBarEncoder = 155
TensionBarEncoder = 156
TensionBarEncoder = 155
TensionBarEncoder = 156
TensionBarEncoder = 155
TensionBarEncoder = 154
TensionBarEncoder = 153
TensionBarEncoder = 152
TensionBarEncoder = 151
TensionBarEncoder = 150
TensionBarEncoder = 149
TensionBarEncoder = 148
TensionBarEncoder = 147
TensionBarEncoder = 146
TensionBarEncoder = 145
TensionBarEncoder = 144
TensionBarEncoder = 143
TensionBarEncoder = 142
TensionBarEncoder = 141
TensionBarEncoder = 140
TensionBarEncoder = 139
TensionBarEncoder = 138
TensionBarEncoder = 137
TensionBarEncoder = 136
TensionBarEncoder = 135
TensionBarEncoder = 134
TensionBarEncoder = 133
TensionBarEncoder = 132
TensionBarEncoder = 131
TensionBarEncoder = 130
TensionBarEncoder = 129
TensionBarEncoder = 128
TensionBarEncoder = 127
TensionBarEncoder = 126
TensionBarEncoder = 125
TensionBarEncoder = 124
TensionBarEncoder = 123
TensionBarEncoder = 122
TensionBarEncoder = 121
TensionBarEncoder = 120
TensionBarEncoder = 119
TensionBarEncoder = 118
TensionBarEncoder = 117
TensionBarEncoder = 116
TensionBarEncoder = 115
TensionBarEncoder = 114
TensionBarEncoder = 113
TensionBarEncoder = 112
TensionBarEncoder = 111
TensionBarEncoder = 110
TensionBarEncoder = 109
TensionBarEncoder = 110
TensionBarEncoder = 109
TensionBarEncoder = 108
TensionBarEncoder = 107
TensionBarEncoder = 106
TensionBarEncoder = 105
TensionBarEncoder = 104
TensionBarEncoder = 103
TensionBarEncoder = 104
TensionBarEncoder = 103
TensionBarEncoder = 102
TensionBarEncoder = 101
TensionBarEncoder = 100
TensionBarEncoder = 99
TensionBarEncoder = 98
TensionBarEncoder = 97
TensionBarEncoder = 96
TensionBarEncoder = 95
TensionBarEncoder = 94
TensionBarEncoder = 93
TensionBarEncoder = 92
TensionBarEncoder = 91
TensionBarEncoder = 90
TensionBarEncoder = 89
TensionBarEncoder = 88
TensionBarEncoder = 87
TensionBarEncoder = 86
TensionBarEncoder = 85
TensionBarEncoder = 86
TensionBarEncoder = 85
TensionBarEncoder = 84
TensionBarEncoder = 83
TensionBarEncoder = 82
TensionBarEncoder = 81
TensionBarEncoder = 80
TensionBarEncoder = 79
TensionBarEncoder = 78
TensionBarEncoder = 77
TensionBarEncoder = 76
TensionBarEncoder = 75
TensionBarEncoder = 74
TensionBarEncoder = 73
TensionBarEncoder = 72
TensionBarEncoder = 71
TensionBarEncoder = 70
TensionBarEncoder = 69
TensionBarEncoder = 68
TensionBarEncoder = 67
TensionBarEncoder = 66
TensionBarEncoder = 65
TensionBarEncoder = 64
TensionBarEncoder = 63
TensionBarEncoder = 62
TensionBarEncoder = 61
TensionBarEncoder = 60
TensionBarEncoder = 59
TensionBarEncoder = 58
TensionBarEncoder = 57
TensionBarEncoder = 58
TensionBarEncoder = 57
TensionBarEncoder = 56
TensionBarEncoder = 55
TensionBarEncoder = 54
TensionBarEncoder = 53
TensionBarEncoder = 52
TensionBarEncoder = 51
TensionBarEncoder = 50
TensionBarEncoder = 49
TensionBarEncoder = 50
TensionBarEncoder = 49
TensionBarEncoder = 50
TensionBarEncoder = 49
TensionBarEncoder = 48
TensionBarEncoder = 47
TensionBarEncoder = 46
TensionBarEncoder = 45
TensionBarEncoder = 44
TensionBarEncoder = 43
TensionBarEncoder = 42
TensionBarEncoder = 41
TensionBarEncoder = 40
TensionBarEncoder = 39
TensionBarEncoder = 38
TensionBarEncoder = 37
TensionBarEncoder = 36
TensionBarEncoder = 35
TensionBarEncoder = 34
TensionBarEncoder = 33
TensionBarEncoder = 34
TensionBarEncoder = 33
TensionBarEncoder = 32
TensionBarEncoder = 31
TensionBarEncoder = 30
TensionBarEncoder = 29
TensionBarEncoder = 28
TensionBarEncoder = 27
TensionBarEncoder = 26
TensionBarEncoder = 25
TensionBarEncoder = 24
TensionBarEncoder = 23
TensionBarEncoder = 22
TensionBarEncoder = 21
TensionBarEncoder = 20
TensionBarEncoder = 19
TensionBarEncoder = 18
TensionBarEncoder = 17
TensionBarEncoder = 16
TensionBarEncoder = 15
TensionBarEncoder = 14
TensionBarEncoder = 13
TensionBarEncoder = 12
TensionBarEncoder = 11
TensionBarEncoder = 10
TensionBarEncoder = 9
TensionBarEncoder = 8
TensionBarEncoder = 7
TensionBarEncoder = 6
TensionBarEncoder = 5
TensionBarEncoder = 6
TensionBarEncoder = 5
TensionBarEncoder = 4
TensionBarEncoder = 3
TensionBarEncoder = 4
TensionBarEncoder = 3
TensionBarEncoder = 2
TensionBarEncoder = 1
TensionBarEncoder = 2
TensionBarEncoder = 1
TensionBarEncoder = 2
TensionBarEncoder = 1
TensionBarEncoder = 2
TensionBarEncoder = 1
TensionBarEncoder = 0
TensionBarEncoder = -1
TensionBarEncoder = -2
TensionBarEncoder = -3
TensionBarEncoder = -4
TensionBarEncoder = -5
TensionBarEncoder = -6
Close Switch Hit!
Message arrived [hq/garage/switch1] 0
Reset TensionBar Encoder to zero.
Current Closed Value: 100%
Message arrived [hq/garage/position] 100
TensionBarEncoder = 0
TensionBarEncoder = 1
TensionBarEncoder = 2
TensionBarEncoder = 3
TensionBarEncoder = 4
TensionBarEncoder = 5
TensionBarEncoder = 6
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 7
TensionBarEncoder = 8
TensionBarEncoder = 9
TensionBarEncoder = 8
TensionBarEncoder = 9
TensionBarEncoder = 10
TensionBarEncoder = 11
TensionBarEncoder = 12
TensionBarEncoder = 13
TensionBarEncoder = 14
TensionBarEncoder = 15
TensionBarEncoder = 16
TensionBarEncoder = 17
TensionBarEncoder = 18
TensionBarEncoder = 19
TensionBarEncoder = 20
TensionBarEncoder = 21
TensionBarEncoder = 22
TensionBarEncoder = 21
TensionBarEncoder = 22
TensionBarEncoder = 23
TensionBarEncoder = 24
TensionBarEncoder = 23
TensionBarEncoder = 24
TensionBarEncoder = 25
TensionBarEncoder = 26
Garage Door Position: 89%
Message arrived [hq/garage/position] 89
TensionBarEncoder = 27
TensionBarEncoder = 28
TensionBarEncoder = 27
TensionBarEncoder = 28
TensionBarEncoder = 29
TensionBarEncoder = 30
TensionBarEncoder = 31
TensionBarEncoder = 32
TensionBarEncoder = 33
TensionBarEncoder = 32
TensionBarEncoder = 33
TensionBarEncoder = 32
TensionBarEncoder = 33
TensionBarEncoder = 34
TensionBarEncoder = 35
TensionBarEncoder = 36
TensionBarEncoder = 37
TensionBarEncoder = 38
TensionBarEncoder = 39
TensionBarEncoder = 40
TensionBarEncoder = 41
TensionBarEncoder = 40
TensionBarEncoder = 41
TensionBarEncoder = 42
TensionBarEncoder = 43
TensionBarEncoder = 44
TensionBarEncoder = 45
TensionBarEncoder = 46
TensionBarEncoder = 45
TensionBarEncoder = 46
TensionBarEncoder = 47
TensionBarEncoder = 48
TensionBarEncoder = 49
TensionBarEncoder = 48
TensionBarEncoder = 49
TensionBarEncoder = 50
TensionBarEncoder = 51
TensionBarEncoder = 52
TensionBarEncoder = 53
TensionBarEncoder = 54
TensionBarEncoder = 55
TensionBarEncoder = 56
TensionBarEncoder = 57
TensionBarEncoder = 58
TensionBarEncoder = 59
TensionBarEncoder = 60
TensionBarEncoder = 61
TensionBarEncoder = 62
TensionBarEncoder = 63
TensionBarEncoder = 64
TensionBarEncoder = 65
TensionBarEncoder = 66
Garage Door Position: 77%
Message arrived [hq/garage/position] 77
TensionBarEncoder = 67
TensionBarEncoder = 68
TensionBarEncoder = 69
TensionBarEncoder = 70
TensionBarEncoder = 71
TensionBarEncoder = 72
TensionBarEncoder = 73
TensionBarEncoder = 72
TensionBarEncoder = 73
TensionBarEncoder = 74
TensionBarEncoder = 75
TensionBarEncoder = 76
TensionBarEncoder = 77
TensionBarEncoder = 78
TensionBarEncoder = 77
TensionBarEncoder = 78
TensionBarEncoder = 79
TensionBarEncoder = 80
TensionBarEncoder = 81
TensionBarEncoder = 80
TensionBarEncoder = 81
TensionBarEncoder = 82
TensionBarEncoder = 83
TensionBarEncoder = 84
TensionBarEncoder = 85
TensionBarEncoder = 86
TensionBarEncoder = 85
TensionBarEncoder = 86
TensionBarEncoder = 85
TensionBarEncoder = 86
TensionBarEncoder = 87
TensionBarEncoder = 88
TensionBarEncoder = 89
TensionBarEncoder = 88
TensionBarEncoder = 89
TensionBarEncoder = 90
TensionBarEncoder = 91
TensionBarEncoder = 92
TensionBarEncoder = 93
TensionBarEncoder = 94
TensionBarEncoder = 93
TensionBarEncoder = 94
TensionBarEncoder = 95
TensionBarEncoder = 96
TensionBarEncoder = 97
TensionBarEncoder = 96
TensionBarEncoder = 97
TensionBarEncoder = 98
TensionBarEncoder = 99
TensionBarEncoder = 100
TensionBarEncoder = 101
TensionBarEncoder = 102
TensionBarEncoder = 103
TensionBarEncoder = 104
TensionBarEncoder = 105
TensionBarEncoder = 104
TensionBarEncoder = 105
TensionBarEncoder = 106
TensionBarEncoder = 107
TensionBarEncoder = 108
TensionBarEncoder = 109
TensionBarEncoder = 110
TensionBarEncoder = 109
TensionBarEncoder = 110
TensionBarEncoder = 109
TensionBarEncoder = 110
Garage Door Position: 63%
Message arrived [hq/garage/position] 63
TensionBarEncoder = 111
TensionBarEncoder = 112
TensionBarEncoder = 113
TensionBarEncoder = 114
TensionBarEncoder = 115
TensionBarEncoder = 116
TensionBarEncoder = 117
TensionBarEncoder = 118
TensionBarEncoder = 119
TensionBarEncoder = 120
TensionBarEncoder = 121
TensionBarEncoder = 122
TensionBarEncoder = 123
TensionBarEncoder = 124
TensionBarEncoder = 125
TensionBarEncoder = 126
TensionBarEncoder = 125
TensionBarEncoder = 126
TensionBarEncoder = 127
TensionBarEncoder = 128
TensionBarEncoder = 129
TensionBarEncoder = 130
TensionBarEncoder = 131
TensionBarEncoder = 132
TensionBarEncoder = 133
TensionBarEncoder = 134
TensionBarEncoder = 135
TensionBarEncoder = 136
TensionBarEncoder = 137
TensionBarEncoder = 138
TensionBarEncoder = 139
TensionBarEncoder = 140
TensionBarEncoder = 141
TensionBarEncoder = 142
TensionBarEncoder = 143
TensionBarEncoder = 144
TensionBarEncoder = 145
TensionBarEncoder = 146
TensionBarEncoder = 147
TensionBarEncoder = 148
TensionBarEncoder = 149
TensionBarEncoder = 150
TensionBarEncoder = 151
TensionBarEncoder = 152
TensionBarEncoder = 153
TensionBarEncoder = 154
TensionBarEncoder = 155
TensionBarEncoder = 156
Garage Door Position: 48%
Message arrived [hq/garage/position] 48
TensionBarEncoder = 157
TensionBarEncoder = 158
TensionBarEncoder = 159
TensionBarEncoder = 160
TensionBarEncoder = 161
TensionBarEncoder = 160
TensionBarEncoder = 161
TensionBarEncoder = 162
TensionBarEncoder = 163
TensionBarEncoder = 164
TensionBarEncoder = 165
TensionBarEncoder = 164
TensionBarEncoder = 165
TensionBarEncoder = 166
TensionBarEncoder = 167
TensionBarEncoder = 168
TensionBarEncoder = 169
TensionBarEncoder = 170
TensionBarEncoder = 171
TensionBarEncoder = 172
TensionBarEncoder = 173
TensionBarEncoder = 174
TensionBarEncoder = 175
TensionBarEncoder = 176
TensionBarEncoder = 177
TensionBarEncoder = 178
TensionBarEncoder = 179
TensionBarEncoder = 180
TensionBarEncoder = 181
TensionBarEncoder = 182
TensionBarEncoder = 183
TensionBarEncoder = 184
TensionBarEncoder = 185
TensionBarEncoder = 186
TensionBarEncoder = 187
TensionBarEncoder = 188
TensionBarEncoder = 187
TensionBarEncoder = 188
TensionBarEncoder = 189
TensionBarEncoder = 190
TensionBarEncoder = 189
TensionBarEncoder = 190
TensionBarEncoder = 189
TensionBarEncoder = 190
TensionBarEncoder = 191
TensionBarEncoder = 192
TensionBarEncoder = 193
TensionBarEncoder = 194
TensionBarEncoder = 195
TensionBarEncoder = 196
Garage Door Position: 35%
Message arrived [hq/garage/position] 35
TensionBarEncoder = 197
TensionBarEncoder = 198
TensionBarEncoder = 199
TensionBarEncoder = 200
TensionBarEncoder = 201
TensionBarEncoder = 200
TensionBarEncoder = 201
TensionBarEncoder = 202
TensionBarEncoder = 203
TensionBarEncoder = 204
TensionBarEncoder = 205
TensionBarEncoder = 204
TensionBarEncoder = 205
TensionBarEncoder = 206
TensionBarEncoder = 207
TensionBarEncoder = 208
TensionBarEncoder = 209
TensionBarEncoder = 210
TensionBarEncoder = 211
TensionBarEncoder = 212
TensionBarEncoder = 213
TensionBarEncoder = 214
TensionBarEncoder = 215
TensionBarEncoder = 216
TensionBarEncoder = 217
TensionBarEncoder = 218
TensionBarEncoder = 219
TensionBarEncoder = 220
TensionBarEncoder = 221
TensionBarEncoder = 220
TensionBarEncoder = 221
TensionBarEncoder = 222
TensionBarEncoder = 223
TensionBarEncoder = 224
TensionBarEncoder = 225
TensionBarEncoder = 224
TensionBarEncoder = 225
TensionBarEncoder = 226
TensionBarEncoder = 227
TensionBarEncoder = 228
TensionBarEncoder = 229
TensionBarEncoder = 228
TensionBarEncoder = 229
TensionBarEncoder = 230
TensionBarEncoder = 231
TensionBarEncoder = 232
TensionBarEncoder = 233
TensionBarEncoder = 234
TensionBarEncoder = 235
TensionBarEncoder = 236
TensionBarEncoder = 237
TensionBarEncoder = 238
TensionBarEncoder = 239
TensionBarEncoder = 240
TensionBarEncoder = 241
TensionBarEncoder = 242
TensionBarEncoder = 243
TensionBarEncoder = 244
TensionBarEncoder = 245
TensionBarEncoder = 246
Garage Door Position: 19%
Message arrived [hq/garage/position] 19
TensionBarEncoder = 247
TensionBarEncoder = 248
TensionBarEncoder = 249
TensionBarEncoder = 250
TensionBarEncoder = 251
TensionBarEncoder = 252
TensionBarEncoder = 253
TensionBarEncoder = 252
TensionBarEncoder = 253
TensionBarEncoder = 252
TensionBarEncoder = 253
TensionBarEncoder = 254
TensionBarEncoder = 255
TensionBarEncoder = 256
TensionBarEncoder = 257
TensionBarEncoder = 258
TensionBarEncoder = 259
TensionBarEncoder = 260
TensionBarEncoder = 261
TensionBarEncoder = 262
TensionBarEncoder = 263
TensionBarEncoder = 264
TensionBarEncoder = 265
TensionBarEncoder = 264
TensionBarEncoder = 265
TensionBarEncoder = 266
TensionBarEncoder = 267
TensionBarEncoder = 268
TensionBarEncoder = 269
TensionBarEncoder = 270
TensionBarEncoder = 271
TensionBarEncoder = 272
TensionBarEncoder = 273
TensionBarEncoder = 272
TensionBarEncoder = 273
TensionBarEncoder = 274
TensionBarEncoder = 275
TensionBarEncoder = 276
TensionBarEncoder = 277
TensionBarEncoder = 278
TensionBarEncoder = 279
TensionBarEncoder = 280
TensionBarEncoder = 281
TensionBarEncoder = 282
TensionBarEncoder = 283
TensionBarEncoder = 284
TensionBarEncoder = 285
TensionBarEncoder = 286
TensionBarEncoder = 287
TensionBarEncoder = 288
TensionBarEncoder = 289
TensionBarEncoder = 290
TensionBarEncoder = 291
TensionBarEncoder = 292
TensionBarEncoder = 293
TensionBarEncoder = 294
TensionBarEncoder = 295
TensionBarEncoder = 296
Garage Door Position: 3%
Message arrived [hq/garage/position] 3
TensionBarEncoder = 297
TensionBarEncoder = 298
TensionBarEncoder = 299
TensionBarEncoder = 300
TensionBarEncoder = 301
TensionBarEncoder = 302
TensionBarEncoder = 303
TensionBarEncoder = 304
TensionBarEncoder = 305
TensionBarEncoder = 306
TensionBarEncoder = 307
TensionBarEncoder = 308
TensionBarEncoder = 309
TensionBarEncoder = 308
TensionBarEncoder = 309
TensionBarEncoder = 308
TensionBarEncoder = 309
TensionBarEncoder = 310
TensionBarEncoder = 309
TensionBarEncoder = 310
TensionBarEncoder = 309
TensionBarEncoder = 310
TensionBarEncoder = 309
TensionBarEncoder = 310
TensionBarEncoder = 309
TensionBarEncoder = 308
TensionBarEncoder = 309
TensionBarEncoder = 308
Garage Door Position: 0%
Message arrived [hq/garage/position] 0
Forcing publish every 5 minutes...
New temperature:27.75 degC   81.95 degF
New humidity:54.12 %
New barometer:1017.89 hPa   30.06 inHg
Message arrived [hq/garage/available] 1
Garage Temperature: 27.75
Message arrived [hq/garage/temperature] 27.75
Message arrived [hq/garage/humidity] 54.12
Message arrived [hq/garage/barometer] 1017.89

</ End of Serial Monitor>

Reference URL'S

https://www.arduino.cc/en/Guide/ArduinoMini
https://www.arduino.cc/en/Main/MiniUSB
http://kwartzlab.ca/pipermail/discuss_kwartzlab.ca/2012-July/001092.html
https://docs.google.com/spreadsheets/d/1Bc5FDpY0nzs8TgmjcceNpZfRsU2xK9hx_y-vackjETM/edit#gid=0
http://www.diyode.com/2012/02/building-the-codeshield/
https://gist.github.com/balloob/1176b6d87c2816bd07919ce6e29a19e9
https://gist.github.com/mtl010957/9ee85fb404f65e15c440b08c659c0419
https://home-assistant.io/blog/2015/10/11/measure-temperature-with-esp8266-and-report-to-mqtt/
http://www.pjrc.com/teensy/td_libs_Encoder.html
https://github.com/knolleary/pubsubclient/blob/master/examples/mqtt_reconnect_nonblocking/mqtt_reconnect_nonblocking.ino
http://www.esp8266.com/viewtopic.php?f=29&t=8746
http://www.esp8266.com/viewtopic.php?t=4462


Old tests with push stuff before MQTT (NOT REQUIRED FOR ABOVE)



CURL TEST

curl -X POST \
      -H "x-instapush-appid: APPIDHERE" \
      -H "x-instapush-appsecret: APPSECRETHERE" \
      -H "Content-Type: application/json" \
      -d '{"event":"GDS,"trackers":{"status":"open "}}' \
      https://api.instapush.im/post

NODEMCU TEST

appid = "APPIDHERE"
appsecret = "APPSECRETHERE"
key = "status"
event = "GDSStatus"
val = "open"


host = "api.instapush.im"
done = nil

if not wifi.sta.getip() then
 print("Connecting to wifi")
 wifi.setmode(wifi.STATION)
 wifi.sta.config("SSIDHERE","PASSWORDHERE")
 ip = wifi.sta.getip()
 print(ip)
end

function upload()
 conn = net.createConnection(net.TCP, 0)
 conn:on("receive",
  function(conn, payload)
   success = true
   print(payload)
  end)  
 conn:on("disconnection",
  function(conn, payload)
   print('\nDisconnected')
  end)
 conn:on("connection",
  function(conn, payload)
   print('\nConnected')
   data = "event=" .. event .. "&" .. key .. "=" .. val
   conn:send("POST /php HTTP/1.1\r\n"
   .. "Host: " .. host .. "\r\n"
   .. "X-INSTAPUSH-APPID: " .. appid .. "\r\n"
   .. "X-INSTAPUSH-APPSECRET: " .. appsecret .. "\r\n"
   .. "Content-Type: application/x-www-form-urlencoded\r\n"
   .. "Content-Length: " .. string.len(data) .. "\r\n"
   .. "Connection: Close\r\n\r\n"
   .. data)
  end)  
 print("Opening port")
 conn:connect(80, host)
end

function maintask()
        if not wifi.sta.getip() then
            print("Connecting to AP, Waiting...")
        elseif not done then
            print("Uploading to server...")
            upload()
            done = 1
       end
end

maintask()
tmr.alarm(0, 1000, 1, maintask)


Arduino Code

https://codebender.cc/sketch:338364

{% gist 0895a6778d7906ce79cfd64f93e4dae1 %}

Test

<script src="https://gist.github.com/NonaSuomy/0895a6778d7906ce79cfd64f93e4dae1.js"></script>

Instapush Mobile App

https://play.google.com/store/apps/details?id=im.instapush.pushbots
