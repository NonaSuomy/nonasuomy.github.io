---
layout: post
title: Arch Linux Infrastructure - Brouter Inception - Part 3.1 - WebVirtCloud
---

![alt text]({{ site.baseurl }}../images/infrastructure/HOTInfrastructureLayoutVM.png "Infrastructure WebGUI")

# Index #

[Part 01 - Network Switch VLANs](../Infrastructure-Part-1)

[Part 02 - Hypervisor OS Install](../Infrastructure-Part-2)

[Part 03 - Hypervisor OS Setup](../Infrastructure-Part-3)

Part 03.1 - Hypervisor WebVirtCloud You Are Here!

[Part 04 - Virtual Router](../Infrastructure-Part-4)

[Part 05 - VoIP Server](../Infrastructure-Part-5)

[Part 06 - Automation Server](../Infrastructure-Part-6)

[Part 07 - NAS](../Infrastructure-Part-7)

[Part 08 - Underconstruction](../Infrastructure-Part-8)

[Part 09 - Underconstruction](../Infrastructure-Part-9)

[Part 10 - Underconstruction](../Infrastructure-Part-10)

# WebVirtCloud #

WebVirtCloud is a virtualization web interface for admins and users. It can delegate Virtual Machine's to users.  noVNC viewer presents a full graphical console to the guest domain.  KVM is currently the only hypervisor supported.

### Install WebVirtCloud Panel (Arch Linux) ###

```bash
sudo pacman -Sy base-devel git python-virtualenv python libxml2 libvirt zlib nginx supervisor libsasl gcc pkg-config
cd
mkdir code
cd code
git clone https://github.com/retspen/webvirtcloud
cd webvirtcloud
sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/sites-available
sudo cp conf/supervisor/webvirtcloud.conf /etc/supervisor.d/
sudo cp conf/nginx/webvirtcloud.conf /etc/nginx/sites-enabled/
cd ..
sudo mv webvirtcloud /srv
cd /srv/webvirtcloud
sudo virtualenv venv --python=python2.7
source venv/bin/activate
```

Edit requirements.txt

```bash
sudo nano conf/requirements.txt
```

Comment out the version on libvirt-python

```
libvirt-python #==1.3.2
```

Carry on...

```bash
sudo pip install -r conf/requirements.txt 
sudo python manage.py migrate
sudo chown -R http:http /srv/webvirtcloud
```

**Real Virtual Example**

