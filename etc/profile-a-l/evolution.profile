# Firejail profile for evolution
# Description: Groupware suite with mail client and organizer
# This file is overwritten after every install/update
# Persistent local customizations
include evolution.local
# Persistent global definitions
include globals.local

noblacklist /tmp/evolution-*
noblacklist /var/mail
noblacklist /var/spool/mail
noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.cache/evolution
noblacklist ${HOME}/.config/evolution
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/evolution
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc

caps.drop all
netfilter
# no3d breaks under wayland
#no3d
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
#private-tmp
writable-var

restrict-namespaces
