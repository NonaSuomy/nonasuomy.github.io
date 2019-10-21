---
layout: post
title: Arch Linux Infrastructure -  Part 8 - NFTables Transparent TOR Proxy / SSH / IRC
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutTOR.png "TOR")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

Part 08 - NFTables Transparent TOR Proxy / SSH / IRC - You Are Here!

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)


# SSH Gateway TOR IRC #

## 2FA SSH ##

Install SSH.

```
sudo pacman -S openssh
```

Enable timesyncd so the correct time gets synced for 2FA to work properly.

```
sudo timedatectl set-timezone Country/Zone
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd
```

/etc/ssh/sshd_config
```
ChallengeResponseAuthentication yes
```

Allow all the local VLAN IP’s access without 2FA.

/etc/security/access-local.conf
```
# Only allow from local IP range
+ : ALL : 10.0.10.0/24
+ : ALL : 10.0.20.0/24
+ : ALL : 10.0.30.0/24
+ : ALL : 10.0.40.0/24
+ : ALL : 10.0.50.0/24
+ : ALL : LOCAL
- : ALL : ALL
```

Add pam_google_authenticator to the sshd and access-local.conf.

/etc/pam.d/sshd
```
#auth 	required  pam_securetty.so 	#disable remote root
auth [success=1 default=ignore] pam_access.so accessfile=/etc/security/access-local.conf
auth required pam_google_authenticator.so
auth  	include   system-remote-login
account   include   system-remote-login
password  include   system-remote-login
session   include   system-remote-login
```

Run google-authenticator to generate challenge key.

```
google-authenticator

Do you want authentication tokens to be time-based (y/n) y

Warning: pasting the following URL into your browser exposes the OTP secret to Google:

https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/user@server001%3Fsecret%3D10101010101010101010101010%26issuer%3Dsever001



Your new secret key is: 101010101010101010101010104
Enter code from app (-1 to skip): 010101
Code confirmed
Your emergency scratch codes are:
  01010101
  01010111
  01011111
  01111111
  11111111

Do you want me to update your "/home/user/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) n

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```

Enable & Start SSH.

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

## Transparent TOR Proxy ##

Install nftables & tor

```
sudo pacman -S nftables tor torify curl httping
```

Configure TOR.

/etc/tor/torrc
```
SocksPort 9050
DNSPort 5353
TransPort 9040 IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort
AutomapHostsOnResolve 1
VirtualAddrNetworkIPv4 10.192.0.0/10
```

Enable & Start TOR

```
sudo systemctl enable tor
sudo systemctl start tor
```

Configure NFTables.

/etc/nftables.conf
```
define interface = enp1s0
define uid = 43
table ip nat {
        set unrouteables {
                type ipv4_addr
                flags interval
                elements = { 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 0.0.0.0/8, 100.64.0.0/10, 169.254.0.0/16, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 240.0.0.0/4 }
        }

        chain POSTROUTING {
                type nat hook postrouting priority 100; policy accept;
        }

        chain OUTPUT {
                type nat hook output priority -100; policy accept;
                meta l4proto tcp ip daddr 10.192.0.0/10 redirect to :9040
                meta l4proto udp ip daddr 127.0.0.1 udp dport 53 redirect to :5353
                skuid $uid return
                oifname "lo" return
                ip daddr @unrouteables return
                meta l4proto tcp redirect to :9040
        }
}
table ip filter {
        set private {
                type ipv4_addr
                flags interval
                elements = { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 127.0.0.0/8 }
        }
        chain INPUT {
                type filter hook input priority 0; policy drop;
                iifname $interface meta l4proto tcp tcp dport 22 ct state new accept
                ct state established accept
                iifname "lo" accept
                ip saddr @private accept
        }

        chain FORWARD {
                type filter hook forward priority 0; policy drop;
        }

        chain OUTPUT {
                type filter hook output priority 0; policy drop;
                ct state established accept
                oifname $interface meta l4proto tcp skuid $uid ct state new accept
                oifname "lo" accept
                ip daddr @private accept
        }
}
```

Enable & Start NFTables

```
sudo systemctl enable nftables
sudo systemctl start nftables
```

Test Tor IP ( Should not be your public IP from your ISP )

```
curl https://ipinfo.io/ip

107.155.49.126

httping facebookcorewwwi.onion

PING facebookcorewwwi.onion:80 (/):
connected to 10.223.8.73:80 (320 bytes), seq=0 time=5963.04 ms 
connected to 10.223.8.73:80 (320 bytes), seq=1 time=670.23 ms 
--- http://facebookcorewwwi.onion/ ping statistics ---
2 connects, 2 ok, 0.00% failed, time 16126ms
round-trip min/avg/max = 620.2/1407.5/5963.0 ms
```

Install tmux & irssi.

```
sudo pacman -S tmux irssi
```

Start a tmux session and name it something.

```
tmux new -s SomeName
```

To detach from tmux

```
Ctrl B D
```

To reattach to your tmux session

```
tmux a -t SomeName
```

Start irssi client.

```
irssi
```

Configure irssi.

```
(Server Window)
/window 1

/set nick YourNickname
/set alternate_nick ALTYourNickname
/set user_name YourNickname
/set real_name Your Nickname
/set dcc_autoget ON
/set dcc_download_path ~/Downloads
```

