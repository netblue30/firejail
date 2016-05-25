# KDE okular profile
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.kde/share/config/okularrc
noblacklist ~/.kde/share/config/okularpartrc
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
#net none
#shell none
#private-bin okular,kbuildsycoca4,kbuildsycoca5
#private-etc X11

