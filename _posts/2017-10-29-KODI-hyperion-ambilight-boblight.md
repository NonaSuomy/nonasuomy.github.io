---
layout: post
title: KODI - Raspberry Pi - Arduino - Hyperion Ambilight Boblight
---

![alt text]({{ site.baseurl }}../images/hyperion/HyperionCap.png "Layout")

# Hyperion #

## Configuration Builder Machine ##

Download HyperCon.jar

https://sourceforge.net/projects/hyperion-project/files/latest/download

Execute HyperCon.jar

```
java -jar HyperCon.jar
```

Make a dat file or import the one below to HyperCon.jar.

Hardware

```
Device

Configuration name: MyHyperionConfig
Type: Adalight
Output: /dev/ttyACM0
Baurdrate: 460800
Delay [ms]: 0
RGB Byte Order: GRB
```

```
Construction

LED top left: Check
LED bottom left: Check
LED top right: Check
LED bottom right: Check
Direction: counter clockwise
LEDs horizontal: 50
LEDs Left: 25
LEDs Right: 25
Bottom Gap: 20
1st LED offset: 41
```
```
Image Process
Horizontal depth [%]: 8
Virtical depth [%]: 5
Horizontal gap [%]: 0
Vertical gap [%]: 0
Overlap [%]: 0
```
```
Blackboarder Detection
Enable: Check
Threshold [%]: 0
mode: default
```

Process
```
Smoothing

Enabled: Check
Type: Linear smoothing
Time [ms]: 200
Update Freq. [Hz]: 20
Update Delay: 0
```
```
Color Calibration
default
```
```
Transform [default]
Whitelevel: Red: 255 Green: 255 Blue: 255
Gamma: Red: 2.5 Green: 2.5 Blue: 2.5
Red Channel: Red: 255 Green: 0 Blue: 0
Green Channel: Red: 0 Green: 255 Blue: 0
Blue Channel: Red: 0 Green: 0 Blue: 255
Temperature: Red: 255 Green: 255 Blue: 255
Threshold: Red: 0 Green: 0 Blue: 0
Saturation gain: 1
Luminance gain: 1
Backlight: 0
```

Grabber

```
Internal Frame Grabber

Enabled: Check
Width: 64
Heigth: 64
Interval [ms]: 100
Priority Channel: 890
```
```
GrabberV4L2
Enabled: Uncheck
Device: /dev/video0
Input: 0
Video Standard: NTSC_M
Width: -1
Height: -1
Frame Decimation: 2
Size Decimation: 8
Priority Channel: 900
3D Mode: 2D
Crop Left: 0
Crop Right: 0
Crop Top: 0
Crop Bottom: 0
Red Signal Threshold: 0
Green Signal Threshold: 0
Blue Signal Threshold: 0
```

External

```
Kodi Checker

Enabled: Check
Kodi IP-Address: 127.0.0.1
TCP Port: 8080
Menu: Uncheck
Video: Check
Picture: Check
Audio: Check
Screensaver: Check
3D Check: Check
Pause: Check
```
```
Json / Proto / Boblight Server

Json Server TCP Port: 19444
Proto Server TCP Port: 19445
Activate Boblight: Uncheck
Boblight Server TCP Port: 19333
Priority Channel: 900
```
```
Booteffect / Static Color

Enabled: Check
Static Color [RGB]: 0 0 0
Effect: Rainbow swirl fast
Duration [ms]: 3000
Priority Chan.: 700
```
```
Proto/Json Forward

Enabled: Uncheck
Proto target(s): "127.0.0.1:19447"
Json target(s): "127.0.0.1:19446"
```

SSH

```
SSH - Connection

System: All Systems (not OE/LE)
Target IP: 192.168.0.3
Port: 22
Username: osmc
Password: osmc
[Connect][Show Traffic]
```
```
SSH - Manage Hyperion from HyperCon

[Inst./Upd. Hyperion] [Remove Hyperion]
[Start] [Stop] [Get Log]
```
```
SSH - Send Hyperion Configuration

[Local Config Path] [Send Config]
```
```
SSH - Colorpicker

Colorwheel: Check Expertview: Uncheck
Auto Update: Uncheck
[Set Led Color] [Clear]
```

