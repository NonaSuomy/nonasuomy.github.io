---
layout: post
title: Arduino Create Agent Bridge Arch Linux
---
# Resources #
https://create.arduino.cc/editor


Download the bleading edge Agent: http://downloads.arduino.cc/CreateBridge/staging/ArduinoCreateAgent-1.0-linux-x64-installer.run


**Note:** *1.1 (1.0.46) is the official release 1.0 (1.0.188) is the dev release above.*


Which is actually newer than this one here: http://create.arduino.cc/getting-started/plugin?page=2.


## Other Research ##
https://github.com/arduino/arduino-create-agent/issues/45
https://github.com/puma/puma-dev/issues/47#issuecomment-259231445


# Arch Linux Install 
## Troubleshooting ##


### FireFox ###


```
FireFox Version 49.0.2
```


Go here:
http://create.arduino.cc/getting-started/plugin?page=2


Follow the directions on screen and make sure to add the cert to FireFox's own keychain, other wise you will get the HTTPS error in the console and it won't connect.


### Chromium ###


```
Chromium Version 54.0.2840.90 (64-bit)
```


I followed the on screen steps for Chromium and it didn't work, Chromium uses the local machines certs folder, so you have to manually copy it there, because the script is currently broken for Arch Linux. Steps below on how to proceed.


```
Something went wrong


We are not able to establish a secure (HTTPS) connection between the Plugin and the Arduino Web Editor. You can try to restart your browser once more, or Download the Installer and run it again.
Please Write us on the Forum so we can help debugging this issue.
```
**Note:** *note here*


Now if I hit up the http://create.arduino.cc/getting-started/plugin?page=2 then hit skip for the plugin download as I already have it installed:


```
INFO[0280] called restart /home/username/ArduinoCreateAgent-1.0/Arduino_Create_Bridge 
INFO[0280] Starting new spjs process                    
&{/home/username/ArduinoCreateAgent-1.0/Arduino_Create_Bridge [/home/username/ArduinoCreateAgent-1.0/Arduino_Create_Bridge -ls -regex usb|acm|com -gc std ] []  <nil> <nil> <nil> [] <nil> <nil> <nil> <nil> false [] [] [] [] <nil>}
FATA[0280] Exited current spjs for restart              
[username@systemname ArduinoCreateAgent-1.0]$
```


I get bumped back to the CLI, so staying on the same page I run it again...


```
ArduinoCreateAgent-1.0]$ ./Arduino_Create_Bridge 
INFO[0000] map[avrdude:/home/username/.arduino-create/avrdude/6.3.0-arduino6 avrdude-6.3.0-arduino6:/home/username/.arduino-create/avrdude/6.3.0-arduino6] 
INFO[0000] Version:1.0.188                               
INFO[0000] Hostname: systemname                            
INFO[0000] Garbage collection is on using Standard mode, meaning we just let Golang determine when to garbage collect. 
INFO[0000] You specified a serial port regular expression filter: usb|acm|com
 
INFO[0000] Your serial ports:                           
INFO[0000] 	{/dev/ttyACM0     0x8036 0x2341  false}
    
INFO[0000] 	{/dev/ttyUSB0     0x6001 0x0403 A6004mMA false}
 
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)


[GIN-debug] GET   /                         --> main.homeHandler (2 handlers)
[GIN-debug] GET   /certificate.crt          --> main.certHandler (2 handlers)
[GIN-debug] DELETE /certificate.crt          --> main.deleteCertHandler (2 handlers)
[GIN-debug] POST  /upload                   --> main.uploadHandler (2 handlers)
[GIN-debug] GET   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] POST  /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
INFO[0000] Inside run of serialhub                      
[GIN-debug] WS    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WSS   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] GET   /info                     --> main.infoHandler (2 handlers)
[GIN-debug] POST  /killbrowser              --> main.killBrowserHandler (2 handlers)
[GIN-debug] POST  /pause                    --> main.pauseHandler (2 handlers)
[GIN-debug] POST  /update                   --> main.updateHandler (2 handlers)
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8991
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8992
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8992: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8992: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8993
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8991
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8992
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8992: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8992: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8993
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8993: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8993: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8994


(Arduino_Create_Bridge:15477): Gdk-CRITICAL **: gdk_window_thaw_toplevel_updates: assertion 'window->update_and_descendants_freeze_count > 0' failed
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
...
```


I get bumped back to the CLI, so staying on the same page I run it again...


**Note:** *I was informed it does this because it knows there has been an update.*


