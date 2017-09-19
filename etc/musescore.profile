# Firejail profile for musescore
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/musescore.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/MusE
noblacklist ~/.config/MuseScore
noblacklist ~/.local/share/data/MusE
noblacklist ~/.local/share/data/MuseScore

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin musescore,mscore
private-tmp

noexec ${HOME}
noexec /tmp
