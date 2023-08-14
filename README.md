# Firejail

[![Build (GitLab)](https://gitlab.com/Firejail/firejail_ci/badges/master/pipeline.svg)](https://gitlab.com/Firejail/firejail_ci/pipelines)
[![Build (GitHub)](https://github.com/netblue30/firejail/workflows/Build/badge.svg)](https://github.com/netblue30/firejail/actions?query=workflow%3ABuild)
[![CodeQL](https://github.com/netblue30/firejail/workflows/CodeQL/badge.svg)](https://github.com/netblue30/firejail/actions?query=workflow%3ACodeQL)
[![Packaging status (Repology)](https://repology.org/badge/tiny-repos/firejail.svg)](https://repology.org/project/firejail/versions)

Firejail is a SUID sandbox program that reduces the risk of security breaches
by restricting the running environment of untrusted applications using Linux
namespaces, seccomp-bpf and Linux capabilities.  It allows a process and all
its descendants to have their own private view of the globally shared kernel
resources, such as the network stack, process table, mount table.  Firejail can
work in a SELinux or AppArmor environment, and it is integrated with Linux
Control Groups.

Written in C with virtually no dependencies, the software runs on any Linux
computer with a 3.x kernel version or newer.  It can sandbox any type of
processes: servers, graphical applications, and even user login sessions.  The
software includes sandbox profiles for a number of more common Linux programs,
such as Mozilla Firefox, Chromium, VLC, Transmission etc.

The sandbox is lightweight, the overhead is low.  There are no complicated
configuration files to edit, no socket connections open, no daemons running in
the background.  All security features are implemented directly in Linux kernel
and available on any Linux computer.

## Videos

<table>
<tr>

<td>
<a href="https://odysee.com/@netblue30:9/firefox:c" target="_blank">
<img src="https://thumbs.odycdn.com/acf4b1c66737feb97640fb1d28a7daa6.png"
alt="Advanced Browser Security" width="240" height="142" border="10" />
<br/>Advanced Browser Security
</a>
</td>

<td>
<a href="https://odysee.com/@netblue30:9/nonet:7" target="_blank">
<img src="https://thumbs.odycdn.com/5be2964201c31689ee8f78cb9f35e89a.png"
alt="How To Disable Network Access" width="240" height="142" border="10" />
<br/>How To Disable Network Access
</a>
</td>

<td>
<a href="https://odysee.com/@netblue30:9/divested:2" target="_blank">
<img src="https://thumbs.odycdn.com/f30ece33a6547af9ae48244f4ba73028.png"
alt="Deep Dive" width="240" height="142" border="10" />
<br/>Deep Dive
</a>
</td>

</tr>
</table>

## Links

* Project webpage: <https://firejail.wordpress.com/>
* IRC: <https://web.libera.chat/#firejail>
* Download and Installation: <https://firejail.wordpress.com/download-2/>
* Features: <https://firejail.wordpress.com/features-3/>
* Documentation: <https://firejail.wordpress.com/documentation-2/>
* FAQ: <https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions>
* Wiki: <https://github.com/netblue30/firejail/wiki>
* GitHub Actions: <https://github.com/netblue30/firejail/actions>
* GitLab CI: <https://gitlab.com/Firejail/firejail_ci/pipelines>
* Video Channel: <https://odysee.com/@netblue30:9?order=new>
* Backup Video Channel: <https://www.bitchute.com/profile/JSBsA1aoQVfW/>

## Security vulnerabilities

See [SECURITY.md](SECURITY.md).

## Installing

### Debian

Debian stable (bullseye): We recommend to use the
[backports](https://packages.debian.org/bullseye-backports/firejail) package.

### Ubuntu

For Ubuntu 18.04+ and derivatives (such as Linux Mint), users are **strongly
advised** to use the
[PPA](https://launchpad.net/~deki/+archive/ubuntu/firejail).

How to add and install from the PPA:

```sh
sudo add-apt-repository ppa:deki/firejail
sudo apt-get update
sudo apt-get install firejail firejail-profiles
```

Reason: The firejail package for Ubuntu 20.04 has been left vulnerable to
CVE-2021-26910 for months after a patch for it was posted on Launchpad:

* [CVE-2021-26910](https://github.com/advisories/GHSA-2q4h-h5jp-942w)
* [firejail version in Ubuntu 20.04 LTS is vulnerable to
  CVE-2021-26910](https://bugs.launchpad.net/ubuntu/+source/firejail/+bug/1916767)

See also <https://wiki.ubuntu.com/SecurityTeam/FAQ>:

> What software is supported by the Ubuntu Security team?
>
> Ubuntu is currently divided into four components: main, restricted, universe
> and multiverse.  All binary packages in main and restricted are supported by
> the Ubuntu Security team for the life of an Ubuntu release, while binary
> packages in universe and multiverse are supported by the Ubuntu community.

Additionally, the PPA version is likely to be more recent and to contain more
profile fixes.

See the following discussions for details:

* [Should I keep using the version of firejail available in my distro
  repos?](https://github.com/netblue30/firejail/discussions/4666)
* [How to install the latest version on Ubuntu and
  derivatives](https://github.com/netblue30/firejail/discussions/4663)

### Other

Firejail is available in multiple Linux distributions:

<details>
<summary>Repology</summary>
<p>

[![Packaging status (Repology)](https://repology.org/badge/vertical-allrepos/firejail.svg)](https://repology.org/project/firejail/versions)

</p>
</details>

Other than the [aforementioned exceptions](#installing), as long as your
distribution provides a [supported version](SECURITY.md) of firejail, it's
generally a good idea to install it from the distribution.

The version can be checked with `firejail --version` after installing.

You can also install one of the [released
packages](https://github.com/netblue30/firejail/releases).

Or clone the source code from our git repository and build manually:

```sh
git clone https://github.com/netblue30/firejail.git
cd firejail
./configure && make && sudo make install-strip
```

On Debian/Ubuntu you will need to install git and gcc.  AppArmor development
libraries and pkg-config are required when using the `--enable-apparmor`
./configure option:

```sh
sudo apt-get install git build-essential libapparmor-dev pkg-config gawk
```

For `--selinux` option, add libselinux1-dev (libselinux-devel for Fedora).

Detailed information on using firejail from git is available on the
[wiki](https://github.com/netblue30/firejail/wiki/Using-firejail-from-git).

## Running the sandbox

To start the sandbox, prefix your command with `firejail`:

```sh
firejail firefox            # starting Mozilla Firefox
firejail transmission-gtk   # starting Transmission BitTorrent
firejail vlc                # starting VideoLAN Client
sudo firejail /etc/init.d/nginx start
```

Run `firejail --list` in a terminal to list all active sandboxes.  Example:

```console
$ firejail --list
1617:netblue:/usr/bin/firejail /usr/bin/firefox-esr
7719:netblue:/usr/bin/firejail /usr/bin/transmission-qt
7779:netblue:/usr/bin/firejail /usr/bin/galculator
7874:netblue:/usr/bin/firejail /usr/bin/vlc --started-from-file file:///home/netblue/firejail-whitelist.mp4
7916:netblue:firejail --list
```

## Desktop integration

Integrate your sandbox into your desktop by running the following two commands:

```sh
firecfg --fix-sound
sudo firecfg
```

The first command solves some shared memory/PID namespace bugs in PulseAudio
software prior to version 9.  The second command integrates Firejail into your
desktop.  You would need to logout and login back to apply PulseAudio changes.

Start your programs the way you are used to: desktop manager menus, file
manager, desktop launchers.

The integration applies to any program supported by default by Firejail.  There
are over 900 default applications in the current Firejail version, and the
number goes up with every new release.

We keep the application list in
[src/firecfg/firecfg.config](src/firecfg/firecfg.config)
(/etc/firejail/firecfg.config when installed).

## Security profiles

Most Firejail command line options can be passed to the sandbox using profile
files.

You can find the profiles for all supported applications in [etc/](etc/)
(/etc/firejail/ when installed).

We also keep a list of profile fixes for previous released versions in
[etc-fixes/](etc-fixes/).

If you keep additional Firejail security profiles in a public repository,
please give us a link:

* <https://github.com/chiraag-nataraj/firejail-profiles>
* <https://github.com/triceratops1/fe>

Use this issue to request new profiles:

* [Profile requests](https://github.com/netblue30/firejail/issues/1139)

You can also use this tool to get a list of syscalls needed by a program:

* [contrib/syscalls.sh](contrib/syscalls.sh)

## Uninstalling

firecfg creates symlinks in /usr/local/bin, so to fully remove firejail, run
the following before uninstalling:

```sh
sudo firecfg --clean
```

See `man firecfg` for details.

Note: Broken symlinks are ignored when searching for an executable in `$PATH`,
so uninstalling without doing the above should not cause issues.

## Latest released version: 0.9.72

## Current development version: 0.9.73

### --keep-shell-rc

```text
       --keep-shell-rc
              By default, when using a private home directory, firejail copies
              files  from the system's user home template (/etc/skel) into it,
              which overrides attempts to whitelist the original  files  (such
              as  ~/.bashrc and ~/.zshrc).  This option disables this feature,
              and enables the user to whitelist the original files.
```

### private-etc rework

```text
       --private-etc, --private-etc=file,directory,@group
              The files installed by --private-etc are copies of the original
              system files from /etc directory.  By default, the command
              brings in a skeleton of files and directories used by most
              console tools:

              $ firejail --private-etc dig debian.org

              For X11/GTK/QT/Gnome/KDE  programs add @x11 group as a
              parameter. Example:

              $ firejail --private-etc=@x11,gcrypt,python* gimp

              gcrypt and /etc/python* directories are not part of the generic
              @x11 group.  File globbing is supported.

              For games, add @games group:

              $ firejail --private-etc=@games,@x11 warzone2100

              Sound and networking files are included automatically, unless
              --nosound or --net=none are specified.  Files for encrypted
              TLS/SSL protocol are in @tls-ca group.

              $ firejail --private-etc=@tls-ca,wgetrc wget https://debian.org

              Note: The easiest way to extract the list of /etc files accessed
              by your program is using strace utility:

              $ strace /usr/bin/transmission-qt 2>&1 | grep open | grep etc
```

We keep the list of groups in
[src/include/etc_groups.h](src/include/etc_groups.h).

Discussion:

* [private-etc rework](https://github.com/netblue30/firejail/discussions/5610)

### Profile Statistics

A small tool to print profile statistics.  Compile and install as usual.  The
tool is installed in the /usr/lib/firejail directory.

Run it over the profiles in /etc/profiles:

```console
$ /usr/lib/firejail/profstats /etc/firejail/*.profile
No include .local found in /etc/firejail/noprofile.profile
Warning: multiple caps in /etc/firejail/transmission-daemon.profile

Stats:
    profiles			1209
    include local profile	1208   (include profile-name.local)
    include globals		1181   (include globals.local)
    blacklist ~/.ssh		1079   (include disable-common.inc)
    seccomp			1096
    capabilities		1202
    noexec			1087   (include disable-exec.inc)
    noroot			1003
    memory-deny-write-execute	272
    restrict-namespaces		958
    apparmor			753
    private-bin			704
    private-dev			1058
    private-etc			550
    private-lib			71
    private-tmp			932
    whitelist home directory	585
    whitelist var		870   (include whitelist-var-common.inc)
    whitelist run/user		1176   (include whitelist-runuser-common.inc
					or blacklist ${RUNUSER})
    whitelist usr/share		640   (include whitelist-usr-share-common.inc
    net none			410
    dbus-user none 		679
    dbus-user filter 		141
    dbus-system none 		851
    dbus-system filter 		12
```
