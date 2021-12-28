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
<a href="https://www.brighteon.com/6ebef4a5-20fe-4071-9d03-e6172c806ff7" target="_blank">
<img src="https://photos.brighteon.com/thumbnail/092dccab-9974-4775-93d2-35e31b2ebf61"
alt="Advanced Browser Security" width="240" height="142" border="10" /><br/>Advanced Browser Security</a>
</td>

<td>
<a href="https://www.brighteon.com/f09f693a-9847-4d9e-aaaf-60f756cc3833" target="_blank">
<img src="https://photos.brighteon.com/thumbnail/ab951131-81c7-4a6b-b483-924a342fea11"
alt="How To Disable Network Access" width="240" height="142" border="10" /><br/>How To Disable Network Access</a>
</td>

<td>
<a href="https://www.brighteon.com/94ae1731-2352-4cda-bb48-7cc7a6ad32f8" target="_blank">
<img src="https://photos.brighteon.com/thumbnail/5c90254c-61f3-4927-ac57-ae279dc543cf"
alt="Deep Dive" width="240" height="142" border="10" /><br/>Deep Dive</a>
</td>

</tr></table>

Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions

Wiki: https://github.com/netblue30/firejail/wiki

GitLab-CI status: https://gitlab.com/Firejail/firejail_ci/pipelines/

Video Channel: https://www.brighteon.com/channels/netblue30

Backup Video Channel: https://www.bitchute.com/profile/JSBsA1aoQVfW/

## Security vulnerabilities

We take security bugs very seriously. If you believe you have found one, please report it by emailing us at netblue30@protonmail.com

`````
Security Advisory - Feb 8, 2021

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

### Debian

Debian stable (bullseye): We recommend to use the [backports](https://packages.debian.org/bullseye-backports/firejail) package.

### Ubuntu

For Ubuntu 18.04+ and derivatives (such as Linux Mint), users are **strongly advised** to use the [PPA](https://launchpad.net/~deki/+archive/ubuntu/firejail).

How to add and install from the PPA:

```sh
sudo add-apt-repository ppa:deki/firejail
sudo apt-get update
sudo apt-get install firejail firejail-profiles
```

Reason: The firejail package for Ubuntu 20.04 has been left vulnerable to CVE-2021-26910 for months after a patch for it was posted on Launchpad:

* [firejail version in Ubuntu 20.04 LTS is vulnerable to CVE-2021-26910](https://bugs.launchpad.net/ubuntu/+source/firejail/+bug/1916767)

See also <https://wiki.ubuntu.com/SecurityTeam/FAQ>:

> What software is supported by the Ubuntu Security team?
>
> Ubuntu is currently divided into four components: main, restricted, universe
> and multiverse. All binary packages in main and restricted are supported by
> the Ubuntu Security team for the life of an Ubuntu release, while binary
> packages in universe and multiverse are supported by the Ubuntu community.

Additionally, the PPA version is likely to be more recent and to contain more profile fixes.

See the following discussions for details:

* [Should I keep using the version of firejail available in my distro repos?](https://github.com/netblue30/firejail/discussions/4666)
* [How to install the latest version on Ubuntu and derivatives](https://github.com/netblue30/firejail/discussions/4663)

### Other

Try installing Firejail from your distribution.

Firejail is included in Alpine, ALT Linux, Arch, Artix, Chakra, Debian, Deepin, Devuan, Fedora, Gentoo, Manjaro, Mint, NixOS, Parabola, Parrot, PCLinuxOS, ROSA, Solus, Slackware/SlackBuilds, Trisquel, Ubuntu, Void and possibly others.

Note: The firejail 0.9.52-LTS version is deprecated.

You can also install one of the [released packages](http://sourceforge.net/projects/firejail/files/firejail), or clone Firejail’s source code from our Git repository and compile manually:

`````
$ git clone https://github.com/netblue30/firejail.git
$ cd firejail
$ ./configure && make && sudo make install-strip
`````
On Debian/Ubuntu you will need to install git and gcc compiler. AppArmor
development libraries and pkg-config are required when using `--apparmor`
./configure option:
`````
$ sudo apt-get install git build-essential libapparmor-dev pkg-config gawk
`````
For `--selinux` option, add libselinux1-dev (libselinux-devel for Fedora).

Detailed information on using firejail from git is available on the [wiki](https://github.com/netblue30/firejail/wiki/Using-firejail-from-git).

## Running the sandbox

To start the sandbox, prefix your command with `firejail`:

`````
$ firejail firefox            # starting Mozilla Firefox
$ firejail transmission-gtk   # starting Transmission BitTorrent
$ firejail vlc                # starting VideoLAN Client
$ sudo firejail /etc/init.d/nginx start
`````
Run `firejail --list` in a terminal to list all active sandboxes. Example:
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
We keep the application list in [/etc/firejail/firecfg.config](https://github.com/netblue30/firejail/blob/master/src/firecfg/firecfg.config) file.

## Security profiles

Most Firejail command line options can be passed to the sandbox using profile files.
You can find the profiles for all supported applications in [/etc/firejail](https://github.com/netblue30/firejail/tree/master/etc) directory.

If you keep additional Firejail security profiles in a public repository, please give us a link:

* https://github.com/chiraag-nataraj/firejail-profiles

* https://github.com/triceratops1/fe

Use this issue to request new profiles: [#1139](https://github.com/netblue30/firejail/issues/1139)

You can also use this tool to get a list of syscalls needed by a program: [contrib/syscalls.sh](contrib/syscalls.sh).

We also keep a list of profile fixes for previous released versions in [etc-fixes](https://github.com/netblue30/firejail/tree/master/etc-fixes) directory.

## Latest released version: 0.9.66

## Current development version: 0.9.67

Milestone page: https://github.com/netblue30/firejail/milestone/1
Release discussion: https://github.com/netblue30/firejail/issues/3696

Moving from whitelist/blacklist to allow/deny is under way! We are still open to other options, so it might change!

The old whitelist/blacklist will remain as aliasses for the next one or two releases
in order to give users a chance to switch their local profiles.
The latest discussion on this issue is here: https://github.com/netblue30/firejail/issues/4379

### Intrusion Detection System ###
`````
      --ids-check
              Check  file  hashes previously generated by --ids-check. See IN‐
              TRUSION DETECTION SYSTEM section for more details.

              Example:
              $ firejail --ids-check

       --ids-init
              Initialize file hashes. See INTRUSION DETECTION  SYSTEM  section
              for more details.

              Example:
              $ firejail --ids-init

