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
<a href="https://odysee.com/@netblue30:9/firefox:c" target="_blank">
<img src="https://thumbs.odycdn.com/acf4b1c66737feb97640fb1d28a7daa6.png"
alt="Advanced Browser Security" width="240" height="142" border="10" /><br/>Advanced Browser Security</a>
</td>

<td>
<a href="https://odysee.com/@netblue30:9/nonet:7" target="_blank">
<img src="https://thumbs.odycdn.com/5be2964201c31689ee8f78cb9f35e89a.png"
alt="How To Disable Network Access" width="240" height="142" border="10" /><br/>How To Disable Network Access</a>
</td>

<td>
<a href="https://odysee.com/@netblue30:9/divested:2" target="_blank">
<img src="https://thumbs.odycdn.com/f30ece33a6547af9ae48244f4ba73028.png"
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

Video Channel: https://odysee.com/@netblue30:9?order=new

Backup Video Channel: https://www.bitchute.com/profile/JSBsA1aoQVfW/

## Security vulnerabilities

We take security bugs very seriously. If you believe you have found one, please report it by emailing us at netblue30@protonmail.com

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

Firejail is included in a large number of Linux distributions.

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

## Latest released version: 0.9.70

## Current development version: 0.9.71

Milestone page: https://github.com/netblue30/firejail/milestone/1

### Restrict namespaces

`````
       --restrict-namespaces
              Install a seccomp filter that  blocks  attempts  to  create  new
              cgroup, ipc, net, mount, pid, time, user or uts namespaces.

              Example:
              $ firejail --restrict-namespaces

       --restrict-namespaces=cgroup,ipc,net,mnt,pid,time,user,uts
              Install  a  seccomp filter that blocks attempts to create any of
              the specified namespaces. The filter examines the  arguments  of
              clone, unshare and setns system calls and returns error EPERM to
              the process (or kills it or logs the attempt, see  --seccomp-er‐
              ror-action below) if necessary. Note that the filter is not able
              to examine the arguments of clone3 system calls, and always  re‐
              sponds to these calls with error ENOSYS.

              Example:
              $ firejail --restrict-namespaces=user,net
`````

#### Support for custom AppArmor profiles

`````
      --apparmor
              Enable AppArmor confinement with the "firejail-default" AppArmor
              profile.   For more information, please see APPARMOR section be‐
              low.

       --apparmor=profile_name
              Enable AppArmor confinement  with  a  custom  AppArmor  profile.
              Note  that  profile  in question must already be loaded into the
              kernel.  For more information, please see APPARMOR  section  be‐
`````

### Profile Statistics

A small tool to print profile statistics. Compile and install as usual. The tool is installed in /usr/lib/firejail directory.
Run it over the profiles in /etc/profiles:
```
$ /usr/lib/firejail/profstats /etc/firejail/*.profile
No include .local found in /etc/firejail/noprofile.profile
Warning: multiple caps in /etc/firejail/transmission-daemon.profile

Stats:
    profiles			1191
    include local profile	1190   (include profile-name.local)
    include globals		1164   (include globals.local)
    blacklist ~/.ssh		1063   (include disable-common.inc)
    seccomp			1082
    capabilities		1185
    noexec			1070   (include disable-exec.inc)
    noroot			991
    memory-deny-write-execute	267
    apparmor			710
    private-bin			689
    private-dev			1041
    private-etc			539
    private-lib			70
    private-tmp			915
    whitelist home directory	573
    whitelist var		855   (include whitelist-var-common.inc)
    whitelist run/user		1159   (include whitelist-runuser-common.inc
					or blacklist ${RUNUSER})
    whitelist usr/share		628   (include whitelist-usr-share-common.inc
    net none			403
    dbus-user none 		673
    dbus-user filter 		123
    dbus-system none 		833
    dbus-system filter 		12
```

### New profiles:

onionshare, onionshare-cli, opera-developer, songrec, gdu, makedeb