```
[user@hypervisor ~]$  sudo pacman -Sy base-devel git python-virtualenv python libxml2 libvirt zlib nginx supervisor libsasl gcc pkg-config
:: Synchronizing package databases...
 core is up to date
 extra                   1660.4 KiB   941K/s 00:02 [----------------------] 100%
 community                  3.9 MiB  1990K/s 00:02 [----------------------] 100%
 multilib                 172.5 KiB  9.91M/s 00:00 [----------------------] 100%
 archlinuxfr is up to date
:: There are 25 members in group base-devel:
:: Repository core
   1) autoconf  2) automake  3) binutils  4) bison  5) fakeroot  6) file
   7) findutils  8) flex  9) gawk  10) gcc  11) gettext  12) grep  13) groff
   14) gzip  15) libtool  16) m4  17) make  18) pacman  19) patch
   20) pkg-config  21) sed  22) sudo  23) texinfo  24) util-linux  25) which

Enter a selection (default=all):

resolving dependencies...
looking for conflicting packages...

Packages (38) geoip-1.6.10-1  geoip-database-20170704-1  perl-error-0.17024-2
              python2-meld3-1.0.2-1  autoconf-2.69-4  automake-1.15.1-1
              binutils-2.28.0-4  bison-3.0.4-3  fakeroot-1.21-2  file-5.31-1
              findutils-4.6.0-2  flex-2.6.4-1  gawk-4.1.4-2  gcc-7.1.1-4
              gettext-0.19.8.1-2  git-2.13.4-1  grep-3.1-1  groff-1.22.3-7
              gzip-1.8-2  libsasl-2.1.26-11  libtool-2.4.6-8  libvirt-3.6.0-1
              libxml2-2.9.4+96+gfb56f80e-1  m4-1.4.18-1  make-4.2.1-2
              nginx-1.12.1-1  pacman-5.0.2-2  patch-2.7.5-1
              pkg-config-0.29.2-1  python-3.6.2-1  python-virtualenv-15.1.0-1
              sed-4.4-1  sudo-1.8.20.p2-1  supervisor-3.3.2-1  texinfo-6.4-1
              util-linux-2.30.1-2  which-2.21-2  zlib-1:1.2.11-2

Total Download Size:    17.99 MiB
Total Installed Size:  434.16 MiB
Net Upgrade Size:       44.71 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 util-linux-2.30.1-2...  1975.9 KiB  1490K/s 00:01 [----------------------]  10%
 perl-error-0.17024-...  1994.0 KiB  1301K/s 00:02 [----------------------]  10%
 git-2.13.4-1-x86_64        7.1 MiB  1946K/s 00:04 [----------------------]  39%
 python-virtualenv-1...     8.7 MiB  1881K/s 00:05 [----------------------]  48%
 geoip-database-2017...     9.8 MiB  1862K/s 00:05 [----------------------]  54%
 geoip-1.6.10-1-x86_64      9.8 MiB  1803K/s 00:06 [----------------------]  54%
 nginx-1.12.1-1-x86_64     10.3 MiB  1766K/s 00:06 [----------------------]  57%
 libvirt-3.6.0-1-x86_64    17.6 MiB  1930K/s 00:09 [----------------------]  97%
 python2-meld3-1.0.2...    17.6 MiB  1888K/s 00:10 [----------------------]  97%
 supervisor-3.3.2-1-any    18.0 MiB  1863K/s 00:10 [----------------------] 100%
(38/38) checking keys in keyring                   [----------------------] 100%
(38/38) checking package integrity                 [----------------------] 100%
(38/38) loading package files                      [----------------------] 100%
(38/38) checking for file conflicts                [----------------------] 100%
(38/38) checking available disk space              [----------------------] 100%
:: Processing package changes...
( 1/38) reinstalling gawk                          [----------------------] 100%
( 2/38) reinstalling m4                            [----------------------] 100%
( 3/38) reinstalling autoconf                      [----------------------] 100%
( 4/38) reinstalling automake                      [----------------------] 100%
( 5/38) reinstalling zlib                          [----------------------] 100%
( 6/38) reinstalling binutils                      [----------------------] 100%
( 7/38) reinstalling bison                         [----------------------] 100%
( 8/38) reinstalling sed                           [----------------------] 100%
( 9/38) reinstalling libsasl                       [----------------------] 100%
(10/38) upgrading util-linux                       [----------------------] 100%
(11/38) reinstalling fakeroot                      [----------------------] 100%
(12/38) reinstalling file                          [----------------------] 100%
(13/38) reinstalling findutils                     [----------------------] 100%
(14/38) reinstalling flex                          [----------------------] 100%
(15/38) reinstalling gcc                           [----------------------] 100%
(16/38) reinstalling gettext                       [----------------------] 100%
(17/38) reinstalling grep                          [----------------------] 100%
(18/38) reinstalling groff                         [----------------------] 100%
(19/38) reinstalling gzip                          [----------------------] 100%
(20/38) reinstalling libtool                       [----------------------] 100%
(21/38) reinstalling texinfo                       [----------------------] 100%
(22/38) reinstalling make                          [----------------------] 100%
(23/38) reinstalling pacman                        [----------------------] 100%
(24/38) reinstalling patch                         [----------------------] 100%
(25/38) reinstalling pkg-config                    [----------------------] 100%
(26/38) reinstalling sudo                          [----------------------] 100%
(27/38) reinstalling which                         [----------------------] 100%
(28/38) installing perl-error                      [----------------------] 100%
(29/38) installing git                             [----------------------] 100%
Optional dependencies for git
    tk: gitk and git gui
    perl-libwww: git svn
    perl-term-readkey: git svn
    perl-mime-tools: git send-email
    perl-net-smtp-ssl: git send-email TLS support
    perl-authen-sasl: git send-email TLS support
    perl-mediawiki-api: git mediawiki support
    perl-datetime-format-iso8601: git mediawiki support
    perl-lwp-protocol-https: git mediawiki https support
    python2: various helper scripts [installed]
    subversion: git svn
    cvsps2: git cvsimport
    gnome-keyring: GNOME keyring credential helper
(30/38) reinstalling python                        [----------------------] 100%
(31/38) installing python-virtualenv               [----------------------] 100%
(32/38) reinstalling libxml2                       [----------------------] 100%
(33/38) upgrading libvirt                          [----------------------] 100%
(34/38) installing geoip-database                  [----------------------] 100%
(35/38) installing geoip                           [----------------------] 100%
Optional dependencies for geoip
    geoip-database-extra: city/ASN databases (not needed for country lookups)
(36/38) installing nginx                           [----------------------] 100%
(37/38) installing python2-meld3                   [----------------------] 100%
(38/38) installing supervisor                      [----------------------] 100%
:: Running post-transaction hooks...
(1/4) Updating system user accounts...
(2/4) Creating temporary files...
(3/4) Arming ConditionNeedsUpdate...
(4/4) Updating the info directory file...
[user@hypervisor ~]$ mkdir code
[user@hypervisor code]$ git clone https://github.com/retspen/webvirtcloud
Cloning into 'webvirtcloud'...
remote: Counting objects: 2071, done.
remote: Total 2071 (delta 0), reused 0 (delta 0), pack-reused 2071
Receiving objects: 100% (2071/2071), 1.92 MiB | 3.79 MiB/s, done.
Resolving deltas: 100% (1371/1371), done.
[user@hypervisor code]$ cd webvirtcloud/
[user@hypervisor webvirtcloud]$ sudo mkdir /etc/nginx/sites-enabled
[user@hypervisor webvirtcloud]$ sudo mkdir /etc/nginx/sites-available
[user@hypervisor webvirtcloud]$ sudo cp conf/supervisor/webvirtcloud.conf /etc/supervisor.d
[user@hypervisor webvirtcloud]$ sudo cp conf/nginx/webvirtcloud.conf /etc/nginx/sites-enabled/
[user@hypervisor webvirtcloud]$ cd ..
[user@hypervisor code]$ sudo cp -R webvirtcloud /srv
[user@hypervisor code]$ cd /srv/webvirtcloud
[user@hypervisor webvirtcloud]$ sudo virtualenv venv --python=python2.7
Running virtualenv with interpreter /usr/bin/python2.7
New python executable in /srv/webvirtcloud/venv/bin/python2.7
Also creating executable in /srv/webvirtcloud/venv/bin/python
Installing setuptools, pip, wheel...done.
[user@hypervisor webvirtcloud]$ source venv/bin/activate
(venv) [user@hypervisor webvirtcloud]$ sudo pip install -r conf/requirements.txt
Collecting Django==1.8.11 (from -r conf/requirements.txt (line 1))
  Downloading Django-1.8.11-py2.py3-none-any.whl (6.2MB)
    100% |████████████████████████████████| 6.2MB 166kB/s
Collecting websockify==0.8.0 (from -r conf/requirements.txt (line 2))
  Downloading websockify-0.8.0.tar.gz (234kB)
    100% |████████████████████████████████| 235kB 1.7MB/s
Collecting gunicorn==19.3.0 (from -r conf/requirements.txt (line 3))
  Downloading gunicorn-19.3.0-py2.py3-none-any.whl (110kB)
    100% |████████████████████████████████| 112kB 2.9MB/s
Collecting libvirt-python==1.3.2 (from -r conf/requirements.txt (line 4))
  Downloading libvirt-python-1.3.2.tar.gz (171kB)
    100% |████████████████████████████████| 174kB 2.2MB/s
Collecting libxml2-python from http://git.gnome.org/browse/libxml2/snapshot/libxml2-2.9.1.tar.gz#egg=libxml2-python&subdirectory=python (from -r conf/requiremen        ts.txt (line 6))
  Downloading http://git.gnome.org/browse/libxml2/snapshot/libxml2-2.9.1.tar.gz
     | 5.8MB 16.7MB/s
Collecting numpy (from websockify==0.8.0->-r conf/requirements.txt (line 2))
  Downloading numpy-1.13.1-cp27-cp27mu-manylinux1_x86_64.whl (16.6MB)
    100% |████████████████████████████████| 16.6MB 64kB/s
Collecting libvirt-python (from -r conf/requirements.txt (line 4))
  Downloading libvirt-python-3.5.0.tar.gz (181kB)
    100% |████████████████████████████████| 184kB 1.3MB/s
Building wheels for collected packages: websockify, libvirt-python, libxml2-python
  Running setup.py bdist_wheel for websockify ... done
  Stored in directory: /root/.cache/pip/wheels/key
  Running setup.py clean for libvirt-python
  Running setup.py bdist_wheel for libxml2-python ... done
  Stored in directory: /root/.cache/pip/wheels/9d/6a/30/key
Successfully built websockify libxml2-python
Failed to build libvirt-python
Installing collected packages: Django, numpy, websockify, gunicorn, libvirt-python, libxml2-python
Building wheels for collected packages: libvirt-python
  Running setup.py bdist_wheel for libvirt-python ... done
  Stored in directory: /root/.cache/pip/wheels/key
Successfully built libvirt-python
Installing collected packages: libvirt-python, libxml2-python
Successfully installed libvirt-python-3.5.0 libxml2-python-2.9.1
(venv) [user@hypervisor webvirtcloud]$ sudo python manage.py migrate
Operations to perform:
  Synchronize unmigrated apps: staticfiles, messages
  Apply all migrations: logs, sessions, admin, create, contenttypes, auth, instances, computes, accounts
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
  Installing custom SQL...
Running migrations:
  Rendering model states... DONE
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying computes.0001_initial... OK
  Applying instances.0001_initial... OK
  Applying accounts.0001_initial... OK
  Applying accounts.0002_auto_20150325_0846... OK
  Applying accounts.0003_usersshkey... OK
  Applying accounts.0004_userattributes... OK
  Applying accounts.0005_userattributes_can_clone_instances... OK
  Applying accounts.0006_userattributes_max_disk_size... OK
  Applying accounts.0007_auto_20160426_0635... OK
  Applying accounts.0004_userinstance_is_vnc... OK
  Applying accounts.0008_merge... OK
  Applying admin.0001_initial... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying computes.0002_compute_details... OK
  Applying create.0001_initial... OK
  Applying create.0002_auto_20150325_0921... OK
  Applying instances.0002_instance_is_template... OK
  Applying logs.0001_initial... OK
  Applying logs.0002_auto_20150316_1420... OK
  Applying logs.0003_auto_20150518_1855... OK
  Applying sessions.0001_initial... OK
(venv) [user@hypervisor webvirtcloud]$ sudo chown -R http:http /srv/webvirtcloud
[sudo] password for user:
```

