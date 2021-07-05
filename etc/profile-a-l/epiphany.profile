# Firejail profile for epiphany
# Description: The GNOME Web browser
# This file is overwritten after every install/update
# Persistent local customizations
include epiphany.local
# Persistent global definitions
include globals.local

# Note: Epiphany use bwrap since 3.34 and can not be firejailed any more.
# See https://github.com/netblue30/firejail/issues/2995

nodeny  ${HOME}/.cache/epiphany
nodeny  ${HOME}/.config/epiphany
nodeny  ${HOME}/.local/share/epiphany

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/epiphany
mkdir ${HOME}/.config/epiphany
mkdir ${HOME}/.local/share/epiphany
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/epiphany
allow  ${HOME}/.config/epiphany
allow  ${HOME}/.local/share/epiphany
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
notv
protocol unix,inet,inet6
seccomp
