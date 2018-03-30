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

[![Firejail Firefox Demo](video.png)](https://www.youtube.com/watch?v=kCnAxD144nU)


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
# Current development version: 0.9.53

## Spectre mitigation

If your gcc compiler version supports it, -mindirect-branch=thunk is inserted into EXTRA_CFLAGS during software configuration.
The patch was introduced in gcc version 8, and it was backported to gcc 7. You'll also find it
on older versions, for example on Debian stable running on gcc 6.3.0.  This is how you check it:
`````
$ ./configure --prefix=/usr
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for a BSD-compatible install... /usr/bin/install -c
checking for ranlib... ranlib
checking for Spectre mitigation support in gcc compiler... yes
[...]
Configuration options:
   prefix: /usr
   sysconfdir: /etc
   seccomp: -DHAVE_SECCOMP
   <linux/seccomp.h>: -DHAVE_SECCOMP_H
   apparmor:
   global config: -DHAVE_GLOBALCFG
   chroot: -DHAVE_CHROOT
   bind: -DHAVE_BIND
   network: -DHAVE_NETWORK
   user namespace: -DHAVE_USERNS
   X11 sandboxing support: -DHAVE_X11
   whitelisting: -DHAVE_WHITELIST
   private home support: -DHAVE_PRIVATE_HOME
   file transfer support: -DHAVE_FILE_TRANSFER
   overlayfs support: -DHAVE_OVERLAYFS
   git install support:
   busybox workaround: no
   Spectre compiler patch: yes
   EXTRA_LDFLAGS:
   EXTRA_CFLAGS:  -mindirect-branch=thunk
   fatal warnings:
   Gcov instrumentation:
   Install contrib scripts: yes
`````
This feature is also supported for LLVM/clang compiler

## New command line options
`````
       --nodbus
              Disable D-Bus access. Only the regular UNIX socket is handled by
              this command. To disable the abstract socket you would  need  to
              request  a  new  network  namespace using --net command. Another
              option is to remove unix from --protocol set.

              Example:
              $ firejail --nodbus --net=none
`````

## AppImage development

Support for private-bin, private-lib and shell none has been disabled while running AppImage archives.
This allows us to use our regular profile files for appimages. We don't have a way to extract the name
of the executable, so the profile will have to be passed on the command line. Example:
`````
$ firejail --profile=/etc/firejail/kdenlive.profile --appimage --apparmor ~/bin/Kdenlive-17.12.0d-x86_64.AppImage
`````
Also, we have full AppArmor support for AppImages:
`````

$ firejail --apparmor --appimage ~/bin/Kdenlive-17.12.0d-x86_64.AppImage
`````

## Seccomp development

Replaced the our seccomp disassembler with a real disassembler lifted from
libseccomp (GPLv2, Paul Moore, Red Hat). The code is in src/fsec-print directory.
`````
$ firejail --seccomp.print=browser
 line  OP JT JF    K
=================================
 0000: 20 00 00 00000004   ld  data.architecture
 0001: 15 01 00 c000003e   jeq ARCH_64 0003 (false 0002)
 0002: 06 00 00 7fff0000   ret ALLOW
 0003: 20 00 00 00000000   ld  data.syscall-number
 0004: 35 01 00 40000000   jge X32_ABI true:0006 (false 0005)
 0005: 35 01 00 00000000   jge read 0007 (false 0006)
 0006: 06 00 00 00050001   ret ERRNO(1)
 0007: 15 41 00 0000009a   jeq modify_ldt 0049 (false 0008)
 0008: 15 40 00 000000d4   jeq lookup_dcookie 0049 (false 0009)
 0009: 15 3f 00 0000012a   jeq perf_event_open 0049 (false 000a)
 000a: 15 3e 00 00000137   jeq process_vm_writev 0049 (false 000b)
 000b: 15 3d 00 0000009c   jeq _sysctl 0049 (false 000c)
 000c: 15 3c 00 000000b7   jeq afs_syscall 0049 (false 000d)
 000d: 15 3b 00 000000ae   jeq create_module 0049 (false 000e)
 000e: 15 3a 00 000000b1   jeq get_kernel_syms 0049 (false 000f)
 000f: 15 39 00 000000b5   jeq getpmsg 0049 (false 0010)
 0010: 15 38 00 000000b6   jeq putpmsg 0049 (false 0011)
 0011: 15 37 00 000000b2   jeq query_module 0049 (false 0012)
 0012: 15 36 00 000000b9   jeq security 0049 (false 0013)
 0013: 15 35 00 0000008b   jeq sysfs 0049 (false 0014)
 0014: 15 34 00 000000b8   jeq tuxcall 0049 (false 0015)
 0015: 15 33 00 00000086   jeq uselib 0049 (false 0016)
 0016: 15 32 00 00000088   jeq ustat 0049 (false 0017)
 0017: 15 31 00 000000ec   jeq vserver 0049 (false 0018)
 0018: 15 30 00 0000009f   jeq adjtimex 0049 (false 0019)
 0019: 15 2f 00 00000131   jeq clock_adjtime 0049 (false 001a)
 001a: 15 2e 00 000000e3   jeq clock_settime 0049 (false 001b)
 001b: 15 2d 00 000000a4   jeq settimeofday 0049 (false 001c)
 001c: 15 2c 00 000000b0   jeq delete_module 0049 (false 001d)
 001d: 15 2b 00 00000139   jeq finit_module 0049 (false 001e)
 001e: 15 2a 00 000000af   jeq init_module 0049 (false 001f)
 001f: 15 29 00 000000ad   jeq ioperm 0049 (false 0020)
 0020: 15 28 00 000000ac   jeq iopl 0049 (false 0021)
 0021: 15 27 00 000000f6   jeq kexec_load 0049 (false 0022)
 0022: 15 26 00 00000140   jeq kexec_file_load 0049 (false 0023)
 0023: 15 25 00 000000a9   jeq reboot 0049 (false 0024)
 0024: 15 24 00 000000a7   jeq swapon 0049 (false 0025)
 0025: 15 23 00 000000a8   jeq swapoff 0049 (false 0026)
 0026: 15 22 00 000000a3   jeq acct 0049 (false 0027)
 0027: 15 21 00 00000141   jeq bpf 0049 (false 0028)
 0028: 15 20 00 000000a1   jeq chroot 0049 (false 0029)
 0029: 15 1f 00 000000a5   jeq mount 0049 (false 002a)
 002a: 15 1e 00 000000b4   jeq nfsservctl 0049 (false 002b)
 002b: 15 1d 00 0000009b   jeq pivot_root 0049 (false 002c)
 002c: 15 1c 00 000000ab   jeq setdomainname 0049 (false 002d)
 002d: 15 1b 00 000000aa   jeq sethostname 0049 (false 002e)
 002e: 15 1a 00 000000a6   jeq umount2 0049 (false 002f)
 002f: 15 19 00 00000099   jeq vhangup 0049 (false 0030)
 0030: 15 18 00 000000ee   jeq set_mempolicy 0049 (false 0031)
 0031: 15 17 00 00000100   jeq migrate_pages 0049 (false 0032)
 0032: 15 16 00 00000117   jeq move_pages 0049 (false 0033)
 0033: 15 15 00 000000ed   jeq mbind 0049 (false 0034)
 0034: 15 14 00 00000130   jeq open_by_handle_at 0049 (false 0035)
 0035: 15 13 00 0000012f   jeq name_to_handle_at 0049 (false 0036)
 0036: 15 12 00 000000fb   jeq ioprio_set 0049 (false 0037)
 0037: 15 11 00 00000067   jeq syslog 0049 (false 0038)
 0038: 15 10 00 0000012c   jeq fanotify_init 0049 (false 0039)
 0039: 15 0f 00 00000138   jeq kcmp 0049 (false 003a)
 003a: 15 0e 00 000000f8   jeq add_key 0049 (false 003b)
 003b: 15 0d 00 000000f9   jeq request_key 0049 (false 003c)
 003c: 15 0c 00 000000fa   jeq keyctl 0049 (false 003d)
 003d: 15 0b 00 000000ce   jeq io_setup 0049 (false 003e)
 003e: 15 0a 00 000000cf   jeq io_destroy 0049 (false 003f)
 003f: 15 09 00 000000d0   jeq io_getevents 0049 (false 0040)
 0040: 15 08 00 000000d1   jeq io_submit 0049 (false 0041)
 0041: 15 07 00 000000d2   jeq io_cancel 0049 (false 0042)
 0042: 15 06 00 000000d8   jeq remap_file_pages 0049 (false 0043)
 0043: 15 05 00 00000116   jeq vmsplice 0049 (false 0044)
 0044: 15 04 00 00000087   jeq personality 0049 (false 0045)
 0045: 15 03 00 00000143   jeq userfaultfd 0049 (false 0046)
 0046: 15 02 00 00000065   jeq ptrace 0049 (false 0047)
 0047: 15 01 00 00000136   jeq process_vm_readv 0049 (false 0048)
 0048: 06 00 00 7fff0000   ret ALLOW
 0049: 06 00 01 00000000   ret KILL
`````
We are also introducing a seccomp optimizer, to be run directly on seccomp machine code
filters produced by Firejail. The code is in src/fsec-optimize. Currently only the default seccomp
filters built at compile time are run trough the optimizer. It will be extended and applied at run
time on all filters.


## AppArmor development

AppArmor features are supported on overlayfs and chroot sandboxes.

We are in the process of streamlining our AppArmor profile. The restrictions for /proc, /sys
and /run/user directories were moved out of the profile into firejail executable.
We are also adding a "apparmor yes/no" flag in /etc/firejail/firejail.config file allows the user to
enable/disable apparmor functionality globally. By default the flag is enabled.

AppArmor deployment: we are starting apparmor by default for the following programs:
- web browsers: firefox (firefox-common.profile), chromium (chromium-common.profile)
- torrent clients: transmission-qt, transmission-gtk, qbittorrent
- media players: vlc, mpv, audacious, kodi, smplayer
- media editing: kdenlive, audacity, handbrake, inkscape, krita, openshot
- archive managers: ark, engrampa, file-roller
- etc.: digikam, libreoffice, okular, gwenview, galculator, kcalc

Checking apparmor status:
`````
$ firejail --apparmor.print=browser
2146:netblue:/usr/bin/firejail /usr/bin/firefox-esr
  AppArmor: firejail-default enforce

$ firemon --apparmor
2072:netblue:firejail --chroot=/chroot/sid --net=eth0
  AppArmor: unconfined
2146:netblue:/usr/bin/firejail /usr/bin/firefox-esr
  AppArmor: firejail-default enforce
4835:netblue:/usr/bin/firejail /usr/bin/vlc
  AppArmor: firejail-default enforce
`````


## Browser profile unification

All Chromium and Firefox browsers have been unified to instead extend
chromium-common.profile and firefox-common.profile respectively.
This allows for reduced maintenance and ease of adding new browsers.
NOTE: All users of Firefox-based browsers who use addons and plugins
that read/write from ${HOME} will need to uncomment the includes for
firefox-common-addons.inc in firefox-common.profile.

## New profiles

Basilisk browser, Tor Browser language packs, PlayOnLinux, sylpheed, discord-canary,
pycharm-community, pycharm-professional, Pitivi, OnionShare, Fritzing, Kaffeine, pdfchain,
tilp, vivaldi-snapshot, bitcoin-qt, VS Code, falkon, gnome-builder, lobase, asunder,
gnome-recipes, akonadi_control, evince-previewer, evince-thumbnailer, blender-2.8,
thunderbird-beta, ncdu
