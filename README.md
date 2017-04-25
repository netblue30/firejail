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

[![About Firejail](video.png)](http://www.youtube.com/watch?v=Yk1HVPOeoTc)


Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://firejail.wordpress.com/support/frequently-asked-questions/

`````

`````
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

## User submitted profile repositories

If you keep your Firejail profiles in a public repository, please give us a link:

* https://github.com/chiraag-nataraj/firejail-profiles

* https://github.com/triceratops1/fe

Use this issue to request new profiles: https://github.com/netblue30/firejail/issues/1139
`````

`````
# Current development version: 0.9.45
`````

`````
## AppImage

Added AppImage type 2 support, and support for passing command line arguments to appimages.
`````

`````
## New command line options
`````
      --private-opt=file,directory
              Build  a  new /opt in a temporary filesystem, and copy the files
              and directories in the list.  If no listed file is  found,  /opt
              directory  will  be empty.  All modifications are discarded when
              the sandbox is closed.

              Example:
              $ firejail --private-opt=firefox /opt/firefox/firefox

       --private-srv=file,directory
              Build a new /srv in a temporary filesystem, and copy  the  files
              and  directories  in the list.  If no listed file is found, /srv
              directory will be empty.  All modifications are  discarded  when
              the sandbox is closed.

              Example:
              # firejail --private-srv=www /etc/init.d/apache2 start

      --machine-id
              Spoof id number in /etc/machine-id file - a  new  random  id  is
              generated inside the sandbox.

              Example:
              $ firejail --machine-id

       --allow-private-blacklist
              Allow  blacklisting  files in private home directory. By default
              these blacklists are disabled.

              Example:
              $   firejail    --allow-private-blacklist   --private=~/priv-dir
              --blacklist=~/.mozilla

      --hosts-file=file
              Use file as /etc/hosts.

              Example:
              $ firejail --hosts-file=~/myhosts firefox

      --writable-var-log
              Use the real /var/log directory, not  a  clone.  By  default,  a
              tmpfs  is  mounted  on top of /var/log directory, and a skeleton
              filesystem is created based on the original /var/log.

              Example:
              $ sudo firejail --writable-var-log

       --git-install
              Download, compile and install mainline git version  of  Firejail
              from  the  official  repository  on  GitHub.   The  software  is
              installed in /usr/local/bin, and takes precedence over the (old)
              version installed in /usr/bin. If for any reason the new version
              doesn't work, the user can uninstall  it  using  --git-uninstall
              command and revert to the old version.

              Prerequisites: git and compile support are required for this com‐
              mand to work. On Debian/Ubuntu systems this support is installed
              using "sudo apt-get install build-essential git".

              Example:

              $ firejail --git-install

       --git-uninstall
              Remove    the   Firejail   version   previously   installed   in
              /usr/local/bin using --git-install command.

              Example:

              $ firejail --git-uninstall

       --x11=xvfb
              Start  Xvfb  X11  server  and attach the sandbox to this server.
              Xvfb, short for X virtual framebuffer,  performs  all  graphical
              operations  in memory without showing any screen output. Xvfb is
              mainly used for remote access and software testing  on  headless
              servers.

              On Debian platforms Xvfb is installed with the command sudo apt-
              get install xvfb.  This feature is not available when running as
              root.

              Example: remote VNC access

              On  the  server we start a sandbox using Xvfb and openbox window
              manager. The default size of Xvfb screen is 800x600 - it can  be
              changed  in  /etc/firejail/firejail.config  (xvfb-screen).  Some
              sort of networking (--net) is required in order to  isolate  the
              abstract sockets used by other X servers.

              $ firejail --net=none --x11=xvfb openbox

              *** Attaching to Xvfb display 792 ***

              Reading profile /etc/firejail/openbox.profile
              Reading profile /etc/firejail/disable-common.inc
              Reading profile /etc/firejail/disable-common.local
              Parent pid 5400, child pid 5401

              On  the  server  we also start a VNC server and attach it to the
              display handled by our Xvfb server (792).

              $ x11vnc -display :792

              On the client machine we start a VNC viewer and use it  to  con‐
              nect to our server:

              $ vncviewer

       --nowhitelist=dirname_or_filename
              Disable whitelist for this directory or file.

`````
## New Profiles
xiphos, Tor Browser Bundle, display (imagemagik), Wire, mumble, zoom, Guayadeque, qemu, keypass2,
amarok, ark, atool, bleachbit, brasero, dolphin, dragon, elinks, enchant, exiftool, file-roller, gedit,
gjs, gnome-books, gnome-clocks, gnome-documents, gnome-maps, gnome-music, gnome-photos, gnome-weather,
goobox, gpa, gpg, gpg-agent, highlight, img2txt, k3b, kate, lynx, mediainfo, nautilus, odt2txt, pdftotext,
simple-scan, skanlite, ssh-agent, tracker, transmission-cli, transmission-show, w3m, xfburn, xpra, wget,
xed, pluma, Cryptocat, Bless, Gnome 2048, Gnome Calculator, Gnome Contacts, JD-GUI, Lollypop, MultiMC5,
PDFSam, Pithos, Xonotic, wireshark, keepassx2, QupZilla, FossaMail, Uzbl browser, xmms, iridium browser,
Kino, Thunar, Geeqie, Engrampa, Scribus, mousepad, gpicview, keepassxc, cvlc, MediathekView, baloo_file,
Nylas, dino, BibleTime, viewnior, Kodi, viking, youtube-dl, meld, Arduino, akregator, kcalc, ktorrent
