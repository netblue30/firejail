# Firejail profile for musescore
# Description: Free music composition and notation software
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/musescore.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/MusE
noblacklist ${HOME}/.config/MuseScore
noblacklist ${HOME}/.local/share/data/MusE
noblacklist ${HOME}/.local/share/data/MuseScore
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

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
