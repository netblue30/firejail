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
## User submitted profile repositories

If you keep your Firejail profiles in a public repository, please give us a link:

* https://github.com/chiraag-nataraj/firejail-profiles
`````

`````
# Current development version: 0.9.43

## New command line options
`````
      --x11=block
              Blacklist  /tmp/.X11-unix  directory,  ${HOME}/.Xauthority  and  file
              specified in ${XAUTHORITY} enviroment variable.  Remove  DISPLAY  and
              XAUTHORITY  enviroment  variables.   Stop  with  error message if X11
              abstract socket will be accessible in jail.

      --put=name|pid src-filename dest-filename
              Put src-filename in sandbox container.  The container is specified by name or PID.

       --allusers
              All user home directories are visible inside the sandbox. By default, only current user home
              directory is visible.

              Example:
              $ firejail --allusers

       --join-or-start=name
              Join the sandbox identified by name or start a new one.  Same as "firejail  --join=name"  if
              sandbox with specified name exists, otherwise same as "firejail --name=name ..."
              Note that in contrary to other join options there is respective profile option.

      --no3d Disable 3D hardware acceleration.

              Example:
              $ firejail --no3d firefox

      --veth-name=name
              Use this name for the interface  connected  to  the  bridge  for
              --net=bridge_interface commands, instead of the default one.

              Example:
              $ firejail --net=br0 --veth-name=if0

`````

## New profile commands

x11 xpra, x11 xephyr, x11 block, allusers, join-or-start

## New profiles

qpdfview, mupdf, Luminance HDR, Synfig Studio, Gimp, Inkscape, feh, ranger, zathura, 7z, term, keepassx, keepass

