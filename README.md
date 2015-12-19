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

## Development version 0.9.35

### The project has moved to a new home: https://firejail.wordpress.com/

### New security profiles:
New profiles introduced in this version: unbound, dnscrypt-proxy, BitlBee, HexChat, WeeChat,
google-chrome-stable, google-chrome-beta, google-chrome-unstable, opera-beta

### --noblacklist
`````
      --noblacklist=dirname_or_filename
              Disable blacklist for this directory or file.

              Example:
              $ firejail
              $ nc dict.org 2628
              bash: /bin/nc: Permission denied
              $ exit

              $ firejail --noblacklist=/bin/nc
              $ nc dict.org 2628
              220 pan.alephnull.com dictd 1.12.1/rf on Linux 3.14-1-amd64
`````

### --whitelist

Whitelist command accepts files in user home, /dev, /media, /var, and /tmp directories.

### --tracelog

Tracelog command enables auditing blacklisted files and directories. A message
is sent to syslog in case the file or the directory is accessed. Example:
`````
$ firejail --tracelog firefox
`````
Syslog example:
`````
$ sudo tail -f /var/log/syslog
[...]
Dec  3 11:43:25 debian firejail[70]: blacklist violation - sandbox 26370, exe firefox,
   syscall open64, path /etc/shadow
Dec  3 11:46:17 debian firejail[70]: blacklist violation - sandbox 26370, exe firefox,
   syscall opendir, path /boot
[...]
`````
Tracelog is enabled by default in several profile files.

### --profile-path
For  various reasons some users might want to keep the profile files in
a different directory.  Using --profile-path command line option,
Firejail can be instructed to look for profiles into this directory.

This  is  an  example of relocating the profile files into a new directory,
/home/netblue/myprofiles. Start by creating the new directory and
copy all the profile files in:
`````
$ mkdir ~/myprofiles && cd ~/myprofiles && cp /etc/firejail/* .
`````
Using sed utility, modify the absolute paths for include commands:
`````
$ sed -i "s/\/etc\/firejail/\/home\/netblue\/myprofiles/g" *.profile
$ sed -i "s/\/etc\/firejail/\/home\/netblue\/myprofiles/g" *.inc
`````
Start Firejail using the new path:
`````
$ firejail --profile-path=~/myprofiles
`````

### --force

This option allows the user to start a sandbox inside an existing sandbox. It is mainly used for running
Firejail inside a Docker container.

### Debian reproducible build

### Added "name" and "hostname" command support in profile files