```
ArduinoCreateAgent-1.0]$ ./Arduino_Create_Bridge 
INFO[0000] map[avrdude:/home/username/.arduino-create/avrdude/6.3.0-arduino6 avrdude-6.3.0-arduino6:/home/username/.arduino-create/avrdude/6.3.0-arduino6] 
INFO[0000] Version:1.0.188                              
INFO[0000] Hostname: systemname                            
INFO[0000] Garbage collection is on using Standard mode, meaning we just let Golang determine when to garbage collect. 
INFO[0000] You specified a serial port regular expression filter: usb|acm|com
 
INFO[0000] Your serial ports:                           
INFO[0000] 	{/dev/ttyACM0     0x8036 0x2341  false}
    
INFO[0000] 	{/dev/ttyUSB0     0x6001 0x0403 A6004mMA false}
 
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)


[GIN-debug] GET   /                         --> main.homeHandler (2 handlers)
[GIN-debug] GET   /certificate.crt          --> main.certHandler (2 handlers)
[GIN-debug] DELETE /certificate.crt          --> main.deleteCertHandler (2 handlers)
[GIN-debug] POST  /upload                   --> main.uploadHandler (2 handlers)
[GIN-debug] GET   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] POST  /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
INFO[0000] Inside run of serialhub                      
[GIN-debug] WS    /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] WSS   /socket.io/               --> main.(*WsServer).ServeHTTP-fm (2 handlers)
[GIN-debug] GET   /info                     --> main.infoHandler (2 handlers)
[GIN-debug] POST  /killbrowser              --> main.killBrowserHandler (2 handlers)
[GIN-debug] POST  /pause                    --> main.pauseHandler (2 handlers)
[GIN-debug] POST  /update                   --> main.updateHandler (2 handlers)
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8991
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8992
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8992: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8992: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTP on 127.0.0.1:8993
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8991
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8991: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8991: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8992
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8992: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8992: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8993
[GIN-debug] [ERROR] listen tcp 127.0.0.1:8993: bind: address already in use
INFO[0000] Error trying to bind to port: listen tcp 127.0.0.1:8993: bind: address already in use, so exiting... 
[GIN-debug] Listening and serving HTTPS on 127.0.0.1:8994


(Arduino_Create_Bridge:15477): Gdk-CRITICAL **: gdk_window_thaw_toplevel_updates: assertion 'window->update_and_descendants_freeze_count > 0' failed
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
[ERR] bonjour: Failed to bind to udp6 port: listen udp6 :5353: bind: address already in use
...
```


**Note** *You can pretty much ignore the bonjour error, this happens if you have avahi running in the background. https://wiki.archlinux.org/index.php/avahi *




Which the webGUI then says:


```
Plugin correctly installed!


You should now see the Arduino Plugin Icon in your top or bottom bar of the Linux distribution you are using. Click on the Tray Icon for a link to the Arduino Web Editor, and if you want to Pause the plugin.
If you close it you can relaunching by clicking the Arduino Plugin icon on your desktop.
```


When you click next:


```
Restart Chrome


We know this is annoying, but to update the Certificates settings you need to restart Chrome.
If you don't restart the browser, the Arduino Web Editor won't be able to communicate with the plugin. The browser will reopen just this tab.
Any issue or question? Write us on the Forum.
```


Click Restart:


```
Loading Arduino Create...
```


CLI:


```
http2: server: error reading preface from client 127.0.0.1:53542: read tcp 127.0.0.1:8992->127.0.0.1:53542: read: connection reset by peer
```


WebGUI:


```
Something went wrong


We are not able to establish a secure (HTTPS) connection between the Plugin and the Arduino Web Editor. You can try to restart your browser once more, or Download the Installer and run it again.
Please Write us on the Forum so we can help debugging this issue.
```


## The Fix ##


I believe the issue is with createAgentLocal.crt this file doesn't exist the name should be ca.cert.cer.


https://github.com/arduino/arduino-create-agent/issues/129
https://forum.arduino.cc/index.php?PHPSESSID=kbbk4oj7ed1u6u7qhv137n1kh2&topic=411290.msg2854866#msg2854866


```* copy ca.cert.cer to your local certificate pool and refresh the index (maybe use this script to understand where it needs to be copied)```.


### Generate Cert ###
```
ArduinoCreateAgent-1.0]$ sudo ./Arduino_Create_Bridge --generateCert
INFO[0000] written ca.key.pem                           
INFO[0000] written ca.cert.pem                          
INFO[0000] written ca.cert.cer                          
INFO[0000] written key.pem                              
INFO[0000] written cert.pem                             
INFO[0000] written cert.cer
```


### File Listing ###


```
ArduinoCreateAgent-1.0]$ ls
Arduino_Create_Bridge
ca.cert.cer
ca.cert.pem
ca.key.pem
cert.cer
certmgr.sh
cert.pem
config.ini
InstallerIcon.png
key.pem
uninstall
'Uninstall arduino-create-agent.desktop'
uninstall.dat
```


### Copy Cert & Update Trust ###


```
sudo cp ~/ArduinoCreateAgent-1.0/ca.cert.cer /usr/share/ca-certificates/trust-source/anchors/
sudo update-ca-trust
```


Then restart Arduino_Create_Bridge 


```
ArduinoCreateAgent-1.0]$ sudo ./Arduino_Create_Bridge
```


Then restarted Chromium and all of a sudden you should see "Arduino <Something>" Connected! if you had the arduino plugged in, w00t.