Configure basic freenode account.

```
/server freenode
/msg NickServ REGISTER YourPassword youremail@example.com
/msg NickServ IDENTIFY UserName YourPassword
/connect chat.freenode.net 6667 UserName:Password
```

Add an alternate nick to your account.

After you login with your normal account change your nick then group it.

```
/nick UserName001
/msg NickServ GROUP
```

Login with SASL

```
/network add -sasl_username <login> -sasl_password <password> -sasl_mechanism PLAIN freenode
/server add -auto -net freenode -ssl -ssl_verify chat.freenode.net 6697
/channel add -auto #archlinux freenode
/save
```

Login with TOR

TOR V3 Address for freenode instead of chat.freenode.net

After registering your nickname with freenodes nickserv you can add a key to it as well.

```
mkdir ~/.irssi/certs
cd ~/.irssi/certs/
openssl req -x509 -new -newkey rsa:4096 -sha256 -days 1000 -nodes -out freenode.pem -keyout freenode.pem
openssl x509 -in freenode.pem -outform der | sha1sum -b | cut -d' ' -f1
```

Copy the [fingerprint] that pops out and add it to the NickServ on freenode.

```
/msg NickServ CERT ADD [fingerprint]
```

List your added certs on NickServ.

```
/msg NickServ CERT LIST
```

To delete a cert send the cert del command to NickServ.

```
/msg NickServ CERT DEL <fingerprint>
```

Obviously don’t delete the cert you just added.

```
/network add -sasl_username your_freenode_nick -sasl_password your_password -sasl_mechanism EXTERNAL FreenodeTor
/server add -auto -ssl -ssl_cert ~/.irssi/certs/freenode.pem -net FreenodeTor ajnvpgl6prmkb7yktvue6im5wiedlz2w32uhcwaamdiecdrfpwwgnlqd.onion 6697
/ignore * CTCPS
/save
```

Check your user account.

/whois username

```
09:04 -!- UserName [~UserName@project/staff/UserName]
09:04 -!-  ircname  : Unknown
09:04 -!-  channels : #Netfilter
09:04 -!-  server   : zettel.freenode.net [Tor]
09:04 -!-           : is using a secure connection
09:04 -!-           : has client certificate fingerprint XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
09:04 -!-  hostname : gateway/tor-sasl/username 255.255.255.255 
09:04 -!-  idle     : 0 days 9 hours 55 mins 40 secs [signon: Sat Oct 19 22:47:50 2019]
09:04 -!-  account  : UserName
09:04 -!- End of WHOIS
```

Other IRSSI Commands.

```
/CONNECT irc.server.org - Connect to multiple servers.
/SERVER - List connected servers.
/SERVER MODIFY -network Freenode -noauto orwell.freenode.net
/SERVER REMOVE orwell.freenode.net 6667 Freenode
/DISCONNECT network - Disconnect server with tag "network".
/DISCONNECT recon-1 - Stop trying to reconnect to RECON-1 server.
/RMRECONNS - Stop all server reconnections.
/RECONNECT recon-1 - Immediately try reconnecting back to RECON-1.
/RECONNECT ALL - Immediately try reconnecting back to all servers in reconnection queue.


/SET autolog ON
```

Aspell

Plugins

```
mkdir ~/.irssi/scripts ~/.irssi/scripts/autorun
cd ~/.irssi/scripts
wget https://raw.githubusercontent.com/jwilk/irssi-spellcheck/master/spellcheck.pl
yaourt perl-text-aspell
cd ~/.irssi/scripts/autorun
ln -s ../spellcheck.pl
```

Launch irssi

```
irssi
/script load ~/.irssi/scripts/autorun/spellcheck.pl
```

23:07 -!- Irssi: Loaded script 
          spellcheck

Troubleshooting

.irssi/scripts/autorun/spellcheck.pl line 19.

You don’t have the perl aspell library installed.

```
mkdir ~/code
cd ~/code
git clone https://aur.archlinux.org/perl-text-aspell.git
cd perl-text-aspell
sudo makepkg -si
```

Corrections in a split window.

As an experimental feature, it is possible to display corrections in a separate split window:

Name of the window.

```
/set spellcheck_window_name spellchecker
```

Height of the window.

```
spellcheck_window_height 5
```

Create the spellchecker window.

```
/WINDOW NEW SPLIT
/WINDOW NAME spellchecker
/WINDOW STICK OFF
/WINDOW HIDE
```

Other irssi stuff

```
/set autolog on
/set scrollback_lines 0
/set scrollback_time 7days
/set max_command_history 9999
```

Nick Highlight

```
/HILIGHT
/HILIGHT mike
/HILIGHT -regexp mi+ke+
/HILIGHT -mask -color %G bob!*@*.irssi.org
/HILIGHT -full -color %G -actcolor %Y redbull
```

Highlight your nick no matter where it shows in the text line.

```
/set hilight_nick_matches_everywhere on
```

Highlight full line in red.

~/.irssi/default.theme
```
pubmsgmenick = "{msgnick $0 $1-}%R";
menick = "%R$*%n";
```

Turn on terminal beeps.

```
/set bell_beeps ON
/set beep_msg_level MSGS NOTICES DCC DCCMSGS HILIGHT
```
Continue to [Part 09 - Underconstruction](../Infrastructure-Part-9)
