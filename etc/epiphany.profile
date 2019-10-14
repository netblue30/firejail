# Firejail profile for epiphany
# Description: The GNOME Web browser
# This file is overwritten after every install/update
# Persistent local customizations
include epiphany.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/epiphany
noblacklist ${HOME}/.config/epiphany
noblacklist ${HOME}/.local/share/epiphany

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/epiphany
mkdir ${HOME}/.config/epiphany
mkdir ${HOME}/.local/share/epiphany
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/epiphany
whitelist ${HOME}/.config/epiphany
whitelist ${HOME}/.local/share/epiphany
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
notv
protocol unix,inet,inet6
seccomp
