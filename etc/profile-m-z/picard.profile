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
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
private-tmp

