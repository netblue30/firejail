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

caps.drop all
netfilter
no3d
nodvd
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
