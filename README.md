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
# Current development version: 0.9.39
`````

`````

## X11 sandboxing support

X11 support is built around Xpra (http://xpra.org/).
So far I've seen it working on Debian 7 and 8, and Ubuntu 14.04. If you manage to run it on another
distribution, please let me know. Example:
`````
$ firejail --x11 --net=eth0 firefox
`````
--x11 starts the server, --net is required in order to remove the main X11 server socket from the sandbox.
More information here: https://firejail.wordpress.com/documentation-2/x11-guide/

## File transfers
`````
FILE TRANSFER
       These features allow the user to inspect the filesystem container of an
       existing sandbox and transfer files from  the  container  to  the  host
       filesystem.

       --get=name filename
              Retrieve the container file and store it on the host in the cur‐
              rent working directory.  The  container  is  specified  by  name
              (--name option). Full path is needed for filename.

       --get=pid filename
              Retrieve the container file and store it on the host in the cur‐
              rent working directory.  The container is specified  by  process
              ID. Full path is needed for filename.

       --ls=name dir_or_filename
              List  container  files.   The  container  is  specified  by name
              (--name option).  Full path is needed for dir_or_filename.

       --ls=pid dir_or_filename
              List container files.  The container is specified by process ID.
              Full path is needed for dir_or_filename.

       Examples:

              $ firejail --name=mybrowser --private firefox

              $ firejail --ls=mybrowser ~/Downloads
              drwxr-xr-x netblue  netblue         4096 .
              drwxr-xr-x netblue  netblue         4096 ..
              -rw-r--r-- netblue  netblue         7847 x11-x305.png
              -rw-r--r-- netblue  netblue         6800 x11-x642.png
              -rw-r--r-- netblue  netblue        34139 xpra-clipboard.png

              $ firejail --get=mybrowser ~/Downloads/xpra-clipboard.png
`````

## Firecfg
`````
NAME
       Firecfg - Desktop configuration program for Firejail software.

SYNOPSIS
       firecfg [OPTIONS]

DESCRIPTION
       Firecfg is the desktop configuration utility for Firejail software. The
       utility creates several symbolic links  to  firejail  executable.  This
       allows the user to sandbox applications automatically, just by clicking
       on a regular desktop menus and icons.

       The symbolic links are placed in /usr/local/bin. For more  information,
       see DESKTOP INTEGRATION section in man 1 firejail.

OPTIONS
       --clear
              Clear all firejail symbolic links

       -?, --help
              Print options end exit.

       --list List all firejail symbolic links

       --version
              Print program version and exit.

       Example:

       $ sudo firecfg
       /usr/local/bin/firefox created
       /usr/local/bin/vlc created
       [...]
       $ firecfg --list
       /usr/local/bin/firefox
       /usr/local/bin/vlc
       [...]
       $ sudo firecfg --clear
       /usr/local/bin/firefox removed
       /usr/local/bin/vlc removed
       [...]
`````


## Compile time and run time configuration support

Most Linux kernel security features require root privileges during configuration.
The same is true for kernel networking features. Firejail (SUID binary) opens the 
access to these features to regular users. The privilege escalation is restricted 
to the sandbox being configured, and is not extended to the rest of the system. 
This arrangement works fine for user desktops or servers where the access is already limited.

If you not happy with a particular feature, all the support can be eliminated from SUID binary at compile time,
or at run time by editing /etc/firejail/firejail.config file.

The following features can be enabled or disabled:
`````
       secomp Enable or disable seccomp support, default enabled.

       chroot Enable or disable chroot support, default enabled.

       bind   Enable or disable bind support, default enabled.

       network
              Enable or disable networking features, default enabled.

       restricted-network
              Enable  or disable restricted network support, default disabled.
              If enabled, networking features should also be enabled  (network
              yes).   Restricted  networking  grants access to --interface and
              --net=ethXXX only to root user. Regular users are  only  allowed
              --net=none.

       userns Enable or disable user namespace support, default enabled.

       x11    Enable or disable X11 sandboxing support, default enabled.

       file-transfer
              Enable or disable file transfer support, default enabled.
`````

## Default seccomp filter update

Currently 50 syscalls are blacklisted by default, out of a total of 318 calls (AMD64, Debian Jessie).

## STUN/WebRTC disabled in default netfilter configuration

The  current netfilter configuration (--netfilter option) looks like this:
`````
             *filter
              :INPUT DROP [0:0]
              :FORWARD DROP [0:0]
              :OUTPUT ACCEPT [0:0]
              -A INPUT -i lo -j ACCEPT
              -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
              # allow ping
              -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
              -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
              -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
              # drop STUN (WebRTC) requests
              -A OUTPUT -p udp --dport 3478 -j DROP
              -A OUTPUT -p udp --dport 3479 -j DROP
              -A OUTPUT -p tcp --dport 3478 -j DROP
              -A OUTPUT -p tcp --dport 3479 -j DROP
              COMMIT
`````

The filter is loaded by default for Firefox if a network namespace is configured:
`````
$ firejail --net=eth0 firefox
`````

## Set sandbox nice value
`````
      --nice=value
              Set nice value for all processes running inside the sandbox.

              Example:
              $ firejail --nice=-5 firefox
`````

## mkdir

`````
$ man firejail-profile
[...]
       mkdir directory
              Create   a   directory  in  user  home.  Use  this  command  for
              whitelisted directories you need to preserve when the sandbox is
              closed.  Subdirectories  also  need  to  be created using mkdir.
              Example from firefox profile:

              mkdir ~/.mozilla
              whitelist ~/.mozilla
              mkdir ~/.cache
              mkdir ~/.cache/mozilla
              mkdir ~/.cache/mozilla/firefox
              whitelist ~/.cache/mozilla/firefox

[...]
`````

## New security profiles
lxterminal, Epiphany, cherrytree, Polari, Vivaldi, Atril, qutebrowser, SlimJet, Battle for Wesnoth, Hedgewars, qTox

