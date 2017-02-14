# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xpra.local

caps.drop all
# xpra needs to be allowed access to the abstract Unix socket namespace.
#net none
nogroups
nonewprivs
# In noroot mode, Xvfb cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
shell none
protocol unix

private
#private-bin xpra,python,Xvfb,Xorg,sh,xkbcomp,xauth,dbus-launch,pactl,ldconfig,which,strace,bash,cat,ls
private-dev
private-tmp
private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname,machine-id,xpra,X11

blacklist /media
whitelist /var/lib/xkb
whitelist /tmp/.X11-unix
whitelist ${HOME}/.xpra
mask-x11 no