HyperCon_settings.dat
```
#Pesistent settings file for HyperCon
#Sun Oct 29 02:00:23 EDT 2017
ColorConfig.mTransforms[0].mBlueChannelRedSpinner=0
ColorConfig.mTransforms[0].mRedChannelRedSpinner=255
ColorConfig.mSmoothingUpdateFrequency_Hz=20.0
MiscConfig.mScreensaverOn=true
Grabberv4l2Config.mMode=TwoD
MiscConfig.mFrameGrabberWidth=64
SshAndColorPickerConfig.FileName=hyperion.config.json
MiscConfig.mFrameGrabberInterval_ms=100
SshAndColorPickerConfig.srcPath=
MiscConfig.mEffectColorBspinner=0
MiscConfig.mPictureOn=true
SshAndColorPickerConfig.sshCommands[0].command=sudo service hyperion start
MiscConfig.mEffectDurationspinner=3000
ImageProcessConfig.mVerticalDepth=0.05
SshAndColorPickerConfig.sshCommands[2].command=sudo service hyperion restart
Grabberv4l2Config.mPriority=900
MiscConfig.mEffectPriorityspinner=700
ColorConfig.mTransforms[0].mRedThreshold=0.0
ColorConfig.mUpdateDelay=0
Grabberv4l2Config.mCropRight=0
MiscConfig.mXbmcAddress=127.0.0.1
ColorConfig.mTransforms[0].mluminanceMinimumSpinner=0.0
Grabberv4l2Config.mDevice=/dev/video0
DeviceConfig.mColorByteOrder=GRB
ColorConfig.mTransforms[0].mBlueThreshold=0.0
DeviceConfig.mDeviceProperties={output\=/dev/ttyACM0, rate\=460800, delayAfterConnect\=0}
LedFrameConstruction.bottomleftCorner=true
LedFrameConstruction.rightLedCnt=25
MiscConfig.mAudioOn=true
ColorConfig.mSmoothingType=linear
Grabberv4l2Config.mGrabberv4l2Enabled=false
MiscConfig.mEffectsetCombo=rainbowswirlfast
SshAndColorPickerConfig.colorPickerShowColorWheel=true
MiscConfig.mFrameGrabberHeight=64
LedFrameConstruction.firstLedOffset=41
ColorConfig.mTransforms[0].mGreenChannelGreenSpinner=255
Grabberv4l2Config.mCropLeft=0
ImageProcessConfig.mOverlapFraction=0.0
MiscConfig.mXbmcTcpPort=8080
ColorConfig.mTransforms[0].mRedTemperature=255
ColorConfig.mTransforms[0].mBlueTemperature=255
ColorConfig.mSmoothingEnabled=true
Grabberv4l2Config.mCropBottom=0
ColorConfig.mTransforms[0].mBlueChannelBlueSpinner=255
SshAndColorPickerConfig.password=raspberry
MiscConfig.mBlackBorderuFrameCnt=600
LedFrameConstruction.clockwiseDirection=false
MiscConfig.mProtoPort=19445
MiscConfig.mEffectColorGspinner=0
ColorConfig.mTransforms[0].mHSLSaturationGainAdjustSpinner=1.0
ColorConfig.mTransforms[0].mDummy1Label=255
MiscConfig.mBlackBorderThreshold=0.0
ColorConfig.mTransforms[0].mGreenChannelBlueSpinner=0
ColorConfig.mTransforms[0].mGreenTemperature=255
Grabberv4l2Config.mWidth=-1
MiscConfig.mVideoOn=true
LedFrameConstruction.bottomrightCorner=true
Grabberv4l2Config.mStandard=PAL
HyperConConfig.loadDefaultEffect=true
MiscConfig.mBlackBorderbFrameCnt=50
ImageProcessConfig.mHorizontalGap=0.0
MiscConfig.mforwardEnabled=false
LedFrameConstruction.bottomLedCnt=30
SshAndColorPickerConfig.ipAdress=192.168.0.3
ColorConfig.mTransforms[0].mGreenChannelRedSpinner=0
MiscConfig.mBlackBorderbRemoveCnt=1
Grabberv4l2Config.mBlueSignalThreshold=0.0
SshAndColorPickerConfig.username=osmc
MiscConfig.mEffectColorRspinner=0
Grabberv4l2Config.mFrameDecimation=2
ColorConfig.mTransforms[0].mDummy2Label=255
ColorConfig.mTransforms[0].mRedChannelGreenSpinner=0
ColorConfig.mTransforms[0].mLedIndexString=*
ColorConfig.mTransforms[0].mRedGamma=2.5
LedFrameConstruction.leftLedCnt=25
SshAndColorPickerConfig.sshCommands[1].command=sudo service hyperion stop
Grabberv4l2Config.mInput=0
LedFrameConstruction.topLedCnt=50
DeviceConfig.mType=adalight
MiscConfig.mBlackBordermInconsistentCnt=10
ColorConfig.mTransforms[0].mBlueChannelGreenSpinner=0
Grabberv4l2Config.mHeight=-1
MiscConfig.m3DCheckingEnabled=true
SshAndColorPickerConfig.port=22
LedFrameConstruction.toprightCorner=true
ColorConfig.mTransforms[0].mId=default
ColorConfig.mTransforms[0].mRedChannelBlueSpinner=0
Grabberv4l2Config.mGreenSignalThreshold=0.0
Grabberv4l2Config.mSizeDecimation=8
MiscConfig.mBoblightPort=19333
ColorConfig.mTransforms[0].mHSLLuminanceGainAdjustSpinner=1.0
SshAndColorPickerConfig.selectedSystemType=allsystems
ColorConfig.mTransforms[0].mDummy3Label=255
ColorConfig.mSmoothingTime_ms=200
MiscConfig.mProtofield="127.0.0.1\:19447"
SshAndColorPickerConfig.sshCommands[3].command=sudo killall hyperionv4l2
ColorConfig.mTransforms[0].mBlueGamma=2.5
LedFrameConstruction.topleftCorner=true
MiscConfig.mBlackBorderEnabled=true
LedFrameConstruction.bottomGapCnt=0
MiscConfig.mJsonPort=19444
ImageProcessConfig.mHorizontalDepth=0.08
MiscConfig.mPauseOn=true
MiscConfig.mJsonfield="127.0.0.1\:19446"
MiscConfig.mBoblightPriority=900
DeviceConfig.mNameField=MyHyperionConfig
MiscConfig.mBootEffectEnabled=true
Grabberv4l2Config.mRedSignalThreshold=0.0
ImageProcessConfig.mVerticalGap=0.0
MiscConfig.mPathGENN=/usr/share/hyperion/effects
MiscConfig.mXbmcCheckerEnabled=true
MiscConfig.mFrameGrabberEnabled=true
SshAndColorPickerConfig.colorPickerInExpertmode=false
Grabberv4l2Config.mCropTop=0
MiscConfig.mBoblightInterfaceEnabled=false
MiscConfig.mFrameGrabberPriority=890
ColorConfig.mTransforms[0].mGreenThreshold=0.0
MiscConfig.mBlackbordermCombo=defaultt
ColorConfig.mTransforms[0].mGreenGamma=2.5
MiscConfig.mMenuOn=true
MiscConfig.mPathOE=/storage/hyperion/effects
```

