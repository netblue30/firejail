# Firejail
[![Test Status](https://travis-ci.org/netblue30/firejail.svg?branch=master)](https://travis-ci.org/netblue30/firejail)
[![Build Status](https://gitlab.com/Firejail/firejail_ci/badges/master/pipeline.svg)](https://gitlab.com/Firejail/firejail_ci/pipelines/)
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
alt="Firejail Intro video" width="240" height="180" border="10" /><br/>Firejail Intro</a>
</td>

<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=J1ZsXrpAgBU
" target="_blank"><img src="http://img.youtube.com/vi/J1ZsXrpAgBU/0.jpg"
alt="Firejail Intro video" width="240" height="180" border="10" /><br/>Firejail Demo</a>
</td>

<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=EyEz65RYfw4
" target="_blank"><img src="http://img.youtube.com/vi/EyEz65RYfw4/0.jpg"
alt="Firejail Intro video" width="240" height="180" border="10" /><br/>Debian Install</a>
</td>


</tr><tr>
<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Uy2ZTHc4s0w
" target="_blank"><img src="http://img.youtube.com/vi/Uy2ZTHc4s0w/0.jpg"
alt="Firejail Intro video" width="240" height="180" border="10" /><br/>Arch Linux Install</a>

</td>
<td>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=xuMxRx0zSfQ
" target="_blank"><img src="http://img.youtube.com/vi/xuMxRx0zSfQ/0.jpg"
alt="Firejail Intro video" width="240" height="180" border="10" /><br/>Disable Network Access</a>

</td>
</tr></table>

Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions

Wiki: https://github.com/netblue30/firejail/wiki

Travis-CI status: https://travis-ci.org/netblue30/firejail

GitLab-CI status: https://gitlab.com/Firejail/firejail_ci/pipelines/


## Security vulnerabilities

We take security bugs very seriously. If you believe you have found one, please report it by emailing us at netblue30@yahoo.com

## Compile and install
`````
$ git clone https://github.com/netblue30/firejail.git
$ cd firejail
$ ./configure && make && sudo make install-strip
`````
On Debian/Ubuntu you will need to install git and gcc compiler. AppArmor
development libraries and pkg-config are required when using --apparmor
./configure option:
`````
$ sudo apt-get install git build-essential libapparmor-dev pkg-config
`````
For --selinux option, add libselinux1-dev (libselinux-devel for Fedora).

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
## Latest released version: 0.9.62

## Current development version: 0.9.63

### Profile Statistics

A small tool to print profile statistics. Compile as usual and run:
`````
$ make
$ cd etc
$ ./profstats *.profile
Stats:
    profiles			949
    include local profile	949   (include profile-name.local)
    include globals		949   (include globals.local)
    blacklist ~/.ssh		934   (include disable-common.inc)
    seccomp			892
    capabilities		948
    noexec			813   (include disable-exec.inc)
    apparmor			471
    private-dev			812
    private-tmp			711
    whitelist var		621   (include whitelist-var-common.inc)
    whitelist run/user		105   (include whitelist-runuser-common.inc)
    whitelist usr/share		257   (include whitelist-usr-share-common.inc)
    net none			297
`````

Run ./profstats -h for help.

### New profiles:

gfeeds, firefox-x11, tvbrowser, rtv, clipgrab, gnome-passwordsafe, bibtex, gummi, latex, pdflatex, tex, wpp, wpspdf, wps, et, multimc, gnome-hexgl, com.github.johnfactotum.Foliate, desktopeditors, impressive, mupdf-gl, mupdf-x11, mupdf-x11-curl, muraster, mutool, planmaker18, planmaker18free, presentations18, presentations18free, textmaker18, textmaker18free, teams, xournal,
gnome-screenshot, ripperX, sound-juicer, iagno, com.github.dahenson.agenda, gnome-pomodoro, gnome-todo, kmplayer, penguin-command, x2goclient, frogatto, gnome-mines, gnome-nibbles, lightsoff, ts3client_runscript.sh, warmux, ferdi, abiword, four-in-a-row, gnome-mahjongg, gnome-robots, gnome-sudoku, gnome-taquin, gnome-tetravex
