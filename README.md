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

FAQ: https://firejail.wordpress.com/support/

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

We also keep a list of profile fixes for previous released versions in [etc-fixes](https://github.com/netblue30/firejail/tree/master/etc-fixes) directory .
`````

`````
# Current development version: 0.9.56.1

This is probably a bugfix release: fixes, small features, new profiles. If we end up implementing something major
we'll switch to a regular 0.9.57 release.

# New Long Term Support (LTS) version

We are rebasing our Long Term Support branch of Firejail. The current LTS version (0.9.38.x) is more than two years old.
The new version updates the code base to 0.9.56. We target a reduction of approx. 40% of the code by removing rarely
used features (chroot, overlay, rlimits, cgroups), incomplete features (private-bin, private-lib),
and a lot of instrumentation (build profile feature, tracing, auditing, etc). Sandbox-specific security features such as
seccomp, capabilities, filesystem whitelist/blacklist and networking are updated and hardened.

We have an rc1 release out, the final version will follow in the next few weeks:
`````
firejail (0.9.56-LTS~rc1) baseline; urgency=low
  * code based on Firejail version 0.9.56
  * much smaller code base for SUID executable
  * command line options removed:
     --audit, --build, --cgroup, --chroot, --get, --ls, --output,
     --output-stderr, --overlay, --overlay-named, --overlay-tmpfs,
     --overlay-clean, --private-home, --private-bin, --private-etc,
     --private-opt, --private-srv, --put, --rlimit*, --trace, --tracelog,
     --x11*, --xephyr*
  * compile-time options: --enable-apparmor, --disable-seccomp,
     --disable-globalcfg, --disable-network, --disable-userns,
     --disable-whitelist, --disable-suid, --enable-fatal-warnings,
     --enable-busybox-workaround
 -- netblue30 <netblue30@yahoo.com>  Wed, 3 Oct 2018 08:00:00 -0500
`````

The new LTS branch is here: https://github.com/netblue30/firejail/tree/LTSbase

# New profiles:

QMediathekView, aria2c, Authenticator, checkbashisms, devilspie, devilspie2, easystroke, github-desktop, min,
bsdcat, bsdcpio, bsdtar, lzmadec, lbunzip2, lbzcat, lbzip2, lzcat, lzcmp, lzdiff, lzegrep, lzfgrep, lzgrep,
lzless, lzma, lzmainfo, lzmore, unlzma, unxz, xzcat, xzcmp, xzdiff, xzegrep, xzfgrep, xzgrep, xzless, xzmore,
lzip, artha, nitroshare, nitroshare-cli, nitroshare-nmh, nirtoshare-send, nitroshare-ui, mencoder, gnome-pie,
masterpdfeditor, QOwnNotes
