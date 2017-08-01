---
layout: post
title: Arch Linux Infrastructure - Virt-Manager - BREW + Mac
---

Guide to run virt-manager on a Mac box bare metal, instead of using X11 forwarding to a remote window of virt-manager.

# Brew + Virt-Manager #

## Download & Install ##

Install BREW.

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
==> This script will install:
/usr/local/bin/brew
/usr/local/share/doc/homebrew
/usr/local/share/man/man1/brew.1
/usr/local/share/zsh/site-functions/_brew
/usr/local/etc/bash_completion.d/brew
/usr/local/Homebrew
==> The following existing directories will be made group writable:
/usr/local/bin
/usr/local/lib
==> The following existing directories will have their owner set to jamfagent:
/usr/local/bin
/usr/local/lib
==> The following existing directories will have their group set to admin:
/usr/local/bin
==> The following new directories will be created:
/usr/local/Cellar
/usr/local/Homebrew
/usr/local/Frameworks
/usr/local/etc
/usr/local/include
/usr/local/opt
/usr/local/sbin
/usr/local/share
/usr/local/share/zsh
/usr/local/share/zsh/site-functions
/usr/local/var

Press RETURN to continue or any other key to abort
==> /usr/bin/sudo /bin/chmod u+rwx /usr/local/bin /usr/local/lib

WARNING: Improper use of the sudo command could lead to data loss
or the deletion of important system files. Please double-check your
typing when using sudo. Type "man sudo" for more information.

To proceed, enter your password, or type Ctrl-C to abort.

Password:
==> /usr/bin/sudo /bin/chmod g+rwx /usr/local/bin /usr/local/lib
==> /usr/bin/sudo /usr/sbin/chown jamfagent /usr/local/bin /usr/local/lib
==> /usr/bin/sudo /usr/bin/chgrp admin /usr/local/bin
==> /usr/bin/sudo /bin/mkdir -p /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
==> /usr/bin/sudo /bin/chmod g+rwx /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
==> /usr/bin/sudo /bin/chmod 755 /usr/local/share/zsh /usr/local/share/zsh/site-functions
==> /usr/bin/sudo /usr/sbin/chown jamfagent /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
==> /usr/bin/sudo /usr/bin/chgrp admin /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
==> /usr/bin/sudo /bin/mkdir -p /Users/jamfagent/Library/Caches/Homebrew
==> /usr/bin/sudo /bin/chmod g+rwx /Users/jamfagent/Library/Caches/Homebrew
==> /usr/bin/sudo /usr/sbin/chown jamfagent /Users/jamfagent/Library/Caches/Homebrew
==> /usr/bin/sudo /bin/mkdir -p /Library/Caches/Homebrew
==> /usr/bin/sudo /bin/chmod g+rwx /Library/Caches/Homebrew
==> /usr/bin/sudo /usr/sbin/chown jamfagent /Library/Caches/Homebrew
==> Searching online for the Command Line Tools
==> /usr/bin/sudo /usr/bin/touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
==> Installing Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2
==> /usr/bin/sudo /usr/sbin/softwareupdate -i Command\ Line\ Tools\ (macOS\ El\ Capitan\ version\ 10.11)\ for\ Xcode-8.2
Software Update Tool
Copyright 2002-2015 Apple Inc.


