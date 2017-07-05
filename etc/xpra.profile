# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xpra.local


#
# This profile will sandbox Xpra server itself when used with firejail --x11=xpra.
# To enable it, create a firejail-xpra  symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/xpra
#
# or run "sudo firecfg"

# private home directory doesn't work on some distros, so we go for a regular home
#private
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
# xpra needs to be allowed access to the abstract Unix socket namespace.
nogroups
nonewprivs
# In noroot mode, xpra cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
shell none
seccomp
protocol unix


private-dev
private-tmp
# older Xpra versions also use Xvfb
#private-bin xpra,python,Xvfb,Xorg,sh,xkbcomp,xauth,dbus-launch,pactl,ldconfig,which,strace,bash,cat,ls
#private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname,machine-id,xpra,X11

blacklist /media
whitelist /var/lib/xkb

