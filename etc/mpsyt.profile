# Firejail profile for mpsyt
# Description: Terminal based YouTube player and downloader
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mpsyt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.mplayer
noblacklist ${HOME}/.config/mps-youtube
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/mps
noblacklist ${MUSIC}
noblacklist ${VIDEOS}
noblacklist ${DOWNLOADS}

mkdir ${HOME}/.config/mps-youtube

whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.mplayer
whitelist ${HOME}/.config/mps-youtube
whitelist ${HOME}/.netrc
whitelist ${HOME}/mps
whitelist ${MUSIC}
whitelist ${VIDEOS}
whitelist ${DOWNLOADS}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# Seems to cause issues with Nvidia drivers sometimes
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin mpsyt,mplayer,mpv,youtube-dl,python*,env
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