**Note:** *sudo pip install -r conf/requiements.txt will fail on python-libvirt if you don't try to install a different version...*

### Configure The Supervisor ###

```bash
sudo nano /etc/supervisord.conf
```

At the end of the file under the [Included] section add ```files = /etc/supervisor.d/*.ini /etc/supervisor.d/*.conf```

```
; Sample supervisor config file.

[unix_http_server]
file=/run/supervisor.sock   ; (the path to the socket file)
;chmod=0700                 ; socked file mode (default 0700)
;chown=nobody:nogroup       ; socket file uid:gid owner
;username=user              ; (default is no username (open server))
;password=123               ; (default is no password (open server))

[inet_http_server]         ; inet (TCP) server disabled by default
port=127.0.0.1:9001        ; (ip_address:port specifier, *:port for all iface)
;username=user              ; (default is no username (open server))
;password=123               ; (default is no password (open server))

[supervisord]
logfile=/var/log/supervisord.log ; (main log file;default $CWD/supervisord.log)
;logfile_maxbytes=50MB       ; (max main logfile bytes b4 rotation;default 50MB)
;logfile_backups=10          ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
;minfds=1024                 ; (min. avail startup file descriptors;default 1024)
;minprocs=200                ; (min. avail process descriptors;default 200)
;umask=022                   ; (process file creation umask;default 022)
;user=chrism                 ; (default is current user, required if root)
;identifier=supervisor       ; (supervisord identifier, default is 'supervisor')
;directory=/tmp              ; (default is not to cd during start)
;nocleanup=true              ; (don't clean up tempfiles at start;default false)
childlogdir=/var/log/supervisor ; ('AUTO' child log dir, default $TEMP)
;environment=KEY=value       ; (key value pairs to add to environment)
;strip_ansi=false            ; (strip ansi escape codes in logs; def. false)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///run/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
;username=chris              ; should be same as http_username if set
;password=123                ; should be same as http_password if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")
;history_file=~/.sc_history  ; use readline history if available

; The below sample program section shows all possible program subsection values,
; create one or more 'real' program: sections to be able to control them under
; supervisor.

;[program:theprogramname]
;command=/bin/cat              ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
;directory=/tmp                ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=999                  ; the relative start priority (default 999)
;autostart=true                ; start at supervisord start (default: true)
;autorestart=unexpected        ; whether/when to restart (default: unexpected)
;startsecs=1                   ; number of secs prog must stay running (def. 1)
;startretries=3                ; max # of serial start failures (default 3)
;exitcodes=0,2                 ; 'expected' exit codes for process (default 0,2)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;killasgroup=false             ; SIGKILL the UNIX process group (def false)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=true          ; redirect proc stderr to stdout (default false)
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
;stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A=1,B=2           ; process environment additions (def no adds)
;serverurl=AUTO                ; override serverurl computation (childutils)

; The below sample eventlistener section shows all possible
; eventlistener subsection values, create one or more 'real'
; eventlistener: sections to be able to handle event notifications
; sent by supervisor.

;[eventlistener:theeventlistenername]
;command=/bin/eventlistener    ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
;events=EVENT                  ; event notif. types to subscribe to (req'd)
;buffer_size=10                ; event buffer queue size (default 10)
;directory=/tmp                ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=-1                   ; the relative start priority (default -1)
;autostart=true                ; start at supervisord start (default: true)
;autorestart=unexpected        ; whether/when to restart (default: unexpected)
;startsecs=1                   ; number of secs prog must stay running (def. 1)
;startretries=3                ; max # of serial start failures (default 3)
;exitcodes=0,2                 ; 'expected' exit codes for process (default 0,2)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;killasgroup=false             ; SIGKILL the UNIX process group (def false)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=true          ; redirect proc stderr to stdout (default false)
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups        ; # of stderr logfile backups (default 10)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A=1,B=2           ; process environment additions
;serverurl=AUTO                ; override serverurl computation (childutils)

; The below sample group section shows all possible group values,
; create one or more 'real' group: sections to create "heterogeneous"
; process groups.

;[group:thegroupname]
;programs=progname1,progname2  ; each refers to 'x' in [program:x] definitions
;priority=999                  ; the relative start priority (default 999)

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = /etc/supervisor.d/*.ini /etc/supervisor.d/*.conf

```