## Arduino ##

http://www.hobbytronics.co.uk/arduino-serial-buffer-size

```
cp /home/username/.arduino15/packages/arduino/hardware/avr/1.6.20/cores/arduino /home/username/.arduino15/packages/arduino/hardware/avr/1.6.20/cores/arduino_256_serialbuf
```

```
nano /home/username/.arduino15/packages/arduino/hardware/avr/1.6.20/cores/boards.txt
```

```
##############################################################

uno.name=Arduino/Genuino Uno

uno.vid.0=0x2341
uno.pid.0=0x0043
uno.vid.1=0x2341
uno.pid.1=0x0001
uno.vid.2=0x2A03
uno.pid.2=0x0043
uno.vid.3=0x2341
uno.pid.3=0x0243

uno.upload.tool=avrdude
uno.upload.protocol=arduino
uno.upload.maximum_size=32256
uno.upload.maximum_data_size=2048
uno.upload.speed=115200

uno.bootloader.tool=avrdude
uno.bootloader.low_fuses=0xFF
uno.bootloader.high_fuses=0xDE
uno.bootloader.extended_fuses=0xFD
uno.bootloader.unlock_bits=0x3F
uno.bootloader.lock_bits=0x0F
uno.bootloader.file=optiboot/optiboot_atmega328.hex

uno.build.mcu=atmega328p
uno.build.f_cpu=16000000L
uno.build.board=AVR_UNO
uno.build.core=arduino
uno.build.variant=standard

##############################################################

uno256.name=Arduino Uno (256 Serial Buffer)
uno256.upload.tool=avrdude
uno256.upload.protocol=arduino
uno256.upload.maximum_size=32256
uno256.upload.speed=115200
uno256.bootloader.low_fuses=0xff
uno256.bootloader.high_fuses=0xde
uno256.bootloader.extended_fuses=0x05
uno256.bootloader.path=optiboot
uno256.bootloader.file=optiboot_atmega328.hex
uno256.bootloader.unlock_bits=0x3F
uno256.bootloader.lock_bits=0x0F
uno256.build.mcu=atmega328p
uno256.build.f_cpu=16000000L
uno256.build.core=arduino_256_serialbuf
uno256.build.variant=standard

##############################################################
```

```
nano /home/username/.arduino15/packages/arduino/hardware/avr/1.6.20/cores/arduino_256_serialbuf/USBAPI.h
```

