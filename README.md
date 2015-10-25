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

### Enable whitelists in Firefox default profile

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
`````

I intend to bring in all files and directories used by Firefox addons and plugins. So far I have
[Video DownloadHelper](https://addons.mozilla.org/en-US/firefox/addon/video-downloadhelper/),
[Zotero](https://www.zotero.org/download/) and
[LastPass](https://addons.mozilla.org/en-US/firefox/addon/lastpass-password-manager/).
If you're using a anything else, please let me know.