```bash
sudo nano /etc/supervisor.d/webvirtcloud.conf
```

Change user from www:data to http.

```
[program:webvirtcloud]
command=/srv/webvirtcloud/venv/bin/gunicorn webvirtcloud.wsgi:application -c /srv/webvirtcloud/gunicorn.conf.py
directory=/srv/webvirtcloud
user=http
autostart=true
autorestart=true
redirect_stderr=true

[program:novncd]
command=/srv/webvirtcloud/venv/bin/python /srv/webvirtcloud/console/novncd
directory=/srv/webvirtcloud
user=http
autostart=true
autorestart=true
redirect_stderr=true
```

```bash
sudo wget -O - https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/daemon/gstfsd | sudo tee -a /usr/local/bin/gstfsd
sudo wget https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/supervisor/gstfsd.conf -P /etc/supervisor.d/
```

```
--2017-08-03 12:50:24--  https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/supervisor/gstfsd.conf
Loaded CA certificate '/etc/ssl/certs/ca-certificates.crt'
Resolving raw.githubusercontent.com... 151.101.136.133
Connecting to raw.githubusercontent.com|151.101.136.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 150 [text/plain]
Saving to: ‘/etc/supervisord.d/gstfsd.conf’

gstfsd.conf           100%[=========================>]     150  --.-KB/s    in 0s

2017-08-03 12:50:26 (75.8 MB/s) - ‘/etc/supervisor.d/gstfsd.conf’ saved [150/150]
```