```
/*
  USBAPI.h
  Copyright (c) 2005-2014 Arduino.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef __USBAPI__
#define __USBAPI__

#include <inttypes.h>
#include <avr/pgmspace.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <util/delay.h>

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

#include "Arduino.h"

// This definitions is usefull if you want to reduce the EP_SIZE to 16
// at the moment only 64 and 16 as EP_SIZE for all EPs are supported except the control endpoint
#ifndef USB_EP_SIZE
#define USB_EP_SIZE 64
#endif

#if defined(USBCON)

#include "USBDesc.h"
#include "USBCore.h"

//================================================================================
//================================================================================
//	USB

#define EP_TYPE_CONTROL				(0x00)
#define EP_TYPE_BULK_IN				((1<<EPTYPE1) | (1<<EPDIR))
#define EP_TYPE_BULK_OUT			(1<<EPTYPE1)
#define EP_TYPE_INTERRUPT_IN		((1<<EPTYPE1) | (1<<EPTYPE0) | (1<<EPDIR))
#define EP_TYPE_INTERRUPT_OUT		((1<<EPTYPE1) | (1<<EPTYPE0))
#define EP_TYPE_ISOCHRONOUS_IN		((1<<EPTYPE0) | (1<<EPDIR))
#define EP_TYPE_ISOCHRONOUS_OUT		(1<<EPTYPE0)

class USBDevice_
{
public:
	USBDevice_();
	bool configured();

	void attach();
	void detach();	// Serial port goes down too...
	void poll();
	bool wakeupHost(); // returns false, when wakeup cannot be processed
};
extern USBDevice_ USBDevice;

//================================================================================
//================================================================================
//	Serial over CDC (Serial1 is the physical port)

struct ring_buffer;

#ifndef SERIAL_BUFFER_SIZE
#if ((RAMEND - RAMSTART) < 1023)
#define SERIAL_BUFFER_SIZE 16
#else
#define SERIAL_BUFFER_SIZE 256
#endif
#endif
#if (SERIAL_BUFFER_SIZE>256)
#error Please lower the CDC Buffer size
#endif

class Serial_ : public Stream
{
private:
	int peek_buffer;
public:
	Serial_() { peek_buffer = -1; };
	void begin(unsigned long);
	void begin(unsigned long, uint8_t);
	void end(void);

	virtual int available(void);
	virtual int peek(void);
	virtual int read(void);
	virtual int availableForWrite(void);
	virtual void flush(void);
	virtual size_t write(uint8_t);
	virtual size_t write(const uint8_t*, size_t);
	using Print::write; // pull in write(str) and write(buf, size) from Print
	operator bool();

	volatile uint8_t _rx_buffer_head;
	volatile uint8_t _rx_buffer_tail;
	unsigned char _rx_buffer[SERIAL_BUFFER_SIZE];

	// This method allows processing "SEND_BREAK" requests sent by
	// the USB host. Those requests indicate that the host wants to
	// send a BREAK signal and are accompanied by a single uint16_t
	// value, specifying the duration of the break. The value 0
	// means to end any current break, while the value 0xffff means
	// to start an indefinite break.
	// readBreak() will return the value of the most recent break
	// request, but will return it at most once, returning -1 when
	// readBreak() is called again (until another break request is
	// received, which is again returned once).
	// This also mean that if two break requests are received
	// without readBreak() being called in between, the value of the
	// first request is lost.
	// Note that the value returned is a long, so it can return
	// 0-0xffff as well as -1.
	int32_t readBreak();

	// These return the settings specified by the USB host for the
	// serial port. These aren't really used, but are offered here
	// in case a sketch wants to act on these settings.
	uint32_t baud();
	uint8_t stopbits();
	uint8_t paritytype();
	uint8_t numbits();
	bool dtr();
	bool rts();
	enum {
		ONE_STOP_BIT = 0,
		ONE_AND_HALF_STOP_BIT = 1,
		TWO_STOP_BITS = 2,
	};
	enum {
		NO_PARITY = 0,
		ODD_PARITY = 1,
		EVEN_PARITY = 2,
		MARK_PARITY = 3,
		SPACE_PARITY = 4,
	};

};
extern Serial_ Serial;

#define HAVE_CDCSERIAL

//================================================================================
//================================================================================
//  Low level API

typedef struct
{
	uint8_t bmRequestType;
	uint8_t bRequest;
	uint8_t wValueL;
	uint8_t wValueH;
	uint16_t wIndex;
	uint16_t wLength;
} USBSetup;

//================================================================================
//================================================================================
//	MSC 'Driver'

int		MSC_GetInterface(uint8_t* interfaceNum);
int		MSC_GetDescriptor(int i);
bool	MSC_Setup(USBSetup& setup);
bool	MSC_Data(uint8_t rx,uint8_t tx);

//================================================================================
//================================================================================
//	CSC 'Driver'

int		CDC_GetInterface(uint8_t* interfaceNum);
int		CDC_GetDescriptor(int i);
bool	CDC_Setup(USBSetup& setup);

//================================================================================
//================================================================================

#define TRANSFER_PGM		0x80
#define TRANSFER_RELEASE	0x40
#define TRANSFER_ZERO		0x20

int USB_SendControl(uint8_t flags, const void* d, int len);
int USB_RecvControl(void* d, int len);
int USB_RecvControlLong(void* d, int len);

uint8_t	USB_Available(uint8_t ep);
uint8_t USB_SendSpace(uint8_t ep);
int USB_Send(uint8_t ep, const void* data, int len);	// blocking
int USB_Recv(uint8_t ep, void* data, int len);		// non-blocking
int USB_Recv(uint8_t ep);							// non-blocking
void USB_Flush(uint8_t ep);

#endif

#endif /* if defined(USBCON) */
```



