---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 5a - Arch Linux Asterisk
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVoIP.png "Arch Linux Asterisk")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 04a - VM Arch Linux Router - Systemd-networkd](../Infrastructure-Part-4a)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

Part 05a - Arch Linux Asterisk - You Are Here!

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - NFTables Transparent TOR Proxy / SSH / IRC](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# Arch Linux Asterisk #

Install PJProject & Asterisk from AUR.

```
mkdir ~/code
cd ~/code
git clone https://aur.archlinux.com/pjproject.git
cd pjproject
makepkg -si
cd ..
git clone https://aur.archlinux.com/asterisk.git
cd asterisk
makepkg -si
cd ..
```

# Postfix Setup #
Install postfix.

```
sudo pacman -S postfix
```

##Generate an App Password for Postfix ##

Log in to your email, then click this link [https://myaccount.google.com/security](Manage your account access and security settings). Scroll down to “Password & sign-in method” and click 2-Step Verification. You may be asked for your password and a verification code before continuing. Make sure that 2-Step verification is enabled.

Now click this link [https://security.google.com/settings/security/apppasswords](Generate an App password) for Postfix.


Click Select app and choose Other (custom name) from the dropdown. Type “Postfix” and click generate.
The newly generated password will load in the yellow box. Use this in the sasl_passwd file. Save it someplace secure that you’ll be able to utilize it easily in the next step, then click done.


Make a sasl directory under /etc/postfix folder. 

```
sudo mkdir /etc/postfix/sasl
```

Replace the email address with yours and app password you received from google where “xxxxxxxxxxxxxxxx” is.

/etc/postfix/sasl/sasl_passwd
```
[smtp.gmail.com]:587 emailaccount@gmail.com:xxxxxxxxxxxxxxxx
```

Generate postmap.

```
sudo postmap /etc/postfix/sasl/sasl_passwd
```

Edit master.cf and uncomment ```submission inet n       -       n       -       -       smtpd``` .

/etc/postfix/master.cf
```
# Postfix master process configuration file.  For details on the format
# of the file, see the master(5) manual page (command: "man 5 master" or
# on-line: http://www.postfix.org/master.5.html).
#
# Do not forget to execute "postfix reload" after editing this file.
#
# ==========================================================================
# service type  private unpriv  chroot  wakeup  maxproc command + args
#               (yes)   (yes)   (no)    (never) (100)
# ==========================================================================
smtp      inet  n       -       n       -       -       smtpd
#smtp      inet  n       -       n       -       1       postscreen
#smtpd     pass  -       -       n       -       -       smtpd
#dnsblog   unix  -       -       n       -       0       dnsblog
#tlsproxy  unix  -       -       n       -       0       tlsproxy
submission inet n       -       n       -       -       smtpd
```

Add Relayhost to main.cf

```
INTERNET OR INTRANET

# The relayhost parameter specifies the default host to send mail to
# when no entry is matched in the optional transport(5) table. When
# no relayhost is given, mail is routed directly to the destination.
#
# On an intranet, specify the organizational domain name. If your
# internal DNS uses no MX records, specify the name of the intranet
# gateway host instead.
#
# In the case of SMTP, specify a domain, host, host:port, [host]:port,
# [address] or [address]:port; the form [host] turns off MX lookups.
#
# If you're connected via UUCP, see also the default_transport parameter.
#
#relayhost = $mydomain
#relayhost = [gateway.my.domain]
#relayhost = [mailserver.isp.tld]
#relayhost = uucphost
#relayhost = [an.ip.add.ress]
# This tells Postfix to hand off all messages to Gmail, and never do direct delivery.
relayhost = [smtp.gmail.com]:587

# This enables TLS (SMTPS) certificate verification, because Gmail has a valid one.
smtp_tls_security_level = verify
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
smtp_tls_session_cache_database = btree:/var/run/smtp_tls_session_cache

# This tells Postfix to provide the username/password when Gmail asks for one.
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_sasl_security_options = noanonymous
```

Enable postfix.

sudo systemctl enable postfix
sudo systemctl start postfix

If you edit postfix after enabling the service run postfix reload.

```
sudo postfix reload
```

Test Postfix

Use Postfix’s sendmail implementation to send a test email. Enter lines similar to those shown below, and note that there is no prompt between lines until the . ends the process.

```
sendmail recipient@elsewhere.com
From: you@example.com
Subject: Test mail
This is a test email
.
```

Check the destination email account for the test email. Open syslog using the tail -f command to show changes as they appear live:

```
sudo tail -f /var/log/syslog
```

CTRL + C to exit the log.

If you received the test E-Mail ok and you see /etc/postfix/sasl/sasl_passwd.db you can delete /etc/postfix/sasl/sasl_passwd

```
sudo rm /etc/postfix/sasl/sasl_passwd
```

## Configure Asterisk ##

/etc/asterisk/sip.conf
```
; SIP Configuration example for Asterisk

[general]
register => 6DigitAccountNumber:SIPServicePasswordHere@atlanta.voip.ms:5060

;Trunk
[voipms]
canreinvite=no
context=voipmscontext
host=atlanta.voip.ms
secret=SIPServicePasswordHere
type=peer
username=6DigitAccountNumberHere
disallow=all
allow=ulaw
fromuser=6DigitAccountNumberHereAgain
trustrpid=yes
sendrpid=yes
insecure=invite
nat=yes

; Other Settings
udpbindaddr=0.0.0.0

tcpenable=no
tcpbindaddr=0.0.0.0

transport=udp
srvlookup=yes

; Extensions
[201]
type=friend
username=201
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=201@default

[202]
type=friend
username=202
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=202@default

[203]
type=friend
username=203
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=203@default

[204]
type=friend
username=204
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=204@default

[205]
type=friend
username=205
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=205@default

[206]
type=friend
username=206
secret=PhonePasswordHere
host=dynamic
context=internal
mailbox=206@default
```

/etc/asterisk/extensions.conf
```
; extensions.conf - the Asterisk dial plan
;
; Static extension configuration file, used by
; the pbx_config module. This is where you configure all your
; inbound and outbound calls in Asterisk.
;
; This configuration file is reloaded
; - With the "dialplan reload" command in the CLI
; - With the "reload" command (that reloads everything) in the CLI

;
; The "General" category is for certain variables.
;
[general]
;
; If static is set to no, or omitted, then the pbx_config will rewrite
; this file when extensions are modified.  Remember that all comments
; made in the file will be lost when that happens.
;
; XXX Not yet implemented XXX
;
static=yes
;
; if static=yes and writeprotect=no, you can save dialplan by
; CLI command "dialplan save" too
;
writeprotect=no
;
; If autofallthrough is set, then if an extension runs out of
; things to do, it will terminate the call with BUSY, CONGESTION
; or HANGUP depending on Asterisk's best guess. This is the default.
;
; If autofallthrough is not set, then if an extension runs out of
; things to do, Asterisk will wait for a new extension to be dialed
; (this is the original behavior of Asterisk 1.0 and earlier).
;
;autofallthrough=no
;
;
;
; If extenpatternmatchnew is set (true, yes, etc), then a new algorithm that uses
; a Trie to find the best matching pattern is used. In dialplans
; with more than about 20-40 extensions in a single context, this
; new algorithm can provide a noticeable speedup.
; With 50 extensions, the speedup is 1.32x
; with 88 extensions, the speedup is 2.23x
; with 138 extensions, the speedup is 3.44x
; with 238 extensions, the speedup is 5.8x
; with 438 extensions, the speedup is 10.4x
; With 1000 extensions, the speedup is ~25x
; with 10,000 extensions, the speedup is 374x
; Basically, the new algorithm provides a flat response
; time, no matter the number of extensions.
;
; By default, the old pattern matcher is used.
;
; ****This is a new feature! *********************
; The new pattern matcher is for the brave, the bold, and
; the desperate. If you have large dialplans (more than about 50 extensions
; in a context), and/or high call volume, you might consider setting
; this value to "yes" !!
; Please, if you try this out, and are forced to return to the
; old pattern matcher, please report your reasons in a bug report
; on https://issues.asterisk.org. We have made good progress in providing
; something compatible with the old matcher; help us finish the job!
;
; This value can be switched at runtime using the cli command "dialplan set extenpatternmatchn>
; or "dialplan set extenpatternmatchnew false", so you can experiment to your heart's content.
;
;extenpatternmatchnew=no
;
; If clearglobalvars is set, global variables will be cleared
; and reparsed on a dialplan reload, or Asterisk reload.
;
; If clearglobalvars is not set, then global variables will persist
; through reloads, and even if deleted from the extensions.conf or
; one of its included files, will remain set to the previous value.
;
; NOTE: A complication sets in, if you put your global variables into
; the AEL file, instead of the extensions.conf file. With clearglobalvars
; set, a "reload" will often leave the globals vars cleared, because it
; is not unusual to have extensions.conf (which will have no globals)
; load after the extensions.ael file (where the global vars are stored).
; So, with "reload" in this particular situation, first the AEL file will
; clear and then set all the global vars, then, later, when the extensions.conf
; file is loaded, the global vars are all cleared, and then not set, because
; they are not stored in the extensions.conf file.
;
clearglobalvars=no
;
; User context is where entries from users.conf are registered.  The
; default value is 'default'
;
;userscontext=default
;
; You can include other config files, use the #include command
; (without the ';'). Note that this is different from the "include" command
; that includes contexts within other contexts. The #include command works
; in all asterisk configuration files.
;#include "filename.conf"
;#include <filename.conf>
;#include filename.conf
;
; You can execute a program or script that produces config files, and they
; will be inserted where you insert the #exec command. The #exec command
; works on all asterisk configuration files.  However, you will need to
; activate them within asterisk.conf with the "execincludes" option.  They
; are otherwise considered a security risk.
;#exec /opt/bin/build-extra-contexts.sh
;#exec /opt/bin/build-extra-contexts.sh --foo="bar"
;#exec </opt/bin/build-extra-contexts.sh --foo="bar">
;#exec "/opt/bin/build-extra-contexts.sh --foo=\"bar\""
;

; The "Globals" category contains global variables that can be referenced
; in the dialplan with the GLOBAL dialplan function:
; ${GLOBAL(VARIABLE)}
; ${${GLOBAL(VARIABLE)}} or ${text${GLOBAL(VARIABLE)}} or any hybrid
; Unix/Linux environmental variables can be reached with the ENV dialplan
; function: ${ENV(VARIABLE)}
;
[globals]
;TRUNK=DAHDI/G2                                 ; Trunk interface
;
; Note the 'G2' in the TRUNK variable above. It specifies which group (defined
; in chan_dahdi.conf) to dial, i.e. group 2, and how to choose a channel to use
; in the specified group. The four possible options are:
;
; g: select the lowest-numbered non-busy DAHDI channel
;    (aka. ascending sequential hunt group).
; G: select the highest-numbered non-busy DAHDI channel
;    (aka. descending sequential hunt group).
; r: use a round-robin search, starting at the next highest channel than last
;    time (aka. ascending rotary hunt group).
; R: use a round-robin search, starting at the next lowest channel than last
;    time (aka. descending rotary hunt group).
;
;TRUNKMSD=1                                     ; MSD digits to strip (usually 1 or 0)

[internal]

include => voipmscontext

exten => 201,1,Dial(SIP/201,20)
;exten => 201,2,VoiceMail(201@default)
exten => 201,3,Hangup()

exten => 202,1,Dial(SIP/202)
;exten => 202,2,VoiceMail(202@default)
exten => 202,3,Hangup()

exten => 203 Living Room,1,Dial(SIP/203)
exten => 203,2,VoiceMail(203@default)
exten => 203,3,Hangup()

exten => 204,1,Dial(SIP/204)
;exten => 204,2,VoiceMail(204@default)
exten => 204,3,Hangup()

exten => 205,1,Dail(SIP/205)
;exten => 205,2,VoiceMail(205@default)
exten => 205,3,Hangup()

exten => 206,1,Dial(SIP/206)
;exten => 206,2,VoiceMail(206@default)
exten => 206,3,Hangup()

; Testing extensions, These media files are included in the extra sounds packages 
; you have to download them and extract them to the folder:
; cd /var/lib/asterisk/sounds/en/
; wget https://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-gsm-current.tar.gz
; tar -xvf asterisk-extra-sounds-en-gsm-current.tar.gz

; Prepare to be insulted like a Monthy Python knight.
exten => 207,1,Answer()
exten => 207,n,Playback(tt-monty-knights)
exten => 207,n,Hangup()

exten => 208,1,Answer()
exten => 208,n,Playback(zombies)
exten => 208,n,Hangup()

exten => 209,1,Answer()
exten => 209,n,Playback(timewarp)
exten => 209,n,Hangup()

exten => 210,1,Answer()
exten => 210,n,Playback(eletelephony)
exten => 210,n,Hangup()

exten => 211,1,Answer()
exten => 211,n,Playback(weasels-eaten-phonesys)
exten => 211,n,Hangup()

exten => 212,1,Answer()
exten => 212,n,Playback(wrong-try-again-smarty)
exten => 212,n,Hangup()

; Call voicemail main menu to check messages the “s” in s203 meas auto login to mailbox 203.
exten => *97,1,VoiceMailMain(s203@default)

[voipmscontext]
; Make sure to include inbound prior to outbound because the _NXXNXXXXXX handler will match the inbound numbers.
include => voipms-inbound
include => voipms-outbound

[voipms-outbound]
exten => _1NXXNXXXXXX,1,Dial(SIP/${EXTEN}@voipms)
exten => _1NXXNXXXXXX,n,Hangup()
exten => _NXXNXXXXXX,1,Dial(SIP/1${EXTEN}@voipms)
exten => _NXXNXXXXXX,n,Hangup()
exten => _011.,1,Dial(SIP/${EXTEN}@voipms)
exten => _011.,n,Hangup()
exten => _00.,1,Dial(SIP/${EXTEN}@voipms)
exten => _00.,n,Hangup()

; inbound context example for your DID numbers, do not add the number 1 in front

[voipms-inbound]
;exten => 10digitnum,1,Answer()

; s means grab any call we don’t know the DID of.
exten => s,1,Answer()
; Log call information to the console.
exten => s,n,Log(NOTICE, Incoming call from ${CALLERID(all)})
; Ring Group (Ring all these phones) 15Sec ring time.
exten => s,n,Dial(SIP/201&SIP/202&SIP/203&SIP/204,15)
; Dial single extension instead of ring group.
;exten => s,n,Dial(SIP/203,15)
; Pass the call to voicemail if nobody picks up after 15 seconds.
exten => s,n,VoiceMail(203@default)
; Hangup after voicemail process.
exten => s,n,Hangup()
; End of the "incoming" context
```

/etc/asterisk/voicemail.conf
```
; Voicemail Configuration
;
[general]
; Formats for writing Voicemail.  Note that when using IMAP storage for
; voicemail, only the first format specified will be used.
;format=g723sf|wav49|wav
format=wav49|gsm|wav
;
; WARNING:
; If you change the list of formats that you record voicemail in
; when you have mailboxes that contain messages, you _MUST_ absolutely
; manually go through those mailboxes and convert/delete/add the
; the message files so that they appear to have been stored using
; your new format list. If you don't do this, very unpleasant
; things may happen to your users while they are retrieving and
; manipulating their voicemail.
;
; In other words: don't change the format list on a production system
; unless you are _VERY_  sure that you know what you are doing and are
; prepared for the consequences.
;
; Who the e-mail notification should appear to come from
serveremail=asterisk@server.net
;serveremail=asterisk@linux-support.net
; Should the email contain the voicemail as an attachment
attach=yes
; Maximum number of messages per folder.  If not specified, a default value
; (100) is used.  Maximum value for this option is 9999.  If set to 0, a
; mailbox will be greetings-only.
;maxmsg=100
; Maximum length of a voicemail message in seconds
;maxsecs=180
; Minimum length of a voicemail message in seconds for the message to be kept
; The default is no minimum.
;minsecs=3
; Maximum length of greetings in seconds
;maxgreet=60
; How many milliseconds to skip forward/back when rew/ff in message playback
skipms=3000
; How many seconds of silence before we end the recording
maxsilence=10
; Silence threshold (what we consider silence: the lower, the more sensitive)
silencethreshold=128
; Max number of failed login attempts
maxlogins=3

emaildateformat=%A, %B %d, %Y at %r


sendvoicemail=yes ; Allow the user to compose and send a voicemail while inside
                  ; VoiceMailMain() [option 5 from mailbox's advanced menu].
                  ; If set to 'no', option 5 will not be listed.

[default]
; Note: The rest of the system must reference mailboxes defined here as mailbox@default.

;ext => password,NAME,email@address.com

;201 => 1234,201,email@address.com
;202 => 1234,202,email@address.com
203 => 1234,203,email@address.com
;204 => 1234,204,email@address.com
;205 => 1234,205,email@address.com
;206 => 1234,206,email@address.com
```

Enable and start Asterisk service.

```
sudo systemctl enable asterisk
sudo systemctl start asterisk
```

## Troubleshooting Asterisk ##

Look at the asterisk console for issues (Warnings)

```
sudo asterisk -rvvvvvvv
Asterisk 16.5.0, Copyright (C) 1999 - 2018, Digium, Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk 16.5.0 currently running on asterisk001 (pid = 64912)
asterisk001*CLI> 
```

At the Asterisk CLI you can reload the dialplan after changes to extensions.conf

```
asterisk001*CLI> dialplan reload
```

Reload voicemail.conf

```
asterisk001*CLI> voicemail reload
```

Reload sip.conf

```
asterisk001*CLI> sip reload
``` 

Reload everything

```
asterisk001*CLI> reload
``` 

Turn sip debug on to see where problems may be.

```
asterisk001*CLI> sip set debug on
SIP Debugging enabled
``` 

Check if the SIP trunk is registered.

```
asterisk001*CLI> sip show registry
Host                                    dnsmgr Username       Refresh State                Reg.Time                 
atlanta.voip.ms:5060                   N      XXXXXX             105 Registered           Sun, 29 Sep 2019 11:53:24
1 SIP registrations.
``` 

Check if everything is registering with the Asterisk server.

```
asterisk001*CLI> sip show peers
Name/username             Host                                    Dyn Forcerport Comedia    ACL Port     Status      Description                      
201/201                   (Unspecified)                            D  Auto (No)  No             0        Unmonitored                                  
202/202                   (Unspecified)                            D  Auto (No)  No             0        Unmonitored                                  
203/203                   10.0.50.83                                D  Auto (No)  No             5060     Unmonitored                                  
204/204                   (Unspecified)                            D  Auto (No)  No             0        Unmonitored                                  
205/205                   (Unspecified)                            D  Auto (No)  No             0        Unmonitored                                  
206/206                   (Unspecified)                            D  Auto (No)  No             0        Unmonitored                                  
voipms/XXXXXX             XXX.XX.XX.XXX                               Yes        Yes            5060     Unmonitored                                  
7 sip peers [Monitored: 0 online, 0 offline Unmonitored: 2 online, 5 offline]
``` 

Check a single device stats. 

```
asterisk001*CLI> sip show peer 203


  * Name       : 203
  Description  : 
  Secret       : <Set>
  MD5Secret    : <Not set>
  Remote Secret: <Not set>
  Context      : internal
  Record On feature : automon
  Record Off feature : automon
  Subscr.Cont. : <Not set>
  Language     : 
  Tonezone     : <Not set>
  AMA flags    : Unknown
  Transfer mode: open
  CallingPres  : Presentation Allowed, Not Screened
  Callgroup    : 
  Pickupgroup  : 
  Named Callgr : 
  Nam. Pickupgr: 
  MOH Suggest  : 
  Mailbox      : 203@default
  VM Extension : asterisk
  LastMsgsSent : 4/0
  Call limit   : 0
  Max forwards : 0
  Dynamic      : Yes
  Callerid     : "" <>
  MaxCallBR    : 384 kbps
  Expire       : 279
  Insecure     : no
  Force rport  : Auto (No)
  Symmetric RTP: No
  ACL          : No
  ContactACL   : No
  DirectMedACL : No
  T.38 support : No
  T.38 EC mode : Unknown
  T.38 MaxDtgrm: 4294967295
  DirectMedia  : Yes
  PromiscRedir : No
  User=Phone   : No
  Video Support: No
  Text Support : No
  Ign SDP ver  : No
  Trust RPID   : No
  Send RPID    : No
  Path support : No
  Path         : N/A
  TrustIDOutbnd: Legacy
  Subscriptions: Yes
  Overlap dial : Yes
  DTMFmode     : rfc2833
  Timer T1     : 500
  Timer B      : 32000
  ToHost       : 
  Addr->IP     : 10.0.50.83:5060
  Defaddr->IP  : (null)
  Prim.Transp. : UDP
  Allowed.Trsp : UDP
  Def. Username: 203
  SIP Options  : (none)
  Codecs       : (ulaw|alaw|gsm|h263)
  Auto-Framing : No
  Status       : Unmonitored
  Useragent    : PolycomSoundPointIP-SPIP_670-UA/4.0.12.0926
  Reg. Contact : sip:203@10.0.50.83
  Qualify Freq : 60000 ms
  Keepalive    : 0 ms
  Sess-Timers  : Accept
  Sess-Refresh : uas
  Sess-Expires : 1800 secs
  Min-Sess     : 90 secs
  RTP Engine   : asterisk
  Parkinglot   : 
  Use Reason   : No
  Encryption   : No
  RTCP Mux     : No
``` 

Check voicemail stats

```
asterisk001*CLI> voicemail show users
Context    Mbox  User                      Zone       NewMsg
default    201   201                                       0
default    202   202                                       1
default    203   203                                       4
default    204   204                                       0
default    205   205                                       0
default    206   206                                       0
6 voicemail users configured.
``` 

Quit the Asterisk console.

```
asterisk001*CLI> quit
Asterisk cleanly ending (0).
Executing last minute cleanups
```

*Note:* **If you restart the Asterisk service, restart your phones or they will try to communicate with the server again without re-registering with the new instance and you will wonder why calls are not coming in, etc…** 

### TFTP Server ###

Install TFTP Server.

```
sudo pacman -S tftp-hpa
```

Setup TFTP Server with --verbose mode so you can see if the pxeboot is actually getting to it.

/etc/conf.d/tftpd
```
TFTPD_ARGS="--secure /srv/tftp/ --verbose"
```

Start the TFTP Server.

```
sudo systemctl enable tftpd
sudo systemctl start tftpd
```

Set file permissions

```
chmod 777 /srv/tftp
```

Test TFTP Server by creating a file on it and then download from it.

```
echo "hello" | tee /srv/tftp/hello.txt
```

On another system on the same network...

```
sudo pacman -S tftp-hpa
echo "get hello.txt" | tftp 10.0.50.10
tftp> get hello.txt
tftp>
cat hello.txt
hello
```

Check journal for tftp contact "--verbose" mode enables the ability to see what files are getting grabbed otherwise you will see nothing.

```
journalctl -u tftpd -f
```

Example of hello.txt file grab:

```
-- Logs begin at ... etc --
Day Time System in.tftpd[PID]: RRQ from 10.0.50.51 filename hello.txt
```

Example Polycom VoIP set file grab:

```
-- Logs begin at ... etc --
in.tftpd[72701]: WRQ from 10.0.50.14 filename 000aaaaaaaaa-app.log
in.tftpd[72702]: RRQ from 10.0.50.14 filename 000aaaaaaaaa.cfg
in.tftpd[72703]: RRQ from 10.0.50.14 filename 000000000000.cfg
in.tftpd[72704]: RRQ from 10.0.50.14 filename 2345-12670-001.sip.ld
in.tftpd[72705]: RRQ from 10.0.50.14 filename ALongTimeAgo8.wav
in.tftpd[72706]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-phone.cfg
in.tftpd[72707]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-web.cfg
in.tftpd[72708]: RRQ from 10.0.50.14 filename 000000000000-license.cfg
in.tftpd[72709]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-license.cfg
in.tftpd[72710]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-directory.xml
in.tftpd[72711]: RRQ from 10.0.50.14 filename 000000000000-directory.xml
in.tftpd[72712]: RRQ from 10.0.50.14 filename 000aaaaaaaaa.cfg
in.tftpd[72713]: RRQ from 10.0.50.14 filename 000000000000.cfg
in.tftpd[72714]: RRQ from 10.0.50.14 filename 2345-12670-001.sip.ld
in.tftpd[72715]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-phone.cfg
in.tftpd[72704]: tftpd: read(ack): Connection refused
in.tftpd[72716]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-web.cfg
in.tftpd[72717]: RRQ from 10.0.50.14 filename ALongTimeAgo8.wav
in.tftpd[72718]: RRQ from 10.0.50.14 filename 000000000000-license.cfg
in.tftpd[72719]: RRQ from 10.0.50.14 filename 000aaaaaaaaa-license.cfg
in.tftpd[72720]: WRQ from 10.0.50.14 filename 000aaaaaaaaa-boot.log
in.tftpd[72721]: WRQ from 10.0.50.14 filename 000aaaaaaaaa-app.log
in.tftpd[72705]: tftpd: read(ack): Connection refused
in.tftpd[72722]: RRQ from 10.0.50.14 filename Warble.wav
in.tftpd[72723]: RRQ from 10.0.50.14 filename SoundPointIPWelcome.wav
in.tftpd[72724]: RRQ from 10.0.50.14 filename LoudRing.wav
in.tftpd[72725]: WRQ from 10.0.50.14 filename 000aaaaaaaaa-app.log
in.tftpd[72714]: tftpd: read(ack): Connection refused
in.tftpd[72726]: RRQ from 10.0.50.14 filename Leaf.jpg
in.tftpd[72727]: RRQ from 10.0.50.14 filename LeafEM.jpg
in.tftpd[72728]: RRQ from 10.0.50.14 filename Sailboat.jpg
in.tftpd[72729]: RRQ from 10.0.50.14 filename SailboatEM.jpg
in.tftpd[72730]: RRQ from 10.0.50.14 filename Beach.jpg
in.tftpd[72731]: RRQ from 10.0.50.14 filename BeachEM.jpg
in.tftpd[72732]: RRQ from 10.0.50.14 filename Palm.jpg
in.tftpd[72733]: RRQ from 10.0.50.14 filename PalmEM.jpg
in.tftpd[72734]: RRQ from 10.0.50.14 filename Jellyfish.jpg
in.tftpd[72735]: RRQ from 10.0.50.14 filename JellyfishEM.jpg
in.tftpd[72736]: RRQ from 10.0.50.14 filename BravestWarrior.jpg
in.tftpd[72737]: RRQ from 10.0.50.14 filename MountainEM.jpg
```

Example Cisco file grab.

```
in.tftpd[73099]: RRQ from 10.0.50.15 filename CTLSEP00aaaaaaaaab.tlv
in.tftpd[73100]: RRQ from 10.0.50.15 filename ITLSEP00aaaaaaaaab.tlv
in.tftpd[73101]: RRQ from 10.0.50.15 filename ITLFile.tlv
in.tftpd[73102]: RRQ from 10.0.50.15 filename SEP00aaaaaaaaab.cnf.xml
in.tftpd[73103]: RRQ from 10.0.50.15 filename /sp-sip.jar
in.tftpd[73104]: RRQ from 10.0.50.15 filename /g3-tones.xml
in.tftpd[73105]: RRQ from 10.0.50.15 filename dialplan.xml
```

Dump your Cisco / Polycom / Etc. Phone config files onto the TFTP server /srv/tftp

Polycom set example.

https://support.polycom.com/content/support/north-america/usa/en/support/voice/soundpoint-ip/soundpoint-ip335.html


/srv/tftp/MACADDRESSOFPHONE-phone.cfg
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PHONE_CONFIG>
  <ALL
    voIpProt.server.1.address="10.0.50.10"
    voIpProt.server.1.expires="600"
    feature.urlDialing.enabled="0"
    msg.mwi.1.subscribe="203"
    msg.mwi.1.callBack="*97"
    msg.mwi.1.callBackMode="contact"
    reg.1.displayName="203 Living Room"
    reg.1.label="203"
    reg.1.address="203"
    reg.1.type="private"
    reg.1.auth.userId="203"
    reg.1.auth.password="PASSWORD"
    bg.hiRes.color.bm.6.name="BravestWarrior.jpg"
    bg.hiRes.color.selection="3,6"
    sampled_audio saf.1="" saf.2="ALongTimeAgo8.wav" saf.3="Warble.wav" saf.4="SoundPointIPWelcome.wav" saf.5="LoudRing.wav" saf.6="" saf.7="" saf.8="" saf.9="" saf.10="" saf.11="" saf.12="" saf.13="" saf.14="" saf.15="" saf.16="" saf.17="" saf.18="" saf.19="" saf.20="" saf.21="" saf.22="" saf.23="" saf.24=""
    np.normal.ringing.calls.tonePattern="ringer15"
    up.backlight.onIntensity="0"
    up.backlight.timeout="5"
    upgrade.custom.server.url="http://10.0.50.10/ucs.xml"
  />
</PHONE_CONFIG>
```

Cisco set example.

```
<?xml version="1.0" ?>
<device>
    	<deviceProtocol>SIP</deviceProtocol>
    	<sshUserId>cisco</sshUserId>
    	<sshPassword>PASSWORD</sshPassword>
    	<devicePool>
            	<dateTimeSetting>
                    	<dateTemplate>M/D/YA</dateTemplate>
                    	<timeZone>Central Standard/Daylight Time</timeZone>
                    	<ntps>
                            	<ntp>
                                    	<name>10.0.50.1</name>
                                    	<ntpMode>Unicast</ntpMode>
                            	</ntp>
                    	</ntps>
            	</dateTimeSetting>
            	<callManagerGroup>
                    	<members>
                            	<member priority="0">
                                    	<callManager>
                                            	<processNodeName>10.0.50.10</processNodeName>
                                            	<ports>
                                                    	<sipPort>5060</sipPort>
                                            	</ports>
                                    	</callManager>
                            	</member>
                    	</members>
            	</callManagerGroup>
    	</devicePool>
    	<sipProfile>
            	<natEnabled></natEnabled>
            	<natAddress></natAddress>
            	<sipProxies>
                    	<registerWithProxy>true</registerWithProxy>
                    	<outboundProxy></outboundProxy>
                    	<outboundProxyPort></outboundProxyPort>
                    	<backupProxy>10.0.50.10</backupProxy>
                    	<backupProxyPort>5060</backupProxyPort>
            	</sipProxies>
            	<preferredCodec>none</preferredCodec>
            	<phoneLabel>Basement</phoneLabel>
            	<sipLines>
                    	<line button="1">
                            	<featureID>9</featureID>
                            	<featureLabel>205</featureLabel>
                            	<proxy>10.0.50.10</proxy>
                            	<port>5060</port>
                            	<name>205</name>
                            	<authName>205</authName>
                            	<authPassword>PASSWORD</authPassword>
                            	<messageWaitingLampPolicy>1</messageWaitingLampPolicy>
                            	<messagesNumber>*97</messagesNumber>
                    	</line>
            	</sipLines>
            	<dialTemplate>dialplan.xml</dialTemplate>
    	</sipProfile>
<loadInformation></loadInformation>
<directoryURL></directoryURL>
<vendorConfig>
   <webAccess>0</webAccess>
   <sshAccess>0</sshAccess>
   <displayIdleTimeout>00:01</displayIdleTimeout>
</vendorConfig>
</device>
```

## Router Configuration ##

Edit dnsmasq.conf on Arch Linux router/firewall.

```
ssh root@10.0.50.1
```

Get GMTOffset google 2^32-10*60*60 in hex

FFFF7360 => FF:FF:73:60

/etc/dnsmasq.conf
```
# Set time server GMT offset google 2^32-10*60*60 in hex (GMT-5)
dhcp-option=enp6s0,2,FF:FF:73:60
# Set time server IP address (185.198.26.172 TORIX 3.us.pool.ntp.org)
dhcp-option=enp6s0,42,185.198.26.172
# Set TFTP Server
dhcp-option=enp6s0,66,"tftp://10.0.50.10/"
# Set VLAN
dhcp-option=enp6s0,128,"VLAN-A=500;"
# Set FTP Server
#dhcp-option=enp6s0,160,"ftp://useraccount:password@10.0.50.10"

# Log lots of extra information about DHCP transactions.
# Turn this on so we can see the dhcp-options being hit with the phone.
log-dhcp
```

On the dnsmasq Router/Firewall.

```
sudo journalctl -xe
dnsmasq-dhcp[30738]: 1698027017 available DHCP range: 10.0.50.50 -- 10.0.50.200
dnsmasq-dhcp[30738]: 1698027017 vendor class: Polycom-SPIP670
dnsmasq-dhcp[30738]: 1698027017 client provides name: Polycom_000aaaaaaaaa
dnsmasq-dhcp[30738]: 1698027017 DHCPDISCOVER(enp13s0) 00:0a:aa:aa:aa:aa
dnsmasq-dhcp[30738]: 1698027017 tags: known, enp13s0
dnsmasq-dhcp[30738]: 1698027017 DHCPOFFER(enp13s0) 10.0.50.14 00:0a:aa:aa:aa:aa
dnsmasq-dhcp[30738]: 1698027017 requested options: 1:netmask, 28:broadcast, 160, 66:tftp-server,
dnsmasq-dhcp[30738]: 1698027017 requested options: 43:vendor-encap, 3:router, 4, 42:ntp-server,
dnsmasq-dhcp[30738]: 1698027017 requested options: 2:time-offset, 6:dns-server, 15:domain-name,
dnsmasq-dhcp[30738]: 1698027017 requested options: 7:log-server
dnsmasq-dhcp[30738]: 1698027017 next server: 10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  1 option: 53 message-type  2
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 54 server-identifier  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 51 lease-time  12h
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 58 T1  6h
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 59 T2  10h30m
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  1 netmask  255.255.255.0
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 28 broadcast  10.0.50.255
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  3 router  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  6 dns-server  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size: 21 option: 66 tftp-server  tftp://10.0.50.254/
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 42 ntp-server  209.51.161.238
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  2 time-offset  ff:ff:73:60
dnsmasq-dhcp[30738]: 1698027017 available DHCP range: 10.0.50.50 -- 10.0.50.200
dnsmasq-dhcp[30738]: 1698027017 vendor class: Polycom-SPIP670
dnsmasq-dhcp[30738]: 1698027017 client provides name: Polycom_000aaaaaaaaa
dnsmasq-dhcp[30738]: 1698027017 DHCPREQUEST(enp13s0) 10.0.50.14 00:0a:aa:aa:aa:aa
dnsmasq-dhcp[30738]: 1698027017 tags: known, enp13s0
dnsmasq-dhcp[30738]: 1698027017 DHCPACK(enp13s0) 10.0.50.14 00:0a:aa:aa:aa:aa Polycom_000aaaaaaaaa
dnsmasq-dhcp[30738]: 1698027017 requested options: 1:netmask, 28:broadcast, 160, 66:tftp-server,
dnsmasq-dhcp[30738]: 1698027017 requested options: 43:vendor-encap, 3:router, 4, 42:ntp-server,
dnsmasq-dhcp[30738]: 1698027017 requested options: 2:time-offset, 6:dns-server, 15:domain-name,
dnsmasq-dhcp[30738]: 1698027017 requested options: 7:log-server
dnsmasq-dhcp[30738]: 1698027017 next server: 10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  1 option: 53 message-type  5
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 54 server-identifier  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 51 lease-time  12h
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 58 T1  6h
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 59 T2  10h30m
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  1 netmask  255.255.255.0
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 28 broadcast  10.0.50.255
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  3 router  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  6 dns-server  10.0.50.10
dnsmasq-dhcp[30738]: 1698027017 sent size: 21 option: 66 tftp-server  tftp://10.0.50.254/
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option: 42 ntp-server  209.51.161.238
dnsmasq-dhcp[30738]: 1698027017 sent size:  4 option:  2 time-offset  ff:ff:73:60
```

All the DHCP Options in dnsmasq.

```
dnsmasq -w dhcp
Known DHCP options:
  1 netmask
  2 time-offset
  3 router
  6 dns-server
  7 log-server
  9 lpr-server
 13 boot-file-size
 15 domain-name
 16 swap-server
 17 root-path
 18 extension-path
 19 ip-forward-enable
 20 non-local-source-routing
 21 policy-filter
 22 max-datagram-reassembly
 23 default-ttl
 26 mtu
 27 all-subnets-local
 31 router-discovery
 32 router-solicitation
 33 static-route
 34 trailer-encapsulation
 35 arp-timeout
 36 ethernet-encap
 37 tcp-ttl
 38 tcp-keepalive
 40 nis-domain
 41 nis-server
 42 ntp-server
 44 netbios-ns
 45 netbios-dd
 46 netbios-nodetype
 47 netbios-scope
 48 x-windows-fs
 49 x-windows-dm
 58 T1
 59 T2
 60 vendor-class
 64 nis+-domain
 65 nis+-server
 66 tftp-server
 67 bootfile-name
 68 mobile-ip-home
 69 smtp-server
 70 pop3-server
 71 nntp-server
 74 irc-server
 77 user-class
 80 rapid-commit
 93 client-arch
 94 client-interface-id
 97 client-machine-id
119 domain-search
120 sip-server
121 classless-static-route
125 vendor-id-encap
255 server-ip-address
```

Restart dnsmasq service.

```
sudo systemctl restart dnsmasq
```

Check if your phone sets register and can dial out!
