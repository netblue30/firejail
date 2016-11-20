# nautilus profile

# Nautilus is started by systemd on most systems. Therefore it is not firejailed by default. Since there is already a nautilus process running on gnome desktops firejail will have no effect.

noblacklist ~/.config/nautilus

include /etc/firejail/disable-common.inc
# nautilus needs to be able to start arbitrary applications so we cannot blacklist their files
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin nautilus
# private-tmp
# private-dev
# private-etc fonts