fastledhyperion.ino
```
#include "FastLED.h"
 
// How many leds in your strip?
#define NUM_LEDS 240
 
// For led chips like Neopixels, which have a data line, ground, and power, you just
// need to define DATA_PIN.  For led chipsets that are SPI based (four wires - data, clock,
// ground, and power), like the LPD8806 define both DATA_PIN and CLOCK_PIN
#define DATA_PIN 6
#define CLOCK_PIN 13
 
#define COLOR_ORDER RGB
 
// Adalight sends a "Magic Word" (defined in /etc/boblight.conf) before sending the pixel data
uint8_t prefix[] = {'A', 'd', 'a'}, hi, lo, chk, i;
 
// Baudrate, higher rate allows faster refresh rate and more LEDs (defined in /etc/boblight.conf)
#define serialRate 460800
 
// Define the array of leds
CRGB leds[NUM_LEDS];
 
void setup() {
      // Uncomment/edit one of the following lines for your leds arrangement.
      // FastLED.addLeds<TM1803, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<TM1804, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<TM1809, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<WS2812, DATA_PIN, RGB>(leds, NUM_LEDS);
         FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
      // FastLED.addLeds<UCS1903, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<UCS1903B, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<GW6205, DATA_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<GW6205_400, DATA_PIN, RGB>(leds, NUM_LEDS);
     
      // FastLED.addLeds<WS2801, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<SM16716, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<LPD8806, RGB>(leds, NUM_LEDS);
 
      // FastLED.addLeds<WS2801, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<SM16716, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
      // FastLED.addLeds<LPD8806, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
     
        // initial RGB flash
        LEDS.showColor(CRGB(255, 0, 0));
        delay(500);
        LEDS.showColor(CRGB(0, 255, 0));
        delay(500);
        LEDS.showColor(CRGB(0, 0, 255));
        delay(500);
        LEDS.showColor(CRGB(0, 0, 0));
       
        Serial.begin(serialRate);
        Serial.print("Ada\n"); // Send "Magic Word" string to host
 
}
 
void loop() {
  // wait for first byte of Magic Word
  for(i = 0; i < sizeof prefix; ++i) {
    waitLoop: while (!Serial.available()) ;;
    // Check next byte in Magic Word
    if(prefix[i] == Serial.read()) continue;
    // otherwise, start over
    i = 0;
    goto waitLoop;
  }
 
  // Hi, Lo, Checksum
 
  while (!Serial.available()) ;;
  hi=Serial.read();
  while (!Serial.available()) ;;
  lo=Serial.read();
  while (!Serial.available()) ;;
  chk=Serial.read();
 
  // if checksum does not match go back to wait
  if (chk != (hi ^ lo ^ 0x55))
  {
    i=0;
    goto waitLoop;
  }
 
  memset(leds, 0, NUM_LEDS * sizeof(struct CRGB));
  // read the transmission data and set LED values
  for (uint8_t i = 0; i < NUM_LEDS; i++) {
    byte r, g, b;    
    while(!Serial.available());
    r = Serial.read();
    while(!Serial.available());
    g = Serial.read();
    while(!Serial.available());
    b = Serial.read();
    leds[i].r = r;
    leds[i].g = g;
    leds[i].b = b;
  }
  // shows new values
 FastLED.show();
}
```

## Raspberry Pi - OSMC ##

```
ssh osmc@<ipaddress>
```

/boot/config.txt
```
#Increase UART speed
init_uart_clock=14745600
```

