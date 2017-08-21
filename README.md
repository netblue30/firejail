# Firejail
[![Build Status](https://travis-ci.org/netblue30/firejail.svg?branch=master)](https://travis-ci.org/netblue30/firejail)

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
implemented directly in Linux kernel and available on any Linux computer.

[![About Firejail](video.png)](http://www.youtube.com/watch?v=Yk1HVPOeoTc)


Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://firejail.wordpress.com/support/frequently-asked-questions/

Travis-CI status: https://travis-ci.org/netblue30/firejail


## Compile and install
`````
$ git clone https://github.com/netblue30/firejail.git
$ cd firejail
$ ./configure && make && sudo make install-strip
`````
On Debian/Ubuntu you will need to install git and a compiler:
`````
$ sudo apt-get install git build-essential
`````


## Running the sandbox

To start the sandbox, prefix your command with “firejail”:

`````
$ firejail firefox            # starting Mozilla Firefox
$ firejail transmission-gtk   # starting Transmission BitTorrent
$ firejail vlc                # starting VideoLAN Client
$ sudo firejail /etc/init.d/nginx start
`````
Run "firejail --list" in a terminal to list all active sandboxes. Example:
`````
$ firejail --list
1617:netblue:/usr/bin/firejail /usr/bin/firefox-esr
7719:netblue:/usr/bin/firejail /usr/bin/transmission-qt
7779:netblue:/usr/bin/firejail /usr/bin/galculator
7874:netblue:/usr/bin/firejail /usr/bin/vlc --started-from-file file:///home/netblue/firejail-whitelist.mp4
7916:netblue:firejail --list
`````

## Desktop integration

Integrate your sandbox into your desktop by running the following two commands:
`````
$ firecfg --fix-sound
$ sudo firecfg
`````

The first command solves some shared memory/PID namespace bugs in PulseAudio software prior to version 9.
The second command integrates Firejail into your desktop. You would need to logout and login back to apply
PulseAudio changes.

Start your programs the way you are used to: desktop manager menus, file manager, desktop launchers.
The integration applies to any program supported by default by Firejail. There are about 250 default applications
in current Firejail version, and the number goes up with every new release.
We keep the application list in [/usr/lib/firejail/firecfg.config](https://github.com/netblue30/firejail/blob/master/src/firecfg/firecfg.config) file.

## Security profiles

Most Firejail command line options can be passed to the sandbox using profile files.
You can find the profiles for all supported applications in [/etc/firejail](https://github.com/netblue30/firejail/tree/master/etc) directory.

If you keep additional Firejail security profiles in a public repository, please give us a link:

* https://github.com/chiraag-nataraj/firejail-profiles

* https://github.com/triceratops1/fe

Use this issue to request new profiles: [#1139](https://github.com/netblue30/firejail/issues/1139)
`````

`````
# Current development version: 0.9.49

## Travis-CI integration

Check the status of the latest build here: https://travis-ci.org/netblue30/firejail

## New command options:
`````
      --disable-mnt
              Disable /mnt, /media, /run/mount and /run/media access.

              Example:
              $ firejail --disable-mnt firefox

       --xephyr-screen=WIDTHxHEIGHT
              Set screen size for --x11=xephyr. The setting will overwrite the
              default set in  /etc/firejail/firejail.config  for  the  current
              sandbox.  Run  xrandr  to get a list of supported resolutions on
              your computer.

              Example:
              $ firejail --net=eth0 --x11=xephyr --xephyr-screen=640x480 fire‐
              fox

       --output-stderr=logfile
              Similar to --output, but stderr is also stored.

      --notv Disable DVB (Digital Video Broadcasting) TV devices.

              Example:
              $ firejail --notv vlc

       --nodvd
              Disable DVD and audio CD devices.

              Example:
              $ firejail --nodvd

      --memory-deny-write-execute
              Install a seccomp filter to block  attempts  to  create  memory
              mappings  that are both writable and executable, to change map‐
              pings to be executable or to create executable shared memory.

       --private-lib=file,directory
              This  feature  is currently under heavy development. Only amd64
              platforms are supported at this moment.  The idea is to build a
              new /lib in a temporary filesystem, with only the library files
              necessary to run the application.  It could be as simple as:

              $ firejail --private-lib galculator

              but it gets complicated really fast:

              $   firejail   --private-lib=x86_64-linux-gnu/xed,x86_64-linux-
              gnu/gdk-pixbuf-2.0,libenchant.so.1,librsvg-2.so.2 xed

              The feature is integrated with --private-bin:

              $ firejail --private-lib --private-bin=bash,ls,ps
              $ ls /lib
              ld-linux-x86-64.so.2  libgpg-error.so.0  libprocps.so.6 libsys‐
              temd.so.0
              libc.so.6 liblz4.so.1 libpthread.so.0 libtinfo.so.5
              libdl.so.2 liblzma.so.5 librt.so.1 x86_64-linux-gnu
              libgcrypt.so.20 libpcre.so.3 libselinux.so.1
              $ ps
               PID TTY          TIME CMD
                  1 pts/0    00:00:00 firejail
                 45 pts/0    00:00:00 bash
                 48 pts/0    00:00:00 ps
              $

       --seccomp.block_secondary
              Enable seccomp filter and filter system call  architectures  so
              that  only  the native architecture is allowed. For example, on
              amd64, i386 and x32 system calls are blocked as well as  chang‐
              ing the execution domain with personality(2) system call.

`````

## /etc/firejail/firejail.config

`````
# Number of ARP probes sent when assigning an IP address for --net option,
# default 2. This is a partial implementation of RFC 5227. A 0.5 seconds
# timeout is implemented for each probe. Increase this number to 4 if your
# local layer 2 network uses RSTP (IEEE 802.1w). Permitted values are
# between 1 and 30.
# arp-probes 2

# Enable this option if you have a version of Xpra that supports --attach switch
# for start command, default disabled.
# xpra-attach no


`````


## Default seccomp list update

The following syscalls have been added:
afs_syscall, bdflush, break, ftime, getpmsg, gtty, lock, mpx, pciconfig_iobase, pciconfig_read,
pciconfig_write, prof, profil, putpmsg, rtas, s390_runtime_instr, s390_mmio_read, s390_mmio_write,
security, setdomainname,  sethostname, sgetmask, ssetmask, stty, subpage_prot, switch_endian,
ulimit, vhangup, vserver. This brings us to a total of 91 syscalls blacklisted by default.

get_mempolicy syscall was temporarily removed from the default seccomp list. It seems to break
playing youtube videos on Firefox Nightly.



## New profiles:

curl, mplayer2, SMPlayer, Calibre, ebook-viewer, KWrite, Geary, Liferea, peek, silentarmy,
IntelliJ IDEA, Android Studio, electron, riot-web,
Extreme Tux Racer, Frozen Bubble, Open Invaders, Pingus, Simutrans, SuperTux,
telegram-desktop, arm, rambox, apktool, baobab, dex2jar, gitg, hashcat, obs, picard,
remmina, sdat2img, soundconverter, sqlitebrowse, truecraft, gnome-twitch, tuxguitar,
musescore