```
sudo nano /etc/supervisor.d/gstfsd.conf
```

Change ```command=/usr/bin/python /usr/local/bin/gstfsd``` to ```command=/srv/webvirtcloud/venv/bin/python /usr/local/bin/gstfsd```

```
[program:gstfsd]
command=/srv/webvirtcloud/venv/bin/python /usr/local/bin/gstfsd
directory=/usr/local/bin
user=root
autostart=true
autorestart=true
redirect_stderr=true
```

Edit the nginx.conf file

You will need to edit the main nginx.conf file as the one that comes from the rpm's will not work. Comment the following lines and add the sites-enabled at the end of the http section:

```
sudo nano /etc/nginx/nginx.conf
```

```
#user html;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/sites-enabled/*.conf;

#    server {
#        listen       80;
#        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

#        location / {
#            root   /usr/share/nginx/html;
#            index  index.html index.htm;
#        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
#        error_page   500 502 503 504  /50x.html;
#        location = /50x.html {
#            root   /usr/share/nginx/html;
#        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
#    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}
```

Also make sure file in /etc/nginx/sites-enabled/webvirtcloud.conf has the proper paths:

```
sudo nano /etc/nginx/sites-enabled/webvirtcloud.conf
```

Uncomment both lines at the top of file and change the server_name to localhost:

