# Firejail

Firejail is a SUID sandbox program that reduces the risk of security breaches by restricting
the running environment of untrusted applications using Linux namespaces, seccomp-bpf
and Linux capabilities. It allows a process and all its descendants to have their own private
view of the globally shared kernel resources, such as the network stack, process table, mount table.
Firejail can work in a SELinux or AppArmor environment, and it is integrated with Linux Control Groups.

Written in C with virtually no dependencies, the software runs on any Linux computer with a 3.x kernel
version or newer. It can sandbox any type of processes: servers, graphical applications, and even
user login sessions. The software includes sandbox profiles for a number of more common Linux programs,
such as Mozilla Firefox, Chromium, VLC, Transmission etc.

The sandbox is lightweight, the overhead is low. There are no complicated configuration files to edit,
no socket connections open, no daemons running in the background. All security features are
implemented directly in Linux kernel and available on any Linux computer. To start the sandbox,
prefix your command with “firejail”:

`````
$ firejail firefox            # starting Mozilla Firefox
$ firejail transmission-gtk   # starting Transmission BitTorrent 
$ firejail vlc                # starting VideoLAN Client
$ sudo firejail /etc/init.d/nginx start
`````
Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://firejail.wordpress.com/support/frequently-asked-questions/
`````

`````
# Current development version: 0.9.42~rc2

Version 0.9.41~rc1 was released.

## Bringing back --private-home

## Deprecated --user

--user option was deprecated, please use "sudo -u username firejail application" instead.

## --whitelist rework

Symlinks outside user home directories are allowed:
`````
      --whitelist=dirname_or_filename
              Whitelist directory or file. This feature  is  implemented  only
              for  user  home, /dev, /media, /opt, /var, and /tmp directories.
              With the exception of user home, both the link and the real file
              should  be  in  the same top directory. For /home, both the link
              and the real file should be owned by the user.

              Example:
              $ firejail --noprofile --whitelist=~/.mozilla
              $ firejail --whitelist=/tmp/.X11-unix --whitelist=/dev/null
              $ firejail "--whitelist=/home/username/My Virtual Machines"
`````

## AppArmor support

So far I've seen this working on Debian Jessie and Ubuntu 16.04, where I can get Firefox and
Chromium running. There is more testing to come.

`````
APPARMOR
       AppArmor  support is disabled by default at compile time. Use --enable-
       apparmor configuration option to enable it:

              $ ./configure --prefix=/usr --enable-apparmor

       During software install, a generic  AppArmor  profile  file,  firejail-
       default,  is  placed in /etc/apparmor.d directory. The profile needs to
       be loaded into the kernel by running the following command as root:

              # aa-enforce firejail-default

       The installed profile tries to replicate some  advanced  security  fea‐
       tures inspired by kernel-based Grsecurity:

              - Prevent information leakage in /proc and /sys directories. The
              resulting file system is barely enough for running commands such
              as "top" and "ps aux".

              - Allow running programs only from well-known system paths, such
              as /bin, /sbin, /usr/bin etc. Running programs and scripts  from
              user  home  or  other  directories  writable  by the user is not
              allowed.

              - Disable D-Bus. D-Bus has long been a huge security  hole,  and
              most  programs don't use it anyway.  You should have no problems
              running Chromium or Firefox.

       To enable AppArmor confinement on top of your current Firejail security
       features,  pass  --apparmor flag to Firejail command line. You can also
       include apparmor command in a Firejail profile file. Example:

              $ firejail --apparmor firefox

`````

## AppImage support

AppImage (http://appimage.org/) is a distribution-agnostic packaging format.
The package is a regular ISO file containing all binaries, libraries and resources
necessary for the program to run.

We introduce in this release support for sandboxing AppImage applications. Example:
`````
$ firejail --appimage krita-3.0-x86_64.appimage
`````
All Firejail sandboxing options should be available. A private home directory:
`````
$ firejail --appimage --private krita-3.0-x86_64.appimage
`````
or some basic X11 sandboxing:
`````
$ firejail --appimage --net=none --x11 krita-3.0-x86_64.appimage
`````
Major software applications distributing AppImage packages:

* Krita: https://krita.org/download/krita-desktop/
* OpenShot: http://www.openshot.org/download/
* Scribus: https://www.scribus.net/downloads/unstable-branch/
* MuseScore: https://musescore.org/en/download

More packages build by AppImage developer Simon Peter: https://bintray.com/probono/AppImages

AppImage project home: https://github.com/probonopd/AppImageKit

## Sandbox auditing
`````
AUDIT
       Audit feature allows the user to point out gaps in  security  profiles.
       The  implementation  replaces  the  program to be sandboxed with a test
       program. By default, we use faudit program distributed with Firejail. A
       custom test program can also be supplied by the user. Examples:

       Running the default audit program:
            $ firejail --audit transmission-gtk

       Running a custom audit program:
            $ firejail --audit=~/sandbox-test transmission-gtk

       In  the examples above, the sandbox configures transmission-gtk profile
       and starts the test program. The real program,  transmission-gtk,  will
       not be started.

       Limitations: audit feature is not implemented for --x11 commands.
`````

## --noexec
`````
       --noexec=dirname_or_filename
              Remount directory or file noexec, nodev and nosuid.

              Example:
              $ firejail --noexec=/tmp

              /etc and /var are noexec by default. If there are more than one
              mount operation on the path of the file  or  directory,  noexec
              should  be  applied to the last one. Always check if the change
              took effect inside the sandbox.
`````

## --rmenv
`````
      --rmenv=name
              Remove environment variable in the new sandbox.

              Example:
              $ firejail --rmenv=DBUS_SESSION_BUS_ADDRESS
`````

## Converting profiles to private-bin - work in progress!

BitTorrent: deluge, qbittorrent, rtorrent, transmission-gtk, transmission-qt, uget-gtk

File transfer: filezilla

Media: vlc, mpv, gnome-mplayer, audacity, rhythmbox, spotify, xplayer, xviewer, eom

Office: evince, gthumb, fbreader, pix, atril, xreader,

Chat/messaging: qtox, gitter, pidgin

Games: warzone2100, gnome-chess

Weather/climate: aweather

Astronomy: gpredict, stellarium

Browsers: Palemoon

## New security profiles

Gitter, gThumb, mpv, Franz messenger, LibreOffice, pix, audacity, xz, xzdec, gzip, cpio, less, Atom Beta, Atom, jitsi, eom, uudeview
tar (gtar), unzip, unrar, file, skypeforlinux, gnome-chess, inox, Slack, Gajim IM client, DOSBox

