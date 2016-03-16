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
       These features allow the user to inspect the file system  container  of
       an  existing  sandbox and transfer files from the container to the host
       file system.

       --get=name filename
              Retrieve the container file and store it on the host in the cur‐
              rent  working  directory.   The container is spececified by name
              (--name option). Full path is needed for filename.

       --get=pid filename
              Retrieve the container file and store it on the host in the cur‐
              rent working directory.  The container is spececified by process
              ID. Full path is needed for filename.

       --ls=name dir_or_filename
              List container files.  The  container  is  spececified  by  name
              (--name option).  Full path is needed for dir_or_filename.

       --ls=pid dir_or_filename
              List  container  files.  The container is spececified by process
              ID.  Full path is needed for dir_or_filename.

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

lxterminal, Epiphany, cherrytree, Battle for Wesnoth, Hedgewars, qutebrowser, SlimJet