Downloading Command Line Tools (macOS El Capitan version 10.11) for Xcode
Downloaded Command Line Tools (macOS El Capitan version 10.11) for Xcode
Installing Command Line Tools (macOS El Capitan version 10.11) for Xcode
Done with Command Line Tools (macOS El Capitan version 10.11) for Xcode
Done.
==> /usr/bin/sudo /bin/rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
==> /usr/bin/sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
==> Downloading and installing Homebrew...
remote: Counting objects: 6840, done.
remote: Compressing objects: 100% (4090/4090), done.
remote: Total 6840 (delta 4064), reused 4502 (delta 2539), pack-reused 0
Receiving objects: 100% (6840/6840), 3.64 MiB | 1.01 MiB/s, done.
Resolving deltas: 100% (4064/4064), done.
From https://github.com/Homebrew/brew
 * [new branch]      master     -> origin/master
 * [new tag]         0.1        -> 0.1
 * [new tag]         0.2        -> 0.2
 * [new tag]         0.3        -> 0.3
 * [new tag]         0.4        -> 0.4
 * [new tag]         0.5        -> 0.5
 * [new tag]         0.6        -> 0.6
 * [new tag]         0.7        -> 0.7
 * [new tag]         0.7.1      -> 0.7.1
 * [new tag]         0.8        -> 0.8
 * [new tag]         0.8.1      -> 0.8.1
 * [new tag]         0.9        -> 0.9
 * [new tag]         0.9.1      -> 0.9.1
 * [new tag]         0.9.2      -> 0.9.2
 * [new tag]         0.9.3      -> 0.9.3
 * [new tag]         0.9.4      -> 0.9.4
 * [new tag]         0.9.5      -> 0.9.5
 * [new tag]         0.9.8      -> 0.9.8
 * [new tag]         0.9.9      -> 0.9.9
 * [new tag]         1.0.0      -> 1.0.0
 * [new tag]         1.0.1      -> 1.0.1
 * [new tag]         1.0.2      -> 1.0.2
 * [new tag]         1.0.3      -> 1.0.3
 * [new tag]         1.0.4      -> 1.0.4
 * [new tag]         1.0.5      -> 1.0.5
 * [new tag]         1.0.6      -> 1.0.6
 * [new tag]         1.0.7      -> 1.0.7
 * [new tag]         1.0.8      -> 1.0.8
 * [new tag]         1.0.9      -> 1.0.9
 * [new tag]         1.1.0      -> 1.1.0
 * [new tag]         1.1.1      -> 1.1.1
 * [new tag]         1.1.10     -> 1.1.10
 * [new tag]         1.1.11     -> 1.1.11
 * [new tag]         1.1.12     -> 1.1.12
 * [new tag]         1.1.13     -> 1.1.13
 * [new tag]         1.1.2      -> 1.1.2
 * [new tag]         1.1.3      -> 1.1.3
 * [new tag]         1.1.4      -> 1.1.4
 * [new tag]         1.1.5      -> 1.1.5
 * [new tag]         1.1.6      -> 1.1.6
 * [new tag]         1.1.7      -> 1.1.7
 * [new tag]         1.1.8      -> 1.1.8
 * [new tag]         1.1.9      -> 1.1.9
 * [new tag]         1.2.0      -> 1.2.0
 * [new tag]         1.2.1      -> 1.2.1
 * [new tag]         1.2.2      -> 1.2.2
 * [new tag]         1.2.3      -> 1.2.3
 * [new tag]         1.2.4      -> 1.2.4
 * [new tag]         1.2.5      -> 1.2.5
 * [new tag]         1.2.6      -> 1.2.6
 * [new tag]         1.3.0      -> 1.3.0
HEAD is now at 2ad03b8 Merge pull request #2990 from JCount/formula_desc_cop-x86
==> Tapping homebrew/core
Cloning into '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core'...
remote: Counting objects: 4496, done.
remote: Compressing objects: 100% (4288/4288), done.
remote: Total 4496 (delta 34), reused 464 (delta 12), pack-reused 0
Receiving objects: 100% (4496/4496), 3.57 MiB | 1.31 MiB/s, done.
Resolving deltas: 100% (34/34), done.
Tapped 4285 formulae (4,541 files, 11.1MB)
==> Cleaning up /Library/Caches/Homebrew...
==> Migrating /Library/Caches/Homebrew to /Users/jamfagent/Library/Caches/Homebr
==> Deleting /Library/Caches/Homebrew...
Already up-to-date.
==> Installation successful!

==> Homebrew has enabled anonymous aggregate user behaviour analytics.
Read the analytics documentation (and how to opt-out) here:
  http://docs.brew.sh/Analytics.html

==> Next steps:
- Run `brew help` to get started
- Further documentation: 
    http://docs.brew.sh
```

Install XQuartz

```
brew cask install xquartz
==> Tapping caskroom/cask
Cloning into '/usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask'...
remote: Counting objects: 3774, done.
remote: Compressing objects: 100% (3756/3756), done.
remote: Total 3774 (delta 36), reused 499 (delta 14), pack-reused 0
Receiving objects: 100% (3774/3774), 1.28 MiB | 2.15 MiB/s, done.
Resolving deltas: 100% (36/36), done.
Tapped 0 formulae (3,783 files, 4MB)
==> Creating Caskroom at /usr/local/Caskroom
==> We'll set permissions properly so we won't need sudo in the future
Password:
==> Satisfying dependencies
==> Downloading https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.11.dmg
######################################################################## 100.0%
==> Verifying checksum for Cask xquartz
==> Installing Cask xquartz
==> Running installer for xquartz; your password may be necessary.
==> Package installers may write to any location; options such as --appdir are i

