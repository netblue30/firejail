# Firejail profile for supertux2
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/supertux2.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.local/share/supertux2

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.local/share/supertux2
whitelist ~/.local/share/supertux2
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
protocol unix,netlink
seccomp
shell none

# private-bin supertux2
private-dev
# private-etc none
private-tmp

# CLOBBERED COMMENTS
# depending on your usage, you can enable some of the commands below:
# nosound
