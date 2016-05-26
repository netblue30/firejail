# KDE gwenview profile
noblacklist ~/.kde/share/apps/gwenview
noblacklist ~/.kde/share/config/gwenviewrc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
caps.drop all
seccomp
protocol unix
nonewprivs
noroot
nogroups
private-dev

#Experimental:
#shell none
#private-bin gwenview
#private-etc X11