==> installer: Package name is XQuartz 2.7.11
==> installer: Installing at base path /
==> installer: The install was successful.
🍺  xquartz was successfully installed!
```

Add Tap For virt-manager

```
brew tap nonasuomy/homebrew-virt-manager
==> Tapping nonasuomy/virt-manager
Cloning into '/usr/local/Homebrew/Library/Taps/nonasuomy/homebrew-virt-manager'...
remote: Counting objects: 9, done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 9 (delta 0), reused 1 (delta 0), pack-reused 0
Unpacking objects: 100% (9/9), done.
Tapped 6 formulae (38 files, 39.9KB)
```

Install virt-manager & virt-viewer

```
brew install virt-manager virt-viewer
==> Installing virt-manager from nonasuomy/virt-manager
==> Installing dependencies for nonasuomy/virt-manager/virt-manager: readline, sqlite, gdbm, openssl, xz, python3, intltool, pkg-config, dbus, libpng, freetype, fontconfig, pixman, gettext, libffi, pcre, glib, cairo, jpeg, libtiff, python, gobject-introspection, shared-mime-info, gdk-pixbuf, libcroco, graphite2, icu4c, harfbuzz, pango, librsvg, gnome-icon-theme, atk, libepoxy, hicolor-icon-theme, gsettings-desktop-schemas, gtk+3, libtasn1, gmp, nettle, libunistring, p11-kit, gnutls, libgpg-error, libgcrypt, gtk-vnc, check, glib-networking, vala, libsoup, libxml2, py2cairo, pygobject3, libosinfo, yajl, libvirt, libvirt-glib, libtool, spice-protocol, libusb, usbredir, spice-gtk, pcre2, vte3
==> Installing nonasuomy/virt-manager/virt-manager dependency: readline
==> Downloading https://homebrew.bintray.com/bottles/readline-7.0.3_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring readline-7.0.3_1.el_capitan.bottle.tar.gz
==> Using the sandbox
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only..

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/readline/lib
    CPPFLAGS: -I/usr/local/opt/readline/include

==> Summary
🍺  /usr/local/Cellar/readline/7.0.3_1: 46 files, 1.5MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: sqlite
==> Downloading https://homebrew.bintray.com/bottles/sqlite-3.19.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring sqlite-3.19.3.el_capitan.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS provides an older sqlite3.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"' >> ~/.bash_profile

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/sqlite/lib
    CPPFLAGS: -I/usr/local/opt/sqlite/include

==> Summary
🍺  /usr/local/Cellar/sqlite/3.19.3: 12 files, 3MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gdbm
==> Downloading https://homebrew.bintray.com/bottles/gdbm-1.13.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gdbm-1.13.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/gdbm/1.13: 19 files, 554.4KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: openssl
==> Downloading https://homebrew.bintray.com/bottles/openssl-1.0.2l.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring openssl-1.0.2l.el_capitan.bottle.tar.gz
==> Caveats
A CA file has been bootstrapped using certificates from the SystemRoots
keychain. To add additional certificates (e.g. the certificates added in
the System keychain), place .pem files in
  /usr/local/etc/openssl/certs

and run
  /usr/local/opt/openssl/bin/c_rehash

This formula is keg-only, which means it was not symlinked into /usr/local,
because Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/openssl/lib
    CPPFLAGS: -I/usr/local/opt/openssl/include

==> Summary
🍺  /usr/local/Cellar/openssl/1.0.2l: 1,709 files, 12.1MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: xz
==> Downloading https://homebrew.bintray.com/bottles/xz-5.2.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring xz-5.2.3.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/xz/5.2.3: 92 files, 1.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: python3
==> Downloading https://homebrew.bintray.com/bottles/python3-3.6.2.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring python3-3.6.2.el_capitan.bottle.tar.gz
==> /usr/local/Cellar/python3/3.6.2/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/l
==> /usr/local/Cellar/python3/3.6.2/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/l
==> /usr/local/Cellar/python3/3.6.2/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/l
==> Caveats
Pip, setuptools, and wheel have been installed. To update them
  pip3 install --upgrade pip setuptools wheel

You can install Python packages with
  pip3 install <package>

They will install into the site-package directory
  /usr/local/lib/python3.6/site-packages

See: http://docs.brew.sh/Homebrew-and-Python.html
==> Summary
🍺  /usr/local/Cellar/python3/3.6.2: 3,598 files, 55.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: intltool
==> Downloading https://homebrew.bintray.com/bottles/intltool-0.51.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring intltool-0.51.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/intltool/0.51.0: 19 files, 186.0KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: pkg-config
==> Downloading https://homebrew.bintray.com/bottles/pkg-config-0.29.2.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pkg-config-0.29.2.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/pkg-config/0.29.2: 11 files, 627KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: dbus
==> Downloading https://homebrew.bintray.com/bottles/dbus-1.10.22.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring dbus-1.10.22.el_capitan.bottle.tar.gz
==> /usr/local/Cellar/dbus/1.10.22/bin/dbus-uuidgen --ensure=/usr/local/var/lib/dbus/machine-id
==> Caveats
To have launchd start dbus now and restart at login:
  brew services start dbus
