# Firejail profile for epiphany
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/epiphany.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/epiphany
noblacklist ${HOME}/.config/epiphany
noblacklist ${HOME}/.local/share/epiphany

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/epiphany
mkdir ${HOME}/.config/epiphany
mkdir ${HOME}/.local/share/epiphany
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/epiphany
whitelist ${HOME}/.config/epiphany
whitelist ${HOME}/.local/share/epiphany
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
notv
protocol unix,inet,inet6
seccomp
