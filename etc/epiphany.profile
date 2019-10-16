# Firejail profile for epiphany
# Description: The GNOME Web browser
# This file is overwritten after every install/update
# Persistent local customizations
include epiphany.local
# Persistent global definitions
include globals.local

# Note: Epiphany use bwrap since 3.34 and can not be firejailed any more.
# See https://github.com/netblue30/firejail/issues/2995

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