==> Summary
🍺  /usr/local/Cellar/dbus/1.10.22: 72 files, 2.0MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libpng
==> Downloading https://homebrew.bintray.com/bottles/libpng-1.6.31.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libpng-1.6.31.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libpng/1.6.31: 26 files, 1.2MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: freetype
==> Downloading https://homebrew.bintray.com/bottles/freetype-2.8.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring freetype-2.8.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/freetype/2.8: 63 files, 2.6MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: fontconfig
==> Downloading https://homebrew.bintray.com/bottles/fontconfig-2.12.4.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring fontconfig-2.12.4.el_capitan.bottle.tar.gz
==> Regenerating font cache, this may take a while
==> /usr/local/Cellar/fontconfig/2.12.4/bin/fc-cache -frv

🍺  /usr/local/Cellar/fontconfig/2.12.4: 487 files, 3.1MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: pixman
==> Downloading https://homebrew.bintray.com/bottles/pixman-0.34.0_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pixman-0.34.0_1.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/pixman/0.34.0_1: 13 files, 1.3MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gettext
==> Downloading https://homebrew.bintray.com/bottles/gettext-0.19.8.1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gettext-0.19.8.1.el_capitan.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS provides the BSD gettext library & some software gets confused if both are in the library path.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/gettext/bin:$PATH"' >> ~/.bash_profile

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/gettext/lib
    CPPFLAGS: -I/usr/local/opt/gettext/include

==> Summary
🍺  /usr/local/Cellar/gettext/0.19.8.1: 1,934 files, 16.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libffi
==> Downloading https://homebrew.bintray.com/bottles/libffi-3.2.1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libffi-3.2.1.el_capitan.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because some formulae require a newer version of libffi.

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/libffi/lib
For pkg-config to find this software you may need to set:
    PKG_CONFIG_PATH: /usr/local/opt/libffi/lib/pkgconfig

==> Summary
🍺  /usr/local/Cellar/libffi/3.2.1: 16 files, 296.9KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: pcre
==> Downloading https://homebrew.bintray.com/bottles/pcre-8.41.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pcre-8.41.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/pcre/8.41: 204 files, 5.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: glib
==> Downloading https://homebrew.bintray.com/bottles/glib-2.52.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring glib-2.52.3.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/glib/2.52.3: 430 files, 22.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: cairo
==> Downloading https://homebrew.bintray.com/bottles/cairo-1.14.10.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring cairo-1.14.10.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/cairo/1.14.10: 118 files, 5.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: jpeg
==> Downloading https://homebrew.bintray.com/bottles/jpeg-8d.el_capitan.bottle.2.tar.gz
######################################################################## 100.0%
==> Pouring jpeg-8d.el_capitan.bottle.2.tar.gz
🍺  /usr/local/Cellar/jpeg/8d: 19 files, 714.0KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libtiff
==> Downloading https://homebrew.bintray.com/bottles/libtiff-4.0.8_2.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libtiff-4.0.8_2.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libtiff/4.0.8_2: 245 files, 3.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: python
==> Downloading https://homebrew.bintray.com/bottles/python-2.7.13_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring python-2.7.13_1.el_capitan.bottle.tar.gz
==> /usr/local/Cellar/python/2.7.13_1/bin/python2 -s setup.py --no-user-cfg install --force --verbose --single-version-exte
==> /usr/local/Cellar/python/2.7.13_1/bin/python2 -s setup.py --no-user-cfg install --force --verbose --single-version-exte
==> /usr/local/Cellar/python/2.7.13_1/bin/python2 -s setup.py --no-user-cfg install --force --verbose --single-version-exte
==> Caveats
This formula installs a python2 executable to /usr/local/bin.
If you wish to have this formula's python executable in your PATH then add
the following to ~/.bash_profile:
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"

Pip and setuptools have been installed. To update them
  pip2 install --upgrade pip setuptools

You can install Python packages with
  pip2 install <package>

They will install into the site-package directory
  /usr/local/lib/python2.7/site-packages

