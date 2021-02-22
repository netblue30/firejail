# Firejail
[![Build Status](https://gitlab.com/Firejail/firejail_ci/badges/master/pipeline.svg)](https://gitlab.com/Firejail/firejail_ci/pipelines/)
[![CodeQL](https://github.com/netblue30/firejail/workflows/CodeQL/badge.svg)](https://github.com/netblue30/firejail/actions?query=workflow%3ACodeQL)
[![Build CI](https://github.com/netblue30/firejail/workflows/Build%20CI/badge.svg)](https://github.com/netblue30/firejail/actions?query=workflow%3A%22Build+CI%22)
[![Packaging status](https://repology.org/badge/tiny-repos/firejail.svg)](https://repology.org/project/firejail/versions)

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

<table><tr>

<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=7RMz7tePA98
" target="_blank"><img src="http://img.youtube.com/vi/7RMz7tePA98/0.jpg"
alt="Firejail Introduction" width="240" height="180" border="10" /><br/>Firejail Intro</a>
</td>

<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=J1ZsXrpAgBU
" target="_blank"><img src="http://img.youtube.com/vi/J1ZsXrpAgBU/0.jpg"
alt="Firejail Demo" width="240" height="180" border="10" /><br/>Firejail Demo</a>
</td>

<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=EyEz65RYfw4
" target="_blank"><img src="http://img.youtube.com/vi/EyEz65RYfw4/0.jpg"
alt="Debian Install" width="240" height="180" border="10" /><br/>Debian Install</a>
</td>


</tr><tr>
<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Uy2ZTHc4s0w
" target="_blank"><img src="http://img.youtube.com/vi/Uy2ZTHc4s0w/0.jpg"
alt="Arch Linux Install" width="240" height="180" border="10" /><br/>Arch Linux Install</a>

</td>
<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=xuMxRx0zSfQ
" target="_blank"><img src="http://img.youtube.com/vi/xuMxRx0zSfQ/0.jpg"
alt="Disable Network Access" width="240" height="180" border="10" /><br/>Disable Network Access</a>

</td>
<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=N-Mso2bSr3o
" target="_blank"><img src="http://img.youtube.com/vi/N-Mso2bSr3o/0.jpg"
alt="Firejail Security Deep Dive" width="240" height="180" border="10" /><br/>Firejail Security Deep Dive</a>

</td>
</tr></table>

Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions

Wiki: https://github.com/netblue30/firejail/wiki

GitLab-CI status: https://gitlab.com/Firejail/firejail_ci/pipelines/

Video Channel: https://www.youtube.com/channel/UCi5u-syndQYyOeV4NZ04hNA

Backup Video Channel: https://www.bitchute.com/profile/JSBsA1aoQVfW/

## Security vulnerabilities

We take security bugs very seriously. If you believe you have found one, please report it by emailing us at netblue30@protonmail.com

`````
Security Adivsory - Feb 8, 2021

Summary: A vulnerability resulting in root privilege escalation was discovered in
Firejail's OverlayFS code,

Versions affected: Firejail software versions starting with 0.9.30.
Long Term Support (LTS) Firejail branch is not affected by this bug.

Workaround: Disable overlayfs feature at runtime.
In a text editor open /etc/firejail/firejail.config file, and set "overlayfs" entry to "no".

      $ grep overlayfs /etc/firejail/firejail.config
      # Enable or disable overlayfs features, default enabled.
      overlayfs no

Fix: The bug is fixed in Firejail version 0.9.64.4

GitHub commit: (file configure.ac)
https://github.com/netblue30/firejail/commit/97d8a03cad19501f017587cc4e47d8418273834b

Credit:  Security researcher Roman Fiedler analyzed the code and discovered the vulnerability.
Functional PoC exploit code was provided to Firejail development team.
A description of the problem is here on Roman's blog:

https://unparalleled.eu/publications/2021/advisory-unpar-2021-0.txt
https://unparalleled.eu/blog/2021/20210208-rigged-race-against-firejail-for-local-root/
`````

## Installing

Try installing Firejail from your system packages first. Firejail is included in Alpine, ALT Linux, Arch, Chakra, Debian, Deepin, Devuan, Fedora, Gentoo, Manjaro, Mint, NixOS, Parabola, Parrot, PCLinuxOS, ROSA, Solus, Slackware/SlackBuilds, Trisquel, Ubuntu, Void and possibly others.

The firejail 0.9.52-LTS version is deprecated. On Ubuntu 18.04 LTS users are advised to use the [PPA](https://launchpad.net/~deki/+archive/ubuntu/firejail). On Debian buster we recommend to use the [backports](https://packages.debian.org/buster-backports/firejail) package.

You can also install one of the [released packages](http://sourceforge.net/projects/firejail/files/firejail), or clone Firejail’s source code from our Git repository and compile manually:

`````
$ git clone https://github.com/netblue30/firejail.git
$ cd firejail
$ ./configure && make && sudo make install-strip
`````
On Debian/Ubuntu you will need to install git and gcc compiler. AppArmor
development libraries and pkg-config are required when using --apparmor
./configure option:
`````
$ sudo apt-get install git build-essential libapparmor-dev pkg-config gawk
`````
For --selinux option, add libselinux1-dev (libselinux-devel for Fedora).

Detailed information on using firejail from git is available on the [wiki](https://github.com/netblue30/firejail/wiki/Using-firejail-from-git).

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

You can also use this tool to get a list of syscalls needed by a program: [contrib/syscalls.sh](contrib/syscalls.sh).

We also keep a list of profile fixes for previous released versions in [etc-fixes](https://github.com/netblue30/firejail/tree/master/etc-fixes) directory.
`````

`````
## Latest released version: 0.9.64

## Current development version: 0.9.65

Milestone page: https://github.com/netblue30/firejail/milestone/1
Release discussion: https://github.com/netblue30/firejail/issues/3696

### jailtest
`````
JAILTEST(1)                    JAILTEST man page                   JAILTEST(1)

NAME
       jailtest - Simple utility program to test running sandboxes

SYNOPSIS
       sudo jailtest [OPTIONS] [directory]

DESCRIPTION
       WORK IN PROGRESS!  jailtest attaches itself to all sandboxes started by
       the user and performs some basic tests on the sandbox filesystem:

       1. Virtual directories
              jailtest extracts a list with the main virtual  directories  in‐
              stalled by the sandbox.  These directories are build by firejail
              at startup using --private* and --whitelist commands.

       2. Noexec test
              jailtest inserts executable programs  in  /home/username,  /tmp,
              and  /var/tmp  directories and tries to run them form inside the
              sandbox, thus testing if the directory is executable or not.

       3. Read access test
              jailtest creates test files in the directories specified by  the
              user and tries to read them from inside the sandbox.

       The program is running as root exclusively under sudo.

OPTIONS
       --debug
              Print debug messages

       -?, --help
              Print options end exit.

       --version
              Print program version and exit.

       [directory]
              One or more directories in user home to test for read access.

OUTPUT
       For each sandbox detected we print the following line:

            PID:USER:Sandbox Name:Command

       It is followed by relevant sandbox information, such as the virtual di‐
       rectories and various warnings.

EXAMPLE
       $ sudo jailtest ~/.ssh ~/.gnupg
       1429:netblue::/usr/bin/firejail /opt/firefox/firefox
          Virtual dirs: /home/netblue, /tmp, /var/tmp, /dev, /etc,
       5602:netblue::/usr/bin/firejail /usr/bin/ssh netblue@x.y.z.net
          Virtual dirs: /var/tmp, /dev,
          Warning: I can read ~/.ssh
       5926:netblue::/usr/bin/firejail /usr/bin/gimp-2.10
          Virtual dirs: /tmp, /var/tmp, /dev,
          Warning: I can run programs in /home/netblue
       6394:netblue:libreoffice:/usr/bin/firejail libreoffice
          Virtual dirs: /tmp, /var/tmp, /dev,

LICENSE
       This program is free software; you can redistribute it and/or modify it
       under  the  terms of the GNU General Public License as published by the
       Free Software Foundation; either version 2 of the License, or (at  your
       option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firejail(1),  firecfg(1),  firejail-profile(5), firejail-login(5) fire‐
       jail-users(5)

0.9.65                             Feb 2021                        JAILTEST(1)
`````

### Profile Statistics

A small tool to print profile statistics. Compile as usual and run in /etc/profiles:
```
$ sudo cp src/profstats/profstats /etc/firejail/.
$ cd /etc/firejail
$ ./profstats *.profile
Warning: multiple caps in transmission-daemon.profile

Stats:
    profiles			1064
    include local profile	1064   (include profile-name.local)
    include globals		1064   (include globals.local)
    blacklist ~/.ssh		959   (include disable-common.inc)
    seccomp			975
    capabilities		1063
    noexec			944   (include disable-exec.inc)
    memory-deny-write-execute	229
    apparmor			605
    private-bin			564
    private-dev			932
    private-etc			462
    private-tmp			823
    whitelist home directory	502
    whitelist var		744   (include whitelist-var-common.inc)
    whitelist run/user		461   (include whitelist-runuser-common.inc
					or blacklist ${RUNUSER})
    whitelist usr/share		451   (include whitelist-usr-share-common.inc
    net none			345
    dbus-user none 		564
    dbus-user filter 		85
    dbus-system none 		696
    dbus-system filter 		7
```

### New profiles:

vmware-view, display-im6.q16, ipcalc, ipcalc-ng, ebook-convert, ebook-edit, ebook-meta, ebook-polish