```
    server_name localhost;
    access_log /var/log/nginx/webvirtcloud-access_log; 
```

**Full File**

```
server {
    listen 80;

    server_name localhost;
    access_log /var/log/nginx/webvirtcloud-access_log; 

    location /static/ {
        root /srv/webvirtcloud;
        expires max;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Forwarded-Proto $remote_addr;
        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_send_timeout 600;
        client_max_body_size 1024M;
    }
}
```

### Install libguestfs ###

**Note:** *This takes a while to install...*

```
yaourt libguestfs --noconfirm
```

Enable & start services for running WebVirtCloud:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

sudo systemctl enable supervisord
sudo systemctl start supervisord
sudo systemctl status supervisord
```

And finally, check everything is running:

```bash
sudo supervisorctl status

gstfsd                           RUNNING    pid 24187, uptime 0:00:03
novncd                           RUNNING    pid 24186, uptime 0:00:03
webvirtcloud                     RUNNING    pid 24185, uptime 0:00:03

```

Done!!

Go to http://hypervisorip and you should see the login screen.

### Default credentials ###

<pre>
login: admin
password: admin
</pre>

# For new versions of webvirtmgr

1. Create SSH private key and ssh config options (On system where WebVirtMgr is installed):

   `$ sudo su - http -s /bin/bash`
    
   `(nginx default user might be different than "nginx", "www-data" or "http" might be used : check nginx.conf)`

   `exit`
   
   `sudo chown -R http:http /srv/http`
   
   `$ sudo su - http -s /bin/bash`
   
   `$ ssh-keygen`

   `Generating public/private rsa key pair.`

    `Enter file in which to save the key (path-to-id-rsa-in-nginx-home):` _Just hit Enter here!_

```
Created directory '/srv/http/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /srv/http/.ssh/id_rsa.
Your public key has been saved in /srv/http/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:hash http@hypervisor
The key's randomart image is:
+---[RSA 2048]----+
|                 |
+----[SHA256]-----+
```

    `$ touch ~/.ssh/config && echo -e "StrictHostKeyChecking=no\nUserKnownHostsFile=/dev/null" >> ~/.ssh/config`
    
    `$ chmod 0600 ~/.ssh/config`

    `$ exit`
    
2. Add webvirt user (on qemu-kvm/libvirt host server) and add it to the proper group :

Add required user to the kvm & libvirt group:

```bash
sudo useradd -M -G kvm,libvirt -d /home/webvirtmgr -r webvirtmgr
```

```
sudo passwd webvirtmgr
New password:
Retype new password:
passwd: password updated successfully
```

3. Back to webvirtmgr host and copy public key to qemu-kvm/libvirt host server:

    `$ sudo su - http -s /bin/bash`

    `$ ssh-copy-id webvirtmgr@localhost`

```
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/srv/http/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
webvirtmgr@localhost's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'webvirtmgr@localhost'"
and check to make sure that only the key(s) you wanted were added.
```

    Or if you changed the default SSH port use:

    `$ ssh-copy-id -P YOUR_SSH_PORT webvirtmgr@qemu-kvm-libvirt-host`

Now you can test the connection by entering:

```
[http@hypervisor ~]$ ssh webvirtmgr@localhost
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
Last login: Thu Aug  3 16:04:25 2017 from yourip
[webvirtmgr@hypervisor ~]$ exit
[http@hypervisor ~]$ exit
```

For a non-standard SSH port use:

    $ ssh -P YOUR_SSH_PORT webvirtmgr@localhost

You should connect without entering a password.

4. Set up permissions to manage libvirt (on qemu-kvm/libvirt host server):

**Archlinux:** We already did this with our useradd command above...

It should now be possible to log in to WebVirtCloud with an ssh user.

http://hypervisorip

Click Computes.

Click +.

```
Add Connection

  Click SSH Connections tab.