See: http://docs.brew.sh/Homebrew-and-Python.html
==> Summary
🍺  /usr/local/Cellar/python/2.7.13_1: 3,528 files, 48MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gobject-introspection
==> Downloading https://homebrew.bintray.com/bottles/gobject-introspection-1.52.1_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gobject-introspection-1.52.1_1.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/gobject-introspection/1.52.1_1: 172 files, 9.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: shared-mime-info
==> Downloading https://homebrew.bintray.com/bottles/shared-mime-info-1.8_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring shared-mime-info-1.8_1.el_capitan.bottle.tar.gz
==> /usr/local/Cellar/shared-mime-info/1.8_1/bin/update-mime-database /usr/local/share/mime
🍺  /usr/local/Cellar/shared-mime-info/1.8_1: 83 files, 4.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gdk-pixbuf
==> Downloading https://homebrew.bintray.com/bottles/gdk-pixbuf-2.36.7.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gdk-pixbuf-2.36.7.el_capitan.bottle.tar.gz
==> /usr/local/Cellar/gdk-pixbuf/2.36.7/bin/gdk-pixbuf-query-loaders --update-cache
🍺  /usr/local/Cellar/gdk-pixbuf/2.36.7: 200 files, 4.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libcroco
==> Downloading https://homebrew.bintray.com/bottles/libcroco-0.6.12.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libcroco-0.6.12.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libcroco/0.6.12: 80 files, 1.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: graphite2
==> Downloading https://homebrew.bintray.com/bottles/graphite2-1.3.10.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring graphite2-1.3.10.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/graphite2/1.3.10: 18 files, 263.2KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: icu4c
==> Downloading https://homebrew.bintray.com/bottles/icu4c-58.2.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring icu4c-58.2.el_capitan.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS provides libicucore.dylib (but nothing else).

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/icu4c/bin:$PATH"' >> ~/.bash_profile
  echo 'export PATH="/usr/local/opt/icu4c/sbin:$PATH"' >> ~/.bash_profile

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/icu4c/lib
    CPPFLAGS: -I/usr/local/opt/icu4c/include
For pkg-config to find this software you may need to set:
    PKG_CONFIG_PATH: /usr/local/opt/icu4c/lib/pkgconfig

==> Summary
🍺  /usr/local/Cellar/icu4c/58.2: 242 files, 65MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: harfbuzz
==> Downloading https://homebrew.bintray.com/bottles/harfbuzz-1.4.7.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring harfbuzz-1.4.7.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/harfbuzz/1.4.7: 134 files, 5MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: pango
==> Downloading https://homebrew.bintray.com/bottles/pango-1.40.7.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pango-1.40.7.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/pango/1.40.7: 105 files, 4.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: librsvg
==> Downloading https://homebrew.bintray.com/bottles/librsvg-2.40.18.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring librsvg-2.40.18.el_capitan.bottle.tar.gz
==> /usr/local/opt/gdk-pixbuf/bin/gdk-pixbuf-query-loaders --update-cache
🍺  /usr/local/Cellar/librsvg/2.40.18: 51 files, 1.6MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gnome-icon-theme
==> Downloading https://homebrew.bintray.com/bottles/gnome-icon-theme-3.24.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gnome-icon-theme-3.24.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/gnome-icon-theme/3.24.0: 5,433 files, 26.0MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: atk
==> Downloading https://homebrew.bintray.com/bottles/atk-2.24.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring atk-2.24.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/atk/2.24.0: 209 files, 3.3MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libepoxy
==> Downloading https://homebrew.bintray.com/bottles/libepoxy-1.4.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libepoxy-1.4.3.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libepoxy/1.4.3: 11 files, 3.2MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: hicolor-icon-theme
==> Downloading https://homebrew.bintray.com/bottles/hicolor-icon-theme-0.15.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring hicolor-icon-theme-0.15.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/hicolor-icon-theme/0.15: 6 files, 48.5KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gsettings-desktop-schemas
==> Downloading https://homebrew.bintray.com/bottles/gsettings-desktop-schemas-3.24.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gsettings-desktop-schemas-3.24.0.el_capitan.bottle.tar.gz
==> /usr/local/opt/glib/bin/glib-compile-schemas /usr/local/share/glib-2.0/schemas
🍺  /usr/local/Cellar/gsettings-desktop-schemas/3.24.0: 93 files, 3.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gtk+3
==> Downloading https://homebrew.bintray.com/bottles/gtk+3-3.22.17.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gtk+3-3.22.17.el_capitan.bottle.tar.gz
==> /usr/local/opt/glib/bin/glib-compile-schemas /usr/local/share/glib-2.0/schemas
🍺  /usr/local/Cellar/gtk+3/3.22.17: 1,372 files, 68.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libtasn1
==> Downloading https://homebrew.bintray.com/bottles/libtasn1-4.12.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libtasn1-4.12.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libtasn1/4.12: 59 files, 440.4KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gmp
==> Downloading https://homebrew.bintray.com/bottles/gmp-6.1.2.el_capitan.bottle.1.tar.gz
######################################################################## 100.0%
==> Pouring gmp-6.1.2.el_capitan.bottle.1.tar.gz
🍺  /usr/local/Cellar/gmp/6.1.2: 18 files, 3.1MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: nettle
==> Downloading https://homebrew.bintray.com/bottles/nettle-3.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring nettle-3.3.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/nettle/3.3: 81 files, 2.0MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libunistring
==> Downloading https://homebrew.bintray.com/bottles/libunistring-0.9.7.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libunistring-0.9.7.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libunistring/0.9.7: 53 files, 4.2MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: p11-kit
==> Downloading https://homebrew.bintray.com/bottles/p11-kit-0.23.7.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring p11-kit-0.23.7.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/p11-kit/0.23.7: 62 files, 2.5MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gnutls
==> Downloading https://homebrew.bintray.com/bottles/gnutls-3.5.14.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gnutls-3.5.14.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/gnutls/3.5.14: 1,105 files, 7.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libgpg-error
==> Downloading https://homebrew.bintray.com/bottles/libgpg-error-1.27.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libgpg-error-1.27.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libgpg-error/1.27: 22 files, 559.6KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libgcrypt
==> Downloading https://homebrew.bintray.com/bottles/libgcrypt-1.8.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libgcrypt-1.8.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libgcrypt/1.8.0: 19 files, 2.8MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: gtk-vnc
==> Downloading https://homebrew.bintray.com/bottles/gtk-vnc-0.7.1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gtk-vnc-0.7.1.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/gtk-vnc/0.7.1: 83 files, 785.7KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: check
==> Downloading https://homebrew.bintray.com/bottles/check-0.11.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring check-0.11.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/check/0.11.0: 42 files, 518.4KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: glib-networking
==> Downloading https://homebrew.bintray.com/bottles/glib-networking-2.50.0.el_capitan.bottle.1.tar.gz
######################################################################## 100.0%
==> Pouring glib-networking-2.50.0.el_capitan.bottle.1.tar.gz
==> /usr/local/opt/glib/bin/gio-querymodules /usr/local/lib/gio/modules
🍺  /usr/local/Cellar/glib-networking/2.50.0: 77 files, 518.0KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: vala
==> Downloading https://homebrew.bintray.com/bottles/vala-0.36.4.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring vala-0.36.4.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/vala/0.36.4: 378 files, 11.8MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libsoup
==> Downloading https://homebrew.bintray.com/bottles/libsoup-2.58.1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libsoup-2.58.1.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libsoup/2.58.1: 200 files, 5.4MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libxml2
==> Downloading https://homebrew.bintray.com/bottles/libxml2-2.9.4_3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libxml2-2.9.4_3.el_capitan.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/libxml2/bin:$PATH"' >> ~/.bash_profile

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/libxml2/lib
    CPPFLAGS: -I/usr/local/opt/libxml2/include
