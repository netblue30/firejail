# Firejail profile for picard
# Description: Next-Generation MusicBrainz audio files tagger
# This file is overwritten after every install/update
# Persistent local customizations
include picard.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/MusicBrainz
noblacklist ${HOME}/.config/MusicBrainz
noblacklist ${MUSIC}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
