```
https://termux.com/
https://play.google.com/store/apps/details?id=com.termux
apt update
apt upgrade
apt install rsync
apt install termux-api
apt install jq

https://github.com/termux/termux-api-package/tree/master/script
https://github.com/termux/termux-app/issues/61
https://github.com/st42/termux-sudo

termux-battery-status | jq .plugged
termux-wifi-connectioninfo | jq .ssid

ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/data/data/com.termux/files/home/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /data/data/com.termux/files/home/.ssh/id_rsa.
Your public key has been saved in /data/data/com.termux/files/home/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:hash root@nasip
The key's randomart image is:
+---[RSA 2048]----+
|                 |
+----[SHA256]-----+

ssh-copy-id root@nasip
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/data/data/com.termux/files/home/.ssh/id_rsa.pub"
The authenticity of host 'nasip (nasip)' can't be established.
ECDSA key fingerprint is SHA256:key.
Are you sure you want to continue connecting (yes/no)? yes
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
expr: warning: '^ERROR: ': using '^' as the first character
of a basic regular expression is not portable; it is ignored
/data/data/com.termux/files/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@freenas's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@nasip'"
and check to make sure that only the key(s)you wanted were added.

$ ssh root@nasip
Last login: Sat Jul 22 22:49:15 2017 from 10.13.37.167
FreeBSD 11.0-STABLE (FreeNAS.amd64) #0 r313908+b3722b04944(freenas/11.0-stable): Sat Jul  1 02:44:49 UTC 2017

        FreeNAS (c) 2009-2017, The FreeNAS Development Team
        All rights reserved.
        FreeNAS is released under the modified BSD license.

        For more information, documentation, help or support, go here:
        http://freenas.org
Welcome to FreeNAS
root@nasip:~ # exit
logout
Connection to nasip closed.


```