Label: hypervisor001
FQDN / IP: localhost
Username: webvirtmgr
```

Click Add.

```
Computes
hq
Status: Connected
No details available
```

Success!

Click Instances.

You should see all your VM listed w00t!

Click + to add some VM's.

### How To Update ###

```bash
cd /srv/webvirtcloud
git pull
python manage.py migrate
sudo service supervisor restart
```

### How To Update gstfsd ###

How to update <code>gstfsd</code> daemon on hypervisor:

```bash
wget -O - https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/daemon/gstfsd | sudo tee -a /usr/local/bin/gstfsd
sudo systemctl restart supervisord
```

### License ###

WebVirtCloud is licensed under the [Apache Licence, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).


**Underconstruction...**


NOT COMPLETE YET FROM HERE DOWN!!!!!!!!!!!!!!!!!!!!!!!!!!!

Not really sure just yet of what to do with these items below as they fail in Arch.

Change permission for selinux:

```
yaourt selinux ??
```

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/webvirtcloud(/.*)"
```

#### Apache mod_wsgi configuration ####

```
sudo pacman -Sy mod_wsgi2  ??
```

```
WSGIDaemonProcess webvirtcloud threads=2 maximum-requests=1000 display-name=webvirtcloud
WSGIScriptAlias / /srv/webvirtcloud/webvirtcloud/wsgi.py
```

#### Install final required packages for libvirtd and others on Host Server ####

```
sudo pacman -Sy libvirtd qemu virt-manager
```

```bash
wget -O - https://raw.githubusercontent.com/retspen/webvirtcloud/master/dev/libvirt-bootstrap.sh | sudo sh
```
