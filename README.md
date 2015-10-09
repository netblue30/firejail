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



## Known Problems

### PulseAudio 7.0

The srbchannel IPC mechanism, introduced in PulseAudio 6.0, was enabled by default in release 7.0.
Arch Linux users are reporting sound problems when running applications in Firejail sandbox.
A preliminary fix was introduced on master branch. The fix disables PulseAudio shared memory functionality
inside the sandbox. If you are seeing any problems,
please let us know here: https://github.com/netblue30/firejail/issues/69

If you are unable to update Firejail, or if you want to continue using the lates released version, these are some workarounds:

*   Running ALSA

    By default, if Firefox fails to connect to PulseAudio, it will connect directly to ALSA.
    Also by default, ALSA comes with the sound volume down. You would need to install *alsamixer*
    (*alsa-utils* package) or *gnome-alsamixer*, run it, and crank up the volume (both Master and PCM).
 
*  Disable shm functionality in PulseAudio
`````
$ mkdir -p ~/.config/pulse
$ cd ~/.config/pulse
$ cp /etc/pulse/client.conf .
$ echo "enable-shm = no" >> client.conf
`````
* Disable srbchannel IPC mechanism in version 7.0

    Edit /etc/pulse/default.pa – change the line "load-module module-native-protocol-unix"
    to "load-module module-native-protocol-unix srbchannel=no" and restart PulseAudio daemon.


