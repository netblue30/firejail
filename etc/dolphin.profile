# dolphin profile

# warning: firejail is currently not effectively constraining dolphin since used services are started by kdeinit5

noblacklist ~/.config/dolphinrc
noblacklist ~/.local/share/dolphin

include /etc/firejail/disable-common.inc
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
shell none
seccomp
protocol unix

# private-bin
# private-dev
# private-tmp
# private-etc

