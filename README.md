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
$ sudo firejail "/etc/init.d/nginx start && sleep inf"
`````
Project webpage: https://l3net.wordpress.com/projects/firejail/

Download and Installation: https://l3net.wordpress.com/projects/firejail/firejail-download-and-install/

Features: https://l3net.wordpress.com/projects/firejail/firejail-features/

Usage: https://l3net.wordpress.com/projects/firejail/firejail-usage/

FAQ: https://l3net.wordpress.com/projects/firejail/firejail-faq/



## New features in the development version

### Whitelisting in default Firefox profile

The next release will bring in default whitelisting for Firefox files and folders under /home/user.
If you start the sandbox without any other options, this is what you'll get:

![Whitelisted home directory](firefox-whitelist.png?raw=true)

The code is located in etc/firefox.inc file:

`````
whitelist ~/.mozilla
whitelist ~/Downloads
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.lastpass
whitelist ~/.gtkrc-2.0
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
`````

I intend to bring in all files and directories used by Firefox addons and plugins. So far I have
[Video DownloadHelper](https://addons.mozilla.org/en-US/firefox/addon/video-downloadhelper/),
[Zotero](https://www.zotero.org/download/), 
[LastPass](https://addons.mozilla.org/en-US/firefox/addon/lastpass-password-manager/),
[Vimperator](https://addons.mozilla.org/en-US/firefox/addon/vimperator/)
and [Pentadactyl](http://5digits.org/pentadactyl/)
If you're using a anything else, please let me know.

### Whitelisting in default Chromium profile

![Whitelisted home directory](chromium-whitelist.png?raw=true)

### --ignore option

Ignore commands in profile files. Example:
`````
$ firejail --ignore=seccomp wine
`````

### --protocol option

Enable protocol filter. It is based on seccomp and it filters the first argument to socket system call.
If the value is not recognized, seccomp will kill the process.
Valid values: unix, inet, inet6, netlink and packet.

Example:
`````
$ firejail --protocol=unix,inet,inet6
`````

"unix" describes the regular Unix socket connections,
and "inet" and "inet6" describe the regular IPv4 and IPv6 traffic. Most GUI applications need "unix,inet,inet6". "netlink" is the protocol
used to talk to Linux kernel. You'll only need this for applications such as [iproute2](http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2)
used in system administration, and "packet" is used by sniffers to talk directly with the Ethernet layer.

Protocol filter is enabled in all default security profiles for GUI applications ("protocol unix,inet,inet6").

### Dual i386/amd64 seccomp filter

--seccomp option now installs a dual i386/amd64 default filter.
32bit applications, such as Skype, running on regular 64bit computers, are protected by i386 seccomp filter.

### New security profiles

Steam, Skype, Wine. The dual seccomp filter is enabled by default for these applications.