INTRUSION DETECTION SYSTEM (IDS)
       The  host-based  intrusion detection system tracks down and audits user
       and  system  file  modifications.   The  feature  is  configured  using
       /etc/firejail/ids.config    file,   the   checksums   are   stored   in
       /var/lib/firejail/USERNAME.ids, where USERNAME is the name of the  cur‐
       rent user. We use BLAKE2 cryptographic function for hashing.

       As a regular user, initialize the database:

       $ firejail --ids-init
       Opening config file /etc/firejail/ids.config
       Loading config file /etc/firejail/ids.config
       Opening config file /etc/firejail/ids.config.local
       500 1000 1500 2000
       2466 files scanned
       IDS database initialized

       The  default configuration targets several system executables in direc‐
       tories such as /bin, /sbin, /usr/bin, /usr/sbin, and  several  critical
       config  files in user home directory such as ~/.bashrc, ~/.xinitrc, and
       ~/.config/autostart. Several system config files in /etc directory  are
       also hashed.

       Run --ids-check to audit the system:

       $ firejail --ids-check
       Opening config file /etc/firejail/ids.config
       Loading config file /etc/firejail/ids.config
       Opening config file /etc/firejail/ids.config.local
       500 1000 1500
       Warning: modified /home/netblue/.bashrc
       2000
       2466 files scanned: modified 1, permissions 0, new 0, removed 0

       The  program  will  print  the  files that have been modified since the
       database was created, or the files with different  access  permissions.
       New files and deleted files are also flagged.

       Currently  while  scanning  the file system symbolic links are not fol‐
       lowed, and files the user doesn't have  read  access  to  are  silently
       dropped.   The  program  can  also be run as root (sudo firejail --ids-
       init/--ids-check).

`````

### Deteministic Shutdown
`````
      --deterministic-exit-code
              Always exit firejail with the first child's exit status. The de‐
              fault  behavior  is to use the exit status of the final child to
              exit, which can be nondeterministic.

       --deterministic-shutdown
              Always shut down the sandbox after the first  child  has  termi‐
              nated. The default behavior is to keep the sandbox alive as long
              as it contains running processes.
`````

### Network Monitor
`````
       --nettrace=name|pid
              Monitor TCP and UDP traffic coming into the sandbox specified by
              name or pid. Only networked sandboxes  created  with  --net  are
              supported.

              $ firejail --nettrace=browser
              9.9.9.9:53              =>      192.168.1.60    UDP: 122 B/sec
              72.21.91.29:80          =>      192.168.1.60    TCP: 257 B/sec
              80.92.126.65:123        =>      192.168.1.60    UDP: 25 B/sec
              69.30.241.50:443        =>      192.168.1.60    TCP: 88 KB/sec
              140.82.112.4:443        =>      192.168.1.60    TCP: 1861 B/sec

              (14 streams in the last one minute)

`````

### Profile Statistics

A small tool to print profile statistics. Compile and install as usual. The tool is installed in /usr/lib/firejail directory.
Run it over the profiles in /etc/profiles:
```
$ /usr/lib/firejail/profstats /etc/firejail/*.profile
No include .local found in /etc/firejail/noprofile.profile
Warning: multiple caps in /etc/firejail/transmission-daemon.profile

Stats:
    profiles			1176
    include local profile	1175   (include profile-name.local)
    include globals		1144   (include globals.local)
    blacklist ~/.ssh		1050   (include disable-common.inc)
    seccomp			1070
    capabilities		1171
    noexec			1057   (include disable-exec.inc)
    noroot			979
    memory-deny-write-execute	258
    apparmor			700
    private-bin			681
    private-dev			1033
    private-etc			533
    private-tmp			905
    whitelist home directory	562
    whitelist var		842   (include whitelist-var-common.inc)
    whitelist run/user		1145   (include whitelist-runuser-common.inc
					or blacklist ${RUNUSER})
    whitelist usr/share		614   (include whitelist-usr-share-common.inc
    net none			399
    dbus-user none 		662
    dbus-user filter 		113
    dbus-system none 		816
    dbus-system filter 		10
```

### New profiles:

clion-eap, lifeograph, io.github.lainsce.Notejot, rednotebook, zim, microsoft-edge-beta, ncdu2, gallery-dl, yt-dlp, goldendict, bundle,
cmake, make, meson, pip, codium, telnet, ftp, OpenStego, imv, retroarch, torbrowser, CachyBrowser
