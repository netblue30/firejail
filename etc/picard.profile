# Firejail profile for picard
# Description: Next-Generation MusicBrainz audio files tagger
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/picard.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/MusicBrainz
noblacklist ${HOME}/.config/MusicBrainz
noblacklist ${MUSIC}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
