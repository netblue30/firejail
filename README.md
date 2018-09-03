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

FAQ: https://firejail.wordpress.com/support/frequently-asked-questions/

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
# Current development version: 0.9.55

## New commands:
`````
      (wireless support for --net)
      --net=ethernet_interface|wireless_interface
              Enable a new network namespace and connect it to this  ethernet
              interface  using  the  standard  Linux  macvlan|ipvaln  driver.
              Unless specified  with  option  --ip  and  --defaultgw,  an  IP
              address and a default gateway will be assigned automatically to
              the sandbox. The  IP  address  is  verified  using  ARP  before
              assignment.  The  address  configured as default gateway is the
              default gateway of the host. Up to four --net  options  can  be
              specified.   Support  for ipvlan driver was introduced in Linux
              kernel 3.19.

              Example:
              $ firejail --net=eth0 --ip=192.168.1.80 --dns=8.8.8.8 firefox
              $ firejail --net=wlan0 firefox

       (tunneling support)
       --net=tap_interface
              Enable a new network namespace and connect it to this  ethernet
              tap  interface  using the standard Linux macvlan driver. If the
              tap interface is not configured, the sandbox will  not  try  to
              configure  the  interface inside the sandbox.  Please use --ip,
              --netmask and --defaultgw to specify the configuration.

              Example:
              $ firejail --net=tap0 --ip=10.10.20.80  --netmask=255.255.255.0
              --defaultgw=10.10.20.1 firefox

       --netmask=address
              Use this option when you want to assign an IP address in a  new
              namespace  and  the  parent interface specified by --net is not
              configured. An IP address and  a  default  gateway  address
              also  have  to be added. By default the new namespace interface
              comes without IP address and default gateway configured.  Exam‐
              ple:

              $ sudo /sbin/brctl addbr br0
              $ sudo /sbin/ifconfig br0 up
              $     firejail     --ip=10.10.20.67     --netmask=255.255.255.0
              --defaultgw=10.10.20.1

       --keep-dev-shm
              /dev/shm directory is untouched (even with --private-dev)

              Example:
              $ firejail --keep-dev-shm --private-dev

       --nou2f
              Disable U2F devices.

              Example:
              $ firejail --nou2f

       --private-cache
               Mount an empty temporary filesystem on top of the .cache
               directory in user home. All modifications are discarded
               when the sandbox is closed.

              Example:
              $ firejail --private-cache
`````

## New profiles
Microsoft Office Online, riot-desktop, gnome-mpv, snox, gradio, standardnotes-desktop,
shellcheck, patch, flameshot, rview, rvim, vimcat, vimdiff, vimpager, vimtutor,
xxd, Beaker, electrum, clamtk, pybitmessage, dig, whois, jdownloader,
Fluxbox, Blackbox, Awesome, i3