/etc/hyperion/hyperion.config.json
```
// Automatically generated configuration file for Hyperion ambilight daemon
// Notice: All values are explained with comments at our wiki: wiki.hyperion-project.org (config area) 
// Generated by: HyperCon (The Hyperion deamon configuration file builder)
// Created with HyperCon V1.03.3 (22.10.2017)

{
	// DEVICE CONFIGURATION 
	"device" :
	{
		"name"       : "MyHyperionConfig",
		"type"       : "adalight",
		"output"     : "/dev/ttyACM0",
		"rate"     : 460800,
		"delayAfterConnect"     : 0,
		"colorOrder" : "grb"
	},

	// COLOR CALIBRATION CONFIG
	"color" :
	{
		"channelAdjustment" :
		[
			{
				"id"   : "default",
				"leds" : "*",
				"pureRed" :
				{
					"redChannel"		: 255,
					"greenChannel"		: 0,
					"blueChannel"		: 0
				},
				"pureGreen" :
				{
					"redChannel"		: 0,
					"greenChannel"		: 255,
					"blueChannel"		: 0
				},
				"pureBlue" :
				{
					"redChannel"		: 0,
					"greenChannel"		: 0,
					"blueChannel"		: 255
				}
			}
		],
		"temperature" :
		[
			{
				"id"   : "default",
				"leds" : "*",
				"correctionValues" :
				{
					"red" 	: 255,
					"green"	: 255,
					"blue" 	: 255
				}
			}
		],
		"transform" :
		[
			{
				"id"   : "default",
				"leds" : "*",
				"hsl" :
				{
					"saturationGain"	: 1.0000,
					"luminanceGain"		: 1.0000,
					"luminanceMinimum"		: 0.0000
				},
				"red" :
				{
					"threshold" 	: 0.0000,
					"gamma"     	: 2.5000
				},
				"green" :
				{
					"threshold" 	: 0.0000,
					"gamma"     	: 2.5000
				},
				"blue" :
				{
					"threshold" 	: 0.0000,
					"gamma"     	: 2.5000
				}
			}
		],
	// SMOOTHING CONFIG
		"smoothing" :
		{
			"type"            : "linear",
			"time_ms"         : 200,
			"updateFrequency" : 20.0000,
			"updateDelay"     : 0
		}
	},

	// NO V4L2 GRABBER CONFIG
	// FRAME GRABBER CONFIG
	"framegrabber" : 
	{
		"width" : 64,
		"height" : 64,
		"frequency_Hz" : 10.0,
		"priority" : 890
	},

	// BLACKBORDER CONFIG
	"blackborderdetector" : 
	{
		"enable" : true,
		"threshold" : 0.0,
		"unknownFrameCnt" : 600,
		"borderFrameCnt" : 50,
		"maxInconsistentCnt" : 10,
		"blurRemoveCnt" : 1,
		"mode" : "default"
	},

	// KODI CHECK CONFIG
	"xbmcVideoChecker" : 
	{
		"xbmcAddress" : "127.0.0.1",
		"xbmcTcpPort" : 8080,
		"grabVideo" : true,
		"grabPictures" : true,
		"grabAudio" : true,
		"grabMenu" : true,
		"grabPause" : true,
		"grabScreensaver" : true,
		"enable3DDetection" : true
	},

	// BOOTEFFECT CONFIG
	"bootsequence" : 
	{
		"color" : [0,0,0],
		"effect" : "Rainbow swirl fast",
		"duration_ms" : 3000,
		"priority" : 700
	},

	// JSON SERVER CONFIG
	"jsonServer" : 
	{
		"port" : 19444
	},

	// PROTO SERVER CONFIG
	"protoServer" : 
	{
		"port" : 19445
	},

	// EFFECT PATH
	"effects" : 
	{
		"paths" : 
		[
			"/storage/hyperion/effects",
			"/usr/share/hyperion/effects"
		]
	},

	// NO BOBLIGHT SERVER CONFIG
	// NO JSON/PROTO FORWARD CONFIG

	// LED CONFIGURATION
	"leds" : 
	[
		{
			"index" : 0,
			"hscan" : { "minimum" : 0.2800, "maximum" : 0.3000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 1,
			"hscan" : { "minimum" : 0.7000, "maximum" : 0.7200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 2,
			"hscan" : { "minimum" : 0.7200, "maximum" : 0.7400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 3,
			"hscan" : { "minimum" : 0.7400, "maximum" : 0.7600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 4,
			"hscan" : { "minimum" : 0.7600, "maximum" : 0.7800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 5,
			"hscan" : { "minimum" : 0.7800, "maximum" : 0.8000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 6,
			"hscan" : { "minimum" : 0.8000, "maximum" : 0.8200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 7,
			"hscan" : { "minimum" : 0.8200, "maximum" : 0.8400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 8,
			"hscan" : { "minimum" : 0.8400, "maximum" : 0.8600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 9,
			"hscan" : { "minimum" : 0.8600, "maximum" : 0.8800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 10,
			"hscan" : { "minimum" : 0.8800, "maximum" : 0.9000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 11,
			"hscan" : { "minimum" : 0.9000, "maximum" : 0.9200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 12,
			"hscan" : { "minimum" : 0.9200, "maximum" : 0.9400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 13,
			"hscan" : { "minimum" : 0.9400, "maximum" : 0.9600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 14,
			"hscan" : { "minimum" : 0.9600, "maximum" : 0.9800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 15,
			"hscan" : { "minimum" : 0.9800, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 16,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 17,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.9600, "maximum" : 1.0000 }
		},
		{
			"index" : 18,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 0.9600 }
		},
		{
			"index" : 19,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.8800, "maximum" : 0.9200 }
		},
		{
			"index" : 20,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.8400, "maximum" : 0.8800 }
		},
		{
			"index" : 21,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.8000, "maximum" : 0.8400 }
		},
		{
			"index" : 22,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.7600, "maximum" : 0.8000 }
		},
		{
			"index" : 23,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.7200, "maximum" : 0.7600 }
		},
		{
			"index" : 24,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.6800, "maximum" : 0.7200 }
		},
		{
			"index" : 25,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.6400, "maximum" : 0.6800 }
		},
		{
			"index" : 26,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.6000, "maximum" : 0.6400 }
		},
		{
			"index" : 27,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.5600, "maximum" : 0.6000 }
		},
		{
			"index" : 28,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.5200, "maximum" : 0.5600 }
		},
		{
			"index" : 29,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.4800, "maximum" : 0.5200 }
		},
		{
			"index" : 30,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.4400, "maximum" : 0.4800 }
		},
		{
			"index" : 31,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.4000, "maximum" : 0.4400 }
		},
		{
			"index" : 32,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.3600, "maximum" : 0.4000 }
		},
		{
			"index" : 33,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.3200, "maximum" : 0.3600 }
		},
		{
			"index" : 34,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.2800, "maximum" : 0.3200 }
		},
		{
			"index" : 35,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.2400, "maximum" : 0.2800 }
		},
		{
			"index" : 36,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.2000, "maximum" : 0.2400 }
		},
		{
			"index" : 37,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.1600, "maximum" : 0.2000 }
		},
		{
			"index" : 38,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.1200, "maximum" : 0.1600 }
		},
		{
			"index" : 39,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.0800, "maximum" : 0.1200 }
		},
		{
			"index" : 40,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.0400, "maximum" : 0.0800 }
		},
		{
			"index" : 41,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0400 }
		},
		{
			"index" : 42,
			"hscan" : { "minimum" : 0.9500, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 43,
			"hscan" : { "minimum" : 0.9800, "maximum" : 1.0000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 44,
			"hscan" : { "minimum" : 0.9600, "maximum" : 0.9800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 45,
			"hscan" : { "minimum" : 0.9400, "maximum" : 0.9600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 46,
			"hscan" : { "minimum" : 0.9200, "maximum" : 0.9400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 47,
			"hscan" : { "minimum" : 0.9000, "maximum" : 0.9200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 48,
			"hscan" : { "minimum" : 0.8800, "maximum" : 0.9000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 49,
			"hscan" : { "minimum" : 0.8600, "maximum" : 0.8800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 50,
			"hscan" : { "minimum" : 0.8400, "maximum" : 0.8600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 51,
			"hscan" : { "minimum" : 0.8200, "maximum" : 0.8400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 52,
			"hscan" : { "minimum" : 0.8000, "maximum" : 0.8200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 53,
			"hscan" : { "minimum" : 0.7800, "maximum" : 0.8000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 54,
			"hscan" : { "minimum" : 0.7600, "maximum" : 0.7800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 55,
			"hscan" : { "minimum" : 0.7400, "maximum" : 0.7600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 56,
			"hscan" : { "minimum" : 0.7200, "maximum" : 0.7400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 57,
			"hscan" : { "minimum" : 0.7000, "maximum" : 0.7200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 58,
			"hscan" : { "minimum" : 0.6800, "maximum" : 0.7000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 59,
			"hscan" : { "minimum" : 0.6600, "maximum" : 0.6800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 60,
			"hscan" : { "minimum" : 0.6400, "maximum" : 0.6600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 61,
			"hscan" : { "minimum" : 0.6200, "maximum" : 0.6400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 62,
			"hscan" : { "minimum" : 0.6000, "maximum" : 0.6200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 63,
			"hscan" : { "minimum" : 0.5800, "maximum" : 0.6000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 64,
			"hscan" : { "minimum" : 0.5600, "maximum" : 0.5800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 65,
			"hscan" : { "minimum" : 0.5400, "maximum" : 0.5600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 66,
			"hscan" : { "minimum" : 0.5200, "maximum" : 0.5400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 67,
			"hscan" : { "minimum" : 0.5000, "maximum" : 0.5200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 68,
			"hscan" : { "minimum" : 0.4800, "maximum" : 0.5000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 69,
			"hscan" : { "minimum" : 0.4600, "maximum" : 0.4800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 70,
			"hscan" : { "minimum" : 0.4400, "maximum" : 0.4600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 71,
			"hscan" : { "minimum" : 0.4200, "maximum" : 0.4400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 72,
			"hscan" : { "minimum" : 0.4000, "maximum" : 0.4200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 73,
			"hscan" : { "minimum" : 0.3800, "maximum" : 0.4000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 74,
			"hscan" : { "minimum" : 0.3600, "maximum" : 0.3800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 75,
			"hscan" : { "minimum" : 0.3400, "maximum" : 0.3600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 76,
			"hscan" : { "minimum" : 0.3200, "maximum" : 0.3400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 77,
			"hscan" : { "minimum" : 0.3000, "maximum" : 0.3200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 78,
			"hscan" : { "minimum" : 0.2800, "maximum" : 0.3000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 79,
			"hscan" : { "minimum" : 0.2600, "maximum" : 0.2800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 80,
			"hscan" : { "minimum" : 0.2400, "maximum" : 0.2600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 81,
			"hscan" : { "minimum" : 0.2200, "maximum" : 0.2400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 82,
			"hscan" : { "minimum" : 0.2000, "maximum" : 0.2200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 83,
			"hscan" : { "minimum" : 0.1800, "maximum" : 0.2000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 84,
			"hscan" : { "minimum" : 0.1600, "maximum" : 0.1800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 85,
			"hscan" : { "minimum" : 0.1400, "maximum" : 0.1600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 86,
			"hscan" : { "minimum" : 0.1200, "maximum" : 0.1400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 87,
			"hscan" : { "minimum" : 0.1000, "maximum" : 0.1200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 88,
			"hscan" : { "minimum" : 0.0800, "maximum" : 0.1000 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 89,
			"hscan" : { "minimum" : 0.0600, "maximum" : 0.0800 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 90,
			"hscan" : { "minimum" : 0.0400, "maximum" : 0.0600 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 91,
			"hscan" : { "minimum" : 0.0200, "maximum" : 0.0400 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 92,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0200 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 93,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0800 }
		},
		{
			"index" : 94,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.0000, "maximum" : 0.0400 }
		},
		{
			"index" : 95,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.0400, "maximum" : 0.0800 }
		},
		{
			"index" : 96,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.0800, "maximum" : 0.1200 }
		},
		{
			"index" : 97,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.1200, "maximum" : 0.1600 }
		},
		{
			"index" : 98,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.1600, "maximum" : 0.2000 }
		},
		{
			"index" : 99,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.2000, "maximum" : 0.2400 }
		},
		{
			"index" : 100,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.2400, "maximum" : 0.2800 }
		},
		{
			"index" : 101,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.2800, "maximum" : 0.3200 }
		},
		{
			"index" : 102,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.3200, "maximum" : 0.3600 }
		},
		{
			"index" : 103,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.3600, "maximum" : 0.4000 }
		},
		{
			"index" : 104,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.4000, "maximum" : 0.4400 }
		},
		{
			"index" : 105,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.4400, "maximum" : 0.4800 }
		},
		{
			"index" : 106,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.4800, "maximum" : 0.5200 }
		},
		{
			"index" : 107,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.5200, "maximum" : 0.5600 }
		},
		{
			"index" : 108,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.5600, "maximum" : 0.6000 }
		},
		{
			"index" : 109,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.6000, "maximum" : 0.6400 }
		},
		{
			"index" : 110,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.6400, "maximum" : 0.6800 }
		},
		{
			"index" : 111,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.6800, "maximum" : 0.7200 }
		},
		{
			"index" : 112,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.7200, "maximum" : 0.7600 }
		},
		{
			"index" : 113,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.7600, "maximum" : 0.8000 }
		},
		{
			"index" : 114,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.8000, "maximum" : 0.8400 }
		},
		{
			"index" : 115,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.8400, "maximum" : 0.8800 }
		},
		{
			"index" : 116,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.8800, "maximum" : 0.9200 }
		},
		{
			"index" : 117,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 0.9600 }
		},
		{
			"index" : 118,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.9600, "maximum" : 1.0000 }
		},
		{
			"index" : 119,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0500 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 120,
			"hscan" : { "minimum" : 0.0000, "maximum" : 0.0200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 121,
			"hscan" : { "minimum" : 0.0200, "maximum" : 0.0400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 122,
			"hscan" : { "minimum" : 0.0400, "maximum" : 0.0600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 123,
			"hscan" : { "minimum" : 0.0600, "maximum" : 0.0800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 124,
			"hscan" : { "minimum" : 0.0800, "maximum" : 0.1000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 125,
			"hscan" : { "minimum" : 0.1000, "maximum" : 0.1200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 126,
			"hscan" : { "minimum" : 0.1200, "maximum" : 0.1400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 127,
			"hscan" : { "minimum" : 0.1400, "maximum" : 0.1600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 128,
			"hscan" : { "minimum" : 0.1600, "maximum" : 0.1800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 129,
			"hscan" : { "minimum" : 0.1800, "maximum" : 0.2000 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 130,
			"hscan" : { "minimum" : 0.2000, "maximum" : 0.2200 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 131,
			"hscan" : { "minimum" : 0.2200, "maximum" : 0.2400 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 132,
			"hscan" : { "minimum" : 0.2400, "maximum" : 0.2600 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		},
		{
			"index" : 133,
			"hscan" : { "minimum" : 0.2600, "maximum" : 0.2800 },
			"vscan" : { "minimum" : 0.9200, "maximum" : 1.0000 }
		}
	],

	"endOfJson" : "endOfJson"
}
```

