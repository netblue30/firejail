# Firejail profile for musescore
# Description: Free music composition and notation software
# This file is overwritten after every install/update
# Persistent local customizations
include musescore.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/MusE
noblacklist ${HOME}/.config/MuseScore
noblacklist ${HOME}/.local/share/data/MusE
noblacklist ${HOME}/.local/share/data/MuseScore
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
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
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot
tracelog

#private-bin musescore,mscore
private-tmp

#restrict-namespaces
