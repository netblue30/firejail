# Firejail profile for evolution
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/evolution.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist /var/mail
noblacklist /var/spool/mail
# noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.cache/evolution
noblacklist ${HOME}/.config/evolution
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/evolution
noblacklist ${HOME}/.pki

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