For pkg-config to find this software you may need to set:
    PKG_CONFIG_PATH: /usr/local/opt/libxml2/lib/pkgconfig


If you need Python to find bindings for this keg-only formula, run:
  echo /usr/local/opt/libxml2/lib/python2.7/site-packages >> /usr/local/lib/python2.7/site-packages/libxml2.pth
  mkdir -p /Users/jamfagent/Library/Python/2.7/lib/python/site-packages
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/jamfagent/Library/Python/2.7/lib/python/site-packages/homebrew.pth
==> Summary
🍺  /usr/local/Cellar/libxml2/2.9.4_3: 281 files, 10.5MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: py2cairo
==> Downloading https://homebrew.bintray.com/bottles/py2cairo-1.10.0_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring py2cairo-1.10.0_1.el_capitan.bottle.tar.gz
==> Caveats
Python modules have been installed and Homebrew's site-packages is not
in your Python sys.path, so you will not be able to import the modules
this formula installed. If you plan to develop with these modules,
please run:
  mkdir -p /Users/jamfagent/Library/Python/2.7/lib/python/site-packages
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/jamfagent/Library/Python/2.7/lib/python/site-packages/homebrew.pth
==> Summary
🍺  /usr/local/Cellar/py2cairo/1.10.0_1: 9 files, 116.5KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: pygobject3
==> Downloading https://homebrew.bintray.com/bottles/pygobject3-3.24.1_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pygobject3-3.24.1_1.el_capitan.bottle.tar.gz
==> Caveats
Python modules have been installed and Homebrew's site-packages is not
in your Python sys.path, so you will not be able to import the modules
this formula installed. If you plan to develop with these modules,
please run:
  mkdir -p /Users/jamfagent/Library/Python/2.7/lib/python/site-packages
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/jamfagent/Library/Python/2.7/lib/python/site-packages/homebrew.pth
==> Summary
🍺  /usr/local/Cellar/pygobject3/3.24.1_1: 37 files, 1.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libosinfo
==> Downloading https://homebrew.bintray.com/bottles/libosinfo-1.0.0.el_capitan.bottle.1.tar.gz
######################################################################## 100.0%
==> Pouring libosinfo-1.0.0.el_capitan.bottle.1.tar.gz
🍺  /usr/local/Cellar/libosinfo/1.0.0: 209 files, 4.0MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: yajl
==> Downloading https://homebrew.bintray.com/bottles/yajl-2.1.0.el_capitan.bottle.4.tar.gz
######################################################################## 100.0%
==> Pouring yajl-2.1.0.el_capitan.bottle.4.tar.gz
🍺  /usr/local/Cellar/yajl/2.1.0: 17 files, 177.2KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libvirt
==> Downloading https://homebrew.bintray.com/bottles/libvirt-3.5.0.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libvirt-3.5.0.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libvirt/3.5.0: 277 files, 23.9MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: libvirt-glib
==> Downloading https://libvirt.org/sources/glib/libvirt-glib-1.0.0.tar.gz
######################################################################## 100.0%
==> Patching
patching file libvirt-gconfig/Makefile.am
Hunk #1 succeeded at 219 (offset 6 lines).
patching file libvirt-gconfig/Makefile.in
Hunk #1 succeeded at 760 (offset 13 lines).
patching file libvirt-glib/Makefile.am
patching file libvirt-glib/Makefile.in
Hunk #1 succeeded at 441 (offset 5 lines).
patching file libvirt-gobject/Makefile.am
Hunk #1 succeeded at 93 (offset 3 lines).
patching file libvirt-gobject/Makefile.in
Hunk #1 succeeded at 528 (offset 8 lines).
==> ./configure --disable-silent-rules --enable-introspection --prefix=/usr/local/Cellar/libvirt-glib/1.0.0
==> make install
🍺  /usr/local/Cellar/libvirt-glib/1.0.0: 292 files, 2.8MB, built in 43 seconds
==> Installing nonasuomy/virt-manager/virt-manager dependency: libtool
==> Downloading https://homebrew.bintray.com/bottles/libtool-2.4.6_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libtool-2.4.6_1.el_capitan.bottle.tar.gz
==> Caveats
In order to prevent conflicts with Apple's own libtool we have prepended a "g"
so, you have instead: glibtool and glibtoolize.
==> Summary
🍺  /usr/local/Cellar/libtool/2.4.6_1: 70 files, 3.7MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: spice-protocol
==> Downloading https://www.spice-space.org/download/releases/spice-protocol-0.12.12.tar.bz2
######################################################################## 100.0%
==> ./configure --disable-silent-rules --prefix=/usr/local/Cellar/spice-protocol/0.12.12
==> make install
🍺  /usr/local/Cellar/spice-protocol/0.12.12: 24 files, 99.5KB, built in 4 seconds
==> Installing nonasuomy/virt-manager/virt-manager dependency: libusb
==> Downloading https://homebrew.bintray.com/bottles/libusb-1.0.21.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libusb-1.0.21.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/libusb/1.0.21: 29 files, 510.5KB
==> Installing nonasuomy/virt-manager/virt-manager dependency: usbredir
==> Downloading https://www.spice-space.org/download/usbredir/usbredir-0.7.1.tar.bz2
######################################################################## 100.0%
==> ./configure --disable-silent-rules --prefix=/usr/local/Cellar/usbredir/0.7.1
==> make install
🍺  /usr/local/Cellar/usbredir/0.7.1: 20 files, 222.7KB, built in 10 seconds
==> Installing nonasuomy/virt-manager/virt-manager dependency: spice-gtk
==> Downloading https://www.spice-space.org/download/gtk/spice-gtk-0.31.tar.bz2
######################################################################## 100.0%
==> ./configure --disable-silent-rules --with-gtk=3.0 --enable-introspection --enable-vala --with-audio=no --with-coroutine
==> make install
🍺  /usr/local/Cellar/spice-gtk/0.31: 104 files, 3.0MB, built in 1 minute 3 seconds
==> Installing nonasuomy/virt-manager/virt-manager dependency: pcre2
==> Downloading https://homebrew.bintray.com/bottles/pcre2-10.23_1.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring pcre2-10.23_1.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/pcre2/10.23_1: 204 files, 5MB
==> Installing nonasuomy/virt-manager/virt-manager dependency: vte3
==> Downloading https://homebrew.bintray.com/bottles/vte3-0.48.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring vte3-0.48.3.el_capitan.bottle.tar.gz
🍺  /usr/local/Cellar/vte3/0.48.3: 149 files, 3.9MB
==> Installing nonasuomy/virt-manager/virt-manager
==> Downloading https://virt-manager.org/download/sources/virt-manager/virt-manager-1.4.1.tar.gz
==> Downloading from https://releases.pagure.org/virt-manager/virt-manager-1.4.1.tar.gz
######################################################################## 100.0%
==> Patching
patching file virt-clone
patching file virt-convert
patching file virt-install
patching file virt-manager
patching file virt-xml
==> Downloading https://libvirt.org/sources/python/libvirt-python-3.4.0.tar.gz
######################################################################## 100.0%
==> python -c import setuptools... --no-user-cfg install --prefix=/usr/local/Cellar/virt-manager/1.4.1/libexec/vendor --sin
==> Downloading https://pypi.io/packages/source/r/requests/requests-2.12.5.tar.gz
==> Downloading from https://pypi.python.org/packages/b6/61/7b374462d5b6b1d824977182db287758d549d8680444bad8d530195acba2/re
######################################################################## 100.0%
==> python -c import setuptools... --no-user-cfg install --prefix=/usr/local/Cellar/virt-manager/1.4.1/libexec/vendor --sin
==> Downloading https://pypi.io/packages/source/i/ipaddr/ipaddr-2.1.11.tar.gz
==> Downloading from https://pypi.python.org/packages/08/80/7539938aca4901864b7767a23eb6861fac18ef5219b60257fc938dae3568/ip
######################################################################## 100.0%
==> python -c import setuptools... --no-user-cfg install --prefix=/usr/local/Cellar/virt-manager/1.4.1/libexec/vendor --sin
==> python setup.py configure --prefix=/usr/local/Cellar/virt-manager/1.4.1/libexec
==> python setup.py --no-user-cfg --no-update-icon-cache --no-compile-schemas install --prefix=/usr/local/Cellar/virt-manag
==> /usr/local/opt/glib/bin/glib-compile-schemas /usr/local/share/glib-2.0/schemas
==> /usr/local/opt/gtk+3/bin/gtk3-update-icon-cache /usr/local/share/icons/hicolor
🍺  /usr/local/Cellar/virt-manager/1.4.1: 452 files, 11.9MB, built in 34 seconds
==> Installing virt-viewer from nonasuomy/virt-manager
==> Downloading https://virt-manager.org/download/sources/virt-viewer/virt-viewer-4.0.tar.gz
==> Downloading from https://releases.pagure.org/virt-viewer/virt-viewer-4.0.tar.gz
######################################################################## 100.0%
==> ./configure --disable-silent-rules --disable-update-mimedb --with-gtk=3.0 --prefix=/usr/local/Cellar/virt-viewer/4.0
==> make install
==> /usr/local/opt/shared-mime-info/bin/update-mime-database /usr/local/share/mime
==> /usr/local/opt/gtk+3/bin/gtk3-update-icon-cache /usr/local/share/icons/hicolor
🍺  /usr/local/Cellar/virt-viewer/4.0: 117 files, 1.4MB, built in 25 seconds
```

Edit /usr/local/bin/virt-manager and add ":/usr/local/lib/python2.7/site-packages" before " exec ".

```
#!/bin/bash
PYTHONPATH="/usr/local/opt/libxml2/lib/python2.7/site-packages:/usr/local/Cellar/virt-manager/1.4.1/libexec/vendor/lib/python2.7/site-packages:/usr/local/lib/python2.7/site-packages" exec "/usr/local/Cellar/virt-manager/1.4.1/libexec/bin/virt-manager" "$@"
```

Run virt-manager --no-fork

If you want password prompts use askpass.

Add the tap.

```
brew tap theseal/ssh-askpass
==> Tapping theseal/ssh-askpass
Cloning into '/usr/local/Homebrew/Library/Taps/theseal/homebrew-ssh-askpass'...
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 0), reused 4 (delta 0), pack-reused 0
Unpacking objects: 100% (5/5), done.
Tapped 1 formula (29 files, 22.9KB)
```

Install askpass.

```
brew install ssh-askpass
==> Installing ssh-askpass from theseal/ssh-askpass
==> Using the sandbox
==> Downloading https://github.com/theseal/ssh-askpass/archive/v1.2.1.tar.gz
==> Downloading from https://codeload.github.com/theseal/ssh-askpass/tar.gz/v1.2.1
######################################################################## 100.0%
==> Caveats
NOTE: After you have started the launchd service (read below) you need to log out and in (reboot might be easiest) before you can add keys to the agent with `ssh-add -c`.

To have launchd start theseal/ssh-askpass/ssh-askpass now and restart at login:
  brew services start theseal/ssh-askpass/ssh-askpass
==> Summary
🍺  /usr/local/Cellar/ssh-askpass/1.2.1: 5 files, 6.6KB, built in 3 seconds
```

Start virt-manager.

```
virt-manager
```

Should now prompt for a yes for adding keys and password GUI box.
