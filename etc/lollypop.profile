# Firejail profile for lollypop
# Description: Music player for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lollypop.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/lollypop
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
netfilter
no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc asound.conf,ca-certificates,fonts,host.conf,hostname,hosts,pulse,resolv.conf,ssl,pki,crypto-policies,gtk-3.0,xdg,machine-id
private-tmp

noexec ${HOME}
noexec /tmp
