# gedit profile

# when gedit is started via gnome-shell, firejail is not applied because systemd will start it

noblacklist ~/.config/gedit

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin gedit
private-tmp
private-dev
# private-etc fonts
