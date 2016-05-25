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
# Current development version: 0.9.40~rc2
Version 0.9.40-rc1 released!

## X11 sandboxing support

X11 support is built around Xpra (http://xpra.org/) or Xephyr.
`````
       --x11  Start a new X11 server using Xpra or Xephyr and attach the sand‐
              box to this server.  The regular X11 server (display 0)  is  not
              visible  in  the sandbox. This prevents screenshot and keylogger
              applications started in the sandbox  from  accessing  other  X11
              displays.  A network namespace needs to be instantiated in order
              to deny access to X11 abstract Unix domain socket.

              Firejail will try first Xpra, and if Xpra is  not  installed  on
              the  system,  it  will  try to find Xephyr.  This feature is not
              available when running as root.

              Example:
              $ firejail --x11 --net=eth0 firefox

       --x11=xpra
              Start a new X11 server using Xpra (http://xpra.org)  and  attach
              the sandbox to this server.  Xpra is a persistent remote display
              server and client for forwarding X11  applications  and  desktop
              screens.  On Debian platforms Xpra is installed with the command
              sudo apt-get install xpra.  This feature is not  available  when
              running as root.

              Example:
              $ firejail --x11 --net=eth0 firefox

       --x11=xephyr
              Start  a  new  X11 server using Xephyr and attach the sandbox to
              this server.  Xephyr is a display server  implementing  the  X11
              display  server protocol.  It runs in a window just like other X
              applications, but it is an X server itself in which you can  run
              other software.  The default Xephyr window size is 800x600. This
              can be modified in /etc/firejail/firejail.config file, see man 5
              firejail-config for more details.

              The  recommended way to use this feature is to run a window man‐
              ager inside the sandbox.  A security profile for OpenBox is pro‐
              vided.  On Debian platforms Xephyr is installed with the command
              sudo apt-get install xserver-xephyr.  This feature is not avail‐
              able when running as root.

              Example:
              $ firejail --x11 --net=eth0 openbox
`````
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
       --clean
              Remove all firejail symbolic links

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
       $ sudo firecfg --clean
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
       bind   Enable or disable bind support, default enabled.

       chroot Enable or disable chroot support, default enabled.

       file-transfer
              Enable or disable file transfer support, default enabled.

       network
              Enable or disable networking features, default enabled.

       restricted-network
              Enable  or disable restricted network support, default disabled.
              If enabled, networking features should also be enabled  (network
              yes).  Restricted networking  grants access to --interface,
              --net=ethXXX and --netfilter only to root user.  Regular users
			  are only allowed --net=none.  Default disabled

       secomp Enable or disable seccomp support, default enabled.

       userns Enable or disable user namespace support, default enabled.

       x11    Enable or disable X11 sandboxing support, default enabled.

       xephyr-screen
              Screen    size    for   --x11=xephyr,   default   800x600.   Run
              /usr/bin/xrandr for a full list of resolutions available on your
              specific setup. Examples:

              xephyr-screen 640x480
              xephyr-screen 800x600
              xephyr-screen 1024x768
              xephyr-screen 1280x1024
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
lxterminal, Epiphany, cherrytree, Polari, Vivaldi, Atril, qutebrowser, SlimJet, Battle for Wesnoth, Hedgewars, qTox,
OpenSSH client, OpenBox window manager, Dillo, cmus, dnsmasq, PaleMoon, Icedove, abrowser, 0ad, netsurf,
Warzone2100, okular, gwenview, Gpredict, Aweather, Stellarium, Google-Play-Music-Desktop-Player, quiterss,
cyberfox, generic Ubuntu snap application profile, xplayer, xreader, xviewer, mcabber


